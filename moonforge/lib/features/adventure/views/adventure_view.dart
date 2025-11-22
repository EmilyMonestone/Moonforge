import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/entity_widgets_wrappers.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/section_header.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/core/widgets/wrap_layout.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AdventureView extends StatefulWidget {
  const AdventureView({
    super.key,
    required this.chapterId,
    required this.adventureId,
  });

  final String chapterId;
  final String adventureId;

  @override
  State<AdventureView> createState() => _AdventureViewState();
}

class _AdventureViewState extends State<AdventureView> {
  final QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    final adventureRepo = context.read<AdventureRepository>();

    return FutureBuilder<Adventure?>(
      future: adventureRepo.getById(widget.adventureId),
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
          try {
            final ops = adventure.content!['ops'] as List<dynamic>?;
            if (ops != null) {
              _controller.document = Document.fromJson(ops);
            } else {
              _controller.document = Document()
                ..insert(0, adventure.summary ?? '');
            }
          } catch (_) {
            _controller.document = Document()
              ..insert(0, adventure.summary ?? '');
          }
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
                  const Spacer(),
                  ButtonM3E(
                    style: ButtonM3EStyle.tonal,
                    shape: ButtonM3EShape.square,
                    icon: const Icon(Icons.edit_outlined),
                    label: Text(l10n.edit),
                    onPressed: () {
                      AdventureEditRouteData(
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
                _ScenesSection(
                  chapterId: widget.chapterId,
                  adventureId: widget.adventureId,
                ),
                AdventureEntitiesWidget(
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
  const _ScenesSection({required this.chapterId, required this.adventureId});

  final String chapterId;
  final String adventureId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sceneRepo = context.read<SceneRepository>();

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentScenes,
        icon: Icons.movie_outlined,
      ),
      child: FutureBuilder<List<Scene>>(
        future: sceneRepo.getByAdventure(adventureId),
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
          // Sort by updatedAt desc (nulls last)
          scenes.sort((a, b) {
            final ua = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            final ub = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
            return ub.compareTo(ua);
          });
          return CardList<Scene>(
            items: scenes,
            titleOf: (s) => s.name,
            subtitleOf: (s) => formatDateTime(s.updatedAt),
            onTap: (s) => SceneRouteData(
              chapterId: chapterId,
              adventureId: adventureId,
              sceneId: s.id,
            ).go(context),
            enableContextMenu: true,
            routeOf: (s) => SceneRouteData(
              chapterId: chapterId,
              adventureId: adventureId,
              sceneId: s.id,
            ).location,
          );
        },
      ),
    );
  }
}
