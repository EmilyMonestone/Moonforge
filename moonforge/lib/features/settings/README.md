# Settings Feature

This feature manages application preferences, user settings, and app configuration.

## Structure

```
settings/
├── services/
│   └── settings_service.dart      # Persistence layer using SharedPreferences
├── views/
│   └── settings_screen.dart       # Main settings UI with tabs
└── widgets/
    ├── settings_section.dart      # Section header for grouping settings
    ├── settings_tile.dart         # Individual setting item
    └── settings_toggle.dart       # Toggle switch for boolean settings
```

## Features

### Appearance Tab
- **Theme Mode**: System, Light, or Dark mode selection
- **Language**: System, English, or German language selection
- Settings persist across app restarts

### Profile Tab
- **Account Management**: Link to profile settings (placeholder for future implementation)

### Hotkeys Tab
- Placeholder for keyboard shortcuts customization (future implementation)

### More Tab
- **Notifications**: Toggle notifications on/off
- **Analytics**: Opt-in/out of usage analytics
- **About**: Display app version
- **Reset Settings**: Restore all settings to defaults

## Implementation Details

### Settings Persistence

Settings are persisted using SharedPreferences via `SettingsService`:
- Theme mode (system/light/dark)
- Locale (null for system default, or specific locale)
- Rail navigation extended state
- Notifications enabled
- Analytics enabled

### State Management

The `AppSettingsProvider` (in `lib/core/providers/`) manages settings state:
- Loads settings from SharedPreferences on initialization
- Notifies listeners when settings change
- Saves changes automatically to persistent storage
- Provides reset functionality

### Integration

Settings are integrated into the app via:
1. **MultiProviderWrapper** (`lib/core/providers/providers.dart`) - Initializes SharedPreferences and creates SettingsService
2. **MaterialApp** - Consumes theme mode and locale from AppSettingsProvider
3. **Router** - Settings screen accessible at `/settings`

## Usage

### Accessing Settings

```dart
// In a widget
final settings = Provider.of<AppSettingsProvider>(context);
final currentTheme = settings.themeMode;
final notificationsEnabled = settings.notificationsEnabled;
```

### Updating Settings

```dart
// Theme mode
await settings.setThemeMode(ThemeMode.dark);

// Locale
await settings.setLocale(const Locale('de'));

// Notifications
await settings.setNotificationsEnabled(false);

// Reset all
await settings.resetToDefaults();
```

## Future Enhancements

### High Priority
- Implement keyboard shortcuts display and customization
- Add sync settings (frequency, offline mode, conflict resolution)
- Add storage management (usage display, clear cache)
- Create dedicated sub-screens for complex settings categories

### Medium Priority
- Settings import/export for backup/restore
- Advanced developer settings (debug mode, feature flags)
- More granular notification preferences
- Privacy settings (data sharing, cookie preferences)

### Low Priority
- Custom theme color selection
- Font size adjustment
- Compact/comfortable density modes
- Account activity log

## Testing

To test settings persistence:
1. Change theme or language
2. Restart the app
3. Verify settings are preserved

To test reset functionality:
1. Change multiple settings
2. Click "Reset Settings" in More tab
3. Confirm the dialog
4. Verify all settings return to defaults

## Localization

All user-facing strings are internationalized. New strings should be added to:
- `lib/l10n/app_en.arb` (English)
- `lib/l10n/app_de.arb` (German)

Run `flutter pub get` after adding new strings to regenerate localizations.
