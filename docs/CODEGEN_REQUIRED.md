# Code Generation Required

This project uses code generation for routing and other features.

## Router Code Generation

The project now uses **type-safe routes** via `go_router_builder`. All route definitions are in:
- **Source**: `lib/core/services/router_config.dart` - Contains all `@TypedGoRoute` and `@TypedStatefulShellRoute` annotations
- **Generated**: `lib/core/services/router_config.g.dart` - Auto-generated extensions and route configurations

### When to regenerate router code

Run code generation whenever you:
- Add new routes to `router_config.dart`
- Modify existing route paths or parameters
- Change route annotations

### How to regenerate

From the `moonforge/` directory, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or use the convenience script:

```bash
cd moonforge
../scripts/generate_code.sh
```

This will regenerate:
- `lib/core/services/router_config.g.dart` - Router extensions and `$appRoutes`
- Other `.g.dart` files (Drift database, JSON serialization, etc.)

## Type-Safe Navigation

With type-safe routes, navigation is now done like this:

```dart
// Navigate to a simple route
const HomeRouteData().go(context);

// Navigate with parameters
ChapterRouteData(chapterId: 'abc123').push(context);

// Navigate with multiple parameters
SceneRouteData(
  chapterId: 'abc',
  adventureId: 'xyz',
  sceneId: '123',
).go(context);
```

### Benefits

- ✅ **Compile-time safety**: Wrong parameters are caught at compile time
- ✅ **IDE autocomplete**: Full IntelliSense support for routes and parameters
- ✅ **Refactor-safe**: Renaming routes updates all usages
- ✅ **Type-checked**: Parameters are properly typed (String, int, etc.)

## Other Generated Code

The project also uses code generation for:
- **Drift** (database): `lib/data/db/*.g.dart`
- **JSON serialization**: Various `*.g.dart` files throughout the codebase
- **Freezed** (immutable models): If used in the future

Run the same `build_runner` command to regenerate all generated code.
