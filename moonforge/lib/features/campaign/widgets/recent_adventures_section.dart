import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/widgets/section_header.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RecentAdventuresSection extends StatelessWidget {
  const RecentAdventuresSection({super.key, required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final allChapters = context.watch<List<Chapter>>();
    final allAdventures = context.watch<List<Adventure>>();

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentAdventures,
        icon: Icons.update_outlined,
      ),
      child: Builder(
        builder: (context) {
          final chapters = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList();

          if (chapters.isEmpty) {
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

          final List<(Adventure, String)> adventuresWithChapter = [];
          for (final ch in chapters) {
            final chapterAdvs = allAdventures
                .where((adv) => adv.chapterId == ch.id)
                .map((adv) => (adv, ch.id));
            adventuresWithChapter.addAll(chapterAdvs);
          }

          if (adventuresWithChapter.isEmpty && allAdventures.isNotEmpty) {
            for (final adv in allAdventures) {
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
