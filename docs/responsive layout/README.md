# Responsive Layout System (Flutter) — Material 3 Expressive + auto_route

This documentation describes a **responsive layout system** for Flutter apps that:
- Uses **Material 3 (Material You) – Expressive** components and styling.
- Adapts to **phone (portrait-first), tablet, and desktop**.
- Switches between **NavigationBar (phone)** and **NavigationRail (tablet/desktop)**.
- Supports **5–7 top-level destinations**, with an **overflow strategy** for phones.
- Provides an **optional second pane** (detail) that appears **side-by-side** on wide screens and **as a separate page** on narrow screens.
- Is designed to be **compatible with `auto_route`** (nested routes, tabs, deep-linking).

> **Scope**: This is developer documentation. It focuses on patterns, APIs, decision points, and wiring with `auto_route`. It intentionally avoids app-specific example routes/screens, but includes generic snippets to illustrate integration.

## Contents
- [Breakpoints & Size Classes](breakpoints.md)
- [Adaptive Navigation (Bar & Rail) + Overflow](navigation.md)
- [Two‑Pane (Master–Detail) Layout](two_pane.md)
- [Routing with `auto_route`](auto_route_integration.md)

---

## Quick Start

1) **Enable Material 3**
```dart
MaterialApp.router(
  theme: ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF6750A4), // optional seed
  ),
  routerConfig: appRouter.config(), // from auto_route
);
```

2) **Adopt shared breakpoints** (see [`breakpoints.md`](breakpoints.md)) and a size‑class helper to branch layouts:
```dart
final width = MediaQuery.sizeOf(context).width;
final size = AppSizeClass.fromWidth(width);
switch (size) {
  case SizeClass.compact:   return PhoneScaffold(...);
  case SizeClass.medium:    return TabletScaffold(...);
  case SizeClass.expanded:  return DesktopScaffold(...);
}
```

3) **Define destinations (5–7 total)** and split **primary vs overflow** for phones (see [`navigation.md`](navigation.md)).
   - Phones: `NavigationBar` (≤5 primary) + **modal NavigationDrawer** for overflow.
   - Tablet/Desktop: `NavigationRail` (labels visible; can be extended).

4) **Implement the Two‑Pane pattern** (see [`two_pane.md`](two_pane.md)).
   - If width ≥ breakpoint **and** a detail is requested → show **side‑by‑side**.
   - Otherwise → navigate to the detail as a **separate page**.

5) **Wire to `auto_route`** (see [`auto_route_integration.md`](auto_route_integration.md)).
   - Use **AutoTabsRouter** (or ShellRoute) for top destinations.
   - Use **nested routes** for details (`/items/:id`) so the same URL works for both split and single‑page modes.

---

## Design Principles

- **Expressive M3**: prefer modern components (`NavigationBar`, `NavigationRail`, `NavigationDrawer`), motion, and shape.
- **Single Source of Truth**: one destination list feeds both bar and rail.
- **Overflow is explicit**: phones get a drawer / “More” for >5 items.
- **URL & State consistency**: nested detail routes preserve back/forward across sizes.
- **Portrait‑first on phones**: main target orientation is portrait for mobile.

## Folder Suggestions (optional)

```
lib/
  layout/
    breakpoints.dart
    destinations.dart
    adaptive_scaffold.dart
    two_pane.dart
  routing/
    app_router.dart
```

## Testing Checklist
- Resize emulator/window across breakpoints; verify bar↔rail swap.
- On phones: confirm overflow items accessible via drawer/“More”.
- On tablets/desktops: confirm rail labels readable; consider extended rail.
- Two‑pane: select an item → detail appears side‑by‑side (wide) or as a page (narrow).
- Back button & deep links: ensure nested detail routes behave consistently.