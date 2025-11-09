import 'package:flutter/material.dart';

/// A widget that shows the completion status of a scene
class SceneCompletionIndicator extends StatelessWidget {
  const SceneCompletionIndicator({
    super.key,
    required this.isCompleted,
    this.onToggle,
    this.showLabel = true,
  });

  final bool isCompleted;
  final VoidCallback? onToggle;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: isCompleted,
              onChanged: onToggle != null ? (_) => onToggle!() : null,
            ),
            if (showLabel) ...[
              const SizedBox(width: 8),
              Text(
                isCompleted ? 'Completed' : 'Mark as complete',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isCompleted
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                  fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
            if (isCompleted && !showLabel) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check_circle,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
