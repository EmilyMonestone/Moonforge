// Responsive breakpoints and size classes used across the app.
// Keep this in sync with docs/responsive layout/breakpoints.md

import 'package:flutter/material.dart';

/// Three size classes to simplify layout branching
enum SizeClass { compact, medium, expanded }

class AppSizeClass {
  static const double compactMax = 600; // phones (portrait-first)
  static const double mediumMax = 1024; // small tablets / landscape phones

  /// Derive a size class from a width in logical pixels
  static SizeClass fromWidth(double width) {
    if (width < compactMax) return SizeClass.compact;
    if (width < mediumMax) return SizeClass.medium;
    return SizeClass.expanded;
  }

  /// Convenience helper from BuildContext
  static SizeClass of(BuildContext context) =>
      fromWidth(MediaQuery.sizeOf(context).width);

  /// Whether we should try to show a split (two‑pane) layout.
  /// You can tune this threshold per your content needs.
  static bool prefersTwoPane(double width) => width >= 840;
}
