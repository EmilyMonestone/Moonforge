# Routing with `auto_route`

The layout stays **responsive**, while `auto_route` manages **URLs, stacks, and nested routes**.

## Top‑Level Destinations (Tabs / Shell)

- Use **`AutoTabsRouter`** (or ShellRoute) to model your 5–7 top destinations.
- The **NavigationBar** (phone) and **NavigationRail** (tablet/desktop) both drive the **same tabs router**.

```dart
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      // Top-level routes (tabs) — one per destination
      routes: const [
        HomeRoute(),
        SearchRoute(),
        ItemsRoute(), // contains a nested detail route
        ProfileRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        final width = MediaQuery.sizeOf(context).width;
        final size  = AppSizeClass.fromWidth(width);

        // Build adaptive scaffold and wire selection → tabsRouter
        switch (size) {
          case SizeClass.compact:
            return PhoneScaffold(
              selectedIndex: tabsRouter.activeIndex,
              onSelectIndex: tabsRouter.setActiveIndex,
              destinations: kDestinations,
              body: child, // active tab’s AutoRouter
            );
          case SizeClass.medium:
          case SizeClass.expanded:
            return RailScaffold(
              selectedIndex: tabsRouter.activeIndex,
              onSelectIndex: tabsRouter.setActiveIndex,
              destinations: kDestinations,
              body: child,
              extended: size == SizeClass.expanded,
            );
        }
      },
    );
  }
}
```

> `child` is the active tab’s router outlet. Switching tabs swaps that subtree while preserving off‑tab state.

## Nested Detail Routes

For master–detail, give the **master route a child route** for the detail:

```dart
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  final routes = <AutoRoute>[
    AutoRoute(page: AppShellRoute.page, path: '/', children: [
      AutoRoute(page: HomeRoute.page, path: 'home'),
      AutoRoute(page: SearchRoute.page, path: 'search'),
      AutoRoute(page: ItemsRoute.page, path: 'items', children: [
        AutoRoute(page: ItemDetailRoute.page, path: ':id'),
      ]),
      AutoRoute(page: ProfileRoute.page, path: 'profile'),
      AutoRoute(page: SettingsRoute.page, path: 'settings'),
    ]),
  ];
}
```

- On **phones**, tapping an item can do `context.router.push(ItemDetailRoute(id: id))` → full‑page detail.
- On **tablets/desktops**, **`ItemsRoute`** can render a `TwoPaneLayout`. If the **detail child route** is active, render it in the **detail pane**. Otherwise show a placeholder.

### Detecting Active Child Route (detail)
Inside `ItemsRoute` widget, you can read the **nested router** state:

```dart
@RoutePage()
class ItemsPage extends StatelessWidget {
  const ItemsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Child AutoRouter for ItemsRoute
    final childRouter = AutoRouter.of(context);

    final isDetailActive = childRouter.currentChild != null;
    final detailWidget = isDetailActive ? const AutoRouter() : null;

    return TwoPaneLayout(
      master: ItemsList(
        onTapItem: (id) {
          // universal navigation; phones → pushes page; wide → populates right pane
          context.router.push(ItemDetailRoute(id: id));
        },
      ),
      detail: detailWidget,
      showDetail: isDetailActive,
    );
  }
}
```

This keeps **one URL structure** that works for both **split** and **single‑page** modes. Back navigation closes the detail (wide) or pops the page (narrow).

## Deep Links & Web
- The URL `/items/42` should **open the detail**. On wide screens, the app shows **list + detail**; on phones, it shows **detail page**.
- Consider **guards** for auth‑gated routes.
- Keep **tab index** in sync if a deep link lands inside one tab (e.g., programmatically set active tab when route changes).

## Notes
- The code above uses **generated route classes** (e.g., `HomeRoute`). Adjust to your naming.
- If you prefer **ShellRoute** (auto_route 7+), map bar/rail selections to its child routes similarly.