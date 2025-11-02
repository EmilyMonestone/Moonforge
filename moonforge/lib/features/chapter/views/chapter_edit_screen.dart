import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/quill_autosave.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/quill_toolbar.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:drift/drift.dart' as drift;

class ChapterEditScreen extends StatefulWidget {
  const ChapterEditScreen({super.key, required this.chapterId});

  final String chapterId;

  @override
  State<ChapterEditScreen> createState() => _ChapterEditScreenState();
}

class _ChapterEditScreenState extends State<ChapterEditScreen> {
  late final CampaignProvider _campaignProvider;
  final _nameController = TextEditingController();
  final _summaryTextController = TextEditingController();
  late QuillController _contentController;
  QuillAutosave? _autosave;
  final _formKey = GlobalKey<FormState>();
  final _editorKey = GlobalKey();
  bool _isLoading = false;
  bool _isSaving = false;
  Chapter? _chapter;

  @override
  void initState() {
    super.initState();
    _contentController = QuillController.basic();
  }

  @override
  void didChangeDependencies() {
    _campaignProvider = Provider.of<CampaignProvider>(context, listen: true);
    _loadChapter();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _summaryTextController.dispose();
    _contentController.dispose();
    _autosave?.dispose();
    super.dispose();
  }

  Future<void> _loadChapter() async {
    setState(() => _isLoading = true);
    try {
      final campaign = _campaignProvider.currentCampaign;
      if (campaign == null) {
        if (mounted) {
          toastification.show(
            type: ToastificationType.error,
            title: const Text('No campaign selected'),
          );
        }
        return;
      }

      final repo = context.read<ChapterRepository>();
      final chapter = await repo.getById(widget.chapterId);

      if (chapter != null) {
        Document document;
        if (chapter.content != null) {
          try {
            final ops = chapter.content!['ops'] as List<dynamic>?;
            if (ops != null) {
              document = Document.fromJson(ops);
            } else {
              document = Document()
                ..insert(0, chapter.summary ?? '');
            }
          } catch (e) {
            document = Document()
              ..insert(0, chapter.summary ?? '');
          }
        } else {
          document = Document();
        }

        setState(() {
          _chapter = chapter;
          _nameController.text = chapter.name;
          _summaryTextController.text = chapter.summary ?? '';
          _contentController.document = document;
        });

        _autosave = QuillAutosave(
          controller: _contentController,
          storageKey: 'chapter_${chapter.id}_content_draft',
          delay: const Duration(seconds: 2),
          onSave: (content) async {
            logger.d('Content autosaved locally for chapter ${chapter.id}');
          },
        );
        _autosave?.start();
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to load chapter'),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveChapter() async {
    if (!_formKey.currentState!.validate()) return;
    if (_chapter == null) return;

    setState(() => _isSaving = true);
    try {
      final campaign = _campaignProvider.currentCampaign;
      if (campaign == null) {
        throw Exception('No campaign selected');
      }

      final repo = context.read<ChapterRepository>();

      final delta = _contentController.document.toDelta();
      final deltaMap = <String, dynamic>{'ops': delta.toJson()};

      final updated = _chapter!.copyWith(
        name: _nameController.text.trim(),
        summary: drift.Value(_summaryTextController.text
            .trim()
            .isEmpty
            ? null
            : _summaryTextController.text.trim()),
        content: drift.Value(deltaMap),
        updatedAt: drift.Value(DateTime.now()),
        rev: _chapter!.rev + 1,
      );

      await repo.update(updated);

      await _autosave?.clear();

      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Chapter saved successfully'),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to save chapter'),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_chapter == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('No chapter found', style: theme.textTheme.titleMedium),
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
            '${l10n.chapter} ${l10n.edit}',
            style: Theme
                .of(context)
                .textTheme
                .displaySmall,
          ),
          const Spacer(),
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
            onPressed: _isSaving ? null : _saveChapter,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.name,
                prefixIcon: const Icon(Icons.menu_book_outlined),
                helperText: 'Give your chapter a descriptive name',
              ),
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return 'Name is required';
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text(l10n.description, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _summaryTextController,
              decoration: const InputDecoration(
                labelText: 'Short summary',
                hintText: 'Enter a brief summary of the chapter',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Text(l10n.content, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Rich text content of the chapter',
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
            // Quill Editor
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
                  final campaign = _campaignProvider.currentCampaign;
                  if (campaign == null) return [];
                  final service = EntityMentionService(
                    entityRepository: context.read<EntityRepository>(),
                  );
                  return await service.searchEntities(
                    campaignId: campaign.id,
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
