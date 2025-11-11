# Type-Safe Routing Migration Guide

This document explains the migration from string-based routing to type-safe routes using `go_router_builder`.

## What Changed?

### Before (String-Based)

```dart
// Navigating with strings - error-prone!
context.go('/campaign');
context.go('/campaign/chapter/$chapterId');
context.go('/party/$partyId/session/$sessionId/edit');
```

### After (Type-Safe)

```dart
// Navigating with typed route data - compile-time safe!
const CampaignRouteData().go(context);
ChapterRouteData(chapterId: chapterId).go(context);
SessionEditRouteData(partyId: partyId, sessionId: sessionId).go(context);
```

## Benefits

1. **Compile-Time Safety**: Wrong parameters or paths are caught immediately
2. **IDE Autocomplete**: Full IntelliSense support for all routes
3. **Refactor-Safe**: Renaming a route class updates all usages
4. **Type-Checked Parameters**: Parameters are properly typed (String, int, etc.)
5. **Self-Documenting**: Route classes clearly show what parameters are required

## Route Structure

All routes are defined in `lib/core/services/router_config.dart` using annotations:

```dart
@TypedGoRoute<ChapterRouteData>(
  path: 'chapter/:chapterId',
  routes: [
    TypedGoRoute<ChapterEditRouteData>(path: 'edit'),
  ],
)
class ChapterRouteData extends GoRouteData {
  const ChapterRouteData({required this.chapterId});
  
  final String chapterId;
  
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ChapterScreen(chapterId: chapterId);
}
```

## Navigation Methods

Each typed route provides several navigation methods:

```dart
const route = HomeRouteData();

// Navigate, replacing the current route
route.go(context);

// Push a new route on the stack
route.push(context);

// Replace the current route
route.replace(context);

// Push and replace the entire stack
route.pushReplacement(context);

// Get the location string (for use with AppRouter.router.go())
final location = route.location; // Returns '/'
```

## Migration Checklist

If you need to add or modify routes:

1. ✅ Update `lib/core/services/router_config.dart` with your route annotation
2. ✅ Create the route data class extending `GoRouteData`
3. ✅ Implement the `build()` method to return your screen widget
4. ✅ Run code generation: `dart run build_runner build --delete-conflicting-outputs`
5. ✅ Use the typed route in your code: `const MyRouteData().go(context)`

## Common Patterns

### Simple Route (No Parameters)

```dart
@TypedGoRoute<SettingsRouteData>(path: '/settings')
class SettingsRouteData extends GoRouteData {
  const SettingsRouteData();
  
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

// Usage
const SettingsRouteData().go(context);
```

### Route with Path Parameters

```dart
@TypedGoRoute<EntityRouteData>(path: 'entity/:entityId')
class EntityRouteData extends GoRouteData {
  const EntityRouteData({required this.entityId});
  
  final String entityId;
  
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      EntityScreen(entityId: entityId);
}

// Usage
EntityRouteData(entityId: 'entity123').go(context);
```

### Nested Routes

```dart
@TypedGoRoute<PartyRouteData>(
  path: ':partyId',
  routes: [
    TypedGoRoute<PartyEditRouteData>(path: 'edit'),
    TypedGoRoute<SessionListRouteData>(path: 'sessions'),
  ],
)
class PartyRouteData extends GoRouteData {
  const PartyRouteData({required this.partyId});
  final String partyId;
  
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      PartyScreen(partyId: partyId);
}

// Usage
PartyRouteData(partyId: 'party123').go(context);
PartyEditRouteData(partyId: 'party123').push(context);
```

### Multiple Parameters

```dart
@TypedGoRoute<SceneRouteData>(path: 'scene/:sceneId')
class SceneRouteData extends GoRouteData {
  const SceneRouteData({
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
  });
  
  final String chapterId;
  final String adventureId;
  final String sceneId;
  
  @override
  Widget build(BuildContext context, GoRouterState state) => SceneScreen(
    chapterId: chapterId,
    adventureId: adventureId,
    sceneId: sceneId,
  );
}

// Usage
SceneRouteData(
  chapterId: 'ch1',
  adventureId: 'adv1',
  sceneId: 'sc1',
).go(context);
```

## Backward Compatibility

All existing route classes have been aliased for backward compatibility:

```dart
typedef HomeRoute = HomeRouteData;
typedef LoginRoute = LoginRouteData;
typedef CampaignRoute = CampaignRouteData;
// ... and so on
```

This means existing code using `const HomeRouteData().go(context)` will continue to work without changes.

## Shell Routes and Branches

The app uses a `StatefulShellRoute` with 4 branches:

1. **Home Branch** (`/`): Home screen and authentication
2. **Campaign Branch** (`/campaigns`, `/campaign`): All campaign-related screens
3. **Party Branch** (`/party`): Party and session management
4. **Settings Branch** (`/settings`, `/profile`): Settings and profile

Each branch maintains its own navigation stack, so users can switch between tabs without losing their place.

## Tips

- Always use `const` when creating route data objects without parameters
- Run code generation after modifying routes
- Use IDE autocomplete to discover available routes
- Check `router_config.dart` to see all available routes
- The generated `router_config.g.dart` file should not be manually edited

## Troubleshooting

### "Undefined name '$appRoutes'"

Run code generation: `dart run build_runner build --delete-conflicting-outputs`

### "The getter 'location' isn't defined"

Make sure you're using a route data class (e.g., `HomeRouteData`) not a plain string.

### "Missing required parameter"

Check the route data class definition to see what parameters are required.

### Navigation doesn't work

Verify that:

1. The route is defined in `router_config.dart`
2. Code generation has been run
3. You're using the correct route data class
4. All required parameters are provided

## Resources

- [go_router documentation](https://pub.dev/packages/go_router)
- [go_router_builder documentation](https://pub.dev/packages/go_router_builder)
- Project file: `lib/core/services/router_config.dart`
- Generated file: `lib/core/services/router_config.g.dart`
