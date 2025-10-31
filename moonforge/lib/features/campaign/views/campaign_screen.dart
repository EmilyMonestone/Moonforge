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
import 'package:moonforge/data/db/app_db.dart';
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
  void initState() {
    super.initState();
    // Ensure read-only editor once; avoid toggling during build.
    // Some versions expose readOnly on the controller; if not available, this is a no-op at compile time.
    // ignore: invalid_use
    _controller.readOnly = true;
  }
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
  void dispose() {
    _quillScrollController.dispose();
    _quillFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;
    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
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
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.m3e.spacing.sm,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.shortDescription,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                    // Show description when non-empty; otherwise the fallback.
                    campaign.description.trim().isNotEmpty
                        ? campaign.description
                        : l10n.noDescriptionProvided,
                ],
              const SizedBox(height: 8),
                l10n.description,
                style: Theme.of(context).textTheme.titleMedium,
              CustomQuillViewer(
                controller: _controller,
                onMentionTap: (entityId, mentionType) async {
                  // Navigate to entity details when mention is clicked
                  EntityRoute(entityId: entityId).push(context);
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
      ],
    );
class _ChaptersSection extends StatelessWidget {
  const _ChaptersSection({required this.campaign});
  final Campaign campaign;
    // Get all chapters from Drift
    // Note: Chapters don't have campaignId field yet, so we filter by ID prefix
    final allChapters = context.watch<List<Chapter>>();
    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.chapters,
        icon: Icons.library_books_outlined,
      ),
      child: Builder(
        builder: (context) {
          // Filter chapters for this campaign by ID prefix using startsWith
          // Format: chapter-{campaignId}-{timestamp}
          var chapters = allChapters
              .where((ch) => ch.id.startsWith('chapter-${campaign.id}-'))
              .toList();
          if (chapters.isEmpty && allChapters.isNotEmpty) {
            // Fallback: show all chapters when relation is not encoded in IDs.
            chapters = List.of(allChapters);
          }
          chapters.sort((a, b) => a.order.compareTo(b.order));
          if (chapters.isEmpty) {
            return Text(l10n.noChaptersYet);
          return CardList<Chapter>(
            items: chapters,
            titleOf: (c) => '${c.order}. ${c.name}',
            subtitleOf: (c) => c.summary ?? '',
            onTap: (c) => ChapterRoute(chapterId: c.id).go(context),
            enableContextMenu: true,
            routeOf: (c) => ChapterRoute(chapterId: c.id).location,
          );
        },
class _RecentChaptersSection extends StatelessWidget {
  const _RecentChaptersSection({required this.campaign});
        title: l10n.recentChapters,
        icon: Icons.update_outlined,
          // Filter chapters for this campaign by ID prefix using startsWith, sort by updatedAt desc, take 5
          var items = allChapters
          if (items.isEmpty && allChapters.isNotEmpty) {
            // Fallback: use all chapters
            items = List.of(allChapters);
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
          if (recentItems.isNotEmpty) {
            logger.i(recentItems.first.updatedAt);
            items: recentItems,
class _RecentAdventuresSection extends StatelessWidget {
  const _RecentAdventuresSection({required this.campaign});
    // Get all chapters and adventures from Drift
    final allAdventures = context.watch<List<Adventure>>();
        title: l10n.recentAdventures,
          // Filter chapters for this campaign by ID pattern using startsWith
          final chapters = allChapters
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
          // Filter adventures by checking if their ID starts with chapter ID prefix
          // Note: Without parent IDs, we use ID patterns for filtering
          final List<(Adventure, String)> adventuresWithChapter = [];
          for (final ch in chapters) {
            final chapterAdvs = allAdventures
                .where((adv) => adv.id.startsWith('adventure-${ch.id}-'))
                .map((adv) => (adv, ch.id));
            adventuresWithChapter.addAll(chapterAdvs);
          // If mapping by prefix produced nothing, try a heuristic mapping by containment
          if (adventuresWithChapter.isEmpty && allAdventures.isNotEmpty) {
            for (final adv in allAdventures) {
              final match = chapters.firstWhere(
                (ch) => adv.id.contains(ch.id),
                orElse: () =>
                    Chapter(id: '', name: '', order: 0, entityIds: const []),
              );
              if (match.id.isNotEmpty) {
                adventuresWithChapter.add((adv, match.id));
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
          // If still empty after heuristics, show generic list without navigation
          if (adventuresWithChapter.isEmpty) {
          final items = adventuresWithChapter.take(5).toList();
          return CardList<(Adventure, String)>(
            items: items,
            titleOf: (t) => '${t.$1.order}. ${t.$1.name}',
            subtitleOf: (t) => t.$1.summary ?? '',
            onTap: (t) => AdventureRoute(
              chapterId: t.$2,
              adventureId: t.$1.id,
            ).go(context),
class _RecentScenesSection extends StatelessWidget {
  const _RecentScenesSection({required this.campaign});
    // Get all chapters, adventures, and scenes from Drift
    final allScenes = context.watch<List<scene_model.Scene>>();
        title: l10n.recentScenes,
          // If we cannot scope by chapter, fall back to global scenes list
            if (allScenes.isEmpty) return const SizedBox.shrink();
            final generic = List.of(allScenes)
                final adValid = isValidDateTime(ad);
                final bdValid = isValidDateTime(bd);
                if (!adValid && !bdValid) return 0;
                if (!adValid) return 1;
                if (!bdValid) return -1;
                return bd!.compareTo(ad!);
            return CardList<scene_model.Scene>(
              titleOf: (s) => '${s.order}. ${s.title}',
              subtitleOf: (s) => s.summary ?? '',
              // No navigation without a known chapter/adventure mapping
          // Get adventures for these chapters using ID patterns with startsWith
          if (adventuresWithChapter.isEmpty) return const SizedBox.shrink();
          // Get scenes for these adventures using ID patterns with startsWith
          final List<(scene_model.Scene, String, String)> scenesWithContext =
              [];
          for (final advPair in adventuresWithChapter) {
            final adv = advPair.$1;
            final chId = advPair.$2;
            final adventureScenes = allScenes
                .where((scene) => scene.id.startsWith('scene-${adv.id}-'))
                .map((scene) => (scene, chId, adv.id));
            scenesWithContext.addAll(adventureScenes);
          // Heuristic mapping by containment if id-based mapping produced nothing
          if (scenesWithContext.isEmpty && allScenes.isNotEmpty) {
            for (final scene in allScenes) {
              // try to find a matching adventure id contained in the scene id
              final matchAdv = adventuresWithChapter.firstWhere(
                (pair) => scene.id.contains(pair.$1.id),
                orElse: () => (const Adventure(id: '', name: ''), ''),
              if (matchAdv.$1.id.isNotEmpty) {
                scenesWithContext.add((scene, matchAdv.$2, matchAdv.$1.id));
          scenesWithContext.sort((a, b) {
          if (scenesWithContext.isEmpty) {
          final items = scenesWithContext.take(5).toList();
          return CardList<(scene_model.Scene, String, String)>(
            titleOf: (t) => '${t.$1.order}. ${t.$1.title}',
            onTap: (t) => SceneRoute(
              adventureId: t.$3,
              sceneId: t.$1.id,
class _RecentSessionsSection extends StatelessWidget {
  const _RecentSessionsSection({required this.campaign});
    // Get all sessions from Drift
    final allSessions = context.watch<List<Session>>();
        title: l10n.recentSessions,
        icon: Icons.schedule_outlined,
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
          if (recentItems.isEmpty) return const SizedBox.shrink();
          return CardList<Session>(
            titleOf: (s) => s.info?.trim().isNotEmpty == true
                ? s.info!.trim()
                : (s.datetime != null
                      ? s.datetime!.toLocal().toString()
                      : 'Session ${s.id.substring(0, 6)}'),
            onTap: (s) {
              // Navigate into Party root; session route requires partyId which is not available here
              // Consider deep linking when party/session linkage is added.
            },
