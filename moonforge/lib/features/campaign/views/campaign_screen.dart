import 'package:flutter/material.dart';
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/adventure.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/core/models/data/chapter.dart';
import 'package:moonforge/core/models/data/scene.dart';
import 'package:moonforge/core/models/data/schema.dart';
import 'package:moonforge/core/models/data/session.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/responsive_sections.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';
import 'package:moonforge/features/home/widgets/section_header.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CampaignScreen extends StatefulWidget {
  const CampaignScreen({super.key});

  @override
  State<CampaignScreen> createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }
    return SurfaceContainer(
      title: Text(
        campaign.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          ResponsiveSectionsGrid(
            minColumnWidth: 420,
            spacing: 16,
            runSpacing: 16,
            sections: [
              _ChaptersSection(campaign: campaign),
              _RecentChaptersSection(campaign: campaign),
              _RecentAdventuresSection(campaign: campaign),
              _RecentScenesSection(campaign: campaign),
              _RecentSessionsSection(campaign: campaign),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChaptersSection extends StatelessWidget {
  const _ChaptersSection({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final odm = Odm.instance;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.chapters, icon: Icons.library_books_outlined),
        const SizedBox(height: 8),
        FutureBuilder<List<Chapter>>(
          future: odm.campaigns
              .doc(campaign.id)
              .chapters
              .orderBy((o) => (o.order(),))
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(minHeight: 2);
            }
            if (snapshot.hasError) {
              logger.e('Error fetching chapters: ${snapshot.error}');
              return Text('Error: ${snapshot.error}');
            }
            final chapters = snapshot.data ?? const <Chapter>[];
            if (chapters.isEmpty) {
              return Text(l10n.noChaptersYet);
            }
            return CardList<Chapter>(
              items: chapters,
              titleOf: (c) => c.name,
              subtitleOf: (c) => c.summary ?? '',
              onTap: (c) => ChapterRoute(chapterId: c.id).go(context),
            );
          },
        ),
      ],
    );
  }
}

class _RecentChaptersSection extends StatelessWidget {
  const _RecentChaptersSection({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final odm = Odm.instance;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.recentChapters, icon: Icons.update_outlined),
        const SizedBox(height: 8),
        FutureBuilder<List<Chapter>>(
          future: odm.campaigns
              .doc(campaign.id)
              .chapters
              .orderBy((o) => (o.updatedAt(descending: true),))
              .limit(5)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(minHeight: 2);
            }
            if (snapshot.hasError) {
              logger.e('Error fetching recent chapters: ${snapshot.error}');
              return Text('Error: ${snapshot.error}');
            }
            final items = snapshot.data ?? const <Chapter>[];
            if (items.isEmpty) {
              return const SizedBox.shrink();
            }
            return CardList<Chapter>(
              items: items,
              titleOf: (c) => c.name,
              subtitleOf: (c) => (c.updatedAt?.toLocal().toString() ?? ''),
              onTap: (c) => ChapterRoute(chapterId: c.id).go(context),
            );
          },
        ),
      ],
    );
  }
}

class _RecentAdventuresSection extends StatelessWidget {
  const _RecentAdventuresSection({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final odm = Odm.instance;
    final l10n = AppLocalizations.of(context)!;

    Future<List<(Adventure, String /*chapterId*/)>> load() async {
      final chapters = await odm.campaigns.doc(campaign.id).chapters.get();
      if (chapters.isEmpty) return const [];
      final futures = chapters.map((ch) async {
        final advs = await odm.campaigns
            .doc(campaign.id)
            .chapters
            .doc(ch.id)
            .adventures
            .orderBy((o) => (o.updatedAt(descending: true),))
            .limit(5)
            .get();
        return advs.map((a) => (a, ch.id));
      });
      final lists = await Future.wait(futures);
      final all = lists.expand((e) => e).toList();
      all.sort((a, b) {
        final ad = a.$1.updatedAt;
        final bd = b.$1.updatedAt;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return bd.compareTo(ad);
      });
      return all.take(5).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.recentAdventures,
          icon: Icons.update_outlined,
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<(Adventure, String)>>(
          future: load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(minHeight: 2);
            }
            if (snapshot.hasError) {
              logger.e('Error fetching recent adventures: ${snapshot.error}');
              return Text('Error: ${snapshot.error}');
            }
            final items = snapshot.data ?? const <(Adventure, String)>[];
            if (items.isEmpty) return const SizedBox.shrink();
            return CardList<(Adventure, String)>(
              items: items,
              titleOf: (t) => t.$1.name,
              subtitleOf: (t) => t.$1.updatedAt?.toLocal().toString() ?? '',
              onTap: (t) => AdventureRoute(
                chapterId: t.$2,
                adventureId: t.$1.id,
              ).go(context),
            );
          },
        ),
      ],
    );
  }
}

