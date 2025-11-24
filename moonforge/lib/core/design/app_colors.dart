import 'package:flutter/material.dart';

/// Semantic colors that extend Material tokens where needed.
abstract class AppColors {
  static const Color successLight = Color(0xFF00A86B);
  static const Color successDark = Color(0xFF4CD9A0);

  static const Color warningLight = Color(0xFFFFA000);
  static const Color warningDark = Color(0xFFFFC046);

  static const Color infoLight = Color(0xFF0288D1);
  static const Color infoDark = Color(0xFF4FC3F7);

  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);
}

extension ColorHelpers on Color {
  Color lighten([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    final lighter = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lighter).toColor();
  }

  Color darken([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    final darker = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(darker).toColor();
  }
}

extension ColorSchemeContextX on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Color get primary => colorScheme.primary;

  Color get onPrimary => colorScheme.onPrimary;

  Color get surface => colorScheme.surface;

  Color get onSurface => colorScheme.onSurface;

  Color get outline => colorScheme.outline;

  Color get error => colorScheme.error;
}
