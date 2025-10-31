import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/app_router.dart';
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
class CampaignEditScreen extends StatefulWidget {
  const CampaignEditScreen({super.key});
  @override
  State<CampaignEditScreen> createState() => _CampaignEditScreenState();
}
class _CampaignEditScreenState extends State<CampaignEditScreen> {
  late final CampaignProvider _campaignProvider;
  final _nameController = TextEditingController();
  final _descriptionTextController = TextEditingController();
  late QuillController _contentController;
  QuillAutosave? _autosave;
  final _formKey = GlobalKey<FormState>();
  final _editorKey = GlobalKey();
  bool _isLoading = false;
  bool _isSaving = false;
  Campaign? _campaign;
  void initState() {
    super.initState();
    _contentController = QuillController.basic();
  }
  void didChangeDependencies() {
    _campaignProvider = Provider.of<CampaignProvider>(context, listen: true);
    _loadCampaign();
    super.didChangeDependencies();
  void dispose() {
    _nameController.dispose();
    _descriptionTextController.dispose();
    _contentController.dispose();
    _autosave?.dispose();
    super.dispose();
  Future<void> _loadCampaign() async {
    setState(() => _isLoading = true);
    try {
      final campaign = _campaignProvider.currentCampaign;
      debugPrint(campaign.toString());
      if (campaign != null) {
        // Load Quill delta from content if available, otherwise use description
        Document document;
        if (campaign.content != null && campaign.content!.isNotEmpty) {
          try {
            final deltaJson = jsonDecode(campaign.content!);
            document = Document.fromJson(deltaJson);
          } catch (e) {
            // If content is not valid JSON, fall back to plain text description
            document = Document()..insert(0, campaign.description);
          }
        } else if (campaign.description.isNotEmpty) {
          // Use description as plain text if content is null
          document = Document()..insert(0, campaign.description);
        } else {
          document = Document();
        }
        setState(() {
          _campaign = campaign;
          _nameController.text = campaign.name;
          _descriptionTextController.text = campaign.description;
          _contentController.document = document;
        });
        // Initialize autosave after loading the campaign
        _autosave = QuillAutosave(
          controller: _contentController,
          storageKey: 'campaign_${campaign.id}_content_draft',
          delay: const Duration(seconds: 2),
          onSave: (content) async {
            // Autosave is handled locally, no remote save needed here
            logger.d('Content autosaved locally for campaign ${campaign.id}');
          },
        );
        _autosave?.start();
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to load campaign'),
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  Future<void> _saveCampaign() async {
    if (!_formKey.currentState!.validate()) return;
    if (_campaign == null) return;
    setState(() => _isSaving = true);
      final odm = Odm.instance;
      // Save as Delta JSON
      final delta = _contentController.document.toDelta();
      final contentJson = jsonEncode(delta.toJson());
      final updatedCampaign = _campaign!.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionTextController.text.trim(),
        // Keep plain text for backward compatibility
        content: contentJson,
        // Store rich text as Delta JSON
        updatedAt: DateTime.now(),
        rev: _campaign!.rev + 1,
      );
      await odm.campaigns.update(updatedCampaign);
      // Update provider with latest data
      context.read<CampaignProvider>().setCurrentCampaign(updatedCampaign);
      // Clear autosaved draft after successful save
      await _autosave?.clear();
          type: ToastificationType.success,
          title: const Text('Campaign saved successfully'),
        CampaignRoute().go(context);
          title: const Text('Failed to save campaign'),
        logger.e('Error saving campaign: $e');
      if (mounted) setState(() => _isSaving = false);
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
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
            onPressed: () => CampaignRoute().go(context),
            label: Text('l10n.cancel'),
            icon: const Icon(Icons.cancel),
            style: ButtonM3EStyle.outlined,
            shape: ButtonM3EShape.square,
            style: ButtonM3EStyle.filled,
            label: Text(l10n.save),
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveCampaign,
        ],
      ),
      child: Form(
        key: _formKey,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const SizedBox(height: 24),
            Text('Description', style: theme.textTheme.titleMedium),
              controller: _descriptionTextController,
                labelText: 'Short description',
                hintText: 'Enter a brief summary',
              maxLines: 3,
            Text('Content', style: theme.textTheme.titleMedium),
            Text(
              'Rich text content of the campaign',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
            const SizedBox(height: 12),
            // Quill Toolbar
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              child: QuillCustomToolbar(controller: _contentController),
            // Quill Editor
              height: 400,
                  bottom: Radius.circular(4),
              child: CustomQuillEditor(
                controller: _contentController,
                keyForPosition: _editorKey,
                onSearchEntities: (kind, query) async {
                  if (_campaign == null) return [];
                  return await EntityMentionService.searchEntities(
                    campaignId: _campaign!.id,
                    kinds: kind,
                    query: query,
                    limit: 10,
                  );
                },
                padding: const EdgeInsets.all(16),
    );
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
      ],
