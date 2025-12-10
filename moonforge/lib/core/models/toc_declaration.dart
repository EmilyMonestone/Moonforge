import 'package:flutter/material.dart';
import 'package:moonforge/core/models/toc_entry.dart';

/// A widget that declares TOC entries for a page without creating the TocScope.
/// This allows the scaffold to access TOC entries and pass them to the navigation rail.
///
/// Usage:
/// ```dart
/// TocDeclaration(
///   entries: [...],
///   child: pageContent,
/// )
/// ```
class TocDeclaration extends InheritedWidget {
  final List<TocEntry> entries;

  const TocDeclaration({
    super.key,
    required this.entries,
    required super.child,
  });

  static List<TocEntry>? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<TocDeclaration>()
        ?.entries;
  }

  @override
  bool updateShouldNotify(TocDeclaration oldWidget) {
    return entries != oldWidget.entries;
  }
}
