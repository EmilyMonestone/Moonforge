import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/providers/app_settings_provider.dart';
import 'package:moonforge/core/services/auto_updater_service.dart';
import 'package:moonforge/core/utils/app_version.dart';
import 'package:moonforge/core/widgets/auth_user_button.dart';
import 'package:moonforge/core/widgets/window_top_bar.dart' as topbar;
import 'package:moonforge/data/providers/sync_state_provider.dart';
import 'package:moonforge/data/widgets/sync_state_widget.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// A scaffold optimized for wide/desktop layouts.
///
/// Renders a persistent navigation rail (Material 3 Expressive variant) on the
/// left and places content on the right. Includes an extended trailing area
/// for user/profile controls and sync status.
class AdaptiveWideScaffold extends StatelessWidget {
  /// The list of tabs (objects with `icon` and `label`) shown in the rail.
  final List tabs;

  /// The primary content widget for the scaffold body.
  final Widget body;

  /// The currently selected tab index.
  final int selectedIndex;

  /// Callback when the user selects a tab. Receives the `BuildContext` and
  /// the selected tab index.
  final void Function(BuildContext, int) onSelect;

  /// Widget used to render breadcrumbs in the top bar.
  final Widget breadcrumbs;

  /// Create an adaptive wide scaffold.
  const AdaptiveWideScaffold({
    super.key,
    required this.tabs,
    required this.body,
    required this.selectedIndex,
    required this.onSelect,
    required this.breadcrumbs,
  });

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettingsProvider>(context);
    final syncState = Provider.of<SyncStateProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        title: null,
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: topbar.WindowTopBar(
          /*title: appBarTitleText ?? const Text('Moonforge'),*/
          leading: breadcrumbs,
        ),
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRailM3E(
              type: settings.isRailNavExtended
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
                        AuthUserButton(expanded: settings.isRailNavExtended),
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
                              AppLocalizations.of(
                                context,
                              )!.versionWithNumber(appVersion),
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
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  textColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: context.m3e.shapes.square.sm.topLeft,
                ),
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: body,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
