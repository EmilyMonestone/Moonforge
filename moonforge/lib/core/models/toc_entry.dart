import 'package:flutter/material.dart';

/// Represents a single entry in a Table of Contents.
///
/// Each entry has a unique [key] to identify it, a [title] to display,
/// an optional [icon] for visual representation, and a [level] for indentation
/// (0 for top-level, 1+ for nested entries).
class TocEntry {
  const TocEntry({
    required this.key,
    required this.title,
    this.icon,
    this.level = 0,
  });

  /// Unique identifier for this TOC entry, used for scroll tracking
  final GlobalKey key;

  /// Display text for this entry
  final String title;

  /// Optional icon to display next to the title
  final IconData? icon;

  /// Indentation level (0 = top-level, 1+ = nested)
  final int level;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TocEntry &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          title == other.title &&
          icon == other.icon &&
          level == other.level;

  @override
  int get hashCode => Object.hash(key, title, icon, level);
}
