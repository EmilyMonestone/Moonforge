import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Widget for displaying chapter structure overview
class ChapterOutline extends StatelessWidget {
  const ChapterOutline({
    super.key,
    required this.chapter,
    required this.adventures,
    this.onAdventureTap,
  });

  final Chapter chapter;
  final List<Adventure> adventures;
  final void Function(Adventure adventure)? onAdventureTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final sortedAdventures = List<Adventure>.from(adventures)
      ..sort((a, b) => a.order.compareTo(b.order));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chapter header
        Text(
          chapter.name,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (chapter.summary != null && chapter.summary!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            chapter.summary!,
            style: textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Adventures outline
        if (sortedAdventures.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'No adventures yet',
              style: textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ...sortedAdventures.asMap().entries.map((entry) {
            final index = entry.key;
            final adventure = entry.value;
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
              child: InkWell(
                onTap: onAdventureTap != null
                    ? () => onAdventureTap!(adventure)
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number circle
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Adventure info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            adventure.name,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (adventure.summary != null &&
                              adventure.summary!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                adventure.summary!,
                                style: textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
