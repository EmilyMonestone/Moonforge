import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/entity_widgets_wrappers.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/core/widgets/wrap_layout.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';
import 'package:moonforge/features/home/widgets/section_header.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ChapterScreen extends StatefulWidget {
  const ChapterScreen({super.key, required this.chapterId});

  final String chapterId;

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final QuillController _controller = QuillController.basic();

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

    final contentMap = chapter.content;
    if (contentMap != null) {
      try {
        final ops = contentMap['ops'] as List<dynamic>?;
        if (ops != null) {
          _controller.document = Document.fromJson(ops);
        }
      } catch (e) {
        logger.e('Error parsing chapter content: $e');
      }
    }
    _controller.readOnly = true;

    return Column(
      children: [
        SurfaceContainer(
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
              if (chapter.content != null)
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
            _AdventuresSection(
              campaignId: campaign.id,
              chapterId: widget.chapterId,
            ),
            ChapterEntitiesWidget(
              campaignId: campaign.id,
              chapterId: widget.chapterId,
            ),
          ],
        ),
      ],
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
        icon: Icons.auto_stories_outlined,
      ),
      child: Builder(
        builder: (context) {
          if (adventures.isEmpty) {
            return Text(l10n.noAdventuresYet);
          }
          return CardList<db.Adventure>(
            items: adventures,
            titleOf: (a) => a.name,
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
