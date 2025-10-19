import 'package:flutter/material.dart';

/// A simple, reusable responsive grid that lays out provided sections
/// in 1..N columns depending on the available width.
///
/// It uses a Wrap with fixed item widths for each section based on the
/// computed column count, ensuring sections flow to multiple columns
/// on wider screens and stack on narrow screens.
class ResponsiveSectionsGrid extends StatelessWidget {
  const ResponsiveSectionsGrid({
    super.key,
    required this.sections,
    this.minColumnWidth = 420,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  /// The list of section widgets (e.g., a Column with a header and content).
  final List<Widget> sections;

  /// Minimum width a column should have before adding another column.
  final double minColumnWidth;

  /// Horizontal space between items.
  final double spacing;

  /// Vertical space between rows of items.
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        // Determine how many columns can fit based on the minimum width.
        int columns = (maxWidth / minColumnWidth).floor().clamp(1, sections.length);
        if (columns < 1) columns = 1;

        // Compute width each item should take. Account for spacing between items.
        final totalSpacing = spacing * (columns - 1);
        final itemWidth = (maxWidth - totalSpacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final section in sections)
              SizedBox(width: itemWidth, child: section),
          ],
        );
      },
    );
  }
}
