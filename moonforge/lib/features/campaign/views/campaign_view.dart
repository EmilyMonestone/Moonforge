import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart' show BuildContextM3EX;
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/entity_widgets_wrappers.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/section_header.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/core/widgets/wrap_layout.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';
import 'package:moonforge/features/campaign/widgets/campaign_header.dart';
import 'package:moonforge/features/campaign/widgets/campaign_stats_dashboard.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CampaignView extends StatefulWidget {
  const CampaignView({super.key});

  @override
  State<CampaignView> createState() => _CampaignViewState();
}

class _CampaignViewState extends State<CampaignView> {
  QuillController _controller = QuillController.basic();

  // Keep dedicated controllers/nodes to dispose properly.
  final ScrollController _quillScrollController = ScrollController();
  final FocusNode _quillFocusNode = FocusNode();

  Campaign? _lastCampaign;

  @override
  void initState() {
    super.initState();
    _controller.readOnly = true; // ensure viewer only
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final camp = context.read<CampaignProvider>().currentCampaign;
    if ((_lastCampaign?.id) != (camp?.id)) {
      Document doc;
      try {
        if (camp?.content != null) {
          final ops = camp!.content!['ops'] as List<dynamic>?;
          if (ops != null) {
            doc = Document.fromJson(ops);
          } else {
            doc = Document();
          }
        } else {
          doc = Document();
        }
      } catch (e) {
        logger.w('Invalid campaign content structure: $e');
        doc = Document();
      }
      // Replace controller so listeners rebuild properly
      _controller.dispose();
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      )..readOnly = true;
      _lastCampaign = camp;
      // Trigger rebuild for new controller
      setState(() {});
    }
  }

  @override
  void dispose() {
    _quillScrollController.dispose();
    _quillFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;
    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    final service = CampaignService(CampaignRepository(context.read<AppDb>()));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CampaignHeader(campaign: campaign),
        CampaignStatsDashboard(campaign: campaign, service: service),
        SurfaceContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.m3e.spacing.sm,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.shortDescription,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // Show description when non-empty; otherwise the fallback.
                    campaign.description.trim().isNotEmpty
                        ? campaign.description
                        : l10n.noDescriptionProvided,
                  ),
                ],
              ),
              CustomQuillViewer(
                controller: _controller,
                onMentionTap: (entityId, mentionType) async {
                  EntityRouteData(entityId: entityId).push(context);
                },
              ),
            ],
          ),
        ),
        WrapLayout(
          children: [
            _ChaptersSection(campaign: campaign),
            CampaignEntitiesWidget(campaignId: campaign.id),
            _RecentChaptersSection(campaign: campaign),
            _RecentAdventuresSection(campaign: campaign),
            _RecentScenesSection(campaign: campaign),
            _RecentSessionsSection(campaign: campaign),
          ],
        ),
      ],
    );
  }
}

class _ChaptersSection extends StatelessWidget {
  const _ChaptersSection({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Get all chapters from Drift
    // Note: Chapters don't have campaignId field yet, so we filter by ID prefix
    final allChapters = context.watch<List<Chapter>>();

    return SurfaceContainer(
      title: SectionHeader(title: l10n.chapters, icon: DomainType.chapter.icon),
      child: Builder(
        builder: (context) {
          // Filter chapters for this campaign by ID prefix using startsWith
          // Format: chapter-{campaignId}-{timestamp}
          var chapters = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList();
          // No fallback needed with explicit relationships
          chapters.sort((a, b) => a.order.compareTo(b.order));

          if (chapters.isEmpty) {
            return Text(l10n.noChaptersYet);
          }
          return CardList<Chapter>(
            items: chapters,
            titleOf: (c) => '${c.order}. ${c.name}',
            subtitleOf: (c) => c.summary ?? '',
            onTap: (c) => ChapterRouteData(chapterId: c.id).go(context),
            enableContextMenu: true,
            routeOf: (c) => ChapterRouteData(chapterId: c.id).location,
          );
        },
      ),
    );
  }
}

class _RecentChaptersSection extends StatelessWidget {
  const _RecentChaptersSection({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Get all chapters from Drift
    final allChapters = context.watch<List<Chapter>>();

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentChapters,
        icon: Icons.update_outlined,
      ),
      child: Builder(
        builder: (context) {
          // Filter chapters for this campaign by ID prefix using startsWith, sort by updatedAt desc, take 5
          var items = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList();
          // No fallback needed with explicit relationships
          items.sort((a, b) {
            final ad = a.updatedAt;
            final bd = b.updatedAt;
            if (ad == null && bd == null) return 0;
            if (ad == null) return 1;
            if (bd == null) return -1;
            return bd.compareTo(ad);
          });

          final recentItems = items.take(5).toList();

          if (recentItems.isEmpty) {
            return const SizedBox.shrink();
          }
          return CardList<Chapter>(
            items: recentItems,
            titleOf: (c) => '${c.order}. ${c.name}',
            subtitleOf: (c) => c.summary ?? '',
            onTap: (c) => ChapterRouteData(chapterId: c.id).go(context),
            enableContextMenu: true,
            routeOf: (c) => ChapterRouteData(chapterId: c.id).location,
          );
        },
      ),
    );
  }
}

