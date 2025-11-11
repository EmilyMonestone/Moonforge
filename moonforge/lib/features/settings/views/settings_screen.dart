import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/app_settings_provider.dart';
import 'package:moonforge/features/settings/widgets/settings_section.dart';
import 'package:moonforge/features/settings/widgets/settings_tile.dart';
import 'package:moonforge/features/settings/widgets/settings_toggle.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: l10n.appearance,
                icon: const Icon(Icons.palette_outlined),
              ),
              Tab(text: l10n.profile, icon: const Icon(Icons.person_outline)),
              Tab(
                text: l10n.hotkeys,
                icon: const Icon(Icons.keyboard_outlined),
              ),
              Tab(text: l10n.more, icon: const Icon(Icons.more_horiz)),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: const [
                _AppearanceSettingsTab(),
                _ProfileTab(),
                _HotkeysTab(),
                _MoreTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceSettingsTab extends StatelessWidget {
  const _AppearanceSettingsTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = Provider.of<AppSettingsProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<Locale?>(
            initialValue: settings.locale,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.language,
              prefixIcon: const Icon(Icons.language_outlined),
            ),
            items: [
              DropdownMenuItem<Locale?>(value: null, child: Text(l10n.system)),
              ...AppLocalizations.supportedLocales.map((locale) {
                final code = locale.languageCode;
                String name;
                switch (code) {
                  case 'en':
                    name = l10n.english;
                    break;
                  case 'de':
                    name = l10n.german;
                    break;
                  default:
                    name = code.toUpperCase();
                }
                return DropdownMenuItem<Locale?>(
                  value: locale,
                  child: Text(name),
                );
              }),
            ],
            onChanged: (locale) => settings.setLocale(locale),
          ),
          const SizedBox(height: 24),
          Text(l10n.theme, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<ThemeMode>(
            initialValue: settings.themeMode,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: l10n.theme,
              prefixIcon: const Icon(Icons.brightness_6_outlined),
            ),
            items: [
              DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(l10n.system),
              ),
              DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.light)),
              DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.dark)),
            ],
            onChanged: (mode) {
              if (mode != null) settings.setThemeMode(mode);
            },
          ),
        ],
      ),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Column(
        children: [
          SettingsSection(
            title: l10n.account,
            children: [
              SettingsTile(
                leading: Icons.person_outline,
                title: l10n.profile,
                subtitle: l10n.accountDescription,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Navigate to profile screen when implemented
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${l10n.profile} ${l10n.ellipsis}')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MoreTab extends StatelessWidget {
  const _MoreTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = Provider.of<AppSettingsProvider>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SettingsSection(
            title: l10n.notifications,
            children: [
              SettingsToggle(
                leading: Icons.notifications_outlined,
                title: l10n.notifications,
                subtitle: l10n.notificationsDescription,
                value: settings.notificationsEnabled,
                onChanged: (value) => settings.setNotificationsEnabled(value),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.privacy,
            children: [
              SettingsToggle(
                leading: Icons.analytics_outlined,
                title: l10n.analytics,
                subtitle: l10n.analyticsDescription,
                value: settings.analyticsEnabled,
                onChanged: (value) => settings.setAnalyticsEnabled(value),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.about,
            children: [
              SettingsTile(
                leading: Icons.info_outline,
                title: l10n.appVersion,
                trailing: FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        'v${snapshot.data!.version}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
          SettingsSection(
            title: l10n.dangerZone,
            children: [
              SettingsTile(
                leading: Icons.restore,
                title: l10n.resetSettings,
                subtitle: l10n.resetSettingsDescription,
                onTap: () => _showResetConfirmation(context, settings, l10n),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(
    BuildContext context,
    AppSettingsProvider settings,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetSettings),
        content: Text(l10n.resetSettingsConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () async {
              await settings.resetToDefaults();
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(l10n.resetSettings)));
              }
            },
            child: Text(l10n.delete), // Reusing 'delete' as it's destructive
          ),
        ],
      ),
    );
  }
}

class _HotkeysTab extends StatelessWidget {
  const _HotkeysTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Define common keyboard shortcuts
    final shortcuts = [
      _Shortcut('Ctrl/Cmd + N', 'New Campaign'),
      _Shortcut('Ctrl/Cmd + S', 'Save'),
      _Shortcut('Ctrl/Cmd + F', 'Search'),
      _Shortcut('Ctrl/Cmd + ,', l10n.settings),
      _Shortcut('Ctrl/Cmd + Q', 'Quit'),
      _Shortcut('F11', 'Toggle Fullscreen'),
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Keyboard shortcuts help you navigate and use the app efficiently.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ...shortcuts.map(
            (shortcut) => ListTile(
              leading: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  shortcut.keys,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                ),
              ),
              title: Text(shortcut.description),
            ),
          ),
        ],
      ),
    );
  }
}

class _Shortcut {
  final String keys;
  final String description;

  _Shortcut(this.keys, this.description);
}
