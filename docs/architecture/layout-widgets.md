# Platform-Specific Layout Widgets

This document explains the platform-specific layout architecture in Moonforge and describes when each widget is used.

## Overview

Moonforge uses a **platform-aware** layout system that provides different UI implementations for mobile platforms (Android, iOS, Fuchsia) versus desktop platforms (Windows, macOS, Linux, Web). This approach ensures optimal user experience based on the expected interaction patterns of each platform type.

## Architecture

### Platform Detection

The `PlatformDetector` utility (`lib/layout/platform_detector.dart`) provides two static methods:

- **`isMobilePlatform`**: Returns `true` for Android, iOS, or Fuchsia
- **`isDesktopPlatform`**: Returns `true` for Windows, macOS, Linux, or Web

### Layout Decision Tree

The `AdaptiveScaffold` combines platform detection with size classes to select the appropriate scaffold widget:

```
┌─────────────────────────────────────────┐
│      AdaptiveScaffold                    │
│  (lib/layout/adaptive_scaffold.dart)     │
└──────────────┬──────────────────────────┘
               │
       ┌───────┴───────┐
       │               │
   Platform?       Platform?
   Mobile          Desktop
       │               │
   ┌───┴───┐       ┌───┴───┐
   │       │       │       │
Compact  Wide   Compact  Wide
   │       │       │       │
   ▼       ▼       ▼       ▼
Mobile  Mobile  Desktop Desktop
Compact  Wide   Compact  Wide
Scaffold Scaffold Scaffold Scaffold
```

## Widget Details

### 1. MobileCompactScaffold

**Location**: `lib/layout/widgets/mobile_compact_scaffold.dart`

**Used for**: Phone-sized screens on Android, iOS, or Fuchsia

**Size class**: `SizeClass.compact` (width < 600px)

**Visual Layout**:
```
┌──────────────────────────────────┐
│  ╔════════════════════════════╗  │
│  ║   WindowTopBar + Breadcrumbs║  │  ← AppBar with breadcrumbs
│  ╚════════════════════════════╝  │
├──────────────────────────────────┤
│                                  │
│                                  │
│        Main Content Body         │  ← Scrollable content area
│                                  │
│                                  │
├──────────────────────────────────┤
│  ┌────┬────┬────┬────┬────┐     │
│  │ 🏠 │ ⚙️ │ 🔍 │ 👤 │ 🔔 │     │  ← NavigationBar (max 5 tabs)
│  └────┴────┴────┴────┴────┘     │
└──────────────────────────────────┘
           [+] FAB                     ← FloatingActionButton for menu
```

**Features**:
- Bottom `NavigationBar` for up to 5 primary tabs
- For > 5 tabs: Adds a persistent `NavigationRail` on the left for overflow
- `FloatingActionButton` to show action menu via bottom sheet
- Touch-optimized spacing and targets

---

### 2. MobileWideScaffold

**Location**: `lib/layout/widgets/mobile_wide_scaffold.dart`

**Used for**: Tablet-sized screens on Android, iOS, or Fuchsia

**Size class**: `SizeClass.medium` or `SizeClass.expanded` (width ≥ 600px)

**Visual Layout**:
```
┌──────────────────────────────────────────┐
│  ╔══════════════════════════════════════╗│
│  ║   WindowTopBar + Breadcrumbs         ║│  ← AppBar
│  ╚══════════════════════════════════════╝│
├───┬──────────────────────────────────────┤
│ 🏠│                                      │
│ ⚙️│                                      │
│ 🔍│      Main Content Body               │  ← NavigationRail + Content
│ 👤│                                      │
│ 🔔│                                      │
│   │                                      │
└───┴──────────────────────────────────────┘
    ↑                                  [+] FAB
NavigationRail
(all tabs)
```

**Features**:
- Persistent `NavigationRail` on the left showing all tabs
- No bottom navigation bar (rail provides all navigation)
- `FloatingActionButton` for action menu
- More horizontal space for content than phone layout

---

### 3. DesktopCompactScaffold

