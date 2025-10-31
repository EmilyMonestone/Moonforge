import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/auth_providers.dart';

/// Provider to manage app-wide settings like theme, locale, and UI preferences.
///
/// Note: With the new Drift-first architecture, user settings are no longer
/// persisted to the database. Settings are stored in memory and reset on app restart.
/// To persist settings, you could use shared_preferences or similar local storage.
class AppSettingsProvider with ChangeNotifier {
  late AuthProvider _authProvider;
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;
  bool _railNavExtended = true;

  ThemeMode get themeMode => _themeMode;

  Locale? get locale => _locale;

  bool get isRailNavExtended => _railNavExtended;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// Set the current locale. Pass null to use system locale.
  void setLocale(Locale? locale) {
    _locale = locale;
    notifyListeners();
  }

  void setRailNavExtended(bool extended) {
    _railNavExtended = extended;
    notifyListeners();
  }

  void updateOnAuthChange(AuthProvider authProvider) {
    _authProvider = authProvider;
    // Settings are now in-memory only
    // TODO: If persistent settings are needed, use shared_preferences or similar
    // For now, we just reset to defaults when auth changes
    if (!authProvider.isLoggedIn) {
      _themeMode = ThemeMode.system;
      _locale = null;
      _railNavExtended = true;
      notifyListeners();
    }
  }
}
