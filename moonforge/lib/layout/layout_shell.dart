import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonforge/core/services/hotkey/hotkey_global_wrapper.dart';
import 'package:moonforge/core/widgets/app_state_initializer.dart';
import 'package:moonforge/core/widgets/command_palette.dart';
import 'package:moonforge/layout/adaptive_scaffold.dart';
import 'package:moonforge/layout/destinations.dart';

class LayoutShell extends StatelessWidget {
  const LayoutShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final title = kPrimaryTabs[navigationShell.currentIndex].label;
    return AppStateInitializer(
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
    );
  }
}
