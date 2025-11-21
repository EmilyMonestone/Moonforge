import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for persisting and loading app settings using SharedPreferences.
class SettingsService {
  static const String _keyThemeMode = 'settings.themeMode';
  static const String _keyLocale = 'settings.locale';
  static const String _keyRailNavExtended = 'settings.railNavExtended';
  static const String _keyNotificationsEnabled =
      'settings.notificationsEnabled';
  static const String _keyAnalyticsEnabled = 'settings.analyticsEnabled';

  final SharedPreferences _prefs;

  SettingsService(this._prefs);

  /// Load theme mode from storage.
  ThemeMode loadThemeMode() {
    final value = _prefs.getString(_keyThemeMode);
    if (value == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  /// Save theme mode to storage.
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs.setString(_keyThemeMode, mode.name);
  }

  /// Load locale from storage. Returns null for system locale.
  Locale? loadLocale() {
    final value = _prefs.getString(_keyLocale);
    if (value == null || value.isEmpty) return null;
    return Locale(value);
  }

  /// Save locale to storage. Pass null to use system locale.
  Future<void> saveLocale(Locale? locale) async {
    if (locale == null) {
      await _prefs.remove(_keyLocale);
    } else {
      await _prefs.setString(_keyLocale, locale.languageCode);
    }
  }

  /// Load rail navigation extended state.
  bool loadRailNavExtended() {
    return _prefs.getBool(_keyRailNavExtended) ?? true;
  }

  /// Save rail navigation extended state.
  Future<void> saveRailNavExtended(bool extended) async {
    await _prefs.setBool(_keyRailNavExtended, extended);
  }

  /// Load notifications enabled state.
  bool loadNotificationsEnabled() {
    return _prefs.getBool(_keyNotificationsEnabled) ?? true;
  }

  /// Save notifications enabled state.
  Future<void> saveNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_keyNotificationsEnabled, enabled);
  }

  /// Load analytics enabled state.
  bool loadAnalyticsEnabled() {
    return _prefs.getBool(_keyAnalyticsEnabled) ?? true;
  }

  /// Save analytics enabled state.
  Future<void> saveAnalyticsEnabled(bool enabled) async {
    await _prefs.setBool(_keyAnalyticsEnabled, enabled);
  }

  /// Clear all settings and restore defaults.
  Future<void> clearAll() async {
    await _prefs.remove(_keyThemeMode);
    await _prefs.remove(_keyLocale);
    await _prefs.remove(_keyRailNavExtended);
    await _prefs.remove(_keyNotificationsEnabled);
    await _prefs.remove(_keyAnalyticsEnabled);
  }
}
