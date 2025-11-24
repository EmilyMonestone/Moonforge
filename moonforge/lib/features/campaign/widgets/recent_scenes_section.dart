import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/widgets/section_header.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RecentScenesSection extends StatelessWidget {
  const RecentScenesSection({super.key, required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          final chapters = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList();

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
            );
          }

          final List<(Adventure, String)> adventuresWithChapter = [];
          for (final ch in chapters) {
            final chapterAdvs = allAdventures
                .where((adv) => adv.chapterId == ch.id)
                .map((adv) => (adv, ch.id));
            adventuresWithChapter.addAll(chapterAdvs);
          }

          if (adventuresWithChapter.isEmpty) return const SizedBox.shrink();

          final List<(Scene, String, String)> scenesWithContext = [];
          for (final advPair in adventuresWithChapter) {
            final adv = advPair.$1;
            final chId = advPair.$2;
            final adventureScenes = allScenes
                .where((scene) => scene.adventureId == adv.id)
                .map((scene) => (scene, chId, adv.id));
            scenesWithContext.addAll(adventureScenes);
          }

          if (scenesWithContext.isEmpty && allScenes.isNotEmpty) {
            for (final scene in allScenes) {
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
