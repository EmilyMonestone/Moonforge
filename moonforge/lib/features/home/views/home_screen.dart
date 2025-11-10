import 'package:drift/drift.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/core/widgets/wrap_layout.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/session_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/home/widgets/recent_section.dart';
import 'package:moonforge/features/home/widgets/stats_overview_widget.dart';
import 'package:moonforge/features/home/widgets/upcoming_sessions_widget.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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

    final campaignsRepo = context.read<CampaignRepository>();
    final sessionsRepo = context.read<SessionRepository>();
    final partiesRepo = context.read<PartyRepository>();

    return WrapLayout(
      minWidth: 420,
      children: [
        SurfaceContainer(
          title: Text(
            l10n.dashboardStats,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          child: const StatsOverviewWidget(),
        ),
        SurfaceContainer(
          title: Text(
            l10n.upcomingSessions,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          child: const UpcomingSessionsWidget(),
        ),
        SurfaceContainer(
          title: Text(
            l10n.recentCampaigns,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          child: RecentSection<Campaign>(
            future: (() async {
              if (uid == null) return const <Campaign>[];
              final list = await campaignsRepo.customQuery(
                filter: (c) =>
                    c.ownerUid.equals(uid) | c.memberUids.contains(uid),
                sort: [
                  (c) => OrderingTerm(
                    expression: c.updatedAt,
                    mode: OrderingMode.desc,
                  ),
                ],
                limit: 5,
              );
              return list;
            })(),
            titleOf: (c) => c.name,
            subtitleOf: (c) => c.description,
            onTap: (item) {
              campaignProvider.setCurrentCampaign(item);
              context.go(const CampaignRoute().location);
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
            future: (() async {
              if (uid == null) return const <Session>[];
              final list = await sessionsRepo.customQuery(
                sort: [
                  (s) => OrderingTerm(
                    expression: s.datetime,
                    mode: OrderingMode.desc,
                  ),
                ],
                limit: 5,
              );
              return list;
            })(),
            titleOf: (ses) => ses.datetime != null
                ? ses.datetime!.toLocal().toString()
                : 'Session ${ses.id.substring(0, 6)}',
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
              final list = await partiesRepo.customQuery(
                sort: [
                  (p) => OrderingTerm(
                    expression: p.updatedAt,
                    mode: OrderingMode.desc,
                  ),
                ],
                limit: 5,
              );
              return list;
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
