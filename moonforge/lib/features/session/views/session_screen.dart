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
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/data/repo/session_repository.dart';
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

  @override
  void dispose() {
    _infoController.dispose();
    _logController.dispose();
    super.dispose();
  }

  Future<void> _showShareSettings(
    db.Session session,
    db.Campaign campaign,
  ) async {
    final repo = context.read<SessionRepository>();
    await showDialog(
      context: context,
      builder: (context) => ShareSettingsDialog(
        session: session,
        onUpdate: (updatedSession) async {
          await repo.update(updatedSession);
        },
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;
    final currentUserUid = context.watch<AuthProvider>().uid;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    final isDM = PermissionsUtils.isDM(campaign, currentUserUid);

    return FutureBuilder<db.Session?>(
      future: context.read<SessionRepository>().getById(widget.sessionId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e('Error fetching session: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final session = snapshot.data;
        if (session == null) {
          return Center(child: Text('Session not found'));
        }

        // Set up info controller (DM-only)
        if (isDM && session.info != null && session.info!.isNotEmpty) {
          try {
            final ops = session.info!['ops'] as List<dynamic>?;
            if (ops != null) _infoController.document = Document.fromJson(ops);
          } catch (e) {
            logger.e('Error parsing info delta: $e');
          }
        }
        _infoController.readOnly = true;

        // Set up log controller (all users)
        if (session.log != null && session.log!.isNotEmpty) {
          try {
            final ops = session.log!['ops'] as List<dynamic>?;
            if (ops != null) _logController.document = Document.fromJson(ops);
          } catch (e) {
            logger.e('Error parsing log delta: $e');
          }
        }
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
                  if (isDM)
                    ButtonM3E(
                      onPressed: () => _showShareSettings(session, campaign),
                      label: Text(l10n.shareSettings),
                      icon: const Icon(Icons.share_outlined),
                      style: ButtonM3EStyle.outlined,
                      shape: ButtonM3EShape.square,
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: context.m3e.spacing.md,
                children: [
                  // DM-only info section
                  if (isDM) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.admin_panel_settings_outlined,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'DM Notes (Private)',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    if (session.info == null || session.info!.isEmpty)
                      Text(
                        'No DM notes yet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      )
                    else
                      CustomQuillViewer(
                        controller: _infoController,
                        onMentionTap: (entityId, mentionType) async {
                          EntityRoute(entityId: entityId).push(context);
                        },
                      ),
                    const Divider(height: 32),
                  ],

                  // Shared log section
                  Row(
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Session Log',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  if (session.log == null || session.log!.isEmpty)
                    Text(
                      'No session log yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    CustomQuillViewer(
                      controller: _logController,
                      onMentionTap: (entityId, mentionType) async {
                        EntityRoute(entityId: entityId).push(context);
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