**Location**: `lib/layout/widgets/desktop_compact_scaffold.dart`

**Used for**: Narrow windows on Windows, macOS, Linux, or Web

**Size class**: `SizeClass.compact` (width < 600px)

**Visual Layout**:
```
┌──────────────────────────────────────────┐
│  ╔══════════════════════════════════════╗│
│  ║ WindowTopBar + Breadcrumbs           ║│  ← AppBar (desktop style)
│  ╚══════════════════════════════════════╝│
├───┬──────────────────────────────────────┤
│ 🏠│                                      │
│ ⚙️│                                      │
│ 🔍│      Main Content Body               │  ← Always uses NavigationRail
│ 👤│                                      │
│ 🔔│                                      │
│   │                                      │
└───┴──────────────────────────────────────┘
    ↑                                  [+] FAB
NavigationRail
```

**Features**:
- Uses `NavigationRail` even in compact mode (desktop users expect persistent navigation)
- No bottom navigation bar
- Desktop-style window top bar
- `FloatingActionButton` for action menu
- Optimized for mouse/keyboard interaction

---

### 4. DesktopWideScaffold

**Location**: `lib/layout/widgets/desktop_wide_scaffold.dart`

**Used for**: Normal/wide windows on Windows, macOS, Linux, or Web

**Size class**: `SizeClass.medium` or `SizeClass.expanded` (width ≥ 600px)

**Visual Layout**:
```
┌────────────────────────────────────────────────────┐
│  ╔════════════════════════════════════════════════╗│
│  ║ WindowTopBar + Breadcrumbs                     ║│  ← AppBar
│  ╚════════════════════════════════════════════════╝│
├───────────┬────────────────────────────────────────┤
│  ╔═════╗  │                                        │
│  ║ 🏠  ║  │                                        │
│  ║Home ║  │                                        │  ← NavigationRailM3E
│  ╠═════╣  │                                        │    (Material 3 Expressive)
│  ║ ⚙️  ║  │       Main Content Body                │    Expandable/Collapsible
│  ║Set..║  │                                        │
│  ╠═════╣  │                                        │
│  ║ ... ║  │                                        │
│  ╠═════╣  │                                        │
│  ║     ║  │                                        │
│  ║ 👤  ║  │                                        │
│  ║Sync ║  │                                        │
│  ║v1.0 ║  │                                        │
│  ╚═════╝  │                                        │
└───────────┴────────────────────────────────────────┘
     ↑
Expanded rail with:
- User profile button
- Sync status widget
- Version info
```

**Features**:
- Enhanced `NavigationRailM3E` (Material 3 Expressive variant)
- Expandable/collapsible rail (controlled by user settings)
- Trailing section at bottom with:
  - `AuthUserButton` (user profile)
  - `SyncStateWidget` (sync status)
  - App version and beta badge
- Full desktop-optimized experience
- No floating action button (desktop uses traditional menus)

---

## Size Class Reference

Size classes are defined in `lib/layout/breakpoints.dart`:

| Size Class | Width Range | Typical Devices |
|-----------|-------------|-----------------|
| `compact` | < 600px | Phones (portrait), narrow windows |
| `medium` | 600px - 1024px | Phones (landscape), small tablets, medium windows |
| `expanded` | ≥ 1024px | Tablets (landscape), large displays, wide windows |

---

## Platform-Specific Differences

### Mobile Platforms (Android, iOS, Fuchsia)

**Design principles**:
- Touch-first interactions
- Bottom navigation for compact screens (easier thumb reach)
- Floating action buttons for primary actions
- Simplified top bar
- Modal bottom sheets for menus

**Characteristics**:
- Larger touch targets
- More vertical scrolling
- System gestures respected (e.g., iOS swipe back)
- Platform-specific Material You theming

### Desktop Platforms (Windows, macOS, Linux, Web)

**Design principles**:
- Mouse/keyboard-first interactions
- Persistent navigation rails (always visible)
- Enhanced navigation with expand/collapse
- Window control integration
- Traditional menu patterns

