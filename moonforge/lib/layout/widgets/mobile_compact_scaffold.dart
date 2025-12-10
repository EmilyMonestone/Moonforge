import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart';
import 'package:moonforge/core/repositories/menu_registry.dart';
import 'package:moonforge/core/widgets/window_top_bar.dart' as topbar;
import 'package:moonforge/layout/destinations.dart';

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

  Widget _buildSheetItem(BuildContext context, MenuBarAction item) {
    if (item.children != null && item.children!.isNotEmpty) {
      return ExpansionTile(
        leading: item.icon != null ? Icon(item.icon) : null,
        title: Text(item.label),
        subtitle: item.helpText != null ? Text(item.helpText!) : null,
        children: [
          for (final child in item.children!)
            ListTile(
              leading: child.icon != null ? Icon(child.icon) : null,
              title: Text(child.label),
              subtitle: child.helpText != null ? Text(child.helpText!) : null,
              onTap: () {
                Navigator.of(context).pop();
                child.onPressed?.call(context);
              },
            ),
        ],
      );
    } else {
      return ListTile(
        leading: item.icon != null ? Icon(item.icon) : null,
        title: Text(item.label),
        subtitle: item.helpText != null ? Text(item.helpText!) : null,
        onTap: () {
          Navigator.of(context).pop();
          item.onPressed?.call(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary =
        tabs.length <= kMaxBottomNavTabs ? tabs : tabs.take(kMaxBottomNavTabs).toList();
    final overflow = tabs.length > kMaxBottomNavTabs
        ? tabs.skip(kMaxBottomNavTabs).toList()
        : const <TabSpec>[];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        flexibleSpace: topbar.WindowTopBar(
          isCompact: true,
          leading: breadcrumbs,
          trailing: const SizedBox.shrink(),
        ),
        centerTitle: false,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: topbar.kWindowCaptionHeight * 2,
      ),
      body: SafeArea(
        child: overflow.isEmpty
            ? Container(
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
              )
            : Row(
                children: [
                  NavigationRail(
                    selectedIndex:
                        selectedIndex >= kMaxBottomNavTabs ? selectedIndex - kMaxBottomNavTabs : null,
                    onDestinationSelected: (i) => onSelect(context, kMaxBottomNavTabs + i),
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
                  Expanded(
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
                ],
              ),
      ),
      floatingActionButton: Builder(
        builder: (ctx) {
          final items = MenuRegistry.resolve(ctx, GoRouterState.of(ctx).uri);
          if (items == null || items.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: ctx,
                useSafeArea: true,
                showDragHandle: true,
                builder: (sheetCtx) {
                  return SafeArea(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final item in items) _buildSheetItem(sheetCtx, item),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Icon(Icons.menu_rounded),
          );
        },
      ),
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
