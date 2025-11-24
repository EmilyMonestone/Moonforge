import 'package:flutter/material.dart';

extension TextStyleX on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  TextStyle colored(Color color) => copyWith(color: color);

  TextStyle withOpacity(double opacity) =>
      copyWith(color: color?.withValues(alpha: opacity));
}

extension TextThemeContextX on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;

  TextStyle get displayLarge => textStyles.displayLarge!;

  TextStyle get displayMedium => textStyles.displayMedium!;

  TextStyle get displaySmall => textStyles.displaySmall!;

  TextStyle get titleLarge => textStyles.titleLarge!;

  TextStyle get titleMedium => textStyles.titleMedium!;

  TextStyle get titleSmall => textStyles.titleSmall!;

  TextStyle get bodyLarge => textStyles.bodyLarge!;

  TextStyle get bodyMedium => textStyles.bodyMedium!;

  TextStyle get bodySmall => textStyles.bodySmall!;

  TextStyle get labelLarge => textStyles.labelLarge!;

  TextStyle get labelMedium => textStyles.labelMedium!;

  TextStyle get labelSmall => textStyles.labelSmall!;
}
