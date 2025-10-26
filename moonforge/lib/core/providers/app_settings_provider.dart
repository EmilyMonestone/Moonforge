import 'package:flutter/material.dart';
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/schema.dart';
import 'package:moonforge/core/providers/auth_providers.dart';

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
    final odm = Odm.instance;
    // Load user settings from the database or use defaults
    if (_authProvider.user != null && _authProvider.user?.id != null) {
      odm.users(_authProvider.user!.id).get().then((userData) {
        if (userData != null && userData.settings != null) {
          if (userData.settings!.themeMode != null) {
            _themeMode = userData.settings!.themeMode!;
          }
          if (userData.settings!.locale != null) {
            _locale = Locale(
              userData.settings!.locale!.languageCode,
              userData.settings!.locale!.countryCode,
            );
          } else {
            _locale = null;
          }
          if (userData.settings!.railNavExtended != null) {
            _railNavExtended = userData.settings!.railNavExtended!;
          }
          notifyListeners();
        }
      });
    }
  }
}
