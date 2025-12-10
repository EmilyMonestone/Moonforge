import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/providers/app_settings_provider.dart';
import 'package:moonforge/core/services/auto_updater_service.dart';
import 'package:moonforge/core/utils/app_version.dart';
import 'package:moonforge/core/widgets/auth_user_button.dart';
import 'package:moonforge/data/providers/sync_state_provider.dart';
import 'package:moonforge/data/widgets/sync_state_widget.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:moonforge/layout/destinations.dart';
import 'package:provider/provider.dart';

/// A reusable navigation rail widget that uses Material 3 Expressive design.
///
/// This widget provides consistent navigation across mobile and desktop platforms,
/// including user profile, sync status, and version information in the trailing section.
class AppNavigationRail extends StatelessWidget {
  /// The list of tabs to display in the navigation rail.
  final List<TabSpec> tabs;

  /// The currently selected tab index.
  final int selectedIndex;

  /// Callback when a tab is selected.
  final void Function(BuildContext, int) onSelect;

  /// Whether to force collapsed mode (for mobile compact layouts).
  final bool forceCollapsed;

  const AppNavigationRail({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelect,
    this.forceCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final syncState = Provider.of<SyncStateProvider>(context);

    // For mobile compact, always use collapsed. Otherwise, respect user settings.
    final shouldExpand = !forceCollapsed && settings.isRailNavExtended;

    return NavigationRailM3E(
      type: shouldExpand
          ? NavigationRailM3EType.expanded
          : NavigationRailM3EType.collapsed,
      selectedIndex: selectedIndex,
      expandedWidth: 300,
      onDestinationSelected: (i) => onSelect(context, i),
      sections: [
        NavigationRailM3ESection(
          destinations: [
            for (final tab in tabs)
              NavigationRailM3EDestination(
                icon: Icon(tab.icon),
                label: tab.label,
              ),
          ],
        ),
      ],
      scrollable: true,
      onTypeChanged: (NavigationRailM3EType type) {},
      trailingAtBottom: true,
      trailing: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Builder(
          builder: (context) {
            String appVersion = AppVersion.getVersion();
            return Column(
              children: [
                AuthUserButton(expanded: shouldExpand),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: SyncStateWidget(
                        state: syncState.state,
                        pendingCount: syncState.pendingCount,
                        onTap: () {
                          syncState.refresh();
                        },
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.versionWithNumber(appVersion),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    if (AutoUpdaterService.instance.isBeta)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 4.0,
                          right: 4.0,
                        ),
                        child: Badge(
                          label: Text(
                            'BETA',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          textColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
