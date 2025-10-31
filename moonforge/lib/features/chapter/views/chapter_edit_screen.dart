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
  void initState() {
    super.initState();
    _contentController = QuillController.basic();
  }
  void didChangeDependencies() {
    _campaignProvider = Provider.of<CampaignProvider>(context, listen: true);
    _loadChapter();
    super.didChangeDependencies();
  void dispose() {
    _nameController.dispose();
    _summaryTextController.dispose();
    _contentController.dispose();
    _autosave?.dispose();
    super.dispose();
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
      final odm = Odm.instance;
      final chapter = await odm.campaigns
          .doc(campaign.id)
          .chapters
          .doc(widget.chapterId)
          .get();
      if (chapter != null) {
        // Load Quill delta from content if available
        Document document;
        if (chapter.content != null && chapter.content!.isNotEmpty) {
          try {
            final deltaJson = jsonDecode(chapter.content!);
            document = Document.fromJson(deltaJson);
          } catch (e) {
            // If content is not valid JSON, fall back to empty document
            document = Document();
          }
        } else {
          document = Document();
        setState(() {
          _chapter = chapter;
          _nameController.text = chapter.name;
          _summaryTextController.text = chapter.summary ?? '';
          _contentController.document = document;
        });
        // Initialize autosave after loading the chapter
        _autosave = QuillAutosave(
          controller: _contentController,
          storageKey: 'chapter_${chapter.id}_content_draft',
          delay: const Duration(seconds: 2),
          onSave: (content) async {
            // Autosave is handled locally, no remote save needed here
            logger.d('Content autosaved locally for chapter ${chapter.id}');
          },
        );
        _autosave?.start();
    } catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to load chapter'),
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  Future<void> _saveChapter() async {
    if (!_formKey.currentState!.validate()) return;
    if (_chapter == null) return;
    setState(() => _isSaving = true);
        throw Exception('No campaign selected');
      // Save as Delta JSON
      final delta = _contentController.document.toDelta();
      final contentJson = jsonEncode(delta.toJson());
      final updatedChapter = _chapter!.copyWith(
        name: _nameController.text.trim(),
        summary: _summaryTextController.text.trim(),
        content: contentJson,
        updatedAt: DateTime.now(),
        rev: _chapter!.rev + 1,
      );
      await odm.campaigns.doc(campaign.id).chapters.update(updatedChapter);
      // Clear autosaved draft after successful save
      await _autosave?.clear();
          type: ToastificationType.success,
          title: const Text('Chapter saved successfully'),
        Navigator.of(context).pop();
          title: const Text('Failed to save chapter'),
        logger.e('Error saving chapter: $e');
      if (mounted) setState(() => _isSaving = false);
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    if (_chapter == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text('Chapter not found', style: theme.textTheme.titleMedium),
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
            '${l10n.chapter} ${l10n.edit}',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Spacer(),
          ButtonM3E(
            style: ButtonM3EStyle.outlined,
            shape: ButtonM3EShape.square,
            label: Text(l10n.cancel),
            icon: const Icon(Icons.cancel_outlined),
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonM3EStyle.filled,
            label: Text(l10n.save),
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveChapter,
        ],
      ),
      child: Form(
        key: _formKey,
          crossAxisAlignment: CrossAxisAlignment.stretch,
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '${l10n.chapter} ${l10n.name}',
                prefixIcon: Icon(Icons.library_books_outlined),
                helperText: 'Give your chapter a memorable name',
              ),
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return 'Name is required';
                return null;
              },
            const SizedBox(height: 24),
            Text('Summary', style: theme.textTheme.titleMedium),
              controller: _summaryTextController,
              decoration: const InputDecoration(
                labelText: 'Short summary',
                hintText: 'Enter a brief summary',
              maxLines: 3,
            Text(l10n.content, style: theme.textTheme.titleMedium),
            Text(
              'Rich text content of the chapter',
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
                  final campaign = _campaignProvider.currentCampaign;
                  if (campaign == null) return [];
                  return await EntityMentionService.searchEntities(
                    campaignId: campaign.id,
                    kinds: kind,
                    query: query,
                    limit: 10,
                  );
                },
                padding: const EdgeInsets.all(16),
    );
