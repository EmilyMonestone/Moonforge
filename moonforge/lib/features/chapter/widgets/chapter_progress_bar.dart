import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Widget for displaying visual progress through a chapter
class ChapterProgressBar extends StatelessWidget {
  const ChapterProgressBar({
    super.key,
    required this.chapters,
    required this.currentChapterId,
    this.onChapterTap,
  });

  final List<Chapter> chapters;
  final String currentChapterId;
  final void Function(Chapter chapter)? onChapterTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedChapters = List<Chapter>.from(chapters)
      ..sort((a, b) => a.order.compareTo(b.order));

    final currentIndex = sortedChapters.indexWhere(
      (c) => c.id == currentChapterId,
    );
    final progress = currentIndex >= 0
        ? (currentIndex + 1) / sortedChapters.length
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: theme.colorScheme.surfaceContainer,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${currentIndex + 1} / ${sortedChapters.length}',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Chapter indicators
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sortedChapters.length,
            separatorBuilder: (context, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final chapter = sortedChapters[index];
              final isCurrent = chapter.id == currentChapterId;
              final isPast = index < currentIndex;

              return InkWell(
                onTap: onChapterTap != null
                    ? () => onChapterTap!(chapter)
                    : null,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? theme.colorScheme.primary
                        : isPast
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainer,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCurrent
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      width: isCurrent ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isCurrent
                            ? theme.colorScheme.onPrimary
                            : isPast
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
