import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/toc_provider.dart';
import 'package:moonforge/core/widgets/table_of_contents.dart';
import 'package:moonforge/layout/destinations.dart';
import 'package:moonforge/layout/widgets/common/menu_sheet_builder.dart';
import 'package:moonforge/layout/widgets/common/scrollable_body.dart';

/// Maximum number of tabs to show in the bottom navigation bar before using
/// an overflow navigation rail.
const int kMaxBottomNavTabs = 5;

/// A scaffold optimized for compact/phone layouts on mobile platforms
/// (Android, iOS, Fuchsia).
///
/// Uses a simplified `WindowTopBar` for the app bar area and adapts navigation
/// to a `NavigationBar` with optional overflow handling via a `NavigationRail`
/// and bottom sheet for additional actions. Tailored for touch-first mobile
/// interactions.
class MobileCompactScaffold extends StatelessWidget {
  /// The list of tabs (objects with `icon` and `label`) shown in the
  /// navigation bar or overflow rail.
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

  /// Create a mobile compact scaffold.
  const MobileCompactScaffold({
    super.key,
    required this.tabs,
    required this.body,
    required this.selectedIndex,
    required this.onSelect,
    required this.breadcrumbs,
  });

  @override
  Widget build(BuildContext context) {
    final primary = tabs.length <= kMaxBottomNavTabs
        ? tabs
        : tabs.take(kMaxBottomNavTabs).toList();
    final overflow = tabs.length > kMaxBottomNavTabs
        ? tabs.skip(kMaxBottomNavTabs).toList()
        : const <TabSpec>[];

    // Check if TOC is available
    final tocController = TocProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: breadcrumbs,
        centerTitle: false,
        titleSpacing: 16,
        automaticallyImplyLeading: false,
        toolbarHeight: 56,
        actions: [
          if (tocController != null && tocController.entries.isNotEmpty)
            TocButton(controller: tocController),
        ],
      ),
      body: SafeArea(
        child: overflow.isEmpty
            ? ScrollableBody(child: body)
            : Row(
                children: [
                  NavigationRail(
                    selectedIndex: selectedIndex >= kMaxBottomNavTabs
                        ? selectedIndex - kMaxBottomNavTabs
                        : null,
                    onDestinationSelected: (i) =>
                        onSelect(context, kMaxBottomNavTabs + i),
                    labelType: NavigationRailLabelType.all,
                    scrollable: true,
                    destinations: [
                      for (final tab in overflow)
                        NavigationRailDestination(
                          icon: Icon(tab.icon),
                          label: Text(tab.label),
                        ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: ScrollableBody(child: body)),
                ],
              ),
      ),
      floatingActionButton: const MenuFloatingActionButton(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex.clamp(0, primary.length - 1),
        onDestinationSelected: (i) => onSelect(context, i),
        destinations: [
          for (final tab in primary)
            NavigationDestination(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }
}
