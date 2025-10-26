import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/adventure.dart';
import 'package:moonforge/core/models/data/scene.dart';
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

class AdventureScreen extends StatefulWidget {
  const AdventureScreen({
    super.key,
    required this.chapterId,
    required this.adventureId,
  });

  final String chapterId;
  final String adventureId;

  @override
  State<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends State<AdventureScreen> {
  final QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;
    final odm = Odm.instance;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    return FutureBuilder<Adventure?>(
      future: odm.campaigns
          .doc(campaign.id)
          .chapters
          .doc(widget.chapterId)
          .adventures
          .doc(widget.adventureId)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e('Error fetching adventure: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final adventure = snapshot.data;
        if (adventure == null) {
          return Center(child: Text('Adventure not found'));
        }

        if (adventure.content != null) {
          _controller.document =
              Document.fromJson(jsonDecode(adventure.content!));
        }
        _controller.readOnly = true;

        return Column(
          children: [
            SurfaceContainer(
              title: Row(
                children: [
                  Text(
                    adventure.name,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Spacer(),
                  ButtonM3E(
                    style: ButtonM3EStyle.tonal,
                    shape: ButtonM3EShape.square,
                    icon: Icon(Icons.edit_outlined),
                    label: Text(l10n.edit),
                    onPressed: () {
                      AdventureEditRoute(
                        chapterId: widget.chapterId,
                        adventureId: widget.adventureId,
                      ).go(context);
                    },
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: context.m3e.spacing.sm,
                children: [
                  if (adventure.summary != null &&
                      adventure.summary!.trim().isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.description,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(adventure.summary!),
                      ],
                    ),
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
                _ScenesSection(
                  campaignId: campaign.id,
                  chapterId: widget.chapterId,
                  adventureId: widget.adventureId,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ScenesSection extends StatelessWidget {
  const _ScenesSection({
    required this.campaignId,
    required this.chapterId,
    required this.adventureId,
  });

  final String campaignId;
  final String chapterId;
  final String adventureId;

  @override
  Widget build(BuildContext context) {
    final odm = Odm.instance;
    final l10n = AppLocalizations.of(context)!;

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentScenes,
        icon: Icons.movie_outlined,
      ),
      child: FutureBuilder<List<Scene>>(
        future: odm.campaigns
            .doc(campaignId)
            .chapters
            .doc(chapterId)
            .adventures
            .doc(adventureId)
            .scenes
            .orderBy((o) => (o.updatedAt(descending: true),))
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator(minHeight: 2);
          }
          if (snapshot.hasError) {
            logger.e('Error fetching scenes: ${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          }
          final scenes = snapshot.data ?? const <Scene>[];
          if (scenes.isEmpty) {
            return Text('No scenes yet');
          }
          return CardList<Scene>(
            items: scenes,
            titleOf: (s) => s.title,
            subtitleOf: (s) => (s.updatedAt?.toLocal().toString() ?? ''),
            onTap: (s) => SceneRoute(
              chapterId: chapterId,
              adventureId: adventureId,
              sceneId: s.id,
            ).go(context),
          );
        },
      ),
    );
  }
}
