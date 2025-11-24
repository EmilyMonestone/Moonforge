import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart';
import 'package:moonforge/core/repositories/menu_registry.dart';
import 'package:moonforge/core/widgets/window_top_bar.dart' as topbar;

class AdaptiveCompactScaffold extends StatelessWidget {
  final List tabs;
  final Widget body;
  final int selectedIndex;
  final void Function(BuildContext, int) onSelect;
  final Widget breadcrumbs;

  const AdaptiveCompactScaffold({
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
    final primary = tabs.length <= 5 ? tabs : tabs.take(5).toList();
    final overflow = tabs.length > 5
        ? tabs.skip(5).toList()
        : const <dynamic>[];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        flexibleSpace: topbar.WindowTopBar(
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
                    selectedIndex: selectedIndex >= 5
                        ? selectedIndex - 5
                        : null,
                    onDestinationSelected: (i) => onSelect(context, 5 + i),
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
                        for (final item in items)
                          _buildSheetItem(sheetCtx, item),
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
