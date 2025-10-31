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
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
class AdventureEditScreen extends StatefulWidget {
  const AdventureEditScreen({
    super.key,
    required this.chapterId,
    required this.adventureId,
  });
  final String chapterId;
  final String adventureId;
  @override
  State<AdventureEditScreen> createState() => _AdventureEditScreenState();
}
class _AdventureEditScreenState extends State<AdventureEditScreen> {
  final _nameController = TextEditingController();
  final _summaryController = TextEditingController();
  late QuillController _contentController;
  QuillAutosave? _autosave;
  final _formKey = GlobalKey<FormState>();
  final _editorKey = GlobalKey();
  bool _isLoading = false;
  bool _isSaving = false;
  Adventure? _adventure;
  String? _campaignId;
  void initState() {
    super.initState();
    _contentController = QuillController.basic();
  }
  void didChangeDependencies() {
    super.didChangeDependencies();
    final campaign = Provider.of<CampaignProvider>(
      context,
      listen: true,
    ).currentCampaign;
    if (campaign != null && _campaignId != campaign.id) {
      _campaignId = campaign.id;
      _loadAdventure();
    }
  void dispose() {
    _nameController.dispose();
    _summaryController.dispose();
    _contentController.dispose();
    _autosave?.dispose();
    super.dispose();
  Future<void> _loadAdventure() async {
    if (_campaignId == null) return;
    setState(() => _isLoading = true);
    try {
      final odm = Odm.instance;
      final adventure = await odm.campaigns
          .doc(_campaignId!)
          .chapters
          .doc(widget.chapterId)
          .adventures
          .doc(widget.adventureId)
          .get();
      if (adventure != null) {
        Document document;
        if (adventure.content != null && adventure.content!.isNotEmpty) {
          try {
            final deltaJson = jsonDecode(adventure.content!);
            document = Document.fromJson(deltaJson);
          } catch (e) {
            document = Document()..insert(0, adventure.summary ?? '');
          }
        } else if (adventure.summary != null && adventure.summary!.isNotEmpty) {
          document = Document()..insert(0, adventure.summary!);
        } else {
          document = Document();
        }
        setState(() {
          _adventure = adventure;
          _nameController.text = adventure.name;
          _summaryController.text = adventure.summary ?? '';
          _contentController.document = document;
        });
        _autosave = QuillAutosave(
          controller: _contentController,
          storageKey: 'adventure_${adventure.id}_content_draft',
          delay: const Duration(seconds: 2),
          onSave: (content) async {
            logger.d('Content autosaved locally for adventure ${adventure.id}');
          },
        );
        _autosave?.start();
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to load adventure'),
    } finally {
      if (mounted) setState(() => _isLoading = false);
  Future<void> _saveAdventure() async {
    if (!_formKey.currentState!.validate()) return;
    if (_adventure == null || _campaignId == null) return;
    setState(() => _isSaving = true);
      final delta = _contentController.document.toDelta();
      final contentJson = jsonEncode(delta.toJson());
      final updatedAdventure = _adventure!.copyWith(
        name: _nameController.text.trim(),
        summary: _summaryController.text.trim(),
        content: contentJson,
        updatedAt: DateTime.now(),
        rev: _adventure!.rev + 1,
      );
      await odm.campaigns
          .update(updatedAdventure);
      await _autosave?.clear();
          type: ToastificationType.success,
          title: const Text('Adventure saved successfully'),
        Navigator.of(context).pop();
          title: const Text('Failed to save adventure'),
        logger.e('Error saving adventure: $e');
      if (mounted) setState(() => _isSaving = false);
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    if (_adventure == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('No adventure found', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go back'),
            ),
          ],
        ),
    return SurfaceContainer(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${l10n.adventure} ${l10n.edit}',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const Spacer(),
          ButtonM3E(
            style: ButtonM3EStyle.outlined,
            shape: ButtonM3EShape.square,
            label: Text(l10n.cancel),
            icon: const Icon(Icons.cancel_outlined),
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
            style: ButtonM3EStyle.filled,
            label: Text(l10n.save),
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveAdventure,
        ],
      ),
      child: Form(
        key: _formKey,
          crossAxisAlignment: CrossAxisAlignment.stretch,
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Adventure Name',
                prefixIcon: Icon(Icons.auto_stories_outlined),
                helperText: 'Give your adventure a memorable name',
              ),
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return 'Name is required';
                return null;
              },
            const SizedBox(height: 24),
            Text('Summary', style: theme.textTheme.titleMedium),
              controller: _summaryController,
                labelText: 'Short summary',
                hintText: 'Enter a brief summary',
              maxLines: 3,
            Text('Content', style: theme.textTheme.titleMedium),
            Text(
              'Rich text content of the adventure',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              child: QuillCustomToolbar(controller: _contentController),
              height: 400,
                  bottom: Radius.circular(4),
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
    );
