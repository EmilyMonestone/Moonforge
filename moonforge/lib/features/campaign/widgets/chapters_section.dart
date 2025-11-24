import 'package:flutter/material.dart';
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/section_header.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ChaptersSection extends StatelessWidget {
  const ChaptersSection({super.key, required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Get all chapters from Drift
    final allChapters = context.watch<List<Chapter>>();

    return SurfaceContainer(
      title: SectionHeader(title: l10n.chapters, icon: DomainType.chapter.icon),
      child: Builder(
        builder: (context) {
          var chapters = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList();
          chapters.sort((a, b) => a.order.compareTo(b.order));

          if (chapters.isEmpty) {
            return Text(l10n.noChaptersYet);
          }
          return CardList<Chapter>(
            items: chapters,
            titleOf: (c) => '${c.order}. ${c.name}',
            subtitleOf: (c) => c.summary ?? '',
            onTap: (c) => ChapterRouteData(chapterId: c.id).go(context),
            enableContextMenu: true,
            routeOf: (c) => ChapterRouteData(chapterId: c.id).location,
          );
        },
      ),
    );
  }
}
