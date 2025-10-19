import 'package:flutter/material.dart';
import 'package:riverpod/legacy.dart';

/// App-wide settings state for user-configurable preferences.
/// Minimal for now: theme mode and language (locale).
class AppSettingsState {
  const AppSettingsState({this.themeMode = ThemeMode.system, this.locale});

  final ThemeMode themeMode;
  final Locale? locale;

  AppSettingsState copyWith({ThemeMode? themeMode, Locale? locale}) =>
      AppSettingsState(
        themeMode: themeMode ?? this.themeMode,
        locale: locale ?? this.locale,
      );
}

class AppSettingsNotifier extends StateNotifier<AppSettingsState> {
  AppSettingsNotifier() : super(const AppSettingsState());

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
  }

  /// Set the current locale. Pass null to use system locale.
  void setLocale(Locale? locale) {
    state = state.copyWith(locale: locale);
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettingsState>(
      (ref) => AppSettingsNotifier(),
    );
