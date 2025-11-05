import 'package:flutter/material.dart';

/// Badge widget to display encounter difficulty
class EncounterDifficultyBadge extends StatelessWidget {
  final String difficulty;
  final bool compact;

  const EncounterDifficultyBadge({
    super.key,
    required this.difficulty,
    this.compact = false,
  });

  Color _getDifficultyColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.blue;
      case 'hard':
        return Colors.orange;
      case 'deadly':
        return Colors.red;
      default:
        return colorScheme.primary;
    }
  }

  IconData _getDifficultyIcon() {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Icons.sentiment_satisfied;
      case 'medium':
        return Icons.sentiment_neutral;
      case 'hard':
        return Icons.sentiment_dissatisfied;
      case 'deadly':
        return Icons.dangerous;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getDifficultyColor(context);
    final icon = _getDifficultyIcon();

    if (compact) {
      return Tooltip(
        message: difficulty,
        child: Icon(icon, color: color, size: 20),
      );
    }

    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(difficulty),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      visualDensity: VisualDensity.compact,
    );
  }
}
