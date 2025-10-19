import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/constants/path_names.dart';
import 'package:moonforge/core/models/actions.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/app_version.dart';
import 'package:moonforge/core/widgets/auth_user_button.dart';
import 'package:moonforge/core/widgets/menu_registry.dart';
import 'package:moonforge/core/widgets/window_top_bar.dart' as topbar;
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:moonforge/layout/breakpoints.dart';
import 'package:moonforge/layout/destinations.dart';

/// AdaptiveScaffold builds a responsive Scaffold that switches between
/// NavigationBar (compact) and NavigationRail (medium/expanded).
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.navigationShell,
    required this.tabs,
    required this.body,
    this.appBarTitleText,
  });

  final StatefulNavigationShell navigationShell;
  final List<TabSpec> tabs;
  final Widget body;
  final Widget? appBarTitleText;

  String _localizedTabLabel(BuildContext context, String raw) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return raw;
    switch (raw) {
      case 'Home':
        return l10n.home;
      case 'Campaign':
        return l10n.campaign;
      case 'Party':
        return l10n.party;
      case 'Settings':
        return l10n.settings;
      default:
        return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = AppSizeClass.of(context);

    // Build breadcrumbs from the current location.
    final uri = GoRouterState.of(context).uri;
    final segments = uri.pathSegments;

    Widget breadcrumbs;
    if (segments.isEmpty) {
      breadcrumbs = BreadCrumb(
        items: [
          BreadCrumbItem(
            content: Text(AppLocalizations.of(context)!.home),
            onTap: () => const HomeRoute().go(context),
          ),
        ],
        divider: const Icon(Icons.chevron_right),
      );
    } else {
      breadcrumbs = BreadCrumb.builder(
        itemCount: segments.length,
        builder: (int index) {
          final labelKey = segments[index];
          final path = '/${segments.take(index + 1).join('/')}';
          return BreadCrumbItem(
            content: getPathName(context, labelKey),
            onTap: () => context.go(path),
          );
        },
        divider: const Icon(Icons.chevron_right),
      );
    }

    switch (size) {
      case SizeClass.compact:
        return _buildCompact(context, breadcrumbs);
      case SizeClass.medium:
      case SizeClass.expanded:
        return _buildWide(context, breadcrumbs);
    }
  }

  int get _selectedIndex => navigationShell.currentIndex;

  void _onSelect(BuildContext context, int index) =>
      navigationShell.goBranch(index);

  void _showFabMenu(BuildContext context, List<MenuBarAction> items) {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [for (final item in items) _buildSheetItem(ctx, item)],
          ),
        );
      },
    );
  }

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

  // Phones: NavigationBar + optional persistent side NavigationRail for overflow (>5)
  Widget _buildCompact(BuildContext context, Widget breadcrumbs) {
    final primary = tabs.length <= 5 ? tabs : tabs.take(5).toList();
    final overflow = tabs.length > 5
        ? tabs.skip(5).toList()
        : const <TabSpec>[];

    return Scaffold(
      appBar: AppBar(
        title: topbar.WindowTopBar(
          /*title: appBarTitleText ?? const Text('Moonforge'),*/
          leading: breadcrumbs,
          // Hide the top menu bar on compact/mobile; use FAB instead
          trailing: const SizedBox.shrink(),
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
                    onDestinationSelected: (i) => _onSelect(context, 5 + i),
                    labelType: NavigationRailLabelType.all,
                    scrollable: true,
                    destinations: [
                      for (final tab in overflow)
                        NavigationRailDestination(
                          icon: Icon(tab.icon),
                          label: Text(_localizedTabLabel(context, tab.label)),
                        ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(child: body),
                ],
              ),
      ),
      floatingActionButton: Builder(
        builder: (ctx) {
          final items = MenuRegistry.resolve(ctx, GoRouterState.of(ctx).uri);
          if (items == null || items.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton(
            onPressed: () => _showFabMenu(ctx, items),
            child: const Icon(Icons.menu_rounded),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex.clamp(0, primary.length - 1),
        onDestinationSelected: (i) => _onSelect(context, i),
        destinations: [
          for (final tab in primary)
            NavigationDestination(
              icon: Icon(tab.icon),
              label: _localizedTabLabel(context, tab.label),
            ),
        ],
      ),
    );
  }

  // Tablets/Desktops: NavigationRail (extended on expanded)
  Widget _buildWide(BuildContext context, Widget breadcrumbs) {
    final isExpanded = AppSizeClass.of(context) == SizeClass.expanded;

    return Scaffold(
      appBar: AppBar(
        title: topbar.WindowTopBar(
          /*title: appBarTitleText ?? const Text('Moonforge'),*/
          leading: breadcrumbs,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              extended: isExpanded,
              selectedIndex: _selectedIndex,
              onDestinationSelected: (i) => _onSelect(context, i),
              labelType: isExpanded ? null : NavigationRailLabelType.all,
              scrollable: true,
              destinations: [
                for (final tab in tabs)
                  NavigationRailDestination(
                    icon: Icon(tab.icon),
                    label: Text(_localizedTabLabel(context, tab.label)),
                  ),
              ],
              trailingAtBottom: true,
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Builder(
                  builder: (context) {
                    String appVersion = AppVersion.getVersion();
                    return Column(
                      children: [
                        const AuthUserButton(),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.versionWithNumber(appVersion),
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