class _RecentScenesSection extends StatelessWidget {
  const _RecentScenesSection({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final odm = Odm.instance;
    final l10n = AppLocalizations.of(context)!;

    Future<List<(Scene, String /*chapterId*/, String /*adventureId*/)>>
    load() async {
      final chapters = await odm.campaigns.doc(campaign.id).chapters.get();
      if (chapters.isEmpty) return const [];
      final advLists = await Future.wait(
        chapters.map((ch) async {
          final advs = await odm.campaigns
              .doc(campaign.id)
              .chapters
              .doc(ch.id)
              .adventures
              .get();
          return advs.map((a) => (a, ch.id));
        }),
      );
      final allAdvs = advLists.expand((e) => e).toList();
      if (allAdvs.isEmpty) return const [];
      final scenesLists = await Future.wait(
        allAdvs.map((pair) async {
          final a = pair.$1;
          final chId = pair.$2;
          final scenes = await odm.campaigns
              .doc(campaign.id)
              .chapters
              .doc(chId)
              .adventures
              .doc(a.id)
              .scenes
              .orderBy((o) => (o.updatedAt(descending: true),))
              .limit(5)
              .get();
          return scenes.map((s) => (s, chId, a.id));
        }),
      );
      final all = scenesLists.expand((e) => e).toList();
      all.sort((a, b) {
        final ad = a.$1.updatedAt;
        final bd = b.$1.updatedAt;
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return bd.compareTo(ad);
      });
      return all.take(5).toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.recentScenes, icon: Icons.update_outlined),
        const SizedBox(height: 8),
        FutureBuilder<List<(Scene, String, String)>>(
          future: load(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(minHeight: 2);
            }
            if (snapshot.hasError) {
              logger.e('Error fetching recent scenes: ${snapshot.error}');
              return Text('Error: ${snapshot.error}');
            }
            final items = snapshot.data ?? const <(Scene, String, String)>[];
            if (items.isEmpty) return const SizedBox.shrink();
            return CardList<(Scene, String, String)>(
              items: items,
              titleOf: (t) => t.$1.title,
              subtitleOf: (t) => t.$1.updatedAt?.toLocal().toString() ?? '',
              onTap: (t) => SceneRoute(
                chapterId: t.$2,
                adventureId: t.$3,
                sceneId: t.$1.id,
              ).go(context),
            );
          },
        ),
      ],
    );
  }
}

class _RecentSessionsSection extends StatelessWidget {
  const _RecentSessionsSection({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final odm = Odm.instance;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: l10n.recentSessions,
          icon: Icons.schedule_outlined,
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<Session>>(
          future: odm.campaigns
              .doc(campaign.id)
              .sessions
              .orderBy((o) => (o.datetime(descending: true),))
              .limit(5)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator(minHeight: 2);
            }
            if (snapshot.hasError) {
              logger.e('Error fetching recent sessions: ${snapshot.error}');
              return Text('Error: ${snapshot.error}');
            }
            final items = snapshot.data ?? const <Session>[];
            if (items.isEmpty) return const SizedBox.shrink();
            return CardList<Session>(
              items: items,
              titleOf: (s) => s.info?.trim().isNotEmpty == true
                  ? s.info!.trim()
                  : (s.datetime != null
                        ? s.datetime!.toLocal().toString()
                        : 'Session ${s.id.substring(0, 6)}'),
              onTap: (s) {
                // Navigate into Party root; session route requires partyId which is not available here
                // Consider deep linking when party/session linkage is added.
              },
            );
          },
        ),
      ],
    );
  }
}
