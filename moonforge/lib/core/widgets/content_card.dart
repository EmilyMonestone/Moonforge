import 'package:flutter/material.dart';

/// Card wrapper with configurable spacing and tap handling for repeated layouts.
///
/// ```dart
/// ContentCard(
///   onTap: () => openCampaign(campaign),
///   child: Column(
///     crossAxisAlignment: CrossAxisAlignment.start,
///     children: [
///       Text(campaign.name, style: theme.textTheme.titleMedium),
///       const SizedBox(height: 8),
///       Text(campaign.summary),
///     ],
///   ),
/// );
/// ```
class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin,
      child: Padding(padding: padding, child: child),
    );

    if (onTap == null) return card;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: card,
    );
  }
}
