import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/core/models/toc_entry.dart';
import 'package:moonforge/core/models/toc_notification.dart';
import 'package:moonforge/core/providers/toc_provider.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/entity_widgets_wrappers.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/section_header.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/core/widgets/wrap_layout.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/chapter/services/chapter_navigation_service.dart';
import 'package:moonforge/features/chapter/widgets/chapter_navigation_widget.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ChapterView extends StatefulWidget {
  const ChapterView({super.key, required this.chapterId});

  final String chapterId;

  @override
  State<ChapterView> createState() => _ChapterViewState();
}

class _ChapterViewState extends State<ChapterView> {
  QuillController _controller = QuillController.basic();
  db.Chapter? _lastChapter;

  // TOC section keys
  final _chapterKey = GlobalKey();
  final _adventuresKey = GlobalKey();
  final _entitiesKey = GlobalKey();
  final _navigationKey = GlobalKey();

  late final List<TocEntry> _tocEntries;

  @override
  void initState() {
    super.initState();
    
    // Initialize TOC entries
    _tocEntries = [
      TocEntry(
        key: _chapterKey,
        title: 'Chapter',
        icon: Icons.book_outlined,
        level: 0,
      ),
      TocEntry(
        key: _adventuresKey,
        title: 'Adventures',
        icon: Icons.explore_outlined,
        level: 0,
      ),
      TocEntry(
        key: _entitiesKey,
        title: 'Entities',
        icon: Icons.people_outline,
        level: 0,
      ),
      TocEntry(
        key: _navigationKey,
        title: 'Navigation',
        icon: Icons.navigation_outlined,
        level: 0,
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final chapters = context.watch<List<db.Chapter>>();
    final chapter = chapters.firstWhere(
      (c) => c.id == widget.chapterId,
      orElse: () => db.Chapter(
        id: '',
        campaignId: '',
        name: '',
        order: 0,
        entityIds: const <String>[],
        rev: 0,
      ),
    );
    if (chapter.id.isEmpty) return; // not found, skip controller update
    if (_lastChapter?.id != chapter.id || _lastChapter?.rev != chapter.rev) {
      Document doc;
      try {
        final contentMap = chapter.content;
        if (contentMap != null) {
          final ops = contentMap['ops'] as List<dynamic>?;
          doc = ops != null ? Document.fromJson(ops) : Document();
        } else {
          doc = Document();
        }
      } catch (e) {
        logger.e('Error parsing chapter content: $e');
        doc = Document();
      }
      _controller.dispose();
      _controller = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      )..readOnly = true;
      _lastChapter = chapter;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    // Get chapter from local list
    final chapters = context.watch<List<db.Chapter>>();
    final chapter = chapters.firstWhere(
      (c) => c.id == widget.chapterId,
      orElse: () => db.Chapter(
        id: '',
        campaignId: '',
        name: '',
        order: 0,
        entityIds: const <String>[],
        rev: 0,
      ),
    );
    if (chapter.id.isEmpty) {
      return Center(child: Text('Chapter not found'));
    }

    _controller.readOnly = true;
    final chapterNav = getIt<ChapterNavigationService>();

    // Send TOC notification to scaffold
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TocEntriesNotification(_tocEntries).dispatch(context);
    });

    return TocScope(
      entries: _tocEntries,
      child: Column(
        children: [
          Container(
            key: _chapterKey,
            child: SurfaceContainer(
              title: Row(
                children: [
                  Text(
                    chapter.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Spacer(),
                  ButtonM3E(
                    style: ButtonM3EStyle.tonal,
                    shape: ButtonM3EShape.square,
                    icon: Icon(Icons.edit_outlined),
                    label: Text(l10n.edit),
                    onPressed: () {
                      ChapterEditRouteData(chapterId: widget.chapterId).go(context);
                    },
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: context.m3e.spacing.sm,
                children: [
                  if ((chapter.summary ?? '').trim().isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Summary',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(chapter.summary ?? ''),
                      ],
                    ),
                  if (chapter.content != null && (_controller.document.length > 0))
                    CustomQuillViewer(
                      controller: _controller,
                      onMentionTap: (entityId, mentionType) async {
                        EntityRouteData(entityId: entityId).push(context);
                      },
                    ),
                ],
              ),
            ),
          ),
          WrapLayout(
            children: [
              Container(
                key: _adventuresKey,
                child: _AdventuresSection(
                  campaignId: campaign.id,
                  chapterId: widget.chapterId,
                ),
              ),
              Container(
                key: _entitiesKey,
                child: ChapterEntitiesWidget(
                  campaignId: campaign.id,
                  chapterId: widget.chapterId,
                ),
              ),
              Container(
                key: _navigationKey,
                child: FutureBuilder<int?>(
                  future: chapterNav.getChapterPosition(widget.chapterId),
                  builder: (context, snapshot) {
                    final position = snapshot.data;
                    return FutureBuilder<int>(
                      future: chapterNav.getTotalChapters(campaign.id),
                      builder: (context, totalSnapshot) {
                        if (position == null || !totalSnapshot.hasData) {
                          return const SizedBox.shrink();
                        }
                        return ChapterNavigationWidget(
                          currentChapter: chapter,
                          currentPosition: position,
                          totalChapters: totalSnapshot.data,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdventuresSection extends StatelessWidget {
  const _AdventuresSection({required this.campaignId, required this.chapterId});

  final String campaignId;
  final String chapterId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Get all adventures and filter by chapter via id prefix or chapterId
    final allAdventures = context.watch<List<db.Adventure>>();
    final adventures =
        allAdventures
            .where(
              (a) =>
                  a.id.startsWith('adventure-$chapterId-') ||
                  a.chapterId == chapterId,
            )
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.adventures,
        icon: DomainType.adventure.icon,
      ),
      child: Builder(
        builder: (context) {
          if (adventures.isEmpty) {
            return Text(l10n.noAdventuresYet);
          }
          return CardList<db.Adventure>(
            items: adventures,
            titleOf: (a) => '${(a.order ?? 0) + 1}. ${a.name}',
            subtitleOf: (a) => a.summary ?? '',
            onTap: (a) => AdventureRouteData(
              chapterId: chapterId,
              adventureId: a.id,
            ).go(context),
            enableContextMenu: true,
            routeOf: (a) => AdventureRouteData(
              chapterId: chapterId,
              adventureId: a.id,
            ).location,
          );
        },
      ),
    );
  }
}
