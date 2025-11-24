import 'package:flutter/material.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color surfaceContainerLow;
  final Color surfaceContainerHigh;
  final Color success;
  final Color warning;
  final Color info;

  const AppThemeExtension({
    required this.surfaceContainerLow,
    required this.surfaceContainerHigh,
    required this.success,
    required this.warning,
    required this.info,
  });

  static AppThemeExtension light(ColorScheme scheme) => AppThemeExtension(
    surfaceContainerLow: scheme.surfaceContainerLow,
    surfaceContainerHigh: scheme.surfaceContainerHigh,
    success: const Color(0xFF00A86B),
    warning: const Color(0xFFFFA000),
    info: const Color(0xFF0288D1),
  );

  static AppThemeExtension dark(ColorScheme scheme) => AppThemeExtension(
    surfaceContainerLow: scheme.surfaceContainerLow,
    surfaceContainerHigh: scheme.surfaceContainerHigh,
    success: const Color(0xFF4CD9A0),
    warning: const Color(0xFFFFC046),
    info: const Color(0xFF4FC3F7),
  );

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? surfaceContainerLow,
    Color? surfaceContainerHigh,
    Color? success,
    Color? warning,
    Color? info,
  }) {
    return AppThemeExtension(
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      surfaceContainerLow: Color.lerp(
        surfaceContainerLow,
        other.surfaceContainerLow,
        t,
      )!,
      surfaceContainerHigh: Color.lerp(
        surfaceContainerHigh,
        other.surfaceContainerHigh,
        t,
      )!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
    );
  }
}

extension BuildContextThemeExt on BuildContext {
  AppThemeExtension get appTheme =>
      Theme.of(this).extension<AppThemeExtension>() ??
      AppThemeExtension.light(Theme.of(this).colorScheme);
}
