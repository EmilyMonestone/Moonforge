import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/quill_autosave.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/quill_toolbar.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/firebase/models/scene.dart';
import 'package:moonforge/data/firebase/models/schema.dart';
import 'package:moonforge/data/firebase/odm.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class SceneEditScreen extends StatefulWidget {
  const SceneEditScreen({
    super.key,
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });

  final String chapterId;
  final String adventureId;
  final String sceneId;

  @override
  State<SceneEditScreen> createState() => _SceneEditScreenState();
}

class _SceneEditScreenState extends State<SceneEditScreen> {
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();
  late QuillController _contentController;
  QuillAutosave? _autosave;
  final _formKey = GlobalKey<FormState>();
  final _editorKey = GlobalKey();
  bool _isLoading = false;
  bool _isSaving = false;
  Scene? _scene;
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

      final odm = Odm.instance;
      final scene = await odm.campaigns
          .doc(campaign.id)
          .chapters
          .doc(widget.chapterId)
          .adventures
          .doc(widget.adventureId)
          .scenes
          .doc(widget.sceneId)
          .get();

      if (scene != null) {
        Document document;
        if (scene.content != null && scene.content!.isNotEmpty) {
          try {
            final deltaJson = jsonDecode(scene.content!);
            document = Document.fromJson(deltaJson);
          } catch (e) {
            document = Document();
          }
        } else {
          document = Document();
        }

        setState(() {
          _scene = scene;
          _titleController.text = scene.title;
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
    if (_scene == null || _campaignId == null) return;

    setState(() => _isSaving = true);
    try {
      final odm = Odm.instance;

      final delta = _contentController.document.toDelta();
      final contentJson = jsonEncode(delta.toJson());

      final updatedScene = _scene!.copyWith(
        title: _titleController.text.trim(),
        summary: _summaryController.text.trim(),
        content: contentJson,
        updatedAt: DateTime.now(),
        rev: _scene!.rev + 1,
      );

      await odm.campaigns
          .doc(_campaignId!)
          .chapters
          .doc(widget.chapterId)
          .adventures
          .doc(widget.adventureId)
          .scenes
          .update(updatedScene);

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
            Text(l10n.content, style: theme.textTheme.titleMedium),
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
                  return await EntityMentionService.searchEntities(
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