**Characteristics**:
- Smaller, denser UI elements
- More horizontal layouts
- Window management features
- Keyboard shortcuts supported
- Rich navigation with metadata (sync, user, version)

---

## Reusable Widgets

The following widgets are shared across all platform-specific scaffolds:

### WindowTopBar
**Location**: `lib/core/widgets/window_top_bar.dart`

Used in all scaffolds for the app bar area. Handles breadcrumbs and window controls.

### AdaptiveBreadcrumb
**Location**: `lib/core/widgets/adaptive_breadcrumb.dart`

Breadcrumb navigation that adapts to available space.

### MenuRegistry & FloatingActionButton
**Location**: `lib/core/repositories/menu_registry.dart`

Context-aware action menu system. Mobile scaffolds use `FloatingActionButton` to show menus in a bottom sheet. Desktop scaffolds may integrate menus differently.

### AuthUserButton
**Location**: `lib/core/widgets/auth_user_button.dart`

User profile button (shown in desktop wide scaffold).

### SyncStateWidget
**Location**: `lib/data/widgets/sync_state_widget.dart`

Displays sync status (shown in desktop wide scaffold).

---

## Implementation Flow

When a route is navigated:

1. `LayoutShell` wraps the app with global services
2. `AdaptiveScaffold` receives the `StatefulNavigationShell`
3. Platform is detected using `PlatformDetector`
4. Screen size is measured using `MediaQuery` and `AppSizeClass`
5. Appropriate scaffold widget is selected based on platform + size
6. Scaffold renders with breadcrumbs, navigation, and body content

---

## Testing

Each scaffold widget has corresponding tests in `test/layout/`:

- `platform_detector_test.dart` - Platform detection logic
- `mobile_compact_scaffold_test.dart` - Mobile compact layout
- `mobile_wide_scaffold_test.dart` - Mobile wide layout
- `desktop_compact_scaffold_test.dart` - Desktop compact layout
- `desktop_wide_scaffold_test.dart` - Desktop wide layout

Run layout tests:
```bash
flutter test test/layout/
```

---

## Migration Notes

### From Size-Based to Platform-Based

Previous implementation used only size classes (`SizeClass`) to determine layout. The refactored implementation uses **both** platform detection and size classes:

**Before**:
```dart
switch (size) {
  case SizeClass.compact:
    return AdaptiveCompactScaffold(...);
  case SizeClass.medium:
  case SizeClass.expanded:
    return AdaptiveWideScaffold(...);
}
```

**After**:
```dart
switch (size) {
  case SizeClass.compact:
    if (PlatformDetector.isMobilePlatform) {
      return MobileCompactScaffold(...);
    } else {
      return DesktopCompactScaffold(...);
    }
  case SizeClass.medium:
  case SizeClass.expanded:
    if (PlatformDetector.isMobilePlatform) {
      return MobileWideScaffold(...);
    } else {
      return DesktopWideScaffold(...);
    }
}
```

### Benefits of Platform-Based Approach

1. **Clearer intent**: Code explicitly shows mobile vs desktop differences
2. **Easier maintenance**: Platform-specific changes don't affect other platforms
3. **Better UX**: Each platform gets optimized layouts for its interaction model
4. **Future flexibility**: Easy to add platform-specific features without complex conditionals

---

## Future Enhancements

Potential improvements to the layout system:

- [ ] Foldable device support (dual-screen layouts)
- [ ] Tablet-specific optimizations (iPad, Surface)
- [ ] Adaptive typography based on platform
- [ ] Platform-specific animations and transitions
- [ ] Customizable breakpoint thresholds per platform
- [ ] Responsive navigation rail width on desktop

---

## Related Documentation

- [Routing Architecture](routing.md) - How navigation integrates with layout
- [Breakpoints](../layout/breakpoints.dart) - Size class definitions
- [Window Top Bar](../../lib/core/widgets/window_top_bar.dart) - Top bar widget

---

*Last updated: 2025-12-10*
