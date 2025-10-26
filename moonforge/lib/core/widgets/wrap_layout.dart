import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart' show BuildContextM3EX;

/// A layout widget that arranges its children in a wrap layout.
class WrapLayout extends StatelessWidget {
  const WrapLayout({
    super.key,
    this.maxColumns = 2,
    this.spacing,
    this.runSpacing,
    this.minWidth = 250,
    this.maxWidth = double.infinity,
    required this.children,
  });

  final List<Widget> children;

  /// default [2]
  final int maxColumns;

  /// default [250]
  final double minWidth;

  /// default [double.infinity]
  final double maxWidth;

  /// default [context.m3e.spacing.sm]
  final double? spacing;

  /// default [context.m3e.spacing.sm]
  final double? runSpacing;

  @override
  Widget build(BuildContext context) {
    final spacingUse = spacing ?? context.m3e.spacing.sm;
    final runSpacingUse = runSpacing ?? context.m3e.spacing.sm;
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;
        if (maxColumns <= 1) {
          return Column(spacing: spacingUse, children: children);
        }
        final double itemWidth =
            (availableWidth - (spacingUse * (maxColumns - 1))) / maxColumns;
        final double constrainedItemWidth = itemWidth
            .clamp(minWidth, maxWidth)
            .clamp(0, availableWidth);
        return Wrap(
          spacing: spacingUse,
          runSpacing: runSpacingUse,
          children: children.map((child) {
            return SizedBox(width: constrainedItemWidth, child: child);
          }).toList(),
        );
      },
    );
  }
}
