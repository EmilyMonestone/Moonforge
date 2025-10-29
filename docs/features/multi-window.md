# Multi-Window Support

Multi-window support allows opening different parts of the campaign in separate windows on desktop platforms and new tabs on web.

## Platform Support

| Platform | Support | Implementation |
|----------|---------|----------------|
| **Windows** | ✅ Full | Native windows via `desktop_multi_window` |
| **Linux** | ✅ Full | Native windows via `desktop_multi_window` |
| **Web** | ✅ Full | Browser tabs via `url_launcher` |
| **macOS** | 🚧 Planned | Not yet implemented |
| **Mobile** | ❌ No | Not applicable |

## User Experience

Users can right-click on navigable items (chapters, adventures, scenes, entities) to see a context menu with "Open in new window" option.

## How to Add Multi-Window Support

### For Custom Widgets

Wrap any widget with `LinkContextMenu`:

```dart
import 'package:moonforge/core/widgets/link_context_menu.dart';

LinkContextMenu(
  route: '/campaign/entity/$entityId',
  child: EntityCard(entity: entity),
)
```

### For CardList Widgets

Enable context menu on `CardList`:

```dart
import 'package:moonforge/features/home/widgets/card_list.dart';

CardList<Entity>(
  items: entities,
  titleOf: (e) => e.name,
  onTap: (e) => EntityRoute(entityId: e.id).go(context),
  enableContextMenu: true,  // Enable right-click menu
  routeOf: (e) => EntityRoute(entityId: e.id).location,  // Provide route
)
```

## Core Components

### MultiWindowService

Cross-platform service (`lib/core/services/multi_window_service.dart`):

```dart
// Check if supported on current platform
if (MultiWindowService.instance.isSupported) {
  // Show context menu
}

// Open route in new window
await MultiWindowService.instance.openRouteInNewWindow('/campaign/entity/123');
```

**Platform implementations:**
- **Desktop**: Uses `desktop_multi_window` package
- **Web**: Uses `url_launcher` to open in new tab
- **Others**: Returns false for `isSupported`

### LinkContextMenu Widget

Reusable widget (`lib/core/widgets/link_context_menu.dart`):

```dart
LinkContextMenu(
  route: '/path/to/route',
  enabled: true,  // Can be conditional
  child: YourWidget(),
)
```

**Features:**
- Right-click detection
- Platform-aware (shows only on supported platforms)
- Localized menu text
- Handles route opening

## Implementation Details

### Desktop (Windows/Linux)

Uses `desktop_multi_window` package:

1. Creates new native window process
2. Passes route as startup argument
3. New window navigates to route on initialization

```dart
// In MultiWindowService
final window = await DesktopMultiWindow.createWindow(jsonEncode({
  'route': route,
}));
window.show();
```

### Web

Uses `url_launcher` package:

1. Constructs full URL with route
2. Opens in new tab with `noopener` security attribute

```dart
// In MultiWindowService
final url = '${window.location.origin}/#$route';
await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
```

## Where Multi-Window is Available

Multi-window support is integrated in:

- ✅ Chapters list (campaign screen)
- ✅ Recent chapters (campaign screen)
- ✅ Adventures list (chapter screen)
- ✅ Scenes list (adventure screen)
- ✅ Any widget using `CardList` with `enableContextMenu: true`
- ✅ Any widget wrapped with `LinkContextMenu`

## Security

- **Web**: Uses `rel="noopener"` to prevent `window.opener` attacks
- **Desktop**: Each window is an isolated process
- **Route validation**: Always validate route parameters before navigating

## Localization

Menu text is localized:

- **English**: "Open in new window"
- **German**: "In neuem Fenster öffnen"

Add translations in `lib/l10n/app_*.arb`:

```json
{
  "openInNewWindow": "Open in new window"
}
```

## Best Practices

1. **Use for navigation items** - Chapters, scenes, entities, etc.
2. **Provide clear routes** - Use type-safe route location strings
3. **Test on platforms** - Verify on Windows, Linux, and Web
4. **Consider mobile** - Context menu hidden on unsupported platforms
5. **Validate routes** - Ensure routes are valid before opening

## Limitations

- **macOS**: Not yet implemented (planned)
- **Mobile**: Not applicable (no multi-window concept)
- **Window management**: No tracking of open windows or focus management
- **State sync**: Windows don't automatically sync state (use Firebase real-time updates)

## Troubleshooting

### Context menu not showing

- Check `MultiWindowService.instance.isSupported` returns true
- Verify platform is Windows, Linux, or Web
- Check `enabled` parameter is not false

### Window opens but doesn't navigate

- Verify route is valid and exists in `app_router.dart`
- Check console for navigation errors
- Ensure `DeepLinkService` handles the route

### Web: Opens in same tab instead of new tab

- Verify `url_launcher` is configured correctly
- Check browser settings allow pop-ups
- Test with different browsers

## Related Documentation

- [Routing](../architecture/routing.md) - Route configuration
- [Development Guide](../getting-started.md) - Setup and development

## Dependencies

- `desktop_multi_window: ^0.2.0` - Desktop window management
- `url_launcher: ^6.3.1` - Web tab opening

## External Resources

- [desktop_multi_window](https://pub.dev/packages/desktop_multi_window)
- [url_launcher](https://pub.dev/packages/url_launcher)
