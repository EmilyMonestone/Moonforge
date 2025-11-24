import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/section_header.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RecentChaptersSection extends StatelessWidget {
  const RecentChaptersSection({super.key, required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final allChapters = context.watch<List<Chapter>>();

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentChapters,
        icon: Icons.update_outlined,
      ),
      child: Builder(
        builder: (context) {
          var items = allChapters
              .where((ch) => ch.campaignId == campaign.id)
              .toList();
          items.sort((a, b) {
            final ad = a.updatedAt;
            final bd = b.updatedAt;
            if (ad == null && bd == null) return 0;
            if (ad == null) return 1;
            if (bd == null) return -1;
            return bd.compareTo(ad);
          });

          final recentItems = items.take(5).toList();

          if (recentItems.isEmpty) return const SizedBox.shrink();

          return CardList<Chapter>(
            items: recentItems,
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
