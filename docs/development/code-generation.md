# Code Generation Quick Reference

Moonforge uses extensive code generation for models, routes, assets, and database code. This quick reference covers the essentials.

## When to Run Code Generation

Run code generation when you:
- Add/modify Freezed models (`@freezed`)
- Change JSON serializable classes (`@JsonSerializable`)
- Update routes in `app_router.dart`
- Modify Drift database tables
- Add/modify Firestore ODM models
- Add assets to `pubspec.yaml`

## Quick Commands

### One-Time Generation

```bash
dart run build_runner build --delete-conflicting-outputs
```

Use `--delete-conflicting-outputs` to handle conflicts automatically.

### Watch Mode (Continuous)

```bash
dart run build_runner watch --delete-conflicting-outputs
```

Automatically regenerates when you save files. Recommended during active development.

### Clean Generated Files

```bash
dart run build_runner clean
```

Removes all generated files. Run this if generation is stuck.

##Generated File Types

| Pattern | Generator | Purpose |
|---------|-----------|---------|
| `*.g.dart` | json_serializable, firestore_odm | JSON serialization, Firestore models |
| `*.freezed.dart` | freezed | Immutable models, unions, copyWith |
| `*.gr.dart` | go_router_builder | Type-safe routes |
| `lib/gen/assets.gen.dart` | flutter_gen | Asset constants |
| `lib/gen/colors.gen.dart` | flutter_gen | Color constants |

**Never edit generated files directly!** They'll be overwritten on next generation.

## Common Generators

### Freezed (Immutable Models)

Add to your model:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign.freezed.dart';
part 'campaign.g.dart';

@freezed
class Campaign with _$Campaign {
  const factory Campaign({
    required String id,
    required String name,
    String? description,
  }) = _Campaign;
  
  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);
}
```

Generates:
- Immutable class with copyWith()
- Equality and toString()
- JSON serialization

### JSON Serializable

For simple JSON classes without Freezed:

```dart
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class Config {
  final String apiKey;
  final int timeout;
  
  Config({required this.apiKey, required this.timeout});
  
  factory Config.fromJson(Map<String, dynamic> json) =>
      _$ConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
```

### go_router_builder

Define routes in `app_router.dart`:

```dart
class MyRoute extends GoRouteData with _$MyRoute {
  const MyRoute({required this.id});
  final String id;
  
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      MyView(id: id);
}
```

Register in `@TypedStatefulShellRoute` then run generation.

### Drift (Database)

Define tables:

```dart
import 'package:drift/drift.dart';

class Campaigns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
}
```

Generates DAOs and query builders.

### Firestore ODM

```dart
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';

@Collection<Campaign>('campaigns')
final campaignsRef = CampaignCollectionReference();
```

Generates type-safe Firestore references.

## Troubleshooting

### Build Fails

```bash
# Clean and rebuild
dart run build_runner clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Import Errors After Generation

- Restart your IDE/analyzer
- Run `flutter pub get`
- Check `part` directives match generated filenames

### Conflicts During Generation

Use `--delete-conflicting-outputs` flag to auto-resolve.

### Generator Not Running

- Check `part` directive exists in source file
- Verify package is in `dev_dependencies` in `pubspec.yaml`
- Check `build.yaml` configuration (if using custom config)

### Slow Generation

Watch mode can be slow with many files. To speed up:
- Only run watch when actively editing generated code
- Use one-time generation (`build`) for occasional changes
- Exclude unnecessary directories in `build.yaml`

## Best Practices

1. **Commit generated files** - They're part of the codebase in this project
2. **Run before committing** - Ensure generated code is up-to-date
3. **Use watch mode sparingly** - Can slow down IDE during large refactors
4. **Clean when stuck** - `build_runner clean` fixes most issues
5. **Check git diff** - Review generated code changes in PRs

## Configuration

Build runner config in `build.yaml` (project root):

```yaml
targets:
  $default:
    builders:
      freezed:
        enabled: true
      json_serializable:
        enabled: true
```

Asset generation config in `pubspec.yaml`:

```yaml
flutter_gen:
  output: lib/gen/
  line_length: 80
  integrations:
    flutter_svg: true
```

## Quick Checks

After generation, verify:

```bash
# No analysis errors
flutter analyze

# Tests pass
flutter test

# App runs
flutter run
```

## Related Documentation

- [Architecture Overview](../architecture/overview.md) - Code generation strategy
- [Getting Started](../getting-started.md) - Initial setup
- [Offline Sync](../architecture/offline-sync.md) - Drift code generation

## External Resources

- [build_runner](https://pub.dev/packages/build_runner)
- [freezed](https://pub.dev/packages/freezed)
- [json_serializable](https://pub.dev/packages/json_serializable)
- [go_router_builder](https://pub.dev/packages/go_router_builder)
- [drift](https://drift.simonbinder.eu/docs/advanced-features/builder_options/)
- [flutter_gen](https://pub.dev/packages/flutter_gen)
