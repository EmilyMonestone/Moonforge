import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/quill_autosave.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/quill_toolbar.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class CampaignEditScreen extends StatefulWidget {
  const CampaignEditScreen({super.key});

  @override
  State<CampaignEditScreen> createState() => _CampaignEditScreenState();
}

class _CampaignEditScreenState extends State<CampaignEditScreen> {
  // Removed final so it can be assigned safely once in initState without LateInitializationError.
  late CampaignProvider _campaignProvider;
  final _nameController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  late QuillController _contentController;
  QuillAutosave? _autosave;
  final _formKey = GlobalKey<FormState>();
  final _editorKey = GlobalKey();
  bool _isLoading = false;
  bool _isSaving = false;
  Campaign? _campaign;
  bool _loadedOnce = false; // guard to ensure we only load once

  @override
  void initState() {
    super.initState();
    _contentController = QuillController.basic();
    // Access provider without listening; safe in initState.
    // Use addPostFrameCallback to ensure context is fully mounted before loading data.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_loadedOnce) {
        _campaignProvider = context.read<CampaignProvider>();
        _loadedOnce = true;
        _loadCampaign();
      }
    });
  }

  @override
  void didChangeDependencies() {
    // Intentionally no re-assignment of _campaignProvider to avoid LateInitializationError & duplicate loads.
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionTextController.dispose();
    _contentController.dispose();
    _autosave?.dispose();
    super.dispose();
  }

  Future<void> _loadCampaign() async {
    setState(() => _isLoading = true);
    try {
      final campaign = _campaignProvider.currentCampaign;
      debugPrint(campaign.toString());

      if (campaign != null) {
        Document document;
        if (campaign.content != null && campaign.content!.isNotEmpty) {
          try {
            final deltaJson = jsonDecode(jsonEncode(campaign.content!));
            document = Document.fromJson(deltaJson);
          } catch (e) {
            document = Document()..insert(0, campaign.description);
          }
        } else if (campaign.description.isNotEmpty) {
          document = Document()..insert(0, campaign.description);
        } else {
          document = Document();
        }

        setState(() {
          _campaign = campaign;
          _nameController.text = campaign.name;
          _descriptionTextController.text = campaign.description;
          // Recreate controller with loaded document to avoid mutating underlying document reference unsafely.
          _contentController.dispose();
          _contentController = QuillController(
            document: document,
            selection: const TextSelection.collapsed(offset: 0),
          );
        });

        // Dispose any previous autosave instance before creating a new one.
        _autosave?.dispose();
        _autosave = QuillAutosave(
          controller: _contentController,
          storageKey: 'campaign_${campaign.id}_content_draft',
          delay: const Duration(seconds: 2),
          onSave: (content) async {
            logger.d('Content autosaved locally for campaign ${campaign.id}');
          },
        )..start();
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to load campaign'),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveCampaign() async {
    if (!_formKey.currentState!.validate()) return;
    if (_campaign == null) return;

    setState(() => _isSaving = true);
    try {
      final repository = context.read<CampaignRepository>();
      final delta = _contentController.document.toDelta();
      final contentJson = delta.toJson();

      final updatedCampaign = _campaign!.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionTextController.text.trim(),
        content: drift.Value({'ops': contentJson}),
        updatedAt: drift.Value(DateTime.now()),
        rev: _campaign!.rev + 1,
      );

      await repository.update(updatedCampaign);
      final refreshed = await repository.getById(_campaign!.id);
      if (refreshed != null && mounted) {
        context.read<CampaignProvider>().setCurrentCampaign(refreshed);
      }
      await _autosave?.clear();

      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Campaign saved successfully'),
        );
        // Avoid calling .go(context) since generated extensions may be missing; navigate via context.go.
        context.go(const CampaignRoute().location);
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to save campaign'),
        );
        logger.e('Error saving campaign: $e');
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

    if (_campaign == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('No campaign selected', style: theme.textTheme.titleMedium),
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
            '${l10n.campaign} ${l10n.edit}',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Spacer(),
          ButtonM3E(
            onPressed: () => context.go(const CampaignRoute().location),
            label: Text(l10n.cancel),
            icon: const Icon(Icons.cancel),
            style: ButtonM3EStyle.outlined,
            shape: ButtonM3EShape.square,
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
            onPressed: _isSaving ? null : _saveCampaign,
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
              decoration: const InputDecoration(
                labelText: 'Campaign Name',
                prefixIcon: Icon(Icons.campaign_outlined),
                helperText: 'Give your campaign a memorable name',
              ),
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return 'Name is required';
                return null;
              },
            ),
            const SizedBox(height: 24),
            Text('Description', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionTextController,
              decoration: const InputDecoration(
                labelText: 'Short description',
                hintText: 'Enter a brief summary',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Text('Content', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              'Rich text content of the campaign',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            // Quill Toolbar
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
                  if (_campaign == null) return [];
                  final service = EntityMentionService(
                    entityRepository: context.read() as EntityRepository,
                  );
                  return await service.searchEntities(
                    campaignId: _campaign!.id,
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
