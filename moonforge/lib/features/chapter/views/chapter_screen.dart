import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/adventure.dart';
import 'package:moonforge/core/models/data/chapter.dart';
import 'package:moonforge/core/models/data/schema.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/core/widgets/wrap_layout.dart';
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
    final odm = Odm.instance;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    return FutureBuilder<Chapter?>(
      future: odm.campaigns
          .doc(campaign.id)
          .chapters
          .doc(widget.chapterId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e('Error fetching chapter: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final chapter = snapshot.data;
        if (chapter == null) {
          return Center(child: Text('Chapter not found'));
        }

        if (chapter.content != null) {
          try {
            _controller.document =
                Document.fromJson(jsonDecode(chapter.content!));
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
                      ChapterEditRoute(chapterId: widget.chapterId).go(context);
                    },
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: context.m3e.spacing.sm,
                children: [
                  if (chapter.summary?.trim().isNotEmpty == true)
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
                    QuillEditor(
                      controller: _controller,
                      scrollController: ScrollController(),
                      focusNode: FocusNode(),
                    ),
                ],
              ),
            ),
            WrapLayout(
              children: [
                _AdventuresSection(
                    campaign: campaign, chapterId: widget.chapterId),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _AdventuresSection extends StatelessWidget {
  const _AdventuresSection({
    required this.campaign,
    required this.chapterId,
  });

  final Campaign campaign;
  final String chapterId;

  @override
  Widget build(BuildContext context) {
    final odm = Odm.instance;
    final l10n = AppLocalizations.of(context)!;

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.adventures,
        icon: Icons.auto_stories_outlined,
      ),
      child: FutureBuilder<List<Adventure>>(
        future: odm.campaigns
            .doc(campaign.id)
            .chapters
            .doc(chapterId)
            .adventures
            .orderBy((o) => (o.order(),))
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(minHeight: 2);
          }
          if (snapshot.hasError) {
            logger.e('Error fetching adventures: ${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          }
          final adventures = snapshot.data ?? const <Adventure>[];
          if (adventures.isEmpty) {
            return Text(l10n.noAdventuresYet);
          }
          return CardList<Adventure>(
            items: adventures,
            titleOf: (a) => a.name,
            subtitleOf: (a) => a.summary ?? '',
            onTap: (a) =>
                AdventureRoute(chapterId: chapterId, adventureId: a.id)
                    .go(context),
          );
        },
      ),
    );
  }
}
