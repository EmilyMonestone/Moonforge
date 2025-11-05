import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/home/widgets/card_list.dart';

/// Widget for displaying adventures within a chapter
class ChapterAdventureList extends StatelessWidget {
  const ChapterAdventureList({
    super.key,
    required this.adventures,
    required this.chapterId,
    this.onAdventureTap,
    this.emptyMessage,
  });

  final List<Adventure> adventures;
  final String chapterId;
  final void Function(Adventure adventure)? onAdventureTap;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (adventures.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            emptyMessage ?? 'No adventures yet',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      );
    }

    final sortedAdventures = List<Adventure>.from(adventures)
      ..sort((a, b) => a.order.compareTo(b.order));

    return CardList<Adventure>(
      items: sortedAdventures,
      titleOf: (a) => a.name,
      subtitleOf: (a) => a.summary ?? '',
      onTap: onAdventureTap ??
          (a) {
            AdventureRoute(
              chapterId: chapterId,
              adventureId: a.id,
            ).go(context);
          },
      enableContextMenu: true,
      routeOf: (a) => AdventureRoute(
        chapterId: chapterId,
        adventureId: a.id,
      ).location,
    );
  }
}
