import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/section_header.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RecentSessionsSection extends StatelessWidget {
  const RecentSessionsSection({super.key, required this.campaign});

  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final allSessions = context.watch<List<Session>>();

    return SurfaceContainer(
      title: SectionHeader(
        title: l10n.recentSessions,
        icon: Icons.schedule_outlined,
      ),
      child: Builder(
        builder: (context) {
          final items = allSessions.toList()
            ..sort((a, b) {
              final ad = a.datetime;
              final bd = b.datetime;
              if (ad == null && bd == null) return 0;
              if (ad == null) return 1;
              if (bd == null) return -1;
              return bd.compareTo(ad);
            });

          final recentItems = items.take(5).toList();
          if (recentItems.isEmpty) return const SizedBox.shrink();

          return CardList<Session>(
            items: recentItems,
            titleOf: (s) => s.datetime != null
                ? s.datetime!.toLocal().toString()
                : 'Session ${s.id.substring(0, 6)}',
            onTap: (s) {
              // Navigation deferred until session-party relationships exist
            },
          );
        },
      ),
    );
  }
}
