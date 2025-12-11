import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/hotkey/hotkey_global_wrapper.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/widgets/app_state_initializer.dart';
import 'package:moonforge/core/widgets/command_palette.dart';
import 'package:moonforge/core/widgets/navigation_history_service.dart';
import 'package:moonforge/layout/adaptive_scaffold.dart';
import 'package:moonforge/layout/destinations.dart';

/// Root layout wrapper that initializes app state, hotkeys, and command palette
/// then renders the adaptive scaffold with the provided navigation shell.
///
/// This widget is the top-level container for app chrome and should be used
/// by the top-level router to embed the `StatefulNavigationShell`.
class LayoutShell extends StatelessWidget {
  const LayoutShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final title = kPrimaryTabs[navigationShell.currentIndex].label;
    final history = AppRouter.navigationHistory;
    final location = navigationShell.shellRouteContext.routerState.uri
        .toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (history.current != location) {
        history.push(location);
        // Persist the current route for "continue where left off" feature
        PersistenceService().write('last_visited_route', location);
      }
    });
    return NavigationHistoryScope(
      notifier: history,
      child: AppStateInitializer(
        child: HotkeyGlobalWrapper(
          child: CommandPalette(
            child: AdaptiveScaffold(
              navigationShell: navigationShell,
              tabs: kPrimaryTabs,
              appBarTitleText: Text(title),
              body: navigationShell,
            ),
          ),
        ),
      ),
    );
  }
}
