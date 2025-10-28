import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:go_router/go_router.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/constants/path_names.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart';
import 'package:moonforge/core/providers/app_settings_provider.dart';
import 'package:moonforge/core/repositories/menu_registry.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/auto_updater_service.dart';
import 'package:moonforge/core/utils/app_version.dart';
import 'package:moonforge/core/widgets/adaptive_breadcrumb.dart';
import 'package:moonforge/core/widgets/auth_user_button.dart';
import 'package:moonforge/core/widgets/window_top_bar.dart' as topbar;
import 'package:moonforge/data/providers/sync_state_provider.dart';
import 'package:moonforge/data/widgets/sync_state_widget.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:moonforge/layout/breakpoints.dart';
import 'package:moonforge/layout/destinations.dart';
import 'package:provider/provider.dart';

/// AdaptiveScaffold builds a responsive Scaffold that switches between
/// NavigationBar (compact) and NavigationRail (medium/expanded).
class AdaptiveScaffold extends StatefulWidget {
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

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
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

  bool railIsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final size = AppSizeClass.of(context);

    // Build breadcrumbs from the current location using AdaptiveBreadcrumb
    final uri = GoRouterState.of(context).uri;
    final segments = uri.pathSegments;

    Widget breadcrumbs;
    if (segments.isEmpty) {
      breadcrumbs = AdaptiveBreadcrumb(
        items: [
          AdaptiveBreadcrumbItem(
            content: Text(AppLocalizations.of(context)!.home),
            onTap: () => const HomeRoute().go(context),
          ),
        ],
        divider: const Icon(Icons.chevron_right, size: 16),
      );
    } else {
      breadcrumbs = AdaptiveBreadcrumb(
        items: segments.map((labelKey) {
          final index = segments.indexOf(labelKey);
          final path = '/${segments.take(index + 1).join('/')}';
          return AdaptiveBreadcrumbItem(
            content: getPathName(context, labelKey),
            onTap: () => context.go(path),
          );
        }).toList(),
        divider: const Icon(Icons.chevron_right, size: 16),
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

  int get _selectedIndex => widget.navigationShell.currentIndex;

  void _onSelect(BuildContext context, int index) =>
      widget.navigationShell.goBranch(index);

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
    final primary = widget.tabs.length <= 5
        ? widget.tabs
        : widget.tabs.take(5).toList();
    final overflow = widget.tabs.length > 5
        ? widget.tabs.skip(5).toList()
        : const <TabSpec>[];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: topbar.WindowTopBar(
          /*title: appBarTitleText ?? const Text('Moonforge'),*/
          leading: breadcrumbs,
          // Hide the top menu bar on compact/mobile; use FAB instead
          trailing: const SizedBox.shrink(),
        ),
        centerTitle: false,
        toolbarHeight: topbar.kWindowCaptionHeight * 2,
      ),
      body: SafeArea(
        child: overflow.isEmpty
            ? Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: widget.body,
                        ),
                      );
                    },
                  ),
                ),
              )
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
                              child: widget.body,
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
    final settings = Provider.of<AppSettingsProvider>(context);
    final syncState = Provider.of<SyncStateProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        surfaceTintColor: Theme.of(context).colorScheme.surface,
        title: topbar.WindowTopBar(
          /*title: appBarTitleText ?? const Text('Moonforge'),*/
          leading: breadcrumbs,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Row(
          children: [
            NavigationRailM3E(
              type: settings.isRailNavExtended
                  ? NavigationRailM3EType.expanded
                  : NavigationRailM3EType.collapsed,
              selectedIndex: _selectedIndex,
              expandedWidth: 300,
              onDestinationSelected: (i) => _onSelect(context, i),
              sections: [
                NavigationRailM3ESection(
                  destinations: [
                    for (final tab in widget.tabs)
                      NavigationRailM3EDestination(
                        icon: Icon(tab.icon),
                        label: _localizedTabLabel(context, tab.label),
                      ),
                  ],
                ),
              ],
              scrollable: true,
              onTypeChanged: (NavigationRailM3EType type) => setState(() {
                railIsExpanded = type == NavigationRailM3EType.expanded;
              }),
              trailingAtBottom: true,
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Builder(
                  builder: (context) {
                    String appVersion = AppVersion.getVersion();
                    return Column(
                      children: [
                        AuthUserButton(expanded: railIsExpanded),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SyncStateWidget(
                              state: syncState.state,
                              pendingCount: syncState.pendingCount,
                              onTap: () {
                                syncState.refresh();
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.versionWithNumber(appVersion),
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            if (AutoUpdaterService.instance.isBeta)
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
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
                          child: widget.body,
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
