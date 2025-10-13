import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/layout/adaptive_scaffold.dart';
import 'package:moonforge/layout/destinations.dart';

@RoutePage()
class LayoutShell extends StatelessWidget {
  const LayoutShell({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      // The order controls the initial tab and bottom/rail order.
      routes: [for (final tab in kPrimaryTabs) tab.routeFactory()],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final title = kPrimaryTabs[tabsRouter.activeIndex].label;
        return AdaptiveScaffold(
          tabsRouter: tabsRouter,
          tabs: kPrimaryTabs,
          appBarTitle: Text(title),
          body: child,
        );
      },
    );
  }
}
