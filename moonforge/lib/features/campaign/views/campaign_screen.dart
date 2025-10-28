import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/entity_widgets_wrappers.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/core/widgets/wrap_layout.dart';
import 'package:moonforge/data/firebase/models/adventure.dart';
import 'package:moonforge/data/firebase/models/campaign.dart';
import 'package:moonforge/data/firebase/models/chapter.dart';
import 'package:moonforge/data/firebase/models/scene.dart';
import 'package:moonforge/data/firebase/models/session.dart';
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
  final QuillController _controller = QuillController.basic();

  // Keep dedicated controllers/nodes to dispose properly.
  final ScrollController _quillScrollController = ScrollController();
  final FocusNode _quillFocusNode = FocusNode();

  Campaign? _lastCampaign;

  @override
  void initState() {
    super.initState();
    // Ensure read-only editor once; avoid toggling during build.
    // Some versions expose readOnly on the controller; if not available, this is a no-op at compile time.
    // ignore: invalid_use
    _controller.readOnly = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update the editor's document only when the campaign actually changes.
    final camp = context.read<CampaignProvider>().currentCampaign;
    if ((_lastCampaign?.id) != (camp?.id)) {
      try {
        if (camp?.content != null && camp!.content!.trim().isNotEmpty) {
          _controller.document = Document.fromJson(jsonDecode(camp.content!));
        } else {
          _controller.document = Document();
        }
      } catch (e) {
        logger.w('Invalid campaign content JSON: $e');
        logger.t('Stacktrace for invalid campaign content', error: e);
        _controller.document = Document();
      }
      _lastCampaign = camp;
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
    return Column(
      children: [
        SurfaceContainer(
          title: Row(
            children: [
              Text(
                campaign.name,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Spacer(),
              ButtonM3E(
                style: ButtonM3EStyle.tonal,
                shape: ButtonM3EShape.square,
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.edit),
                onPressed: () {
                  CampaignEditRoute().go(context);
                },
              ),
            ],
          ),
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
              const SizedBox(height: 8),
              Text(
                l10n.description,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              CustomQuillViewer(
                controller: _controller,
                onMentionTap: (entityId, mentionType) async {
                  // Navigate to entity details when mention is clicked
                  EntityRoute(entityId: entityId).push(context);
                },
              ),
            ],
          ),
        ),
        WrapLayout(
          children: [
            _ChaptersSection(campaign: campaign),
            _RecentChaptersSection(campaign: campaign),
            _RecentAdventuresSection(campaign: campaign),
            _RecentScenesSection(campaign: campaign),
            _RecentSessionsSection(campaign: campaign),
            CampaignEntitiesWidget(campaignId: campaign.id),
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
    
    // Get all chapters from Drift and filter by campaign
    final allChapters = context.watch<List<Chapter>>();

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.chapters,
        icon: Icons.library_books_outlined,
      ),
      child: Builder(
        builder: (context) {
          // Filter chapters for this campaign and sort by order
          final chapters = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList()
            ..sort((a, b) => a.order.compareTo(b.order));
          
          if (chapters.isEmpty) {
            return Text(l10n.noChaptersYet);
          }
          return CardList<Chapter>(
            items: chapters,
            titleOf: (c) => '${c.order}. ${c.name}',
            subtitleOf: (c) => c.summary ?? '',
            onTap: (c) => ChapterRoute(chapterId: c.id).go(context),
            enableContextMenu: true,
            routeOf: (c) => ChapterRoute(chapterId: c.id).location,
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
    
    // Get all chapters from Drift and filter by campaign
    final allChapters = context.watch<List<Chapter>>();
    
    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentChapters,
        icon: Icons.update_outlined,
      ),
      child: Builder(
        builder: (context) {
          // Filter chapters for this campaign, sort by updatedAt desc, take 5
          final items = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList()
            ..sort((a, b) {
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
          if (recentItems.isNotEmpty) {
            logger.i(recentItems.first.updatedAt);
          }
          return CardList<Chapter>(
            items: recentItems,
            titleOf: (c) => '${c.order}. ${c.name}',
            subtitleOf: (c) => formatDateTime(c.updatedAt),
            onTap: (c) => ChapterRoute(chapterId: c.id).go(context),
            enableContextMenu: true,
            routeOf: (c) => ChapterRoute(chapterId: c.id).location,
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
          // Filter chapters for this campaign
          final chapters = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList();
          
          if (chapters.isEmpty) return const SizedBox.shrink();
          
          // Filter adventures for these chapters and pair with chapter ID
          final List<(Adventure, String)> adventuresWithChapter = [];
          for (final ch in chapters) {
            final chapterAdvs = allAdventures
                .where((adv) => adv.chapterId == ch.id)
                .map((adv) => (adv, ch.id));
            adventuresWithChapter.addAll(chapterAdvs);
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
          
          final items = adventuresWithChapter.take(5).toList();
          if (items.isEmpty) return const SizedBox.shrink();
          
          return CardList<(Adventure, String)>(
            items: items,
            titleOf: (t) => '${t.$1.order}. ${t.$1.name}',
            subtitleOf: (t) => formatDateTime(t.$1.updatedAt),
            onTap: (t) => AdventureRoute(
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
          // Filter chapters for this campaign
          final chapters = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList();
          
          if (chapters.isEmpty) return const SizedBox.shrink();
          
          // Get adventures for these chapters
          final List<(Adventure, String)> adventuresWithChapter = [];
          for (final ch in chapters) {
            final chapterAdvs = allAdventures
                .where((adv) => adv.chapterId == ch.id)
                .map((adv) => (adv, ch.id));
            adventuresWithChapter.addAll(chapterAdvs);
          }
          
          if (adventuresWithChapter.isEmpty) return const SizedBox.shrink();
          
          // Get scenes for these adventures
          final List<(Scene, String, String)> scenesWithContext = [];
          for (final advPair in adventuresWithChapter) {
            final adv = advPair.$1;
            final chId = advPair.$2;
            final adventureScenes = allScenes
                .where((scene) => scene.adventureId == adv.id)
                .map((scene) => (scene, chId, adv.id));
            scenesWithContext.addAll(adventureScenes);
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
          
          final items = scenesWithContext.take(5).toList();
          if (items.isEmpty) return const SizedBox.shrink();
          
          return CardList<(Scene, String, String)>(
            items: items,
            titleOf: (t) => '${t.$1.order}. ${t.$1.title}',
            subtitleOf: (t) => formatDateTime(t.$1.updatedAt),
            onTap: (t) => SceneRoute(
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
    );
  }
}
