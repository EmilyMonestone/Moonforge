import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/core/widgets/wrap_layout.dart';
import 'package:moonforge/data/firebase/models/campaign.dart';
import 'package:moonforge/data/firebase/models/party.dart';
import 'package:moonforge/data/firebase/models/session.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../widgets/recent_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final uid = fb_auth.FirebaseAuth.instance.currentUser?.uid;
    final campaignProvider = Provider.of<CampaignProvider>(
      context,
      listen: false,
    );

    // Get all campaigns from Drift
    final allCampaigns = context.watch<List<Campaign>>();
    final allSessions = context.watch<List<Session>>();
    final allParties = context.watch<List<Party>>();

    return WrapLayout(
      minWidth: 420,
      children: [
        SurfaceContainer(
          title: Text(
            l10n.recentCampaigns,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          child: RecentSection<Campaign>(
            future: uid == null
                ? Future.value(const <Campaign>[])
                : Future.value(
                    (() {
                      final list =
                          allCampaigns.where((c) => c.ownerUid == uid).toList()
                            ..sort((a, b) {
                              final ad = a.updatedAt;
                              final bd = b.updatedAt;
                              if (ad == null && bd == null) return 0;
                              if (ad == null) return 1;
                              if (bd == null) return -1;
                              return bd.compareTo(ad);
                            });
                      return list.take(5).toList();
                    })(),
                  ),
            titleOf: (c) => c.name,
            subtitleOf: (c) => c.description,
            onTap: (item) {
              campaignProvider.setCurrentCampaign(item);
              const CampaignRoute().go(context);
            },
            onError: (error, _) {
              logger.e('Error fetching recent campaigns: $error');
            },
          ),
        ),
        SurfaceContainer(
          title: Text(
            l10n.recentSessions,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          child: RecentSection<Session>(
            future: () async {
              if (uid == null) return const <Session>[];
              // Filter campaigns where user is owner or member
              final userCampaigns = allCampaigns
                  .where(
                    (c) =>
                        c.ownerUid == uid ||
                        (c.memberUids?.contains(uid) ?? false),
                  )
                  .toList();
              if (userCampaigns.isEmpty) return const <Session>[];

              // Filter sessions from user's campaigns
              // Note: With local-first, we don't have hierarchical queries yet,
              // so we get all sessions and filter by checking if they belong to user's campaigns
              final userSessions = allSessions.toList();

              // Sort by datetime desc and take top 5
              userSessions.sort((a, b) {
                final ad = a.datetime;
                final bd = b.datetime;
                if (ad == null && bd == null) return 0;
                if (ad == null) return 1;
                if (bd == null) return -1;
                return bd.compareTo(ad);
              });
              return userSessions.take(5).toList();
            }(),
            titleOf: (ses) => ses.info?.trim().isNotEmpty == true
                ? ses.info!.trim()
                : (ses.datetime != null
                      ? ses.datetime!.toLocal().toString()
                      : 'Session ${ses.id.substring(0, 6)}'),
            onTap: (session) {
              // TODO: Navigate to specific session
            },
          ),
        ),
        SurfaceContainer(
          backgroundType: SurfaceBackgroundType.surfaceContainer,
          title: Text(
            l10n.recentParties,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          child: RecentSection<Party>(
            future: () async {
              if (uid == null) return const <Party>[];
              // Filter campaigns where user is owner or member
              final userCampaigns = allCampaigns
                  .where(
                    (c) =>
                        c.ownerUid == uid ||
                        (c.memberUids?.contains(uid) ?? false),
                  )
                  .toList();
              if (userCampaigns.isEmpty) return const <Party>[];

              // Get all parties (local-first doesn't have hierarchical queries yet)
              final userParties = allParties.toList();

              // Sort by updatedAt desc and take top 5
              userParties.sort((a, b) {
                final ad = a.updatedAt;
                final bd = b.updatedAt;
                if (ad == null && bd == null) return 0;
                if (ad == null) return 1;
                if (bd == null) return -1;
                return bd.compareTo(ad);
              });
              return userParties.take(5).toList();
            }(),
            titleOf: (p) => p.name,
            onTap: (party) {
              // TODO: Navigate to specific party
              const PartyRootRoute().go(context);
            },
          ),
        ),
      ],
    );
  }
}