class _RecentAdventuresSection extends StatelessWidget {
  const _RecentAdventuresSection({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Get all chapters and adventures from Drift
    final allChapters = context.watch<List<Chapter>>();
    final allAdventures = context.watch<List<Adventure>>();

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentAdventures,
        icon: Icons.update_outlined,
      ),
      child: Builder(
        builder: (context) {
          // Filter chapters for this campaign by ID pattern using startsWith
          final chapters = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList();

          if (chapters.isEmpty) {
            // Fallback: show global recent adventures if we cannot scope by chapter
            if (allAdventures.isEmpty) return const SizedBox.shrink();
            final generic = List.of(allAdventures)
              ..sort((a, b) {
                final ad = a.updatedAt;
                final bd = b.updatedAt;
                if (ad == null && bd == null) return 0;
                if (ad == null) return 1;
                if (bd == null) return -1;
                return bd.compareTo(ad);
              });
            final items = generic.take(5).toList();
            return CardList<Adventure>(
              items: items,
              titleOf: (a) => '${a.order}. ${a.name}',
              subtitleOf: (a) => a.summary ?? '',
              // No navigation without a known chapter mapping
            );
          }

          // Filter adventures by checking if their ID starts with chapter ID prefix
          // Note: Without parent IDs, we use ID patterns for filtering
          final List<(Adventure, String)> adventuresWithChapter = [];
          for (final ch in chapters) {
            final chapterAdvs = allAdventures
                .where((adv) => adv.chapterId == ch.id)
                .map((adv) => (adv, ch.id));
            adventuresWithChapter.addAll(chapterAdvs);
          }

          // If mapping by prefix produced nothing, try a heuristic mapping by containment
          if (adventuresWithChapter.isEmpty && allAdventures.isNotEmpty) {
            for (final adv in allAdventures) {
              // Try to find a chapter whose id appears in the adventure id
              String? matchedChapterId;
              for (final ch in chapters) {
                if (adv.id.contains(ch.id)) {
                  matchedChapterId = ch.id;
                  break;
                }
              }
              if (matchedChapterId != null) {
                adventuresWithChapter.add((adv, matchedChapterId));
              }
            }
          }

          // Sort by updatedAt desc
          adventuresWithChapter.sort((a, b) {
            final ad = a.$1.updatedAt;
            final bd = b.$1.updatedAt;
            final adValid = isValidDateTime(ad);
            final bdValid = isValidDateTime(bd);
            if (!adValid && !bdValid) return 0;
            if (!adValid) return 1;
            if (!bdValid) return -1;
            return bd!.compareTo(ad!);
          });

          // If still empty after heuristics, show generic list without navigation
          if (adventuresWithChapter.isEmpty) {
            if (allAdventures.isEmpty) return const SizedBox.shrink();
            final generic = List.of(allAdventures)
              ..sort((a, b) {
                final ad = a.updatedAt;
                final bd = b.updatedAt;
                if (ad == null && bd == null) return 0;
                if (ad == null) return 1;
                if (bd == null) return -1;
                return bd.compareTo(ad);
              });
            final items = generic.take(5).toList();
            return CardList<Adventure>(
              items: items,
              titleOf: (a) => '${a.order}. ${a.name}',
              subtitleOf: (a) => a.summary ?? '',
            );
          }

          final items = adventuresWithChapter.take(5).toList();
          return CardList<(Adventure, String)>(
            items: items,
            titleOf: (t) => '${t.$1.order}. ${t.$1.name}',
            subtitleOf: (t) => t.$1.summary ?? '',
            onTap: (t) => AdventureRouteData(
              chapterId: t.$2,
              adventureId: t.$1.id,
            ).go(context),
          );
        },
      ),
    );
  }
}

