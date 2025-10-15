import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:moonforge/core/constants/path_names.dart';
import 'package:moonforge/core/services/app_router.gr.dart';
import 'package:moonforge/layout/breakpoints.dart';
import 'package:moonforge/layout/destinations.dart';

import '../core/providers/auth_providers.dart';

/// AdaptiveScaffold builds a responsive Scaffold that switches between
/// NavigationBar (compact) and NavigationRail (medium/expanded).
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.tabsRouter,
    required this.tabs,
    required this.body,
    this.appBarTitleText,
  });

  final TabsRouter tabsRouter;
  final List<TabSpec> tabs;
  final Widget body;
  final Widget? appBarTitleText;

  @override
  Widget build(BuildContext context) {
    final size = AppSizeClass.of(context);
    int pathCount = tabsRouter.currentSegments.length;
    List<RouteMatch<dynamic>> segments = tabsRouter.currentSegments.toList();
    if (segments[0].name == 'HomeRoute' && pathCount > 1) {
      pathCount -= 1;
      segments = segments.sublist(1);
    }
    Widget breadcrumbs = BreadCrumb.builder(
      itemCount: pathCount,
      builder: (int index) {
        return BreadCrumbItem(
          content: getPathName(segments[index].name),
          onTap: () => tabsRouter.navigatePath(segments[index].path),
        );
      },
      divider: Icon(Icons.chevron_right),
    );

    switch (size) {
      case SizeClass.compact:
        return _buildCompact(context, breadcrumbs);
      case SizeClass.medium:
      case SizeClass.expanded:
        return _buildWide(context, breadcrumbs);
    }
  }

  int get _selectedIndex => tabsRouter.activeIndex;

  void _onSelect(int index) => tabsRouter.setActiveIndex(index);

  // Phones: NavigationBar + optional persistent side NavigationRail for overflow (>5)
  Widget _buildCompact(BuildContext context, Widget breadcrumbs) {
    final primary = tabs.length <= 5 ? tabs : tabs.take(5).toList();
    final overflow = tabs.length > 5
        ? tabs.skip(5).toList()
        : const <TabSpec>[];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            appBarTitleText ?? Text('Moonforge'),
            const SizedBox(width: 16),
            breadcrumbs,
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: overflow.isEmpty
            ? body
            : Row(
                children: [
                  NavigationRail(
                    // Show selection only when an overflow tab is active.
                    selectedIndex: _selectedIndex >= 5
                        ? _selectedIndex - 5
                        : null,
                    onDestinationSelected: (i) => _onSelect(5 + i),
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
                  Expanded(child: body),
                ],
              ),
      ),
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
  Widget _buildWide(BuildContext context, Widget breadcrumbs) {
    final isExpanded = AppSizeClass.of(context) == SizeClass.expanded;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SizedBox(width: 256, child: appBarTitleText ?? Text('Moonforge')),
            breadcrumbs,
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: isExpanded,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onSelect,
              labelType: isExpanded ? null : NavigationRailLabelType.all,
              scrollable: true,
              destinations: [
                for (final tab in tabs)
                  NavigationRailDestination(
                    icon: Icon(tab.icon),
                    label: Text(tab.label),
                  ),
              ],
              trailingAtBottom: true,
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: currentUserProvider.name != null
                    ? FilledButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          tabsRouter.navigate(HomeRoute());
                        },
                        child: Text('Logout'),
                      )
                    : FilledButton(
                        onPressed: () => tabsRouter.navigate(LoginRoute()),
                        child: Text('Login'),
                      ),
              ),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
