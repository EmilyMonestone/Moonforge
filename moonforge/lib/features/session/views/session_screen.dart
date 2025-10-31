import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/permissions_utils.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/share_settings_dialog.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
class SessionScreen extends StatefulWidget {
  const SessionScreen({
    super.key,
    required this.partyId,
    required this.sessionId,
  });
  final String partyId;
  final String sessionId;
  @override
  State<SessionScreen> createState() => _SessionScreenState();
}
class _SessionScreenState extends State<SessionScreen> {
  final QuillController _infoController = QuillController.basic();
  final QuillController _logController = QuillController.basic();
  void dispose() {
    _infoController.dispose();
    _logController.dispose();
    super.dispose();
  }
  Future<void> _showShareSettings(Session session, Campaign campaign) async {
    final odm = Odm.instance;
    await showDialog(
      context: context,
      builder: (context) => ShareSettingsDialog(
        session: session,
        onUpdate: (updatedSession) async {
          await odm.campaigns
              .doc(widget.partyId)
              .sessions
              .update(updatedSession);
        },
      ),
    );
    setState(() {}); // Refresh to show updated state
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;
    final currentUser = context.watch<AuthProvider>().user;
    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }
    final isDM = PermissionsUtils.isDM(campaign, currentUser?.id);
    return FutureBuilder<Session?>(
      future: odm.campaigns
          .doc(widget.partyId)
          .sessions
          .doc(widget.sessionId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e('Error fetching session: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        final session = snapshot.data;
        if (session == null) {
          return Center(child: Text('Session not found'));
        // Set up info controller (DM-only)
        if (isDM && session.info != null && session.info!.isNotEmpty) {
          try {
            _infoController.document = Document.fromJson(
              jsonDecode(session.info!),
            );
          } catch (e) {
            logger.e('Error parsing info delta: $e');
          }
        _infoController.readOnly = true;
        // Set up log controller (all users)
        if (session.log != null && session.log!.isNotEmpty) {
            _logController.document = Document.fromJson(
              jsonDecode(session.log!),
            logger.e('Error parsing log delta: $e');
        _logController.readOnly = true;
        return Column(
          children: [
            SurfaceContainer(
              title: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      if (session.datetime != null)
                        Text(
                          formatDateTime(session.datetime!),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                    ],
                  ),
                  const Spacer(),
                  if (isDM) ...[
                    ButtonM3E(
                      style: ButtonM3EStyle.tonal,
                      shape: ButtonM3EShape.square,
                      icon: const Icon(Icons.share_outlined),
                      label: const Text('Share'),
                      onPressed: () => _showShareSettings(session, campaign),
                    ),
                    const SizedBox(width: 8),
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(l10n.edit),
                      onPressed: () {
                        SessionEditRoute(
                          partyId: widget.partyId,
                          sessionId: widget.sessionId,
                        ).go(context);
                      },
                  ],
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: context.m3e.spacing.md,
                  // DM-only info section
                    Row(
                      children: [
                        Icon(
                          Icons.admin_panel_settings_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        const SizedBox(width: 8),
                          'DM Notes (Private)',
                          style: Theme.of(context).textTheme.titleMedium,
                      ],
                    if (session.info == null || session.info!.isEmpty)
                        'No DM notes yet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )
                    else
                      CustomQuillViewer(
                        controller: _infoController,
                        onMentionTap: (entityId, mentionType) async {
                          EntityRoute(entityId: entityId).push(context);
                        },
                    const Divider(height: 32),
                  // Shared log section
                  Row(
                      Icon(
                        Icons.article_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      const SizedBox(width: 8),
                        'Session Log',
                        style: Theme.of(context).textTheme.titleMedium,
                  if (session.log == null || session.log!.isEmpty)
                    Text(
                      'No session log yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  else
                    CustomQuillViewer(
                      controller: _logController,
                      onMentionTap: (entityId, mentionType) async {
                        EntityRoute(entityId: entityId).push(context);
            ),
          ],
        );
      },
