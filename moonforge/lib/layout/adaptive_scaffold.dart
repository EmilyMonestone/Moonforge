import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/services/breadcrumb_service.dart'
    as breadcrumb_service;
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/adaptive_breadcrumb.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:moonforge/layout/breakpoints.dart';
import 'package:moonforge/layout/destinations.dart';
import 'package:moonforge/layout/platform_detector.dart';
import 'package:moonforge/layout/widgets/desktop_compact_scaffold.dart';
import 'package:moonforge/layout/widgets/desktop_wide_scaffold.dart';
import 'package:moonforge/layout/widgets/mobile_compact_scaffold.dart';
import 'package:moonforge/layout/widgets/mobile_wide_scaffold.dart';

/// AdaptiveScaffold builds a responsive Scaffold that switches between
/// platform-specific layouts (mobile vs desktop) and size classes (compact vs wide).
///
/// Platform detection is used to determine the appropriate scaffold variant:
/// - Mobile platforms (Android, iOS, Fuchsia): Use mobile-optimized scaffolds
/// - Desktop platforms (Windows, macOS, Linux, Web): Use desktop-optimized scaffolds
///
/// Size classes determine compact vs wide layouts within each platform variant.
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
  bool railIsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final size = AppSizeClass.of(context);
    final state = GoRouterState.of(context);

    // Build breadcrumbs from the current location using the new service.
    // Use the URI path as a key to ensure we only rebuild when the route changes
    return FutureBuilder<List<breadcrumb_service.BreadcrumbItem>>(
      key: ValueKey(state.uri.path),
      future: breadcrumb_service.BreadcrumbService.buildBreadcrumbs(
        context,
        state,
      ),
      builder: (context, snapshot) {
        Widget breadcrumbs;

        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          // Show a minimal loading breadcrumb
          breadcrumbs = AdaptiveBreadcrumb(
            items: [
              AdaptiveBreadcrumbItem(
                content: Text(AppLocalizations.of(context)!.ellipsis),
              ),
            ],
            divider: const Icon(Icons.chevron_right, size: 16),
          );
        } else {
          final items = snapshot.data!;
          if (items.isEmpty) {
            breadcrumbs = AdaptiveBreadcrumb(
              items: [
                AdaptiveBreadcrumbItem(
                  content: Text(AppLocalizations.of(context)!.home),
                  onTap: () => const HomeRouteData().go(context),
                ),
              ],
              divider: const Icon(Icons.chevron_right, size: 16),
            );
          } else {
            breadcrumbs = AdaptiveBreadcrumb(
              items: items.map((item) {
                return AdaptiveBreadcrumbItem(
                  content: Text(
                    item.text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  onTap: () => context.go(item.path),
                );
              }).toList(),
              divider: const Icon(Icons.chevron_right, size: 16),
            );
          }
        }

        switch (size) {
          case SizeClass.compact:
            // Use platform-specific compact scaffold
            if (PlatformDetector.isMobilePlatform) {
              return MobileCompactScaffold(
                tabs: widget.tabs,
                body: widget.body,
                selectedIndex: _selectedIndex,
                onSelect: _onSelect,
                breadcrumbs: breadcrumbs,
              );
            } else {
              return DesktopCompactScaffold(
                tabs: widget.tabs,
                body: widget.body,
                selectedIndex: _selectedIndex,
                onSelect: _onSelect,
                breadcrumbs: breadcrumbs,
              );
            }
          case SizeClass.medium:
          case SizeClass.expanded:
            // Use platform-specific wide scaffold
            if (PlatformDetector.isMobilePlatform) {
              return MobileWideScaffold(
                tabs: widget.tabs,
                body: widget.body,
                selectedIndex: _selectedIndex,
                onSelect: _onSelect,
                breadcrumbs: breadcrumbs,
              );
            } else {
              return DesktopWideScaffold(
                tabs: widget.tabs,
                body: widget.body,
                selectedIndex: _selectedIndex,
                onSelect: _onSelect,
                breadcrumbs: breadcrumbs,
              );
            }
        }
      },
    );
  }

  int get _selectedIndex => widget.navigationShell.currentIndex;

  void _onSelect(BuildContext context, int index) =>
      widget.navigationShell.goBranch(index);
}
