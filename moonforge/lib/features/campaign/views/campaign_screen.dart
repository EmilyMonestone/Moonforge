import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/adventure.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/core/models/data/chapter.dart';
import 'package:moonforge/core/models/data/scene.dart';
import 'package:moonforge/core/models/data/schema.dart';
import 'package:moonforge/core/models/data/session.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/core/widgets/wrap_layout.dart';
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
    final odm = Odm.instance;
    final l10n = AppLocalizations.of(context)!;

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.chapters,
        icon: Icons.library_books_outlined,
      ),
      child: FutureBuilder<List<Chapter>>(
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
            titleOf: (c) => '${c.order}. ${c.name}',
            subtitleOf: (c) => c.summary ?? '',
            onTap: (c) => ChapterRoute(chapterId: c.id).go(context),
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
    final odm = Odm.instance;
    final l10n = AppLocalizations.of(context)!;
    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentChapters,
        icon: Icons.update_outlined,
      ),
      child: FutureBuilder<List<Chapter>>(
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
          logger.i(items.first.updatedAt);
          return CardList<Chapter>(
            items: items,
            titleOf: (c) => '${c.order}. ${c.name}',
            subtitleOf: (c) => formatDateTime(c.updatedAt),
            onTap: (c) => ChapterRoute(chapterId: c.id).go(context),
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
        final adValid = isValidDateTime(ad);
        final bdValid = isValidDateTime(bd);
        if (!adValid && !bdValid) return 0;
        if (!adValid) return 1;
        if (!bdValid) return -1;
        return bd!.compareTo(ad!);
      });
      return all.take(5).toList();
    }

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentAdventures,
        icon: Icons.update_outlined,
      ),
      child: FutureBuilder<List<(Adventure, String)>>(
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
        final adValid = isValidDateTime(ad);
        final bdValid = isValidDateTime(bd);
        if (!adValid && !bdValid) return 0;
        if (!adValid) return 1;
        if (!bdValid) return -1;
        return bd!.compareTo(ad!);
      });
      return all.take(5).toList();
    }

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentScenes,
        icon: Icons.update_outlined,
      ),
      child: FutureBuilder<List<(Scene, String, String)>>(
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
    final odm = Odm.instance;
    final l10n = AppLocalizations.of(context)!;
    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentSessions,
        icon: Icons.schedule_outlined,
      ),
      child: FutureBuilder<List<Session>>(
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
    );
  }
}
