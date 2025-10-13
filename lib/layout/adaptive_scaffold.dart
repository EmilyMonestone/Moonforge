import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/layout/breakpoints.dart';
import 'package:moonforge/layout/destinations.dart';

/// AdaptiveScaffold builds a responsive Scaffold that switches between
/// NavigationBar (compact) and NavigationRail (medium/expanded).
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.tabsRouter,
    required this.tabs,
    required this.body,
    this.appBarTitle,
  });

  final TabsRouter tabsRouter;
  final List<TabSpec> tabs;
  final Widget body;
  final Widget? appBarTitle;

  @override
  Widget build(BuildContext context) {
    final size = AppSizeClass.of(context);

    switch (size) {
      case SizeClass.compact:
        return _buildCompact(context);
      case SizeClass.medium:
      case SizeClass.expanded:
        return _buildWide(context);
    }
  }

  int get _selectedIndex => tabsRouter.activeIndex;

  void _onSelect(int index) => tabsRouter.setActiveIndex(index);

  // Phones: NavigationBar + optional modal drawer for overflow (>5)
  Widget _buildCompact(BuildContext context) {
    final primary = tabs.length <= 5 ? tabs : tabs.take(5).toList();
    final overflow = tabs.length > 5
        ? tabs.skip(5).toList()
        : const <TabSpec>[];

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: appBarTitle,
        centerTitle: false,
        leading: overflow.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
              ),
      ),
      drawer: overflow.isEmpty
          ? null
          : NavigationDrawer(
              children: [
                ...overflow.asMap().entries.map((entry) {
                  final index = 5 + entry.key;
                  final tab = entry.value;
                  return ListTile(
                    leading: Icon(tab.icon),
                    title: Text(tab.label),
                    selected: _selectedIndex == index,
                    onTap: () {
                      Navigator.of(context).pop();
                      _onSelect(index);
                    },
                  );
                }),
              ],
            ),
      body: SafeArea(child: body),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex.clamp(0, primary.length - 1),
        onDestinationSelected: (i) => _onSelect(i),
        destinations: [
          for (final tab in primary)
            NavigationDestination(icon: Icon(tab.icon), label: tab.label),
        ],
      ),
    );
  }

  // Tablets/Desktops: NavigationRail (extended on expanded)
  Widget _buildWide(BuildContext context) {
    final isExpanded = AppSizeClass.of(context) == SizeClass.expanded;

    return Scaffold(
      appBar: AppBar(title: appBarTitle, centerTitle: false),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: isExpanded,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onSelect,
              labelType: isExpanded ? null : NavigationRailLabelType.all,
              destinations: [
                for (final tab in tabs)
                  NavigationRailDestination(
                    icon: Icon(tab.icon),
                    label: Text(tab.label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
