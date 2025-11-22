import 'package:flutter/material.dart';

/// Centered error view with optional retry action.
///
/// ```dart
/// return ErrorDisplay(
///   title: l10n.failedToLoadCampaigns,
///   message: error?.toString(),
///   onRetry: _loadCampaigns,
/// );
/// ```
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final children = <Widget>[
      Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
      const SizedBox(height: 16),
      Text(
        title,
        style: theme.textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
      if (message != null) ...[
        const SizedBox(height: 8),
        Text(
          message!,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
      if (onRetry != null) ...[
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}
