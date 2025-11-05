import 'package:flutter/material.dart';
import 'package:moonforge/features/chapter/services/chapter_service.dart';

/// Widget for displaying chapter statistics
class ChapterStatsWidget extends StatelessWidget {
  const ChapterStatsWidget({
    super.key,
    required this.stats,
  });

  final ChapterStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          icon: Icons.auto_stories_outlined,
          label: 'Adventures',
          value: stats.adventureCount.toString(),
          color: theme.colorScheme.primary,
        ),
        _StatItem(
          icon: Icons.theaters_outlined,
          label: 'Scenes',
          value: stats.sceneCount.toString(),
          color: theme.colorScheme.secondary,
        ),
        _StatItem(
          icon: Icons.group_outlined,
          label: 'Entities',
          value: stats.entityCount.toString(),
          color: theme.colorScheme.tertiary,
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
