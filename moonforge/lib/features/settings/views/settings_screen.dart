import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/providers/settings_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                _PlaceholderTab(labelKey: 'profile'),
                _PlaceholderTab(labelKey: 'hotkeys'),
                _PlaceholderTab(labelKey: 'more'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppearanceSettingsTab extends ConsumerWidget {
  const _AppearanceSettingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);

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
            onChanged: (locale) => notifier.setLocale(locale),
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
              if (mode != null) notifier.setThemeMode(mode);
            },
          ),
        ],
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.labelKey});

  final String labelKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    String label;
    switch (labelKey) {
      case 'profile':
        label = l10n.profile;
        break;
      case 'hotkeys':
        label = l10n.hotkeys;
        break;
      case 'more':
        label = l10n.more;
        break;
      default:
        label = l10n.settings;
    }
    return Center(child: Text('$label ${l10n.ellipsis}'));
  }
}
