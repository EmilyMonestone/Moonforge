import 'package:flutter/material.dart';
import 'package:moonforge/core/design/design_system.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// Displays an empty/placeholder state with icon, title, optional message & action.
///
/// ```dart
/// EmptyState(
///   icon: Icons.campaign_outlined,
///   title: l10n.noCampaignsYet,
///   message: l10n.createNewCampaign,
///   actionLabel: l10n.create,
///   onAction: () => createCampaign(context),
/// );
/// ```
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final widgets = <Widget>[
      Icon(icon, size: 64, color: theme.colorScheme.onSurfaceVariant),
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
      if (actionLabel != null && onAction != null) ...[
        const SizedBox(height: AppSpacing.xl),
        FilledButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    ];

    return Center(
      child: Padding(
        padding: AppSpacing.paddingXxl,
        child: Column(mainAxisSize: MainAxisSize.min, children: widgets),
      ),
    );
  }

  /// Convenience factory for a standard "nothing here" state.
  factory EmptyState.standard(BuildContext context, {VoidCallback? onAction}) {
    final l10n = AppLocalizations.of(context)!;
    return EmptyState(
      icon: Icons.inbox_outlined,
      title: l10n.emptyStateNoItems,
      message: l10n.emptyStateGenericMessage,
      actionLabel: onAction != null ? l10n.create : null,
      onAction: onAction,
    );
  }
}
