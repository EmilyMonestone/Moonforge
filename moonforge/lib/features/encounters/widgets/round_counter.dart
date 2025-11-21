import 'package:flutter/material.dart';

/// Widget to display the current round counter
class RoundCounter extends StatelessWidget {
  final int round;

  const RoundCounter({super.key, required this.round});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.restore, size: 20, color: colorScheme.onPrimaryContainer),
          const SizedBox(width: 8),
          Text(
            'Round $round',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
