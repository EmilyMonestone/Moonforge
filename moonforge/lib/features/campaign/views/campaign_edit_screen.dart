import 'dart:convert';

import 'package:firestore_odm/firestore_odm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/core/models/data/schema.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSaving = false;
  Campaign? _campaign;

  @override
  void initState() {
    super.initState();
    _contentController = QuillController.basic();
  }

  @override
  void didChangeDependencies() {
    _campaignProvider = Provider.of<CampaignProvider>(context, listen: true);
    _loadCampaign();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionTextController.dispose();
    _contentController.dispose();
    super.dispose();
  }

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
        updatedAt: FirestoreODM.serverTimestamp,
        rev: _campaign!.rev + 1,
      );

      await odm.campaigns.update(updatedCampaign);

      // Update provider with latest data
      context.read<CampaignProvider>().setCurrentCampaign(updatedCampaign);

      if (mounted) {
        toastification.show(
          type: ToastificationType.success,
          title: const Text('Campaign saved successfully'),
        );
        Navigator.of(context).pop();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Campaign'),
        actions: [
          FilledButton.icon(
            onPressed: _isSaving ? null : _saveCampaign,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: const Text('Save'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Campaign Details',
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Campaign Name',
                                    prefixIcon: Icon(Icons.campaign_outlined),
                                    helperText:
                                        'Give your campaign a memorable name',
                                  ),
                                  validator: (v) {
                                    final value = v?.trim() ?? '';
                                    if (value.isEmpty)
                                      return 'Name is required';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Description',
                                  style: theme.textTheme.titleMedium,
                                ),
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
                                Text(
                                  'Content',
                                  style: theme.textTheme.titleMedium,
                                ),
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
                                    border: Border.all(
                                      color: theme.colorScheme.outline,
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                  child: QuillSimpleToolbar(
                                    controller: _contentController,
                                    config: const QuillSimpleToolbarConfig(
                                      multiRowsDisplay: false,
                                    ),
                                  ),
                                ),
                                // Quill Editor
                                Container(
                                  height: 300,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colorScheme.outline,
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(4),
                                    ),
                                  ),
                                  child: QuillEditor.basic(
                                    controller: _contentController,
                                    config: const QuillEditorConfig(
                                      padding: EdgeInsets.all(16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _MetadataRow extends StatelessWidget {
  const _MetadataRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
