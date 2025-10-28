# Multi-Window Support

This feature adds the ability to open routes in new windows on desktop (Windows, Linux) and web platforms.

## User Experience

When browsing content like chapters, adventures, scenes, or entities, users can:

1. **Left-click** to navigate normally within the same window
2. **Right-click** to see a context menu with "Open in new window" option
3. Select "Open in new window" to open that content in a separate window

### Supported Platforms

- **Web**: Opens content in a new browser tab
- **Desktop (Windows/Linux)**: Opens content in a new native window
- **Mobile/macOS**: Not currently supported (context menu is hidden on these platforms)

## Technical Implementation

### Core Components

#### 1. MultiWindowService (`lib/core/services/multi_window_service.dart`)

Cross-platform service that abstracts window creation:

```dart
// Open a route in a new window
await MultiWindowService.instance.openRouteInNewWindow('/campaign/entity/123');

// Check if multi-window is supported on current platform
if (MultiWindowService.instance.isSupported) {
  // Show context menu
}
```

#### 2. LinkContextMenu Widget (`lib/core/widgets/link_context_menu.dart`)

Reusable widget that adds right-click context menu to any widget:

```dart
LinkContextMenu(
  route: '/campaign/entity/123',
  enabled: true,
  child: YourNavigableWidget(),
)
```

#### 3. CardList Enhancement (`lib/features/home/widgets/card_list.dart`)

The `CardList` widget now supports optional context menu:

```dart
CardList<Chapter>(
  items: chapters,
  titleOf: (c) => c.name,
  onTap: (c) => ChapterRoute(chapterId: c.id).go(context),
  enableContextMenu: true,  // Enable context menu
  routeOf: (c) => ChapterRoute(chapterId: c.id).location,  // Provide route
)
```

### Deep Linking

New windows automatically navigate to the specified route on startup:

1. **Web**: The full URL is constructed and opened in a new tab
2. **Desktop**: The route is passed as an argument to the new window process, which then navigates to it after initialization

### Security

- **Web**: Uses `rel="noopener"` to prevent window.opener attacks
- **Desktop**: Each window is an isolated process with its own app state

## Usage Examples

### Adding Context Menu to Custom Widgets

Wrap any navigable widget with `LinkContextMenu`:

```dart
import 'package:moonforge/core/widgets/link_context_menu.dart';

LinkContextMenu(
  route: '/campaign/entity/$entityId',
  child: EntityCard(entity: entity),
)
```

### Using with CardList

Enable context menu on CardList by providing `routeOf` and setting `enableContextMenu`:

```dart
CardList<Entity>(
  items: entities,
  titleOf: (e) => e.name,
  onTap: (e) => EntityRoute(entityId: e.id).go(context),
  enableContextMenu: true,
  routeOf: (e) => EntityRoute(entityId: e.id).location,
)
```

## Current Integrations

Context menu support has been added to:

- ✅ Chapters list (campaign screen)
- ✅ Recent chapters (campaign screen)
- ✅ Adventures list (chapter screen)
- ✅ Scenes list (adventure screen)

## Future Enhancements

Potential improvements for the future:

1. **Window Management**: Track open windows and prevent duplicates or focus existing windows
2. **State Synchronization**: Sync changes between windows (e.g., Firebase real-time updates)
3. **Window Preferences**: Remember window size/position per route
4. **Keyboard Shortcuts**: Add Ctrl+Click or Cmd+Click shortcuts
5. **macOS Support**: Add support for native macOS multi-window
6. **Mobile Support**: Explore mobile multi-window APIs (Android split-screen, iPad multi-window)

## Testing

Run the tests:

```bash
flutter test test/core/services/multi_window_service_test.dart
flutter test test/core/widgets/link_context_menu_test.dart
```

### Manual Testing

1. **Web Testing**:
   ```bash
   flutter run -d chrome
   ```
   - Right-click on a chapter/adventure/scene
   - Select "Open in new window"
   - Verify new tab opens with correct route

2. **Desktop Testing**:
   ```bash
   flutter run -d windows  # or linux
   ```
   - Right-click on a chapter/adventure/scene
   - Select "Open in new window"
   - Verify new window opens with correct content
   - Verify window is properly sized and positioned

## Dependencies

- `url_launcher: ^6.3.1` - For opening URLs in new tabs on web
- `desktop_multi_window: ^0.2.0` - For creating native windows on desktop

## Localization

Strings are available in:
- English: "Open in new window"
- German: "In neuem Fenster öffnen"

Add translations in `lib/l10n/app_*.arb` files.
