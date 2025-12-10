import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/window_top_bar.dart' as topbar;
import 'package:moonforge/layout/destinations.dart';
import 'package:moonforge/layout/widgets/common/menu_sheet_builder.dart';
import 'package:moonforge/layout/widgets/common/scrollable_body.dart';

/// A scaffold optimized for compact/narrow window layouts on desktop platforms
/// (Windows, macOS, Linux, Web).
///
/// Uses a navigation rail for primary navigation even in compact mode, as
/// desktop users expect persistent navigation. Designed for mouse/keyboard
/// interactions typical of desktop environments.
class DesktopCompactScaffold extends StatelessWidget {
  /// The list of tabs (objects with `icon` and `label`) shown in the rail.
  final List<TabSpec> tabs;

  /// The primary content widget for the scaffold body.
  final Widget body;

  /// The currently selected tab index.
  final int selectedIndex;

  /// Callback when the user selects a tab. Receives the `BuildContext` and
  /// the selected tab index.
  final void Function(BuildContext, int) onSelect;

  /// Widget used to render breadcrumbs in the top bar.
  final Widget breadcrumbs;

  /// Create a desktop compact scaffold.
  const DesktopCompactScaffold({
    super.key,
    required this.tabs,
    required this.body,
    required this.selectedIndex,
    required this.onSelect,
    required this.breadcrumbs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        flexibleSpace: topbar.WindowTopBar(
          isCompact: true,
          leading: breadcrumbs,
        ),
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) => onSelect(context, i),
              labelType: NavigationRailLabelType.all,
              scrollable: true,
              destinations: [
                for (final tab in tabs)
                  NavigationRailDestination(
                    icon: Icon(tab.icon),
                    label: Text(tab.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(
              child: ScrollableBody(child: body),
            ),
          ],
        ),
      ),
      floatingActionButton: const MenuFloatingActionButton(),
    );
  }
}
