import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/permissions_utils.dart';
import 'package:moonforge/core/utils/quill_autosave.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/quill_toolbar.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
class SessionEditScreen extends StatefulWidget {
  const SessionEditScreen({
    super.key,
    required this.partyId,
    required this.sessionId,
  });
  final String partyId;
  final String sessionId;
  @override
  State<SessionEditScreen> createState() => _SessionEditScreenState();
}
class _SessionEditScreenState extends State<SessionEditScreen> {
  late QuillController _infoController;
  late QuillController _logController;
  QuillAutosave? _infoAutosave;
  QuillAutosave? _logAutosave;
  final _infoEditorKey = GlobalKey();
  final _logEditorKey = GlobalKey();
  bool _isLoading = false;
  bool _isSaving = false;
  Session? _session;
  String? _campaignId;
  void initState() {
    super.initState();
    _infoController = QuillController.basic();
    _logController = QuillController.basic();
  }
  void didChangeDependencies() {
    super.didChangeDependencies();
    final campaign = Provider.of<CampaignProvider>(
      context,
      listen: true,
    ).currentCampaign;
    if (campaign != null && _campaignId != campaign.id) {
      _campaignId = campaign.id;
      _loadSession();
    }
  void dispose() {
    _infoController.dispose();
    _logController.dispose();
    _infoAutosave?.dispose();
    _logAutosave?.dispose();
    super.dispose();
  Future<void> _loadSession() async {
    if (_campaignId == null) return;
    setState(() => _isLoading = true);
    try {
      final odm = Odm.instance;
      final session = await odm.campaigns
          .doc(_campaignId!)
          .sessions
          .doc(widget.sessionId)
          .get();
      if (session != null) {
        // Load info document
        Document infoDocument;
        if (session.info != null && session.info!.isNotEmpty) {
          try {
            final deltaJson = jsonDecode(session.info!);
            infoDocument = Document.fromJson(deltaJson);
          } catch (e) {
            logger.e('Error parsing info delta: $e');
            infoDocument = Document();
          }
        } else {
          infoDocument = Document();
        }
        // Load log document
        Document logDocument;
        if (session.log != null && session.log!.isNotEmpty) {
            final deltaJson = jsonDecode(session.log!);
            logDocument = Document.fromJson(deltaJson);
            logger.e('Error parsing log delta: $e');
            logDocument = Document();
          logDocument = Document();
        setState(() {
          _session = session;
          _infoController.document = infoDocument;
          _logController.document = logDocument;
        });
        // Set up autosave for info
        _infoAutosave = QuillAutosave(
          controller: _infoController,
          storageKey: 'session_${session.id}_info_draft',
          delay: const Duration(seconds: 2),
          onSave: (content) async {
            logger.d('Info autosaved locally for session ${session.id}');
          },
        );
        _infoAutosave?.start();
        // Set up autosave for log
        _logAutosave = QuillAutosave(
          controller: _logController,
          storageKey: 'session_${session.id}_log_draft',
            logger.d('Log autosaved locally for session ${session.id}');
        _logAutosave?.start();
      }
    } catch (e) {
      if (mounted) {
        toastification.show(
          type: ToastificationType.error,
          title: const Text('Failed to load session'),
        logger.e('Error loading session: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
  Future<void> _saveSession() async {
    if (_session == null || _campaignId == null) return;
    setState(() => _isSaving = true);
      // Convert info to JSON
      final infoDelta = _infoController.document.toDelta();
      final infoJson = jsonEncode(infoDelta.toJson());
      // Convert log to JSON
      final logDelta = _logController.document.toDelta();
      final logJson = jsonEncode(logDelta.toJson());
      final updatedSession = _session!.copyWith(
        info: infoJson,
        log: logJson,
        updatedAt: DateTime.now(),
        rev: _session!.rev + 1,
      );
      await odm.campaigns.doc(_campaignId!).sessions.update(updatedSession);
      await _infoAutosave?.clear();
      await _logAutosave?.clear();
          type: ToastificationType.success,
          title: const Text('Session saved successfully'),
        Navigator.of(context).pop();
          title: const Text('Failed to save session'),
        logger.e('Error saving session: $e');
      if (mounted) setState(() => _isSaving = false);
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;
    final currentUser = context.watch<AuthProvider>().user;
    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    // Check if user is DM
    final isDM = PermissionsUtils.isDM(campaign, currentUser?.id);
    if (!isDM) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.block, size: 48),
            const SizedBox(height: 16),
            Text(
              'Only the DM can edit sessions',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go back'),
          ],
        ),
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    if (_session == null) {
            const Icon(Icons.error_outline, size: 48),
            Text('No session found', style: theme.textTheme.titleMedium),
    return SurfaceContainer(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Edit Session', style: Theme.of(context).textTheme.displaySmall),
          const Spacer(),
          ButtonM3E(
            style: ButtonM3EStyle.outlined,
            shape: ButtonM3EShape.square,
            label: Text(l10n.cancel),
            icon: const Icon(Icons.cancel_outlined),
            onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          ),
            style: ButtonM3EStyle.filled,
            label: Text(l10n.save),
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveSession,
        ],
      ),
      child: SingleChildScrollView(
          crossAxisAlignment: CrossAxisAlignment.stretch,
            // DM Notes section
            Row(
              children: [
                Icon(
                  Icons.admin_panel_settings_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text('DM Notes (Private)', style: theme.textTheme.titleMedium),
              ],
              'These notes are only visible to you as the DM',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
              child: QuillCustomToolbar(controller: _infoController),
              height: 300,
                  bottom: Radius.circular(4),
              child: CustomQuillEditor(
                controller: _infoController,
                keyForPosition: _infoEditorKey,
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
            const SizedBox(height: 32),
            // Session Log section
                  Icons.article_outlined,
                  color: theme.colorScheme.secondary,
                Text(
                  'Session Log (Shared with Players)',
                  style: theme.textTheme.titleMedium,
              'This log is visible to all players in the party',
              child: QuillCustomToolbar(controller: _logController),
                controller: _logController,
                keyForPosition: _logEditorKey,
    );
