import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/features/settings/services/settings_service.dart';

/// Provider to manage app-wide settings like theme, locale, and UI preferences.
/// Settings are persisted using SharedPreferences via SettingsService.
class AppSettingsProvider with ChangeNotifier {
  final SettingsService? _settingsService;

  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;
  bool _railNavExtended = true;
  bool _notificationsEnabled = true;
  bool _analyticsEnabled = true;

  AppSettingsProvider(this._settingsService) {
    _loadSettings();
  }

  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;
  bool get isRailNavExtended => _railNavExtended;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get analyticsEnabled => _analyticsEnabled;

  /// Load settings from persistent storage on initialization.
  void _loadSettings() {
    if (_settingsService == null) return;

    _themeMode = _settingsService.loadThemeMode();
    _locale = _settingsService.loadLocale();
    _railNavExtended = _settingsService.loadRailNavExtended();
    _notificationsEnabled = _settingsService.loadNotificationsEnabled();
    _analyticsEnabled = _settingsService.loadAnalyticsEnabled();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _settingsService?.saveThemeMode(mode);
  }

  /// Set the current locale. Pass null to use system locale.
  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    await _settingsService?.saveLocale(locale);
  }

  Future<void> setRailNavExtended(bool extended) async {
    _railNavExtended = extended;
    notifyListeners();
    await _settingsService?.saveRailNavExtended(extended);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    notifyListeners();
    await _settingsService?.saveNotificationsEnabled(enabled);
  }

  Future<void> setAnalyticsEnabled(bool enabled) async {
    _analyticsEnabled = enabled;
    notifyListeners();
    await _settingsService?.saveAnalyticsEnabled(enabled);
  }

  void updateOnAuthChange(AuthProvider authProvider) {
    // Settings persist across auth changes
    // Only reload from storage if needed
    if (!authProvider.isLoggedIn) {
      _loadSettings();
    }
  }

  /// Reset all settings to defaults and clear persistent storage.
  Future<void> resetToDefaults() async {
    await _settingsService?.clearAll();
    _themeMode = ThemeMode.system;
    _locale = null;
    _railNavExtended = true;
    _notificationsEnabled = true;
    _analyticsEnabled = true;
    notifyListeners();
  }
}
