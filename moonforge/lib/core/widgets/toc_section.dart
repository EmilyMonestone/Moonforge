import 'package:flutter/material.dart';
import 'package:moonforge/core/models/toc_entry.dart';

/// A widget that wraps a section header and automatically registers it
/// with the TOC system.
///
/// Use this widget to wrap section headers in your pages to automatically
/// generate TOC entries.
class TocSection extends StatelessWidget {
  const TocSection({
    super.key,
    required this.title,
    required this.sectionKey,
    this.icon,
    this.level = 0,
    required this.child,
  });

  /// The title to display in the TOC
  final String title;

  /// The unique key for this section (used for scroll tracking)
  final GlobalKey sectionKey;

  /// Optional icon to display next to the title
  final IconData? icon;

  /// Indentation level (0 = top-level, 1+ = nested)
  final int level;

  /// The content of this section
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Wrap the child with a key so it can be tracked
    return Container(
      key: sectionKey,
      child: child,
    );
  }
}

/// Helper function to create TOC entries from a list of titles
List<TocEntry> createTocEntries(List<String> titles, {List<IconData>? icons}) {
  return List.generate(titles.length, (index) {
    return TocEntry(
      key: GlobalKey(),
      title: titles[index],
      icon: icons != null && index < icons.length ? icons[index] : null,
      level: 0,
    );
  });
}

/// Helper function to create a hierarchical TOC structure
List<TocEntry> createHierarchicalTocEntries(
  List<({String title, IconData? icon, int level})> items,
) {
  return items.map((item) {
    return TocEntry(
      key: GlobalKey(),
      title: item.title,
      icon: item.icon,
      level: item.level,
    );
  }).toList();
}
