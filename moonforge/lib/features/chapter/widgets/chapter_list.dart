import 'package:flutter/material.dart';
import 'package:moonforge/core/design/design_system.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/chapter/widgets/chapter_card.dart';

/// Widget for displaying a list of chapters with optional reordering
class ChapterList extends StatelessWidget {
  const ChapterList({
    super.key,
    required this.chapters,
    this.onReorder,
    this.showOrder = true,
    this.onChapterTap,
    this.emptyMessage,
  });

  final List<Chapter> chapters;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final bool showOrder;
  final void Function(Chapter chapter)? onChapterTap;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.paddingXl,
          child: Text(
            emptyMessage ?? 'No chapters yet',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    // If reordering is enabled, use ReorderableListView
    if (onReorder != null) {
      return ReorderableListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: chapters.length,
        onReorder: onReorder!,
        itemBuilder: (context, index) {
          final chapter = chapters[index];
          return Padding(
            key: ValueKey(chapter.id),
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ChapterCard(
              chapter: chapter,
              showOrder: showOrder,
              onTap: onChapterTap != null
                  ? () => onChapterTap!(chapter)
                  : () {
                      ChapterRouteData(chapterId: chapter.id).go(context);
                    },
            ),
          );
        },
      );
    }

    // Otherwise, use a regular ListView
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chapters.length,
      separatorBuilder: (context, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        return ChapterCard(
          chapter: chapter,
          showOrder: showOrder,
          onTap: onChapterTap != null
              ? () => onChapterTap!(chapter)
              : () {
                  ChapterRouteData(chapterId: chapter.id).go(context);
                },
        );
      },
    );
  }
}
