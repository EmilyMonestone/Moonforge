import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart';
import 'package:moonforge/core/repositories/menu_registry.dart';
import 'package:moonforge/core/widgets/window_top_bar.dart' as topbar;
import 'package:moonforge/layout/destinations.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        flexibleSpace: topbar.WindowTopBar(
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
    );
  }
}
