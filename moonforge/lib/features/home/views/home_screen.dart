import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/core/models/data/party.dart';
import 'package:moonforge/core/models/data/schema.dart';
import 'package:moonforge/core/models/data/session.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/responsive_sections.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../widgets/recent_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final odm = Odm.instance;
    final uid = fb_auth.FirebaseAuth.instance.currentUser?.uid;
    final campaignProvider = Provider.of<CampaignProvider>(
      context,
      listen: false,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          ResponsiveSectionsGrid(
            minColumnWidth: 420,
            spacing: 16,
            runSpacing: 16,
            sections: [
              // Recent Campaigns
              RecentSection<Campaign>(
                title: l10n.recentCampaigns,
                icon: Icons.book_outlined,
                future: uid == null
                    ? Future.value(const <Campaign>[])
                    : odm.campaigns
                        .where(($) => $.ownerUid(isEqualTo: uid))
                        .orderBy(($) => ($.updatedAt(descending: true),))
                        .limit(5)
                        .get(),
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
              // Recent Sessions (across all campaigns user has access to)
              RecentSection<Session>(
                title: l10n.recentSessions,
                icon: Icons.schedule_outlined,
                future: () async {
                  if (uid == null) return const <Session>[];
                  // Load campaigns where user is owner and where user is a member
                  final owned = await odm.campaigns
                      .where(($) => $.ownerUid(isEqualTo: uid))
                      .get();
                  final member = await odm.campaigns
                      .where(($) => $.memberUids(arrayContains: uid))
                      .get();
                  // Merge unique campaigns by id
                  final Map<String, Campaign> campaignMap = {
                    for (final c in [...owned, ...member]) c.id: c,
                  };
                  if (campaignMap.isEmpty) return const <Session>[];
                  // For each campaign, fetch recent sessions
                  final futures = campaignMap.values.map(
                    (c) => odm.campaigns
                        .doc(c.id)
                        .sessions
                        .orderBy(($) => ($.datetime(descending: true),))
                        .limit(5)
                        .get(),
                  );
                  final lists = await Future.wait(futures);
                  final all = lists.expand((e) => e).toList();
                  // Sort by datetime desc and take top 5
                  all.sort((a, b) {
                    final ad = a.datetime;
                    final bd = b.datetime;
                    if (ad == null && bd == null) return 0;
                    if (ad == null) return 1;
                    if (bd == null) return -1;
                    return bd.compareTo(ad);
                  });
                  return all.take(5).toList();
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
              // Recent Parties (across all campaigns user has access to)
              RecentSection<Party>(
                title: l10n.recentParties,
                icon: Icons.group_outlined,
                future: () async {
                  if (uid == null) return const <Party>[];
                  final owned = await odm.campaigns
                      .where(($) => $.ownerUid(isEqualTo: uid))
                      .get();
                  final member = await odm.campaigns
                      .where(($) => $.memberUids(arrayContains: uid))
                      .get();
                  final Map<String, Campaign> campaignMap = {
                    for (final c in [...owned, ...member]) c.id: c,
                  };
                  if (campaignMap.isEmpty) return const <Party>[];
                  final futures = campaignMap.values.map(
                    (c) => odm.campaigns
                        .doc(c.id)
                        .parties
                        .orderBy(($) => ($.updatedAt(descending: true),))
                        .limit(5)
                        .get(),
                  );
                  final lists = await Future.wait(futures);
                  final all = lists.expand((e) => e).toList();
                  all.sort((a, b) {
                    final ad = a.updatedAt;
                    final bd = b.updatedAt;
                    if (ad == null && bd == null) return 0;
                    if (ad == null) return 1;
                    if (bd == null) return -1;
                    return bd.compareTo(ad);
                  });
                  return all.take(5).toList();
                }(),
                titleOf: (p) => p.name,
                onTap: (party) {
                  // TODO: Navigate to specific party
                  const PartyRootRoute().go(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
