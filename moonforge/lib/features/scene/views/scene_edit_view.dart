import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';
import 'package:moonforge/core/models/ai/generation_request.dart';
import 'package:moonforge/core/providers/gemini_provider.dart';
import 'package:moonforge/core/services/story_context_builder.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/quill_autosave.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/quill_toolbar.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:dart_quill_delta/dart_quill_delta.dart' as quill_delta;
import 'package:toastification/toastification.dart';

class SceneEditView extends StatefulWidget {
  const SceneEditView({
    super.key,
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });

  final String chapterId;
  final String adventureId;
  final String sceneId;

  @override
  State<SceneEditView> createState() => _SceneEditViewState();
}

class _SceneEditViewState extends State<SceneEditView> {
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  late QuillController _contentController;
  QuillAutosave? _autosave;
  final _formKey = GlobalKey<FormState>();
  final _editorKey = GlobalKey();
  bool _isLoading = false;
  bool _isSaving = false;
  bool _isGeneratingAi = false;
  db.Scene? _scene;
  String? _campaignId;

  @override
  void initState() {
    super.initState();
    _contentController = QuillController.basic();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoading && _scene == null) {
      _loadScene();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _autosave?.dispose();
    super.dispose();
  }

  Future<void> _loadScene() async {
    setState(() => _isLoading = true);
    try {
      final campaign = context.read<CampaignProvider>().currentCampaign;
      if (campaign == null) {
        if (mounted) {
          toastification.show(
            type: ToastificationType.error,
            title: const Text('No campaign selected'),
          );
        }
        setState(() => _isLoading = false);
        return;
      }
      _campaignId = campaign.id;

      final repo = context.read<SceneRepository>();
      final scene = await repo.getById(widget.sceneId);

      if (scene != null) {
        Document document;
        if (scene.content != null && scene.content!.isNotEmpty) {
          try {
            final contentMap = scene.content!; // Map<String,dynamic>
            final ops = contentMap['ops'];
            if (ops is List) {
              document = Document.fromJson(
                List<Map<String, dynamic>>.from(ops),
              );
            } else {
              document = Document()..insert(0, scene.summary ?? '');
            }
          } catch (e) {
            document = Document()..insert(0, scene.summary ?? '');
          }
        } else if (scene.summary != null && scene.summary!.isNotEmpty) {
          document = Document()..insert(0, scene.summary!);
        } else {
          document = Document();
        }

        setState(() {
          _scene = scene;
          _titleController.text = scene.name;
          _summaryController.text = scene.summary ?? '';
          _contentController.document = document;
        });

        _autosave = QuillAutosave(
          controller: _contentController,
          storageKey: 'scene_${scene.id}_content_draft',
          delay: const Duration(seconds: 2),
          onSave: (content) async {
            logger.d('Content autosaved locally for scene ${scene.id}');
          },
        );
        _autosave?.start();
      }
    } catch (e) {
      logger.e('Error loading scene: $e');
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to load scene'),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveScene() async {
    if (!_formKey.currentState!.validate()) return;
    if (_scene == null) return;

    setState(() => _isSaving = true);
    try {
      final repo = context.read<SceneRepository>();

      final delta = _contentController.document.toDelta();
      final contentMap = {'ops': delta.toJson()};

      final updatedScene = _scene!.copyWith(
        name: _titleController.text.trim(),
        summary: Value(_summaryController.text.trim()),
        content: Value(contentMap),
        updatedAt: Value(DateTime.now()),
        rev: _scene!.rev + 1,
      );

      await repo.update(updatedScene);

      await _autosave?.clear();

      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Scene saved successfully'),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      logger.e('Error saving scene: $e');
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to save scene'),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _continueStoryWithAi() async {
    final geminiProvider = context.read<GeminiProvider?>();
    if (geminiProvider == null) return;

    setState(() => _isGeneratingAi = true);

    try {
      // Build story context
      final contextBuilder = StoryContextBuilder(
        campaignRepo: context.read<CampaignRepository>(),
        chapterRepo: context.read<ChapterRepository>(),
        adventureRepo: context.read<AdventureRepository>(),
        sceneRepo: context.read<SceneRepository>(),
        entityRepo: context.read<EntityRepository>(),
      );

      final storyContext = await contextBuilder.buildForScene(widget.sceneId);

      // Get current content
      final currentContent = _contentController.document.toPlainText();

      // Make AI request
      final request = CompletionRequest(
        context: storyContext,
        currentContent: currentContent,
      );

      final response = await geminiProvider.service.continueStory(request);

      if (!mounted) return;

      if (response.success && response.content != null) {
        // Convert markdown to Quill delta
        final mdDocument = md.Document(
          encodeHtml: false,
          extensionSet: md.ExtensionSet.gitHubFlavored,
        );
        final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
        final contentDelta = mdToDelta.convert(response.content!);

        // Insert generated content at the end
        final length = _contentController.document.length;
        _contentController.document.insert(length - 1, '\n\n');
        _contentController.document.compose(
          quill_delta.Delta()
            ..retain(length + 1)
            ..concat(contentDelta),
          ChangeSource.local,
        );

        toastification.show(
          type: ToastificationType.success,
          title: const Text('Story continued with AI'),
          autoCloseDuration: const Duration(seconds: 3),
        );
      } else {
        toastification.show(
          type: ToastificationType.error,
          title: Text(response.error ?? 'Failed to generate content'),
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
    } catch (e) {
      logger.e('Error continuing story with AI: $e');
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: Text('Error: $e'),
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingAi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_scene == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('No scene found', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go back'),
            ),
          ],
        ),
      );
    }

    return SurfaceContainer(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${l10n.scene} ${l10n.edit}',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Spacer(),
          ButtonM3E(
            style: ButtonM3EStyle.outlined,
            shape: ButtonM3EShape.square,
            label: Text(l10n.cancel),
            icon: const Icon(Icons.cancel_outlined),
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          ),
          ButtonM3E(
            style: ButtonM3EStyle.filled,
            shape: ButtonM3EShape.square,
            label: Text(l10n.save),
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveScene,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.name,
                prefixIcon: Icon(Icons.movie_outlined),
                helperText: 'Give your scene a descriptive title',
              ),
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return 'Title is required';
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(l10n.description, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _summaryController,
              decoration: const InputDecoration(
                labelText: 'Short summary',
                hintText: 'Enter a brief summary of the scene',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(l10n.content, style: theme.textTheme.titleMedium),
                const Spacer(),
                // AI Continue Story button
                if (context.watch<GeminiProvider?>() != null)
                  OutlinedButton.icon(
                    onPressed: _isGeneratingAi ? null : _continueStoryWithAi,
                    icon: _isGeneratingAi
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_fix_high),
                    label: const Text('Continue Story'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Rich text content of the scene',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              child: QuillCustomToolbar(controller: _contentController),
            ),
            Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(4),
                ),
              ),
              child: CustomQuillEditor(
                controller: _contentController,
                keyForPosition: _editorKey,
                onSearchEntities: (kind, query) async {
                  if (_campaignId == null) return [];
                  final service = EntityMentionService(
                    entityRepository: context.read<EntityRepository>(),
                  );
                  return await service.searchEntities(
                    campaignId: _campaignId!,
                    kinds: kind,
                    query: query,
                    limit: 10,
                  );
                },
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
