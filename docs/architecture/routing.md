# Routing and Navigation

This guide covers Moonforge's routing system using go_router with type-safe routes and deep linking support.

## Table of Contents

- [Router Configuration](#router-configuration)
- [Type-Safe Navigation](#type-safe-navigation)
- [Deep Linking](#deep-linking)
- [Adding New Routes](#adding-new-routes)
- [Troubleshooting](#troubleshooting)

## Router Configuration

Moonforge uses **go_router** with **go_router_builder** for type-safe, declarative routing.

### Key Files

- `lib/core/services/app_router.dart` - Route definitions and configuration
- `lib/core/services/app_router.g.dart` - Generated routes (do not edit)
- `lib/core/services/deep_link_service.dart` - Deep link handling
- `lib/layout/app_scaffold.dart` - App-level navigation shell

### Router Initialization

The router is configured in `app_router.dart`:

```dart
part 'app_router.g.dart';

class AppRouter {
  static final router = GoRouter(
    routes: $appRoutes,  // Generated from annotations
    errorBuilder: (context, state) => UnknownPathScreen(),
  );
}
```

## Route Tree

### Branch 1: Home & Auth
- `/` → `HomeRoute`
- `/login` → `LoginRoute`
  - `/login/register` → `RegisterRoute`
  - `/login/forgot` → `ForgotPasswordRoute`

### Branch 2: Campaign
- `/campaign` → `CampaignRoute`
  - `/campaign/edit` → `CampaignEditRoute`
  - `/campaign/chapter/:chapterId` → `ChapterRoute`
    - `/campaign/chapter/:chapterId/edit` → `ChapterEditRoute`
    - `/campaign/chapter/:chapterId/adventure/:adventureId` → `AdventureRoute`
      - `.../adventure/:adventureId/edit` → `AdventureEditRoute`
      - `.../adventure/:adventureId/scene/:sceneId` → `SceneRoute`
        - `.../scene/:sceneId/edit` → `SceneEditRoute`
  - `/campaign/encounter/:encounterId` → `EncounterRoute`
    - `/campaign/encounter/:encounterId/edit` → `EncounterEditRoute`
  - `/campaign/entity/:entityId` → `EntityRoute`
    - `/campaign/entity/:entityId/edit` → `EntityEditRoute`

### Branch 3: Party
- `/party[?id=<query>]` → `PartyRootRoute`
  - `/party/:partyId` → `PartyRoute`
    - `/party/:partyId/edit` → `PartyEditRoute`
    - `/party/:partyId/member/:memberId` → `MemberRoute`
      - `/party/:partyId/member/:memberId/edit` → `MemberEditRoute`
    - `/party/:partyId/session/:sessionId` → `SessionRoute`
      - `/party/:partyId/session/:sessionId/edit` → `SessionEditRoute`

### Branch 4: Settings
- `/settings` → `SettingsRoute`

## Type-Safe Navigation

### Defining Routes

Routes are defined as classes extending `GoRouteData`:

```dart
class ChapterRoute extends GoRouteData with _$ChapterRoute {
  const ChapterRoute({required this.chapterId});
  final String chapterId;
  
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChapterView(chapterId: chapterId);
  }
}
```

Path parameters are constructor fields. Query parameters use optional fields:

```dart
class PartyRootRoute extends GoRouteData with _$PartyRootRoute {
  const PartyRootRoute({this.id});
  final String? id;  // Query parameter
}
```

### Navigating

Use typed route instances for navigation:

```dart
// Navigate (replace current)
const ChapterRoute(chapterId: 'c1').go(context);

// Push (stack new screen)
const ChapterRoute(chapterId: 'c1').push(context);

// Replace current route
const ChapterRoute(chapterId: 'c1').replace(context);

// Push and await result
final result = await const ChapterEditRoute(chapterId: 'c1').push<bool>(context);
```

**Examples:**

```dart
// Navigate to campaign
const CampaignRoute().go(context);

// Open entity editor
const EntityEditRoute(entityId: 'e123').push(context);

// Navigate with query parameter
const PartyRootRoute(id: 'p456').go(context);

// Nested route
const SceneRoute(
  chapterId: 'ch1',
  adventureId: 'adv2',
  sceneId: 's3',
).push(context);
```

## Deep Linking

Moonforge supports deep linking across all platforms using the `moonforge://` URL scheme.

### Supported Deep Links

```
moonforge://campaign              # Campaign view
moonforge://party/[id]           # Specific party
moonforge://settings             # Settings view
```

### How Deep Links Work

1. **App Launch**: `DeepLinkService.initialize()` checks for initial link
2. **Runtime**: `uriLinkStream` delivers links while app is running
3. **Routing**: Service parses URI and calls `GoRouter` methods to navigate

### Architecture

**DeepLinkService** (`lib/core/services/deep_link_service.dart`):

```dart
class DeepLinkService {
  static Future<void> initialize(GoRouter router) async {
    final appLinks = AppLinks();
    
    // Handle initial link (app launched from link)
    final initialLink = await appLinks.getInitialLink();
    if (initialLink != null) {
      _handleDeepLink(initialLink, router);
    }
    
    // Handle links while app is running
    appLinks.uriLinkStream.listen((uri) {
      _handleDeepLink(uri, router);
    });
  }
  
  static void _handleDeepLink(Uri uri, GoRouter router) {
    if (uri.scheme != 'moonforge') return;
    
    final pathSegments = uri.pathSegments;
    if (pathSegments.isEmpty) return;
    
    switch (pathSegments[0]) {
      case 'campaign':
        router.go('/campaign');
        break;
      case 'party':
        if (pathSegments.length > 1) {
          router.go('/party/${pathSegments[1]}');
        } else {
          router.go('/party');
        }
        break;
      case 'settings':
        router.go('/settings');
        break;
    }
  }
}
```

### Platform Configuration

#### Android (`android/app/src/main/AndroidManifest.xml`)

```xml
<activity android:name=".MainActivity">
  <!-- Disable Flutter default deep linking -->
  <meta-data
      android:name="flutter_deeplinking_enabled"
      android:value="false" />
  
  <!-- Custom deep linking -->
  <intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="moonforge" />
  </intent-filter>
</activity>
```

#### iOS (`ios/Runner/Info.plist`)

```xml
<key>FlutterDeepLinkingEnabled</key>
<false/>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>moonforge</string>
    </array>
  </dict>
</array>
```

#### macOS

Same as iOS configuration in `macos/Runner/Info.plist`.

#### Windows (`windows/runner/main.cpp`)

```cpp
#include <app_links/app_links_plugin_c_api.h>

bool SendAppLinkToInstance(const std::wstring& title) {
  HWND hwnd = ::FindWindow(kWindowClassName, title.c_str());
  if (hwnd) {
    // Send WM_COPYDATA message with link
    return true;
  }
  return false;
}
```

Protocol registration happens via MSIX packaging.

#### Linux (`linux/runner/my_application.cc`)

```cpp
static gboolean my_application_local_command_line(
    GApplication* application, gchar*** arguments, int* exit_status) {
  // ...
  return FALSE;  // Propagate to plugin
}
```

Ensure `.desktop` file is configured correctly.

#### Web

Deep links work automatically through browser URLs:

```
http://localhost:port/#/campaign
http://localhost:port/#/party/xyz789
```

### Adding Deep Link Support

To add support for a new route:

1. **Update DeepLinkService** in `lib/core/services/deep_link_service.dart`:

```dart
case 'mynewroute':
  if (pathSegments.length > 1) {
    router.go('/mynewroute/${pathSegments[1]}');
  } else {
    router.go('/mynewroute');
  }
  break;
```

2. **Ensure route exists** in `app_router.dart`

For testing deep links, see [Testing Deep Links Guide](../development/testing-deep-links.md).

## Adding New Routes

### Step 1: Define Route Class

Create a class in `app_router.dart`:

```dart
class MyNewRoute extends GoRouteData with _$MyNewRoute {
  const MyNewRoute({required this.id});
  final String id;
  
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return MyNewView(id: id);
  }
}
```

### Step 2: Register in Route Tree

Add to the appropriate branch in `@TypedStatefulShellRoute`:

```dart
TypedGoRoute<MyNewRoute>(
  path: '/mynew/:id',
),
```

### Step 3: Generate Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 4: Use the Route

```dart
const MyNewRoute(id: 'abc').go(context);
```

### Custom Page Transitions

Override `buildPage()` for custom transitions:

```dart
@override
Page<void> buildPage(BuildContext context, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: MyNewView(id: id),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
```

## Troubleshooting

### Route Not Found

**Solutions**:
- Ensure route is defined in `app_router.dart`
- Run `dart run build_runner build --delete-conflicting-outputs`
- Restart IDE analyzer

### Generated File Not Found

**Solutions**:
- Ensure `part 'app_router.g.dart';` exists
- Run code generation
- Restart IDE

### Deep Links Not Working

See [Platform-Specific Guide](../development/platform-specific.md) for detailed platform configurations.

Common checks:
- Verify platform configuration files
- Check console logs for errors
- Ensure `DeepLinkService.initialize()` is called in `main.dart`
- Validate deep link parameters before using

### Type Errors After Adding Routes

**Solutions**:
- Ensure class mixes in generated mixin: `with _$YourRoute`
- Clean and rebuild: `dart run build_runner clean && dart run build_runner build`

## Best Practices

1. **Use Type-Safe Routes**: Always use typed route instances, not string paths
2. **Path Parameters**: Required parameters = non-nullable fields
3. **Query Parameters**: Optional parameters = nullable fields
4. **Deep Link Validation**: Always validate parameters
5. **Error Handling**: Implement proper error screens
6. **Testing**: Test deep links on all platforms (see [Testing Guide](../development/testing-deep-links.md))

## Related Documentation

- [Testing Deep Links](../development/testing-deep-links.md) - Platform-specific testing
- [Platform-Specific Guide](../development/platform-specific.md) - Deep linking configs
- [Architecture Overview](overview.md) - System architecture

## External Resources

- [go_router Documentation](https://pub.dev/packages/go_router)
- [go_router_builder Documentation](https://pub.dev/packages/go_router_builder)
- [app_links Documentation](https://pub.dev/packages/app_links)
