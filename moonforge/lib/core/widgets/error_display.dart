import 'package:flutter/material.dart';
import 'package:moonforge/core/design/design_system.dart';

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
      const SizedBox(height: AppSpacing.xl),
      Text(
        title,
        style: theme.textTheme.titleMedium,
        textAlign: TextAlign.center,
      ),
      if (message != null) ...[
        const SizedBox(height: AppSpacing.sm),
        Text(
          message!,
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
      if (onRetry != null) ...[
        const SizedBox(height: AppSpacing.xl),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    ];

    return Center(
      child: Padding(
        padding: AppSpacing.paddingXxl,
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}