class _RecentScenesSection extends StatelessWidget {
  const _RecentScenesSection({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Get all chapters, adventures, and scenes from Drift
    final allChapters = context.watch<List<Chapter>>();
    final allAdventures = context.watch<List<Adventure>>();
    final allScenes = context.watch<List<Scene>>();

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentScenes,
        icon: Icons.update_outlined,
      ),
      child: Builder(
        builder: (context) {
          // Filter chapters for this campaign by ID pattern using startsWith
          final chapters = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList();

          // If we cannot scope by chapter, fall back to global scenes list
          if (chapters.isEmpty) {
            if (allScenes.isEmpty) return const SizedBox.shrink();
            final generic = List.of(allScenes)
              ..sort((a, b) {
                final ad = a.updatedAt;
                final bd = b.updatedAt;
                final adValid = isValidDateTime(ad);
                final bdValid = isValidDateTime(bd);
                if (!adValid && !bdValid) return 0;
                if (!adValid) return 1;
                if (!bdValid) return -1;
                return bd!.compareTo(ad!);
              });
            final items = generic.take(5).toList();
            return CardList<Scene>(
              items: items,
              titleOf: (s) => '${s.order}. ${s.name}',
              subtitleOf: (s) => s.summary ?? '',
              // No navigation without a known chapter/adventure mapping
            );
          }

          // Get adventures for these chapters using ID patterns with startsWith
          final List<(Adventure, String)> adventuresWithChapter = [];
          for (final ch in chapters) {
            final chapterAdvs = allAdventures
                .where((adv) => adv.chapterId == ch.id)
                .map((adv) => (adv, ch.id));
            adventuresWithChapter.addAll(chapterAdvs);
          }

          if (adventuresWithChapter.isEmpty) return const SizedBox.shrink();

          // Get scenes for these adventures using ID patterns with startsWith
          final List<(Scene, String, String)> scenesWithContext = [];
          for (final advPair in adventuresWithChapter) {
            final adv = advPair.$1;
            final chId = advPair.$2;
            final adventureScenes = allScenes
                .where((scene) => scene.adventureId == adv.id)
                .map((scene) => (scene, chId, adv.id));
            scenesWithContext.addAll(adventureScenes);
          }

          // Heuristic mapping by containment if id-based mapping produced nothing
          if (scenesWithContext.isEmpty && allScenes.isNotEmpty) {
            for (final scene in allScenes) {
              // try to find a matching adventure id contained in the scene id
              String? matchedChapterId;
              String? matchedAdventureId;
              for (final pair in adventuresWithChapter) {
                if (scene.id.contains(pair.$1.id)) {
                  matchedChapterId = pair.$2;
                  matchedAdventureId = pair.$1.id;
                  break;
                }
              }
              if (matchedAdventureId != null && matchedChapterId != null) {
                scenesWithContext.add((
                  scene,
                  matchedChapterId,
                  matchedAdventureId,
                ));
              }
            }
          }

          // Sort by updatedAt desc
          scenesWithContext.sort((a, b) {
            final ad = a.$1.updatedAt;
            final bd = b.$1.updatedAt;
            final adValid = isValidDateTime(ad);
            final bdValid = isValidDateTime(bd);
            if (!adValid && !bdValid) return 0;
            if (!adValid) return 1;
            if (!bdValid) return -1;
            return bd!.compareTo(ad!);
          });

          if (scenesWithContext.isEmpty) {
            if (allScenes.isEmpty) return const SizedBox.shrink();
            final generic = List.of(allScenes)
              ..sort((a, b) {
                final ad = a.updatedAt;
                final bd = b.updatedAt;
                final adValid = isValidDateTime(ad);
                final bdValid = isValidDateTime(bd);
                if (!adValid && !bdValid) return 0;
                if (!adValid) return 1;
                if (!bdValid) return -1;
                return bd!.compareTo(ad!);
              });
            final items = generic.take(5).toList();
            return CardList<Scene>(
              items: items,
              titleOf: (s) => '${s.order}. ${s.name}',
              subtitleOf: (s) => s.summary ?? '',
            );
          }

          final items = scenesWithContext.take(5).toList();

          return CardList<(Scene, String, String)>(
            items: items,
            titleOf: (t) => '${t.$1.order}. ${t.$1.name}',
            subtitleOf: (t) => t.$1.summary ?? '',
            onTap: (t) => SceneRouteData(
              chapterId: t.$2,
              adventureId: t.$3,
              sceneId: t.$1.id,
            ).go(context),
          );
        },
      ),
    );
  }
}

class _RecentSessionsSection extends StatelessWidget {
  const _RecentSessionsSection({required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Get all sessions from Drift
    final allSessions = context.watch<List<Session>>();

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentSessions,
        icon: Icons.schedule_outlined,
      ),
      child: Builder(
        builder: (context) {
          // Filter sessions for this campaign and sort by datetime desc
          // Note: With local-first, sessions don't have campaignId yet,
          // so we get all sessions. This will need to be updated when
          // session-campaign relationship is added to the schema.
          final items = allSessions.toList()
            ..sort((a, b) {
              final ad = a.datetime;
              final bd = b.datetime;
              if (ad == null && bd == null) return 0;
              if (ad == null) return 1;
              if (bd == null) return -1;
              return bd.compareTo(ad);
            });

          final recentItems = items.take(5).toList();
          if (recentItems.isEmpty) return const SizedBox.shrink();

          return CardList<Session>(
            items: recentItems,
            titleOf: (s) => s.datetime != null
                ? s.datetime!.toLocal().toString()
                : 'Session ${s.id.substring(0, 6)}',
            onTap: (s) {
              // Navigate into Party root; session route requires partyId which is not available here
              // Consider deep linking when party/session linkage is added.
            },
          );
        },
      ),
    );
  }
}
