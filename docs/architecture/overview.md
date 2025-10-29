# Architecture Overview

This document provides a high-level overview of Moonforge's architecture, tech stack, and design principles.

## System Architecture

Moonforge is built as a **multi-platform Flutter application** with an **offline-first architecture** backed by Firebase.

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App (UI)                     │
│                  (Material 3 Expressive)                │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────┴──────────────────────────────────┐
│              State Management (Riverpod)                │
│           Providers, Controllers, View Models           │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────┴──────────────────────────────────┐
│                  Data Layer (Drift)                     │
│         Local SQLite Database (Source of Truth)         │
│              Repositories, DAOs, Sync Engine            │
└──────────┬────────────────────────────────┬─────────────┘
           │                                │
┌──────────┴────────────┐      ┌───────────┴──────────────┐
│   Firebase Firestore  │      │  Firebase Storage        │
│   (Remote Database)   │      │  (Media Files)           │
│   Background Sync     │      │  Background Upload       │
└───────────────────────┘      └──────────────────────────┘
```

### Key Principles

1. **Offline-First**: Local Drift database is source of truth; Firebase syncs in background
2. **Type Safety**: Leverages Dart's type system, Freezed, and code generation
3. **Reactive State**: Riverpod providers with streams for real-time updates
4. **Platform Adaptive**: Shared codebase with platform-specific adaptations
5. **Modular Design**: Feature-based organization with clear boundaries

## Tech Stack

### Core Framework
- **[Flutter 3.x](https://flutter.dev/)** - Cross-platform UI framework
- **[Dart](https://dart.dev/)** - Programming language (stable channel)
- **[Material 3](https://m3.material.io/)** - Design system (Expressive variant)

### State Management
- **[Riverpod](https://riverpod.dev/)** (flutter_riverpod) - Reactive state management
- Providers for dependency injection and state
- StreamProviders for real-time data
- FutureProviders for async operations

See [State Management Guide](state-management.md) for patterns.

### Navigation
- **[go_router](https://pub.dev/packages/go_router)** - Declarative routing
- **[go_router_builder](https://pub.dev/packages/go_router_builder)** - Type-safe routes
- **[app_links](https://pub.dev/packages/app_links)** - Deep linking support

See [Routing Guide](routing.md) for details.

### Data Layer
- **[Drift](https://drift.simonbinder.eu/)** - Type-safe SQLite ORM (offline-first)
- **[Firebase Firestore](https://firebase.google.com/docs/firestore)** - Cloud database (sync)
- **[cloud_firestore_odm](https://pub.dev/packages/cloud_firestore_odm)** - Type-safe Firestore
- **[Firebase Storage](https://firebase.google.com/docs/storage)** - Media files

See [Data Layer](data-layer.md) and [Offline Sync](offline-sync.md) guides.

### Code Generation
- **[build_runner](https://pub.dev/packages/build_runner)** - Code generation framework
- **[freezed](https://pub.dev/packages/freezed)** - Immutable models, unions, copyWith
- **[json_serializable](https://pub.dev/packages/json_serializable)** - JSON serialization
- **[flutter_gen](https://pub.dev/packages/flutter_gen)** - Asset code generation

See [Code Generation Guide](../development/code-generation.md).

### UI Components
- **[flutter_quill](https://pub.dev/packages/flutter_quill)** - Rich text editor
- **[toastification](https://pub.dev/packages/toastification)** - Toast notifications
- **[window_manager](https://pub.dev/packages/window_manager)** - Desktop window control
- **[desktop_multi_window](https://pub.dev/packages/desktop_multi_window)** - Multi-window support
- Custom widgets: `SurfaceContainer`, `CardList`, `LinkContextMenu`

### Authentication & Backend
- **[Firebase Auth](https://firebase.google.com/docs/auth)** - User authentication
- **[Firebase Remote Config](https://firebase.google.com/docs/remote-config)** - Feature flags

### Utilities
- **[logger](https://pub.dev/packages/logger)** - Logging (see `lib/core/utils/logger.dart`)
- **[uuid](https://pub.dev/packages/uuid)** - UUID generation
- **[shared_preferences](https://pub.dev/packages/shared_preferences)** - Simple persistence
- **[package_info_plus](https://pub.dev/packages/package_info_plus)** - App metadata
- **[url_launcher](https://pub.dev/packages/url_launcher)** - Open URLs

## Application Layers

### 1. Presentation Layer (`lib/features/`, `lib/layout/`)

**Views** - UI screens and pages
```dart
// Example: Campaign view
class CampaignView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaign = ref.watch(currentCampaignProvider);
    // UI code
  }
}
```

**Widgets** - Reusable UI components
- Feature-specific: `lib/features/[feature]/widgets/`
- Shared: `lib/core/widgets/`

### 2. Application Layer (`lib/core/providers/`, `lib/features/[feature]/controllers/`)

**Providers** - State and dependency injection
```dart
// Example: Campaign provider
final campaignProvider = StreamProvider<Campaign>((ref) {
  final repo = ref.watch(campaignRepositoryProvider);
  return repo.watchCurrentCampaign();
});
```

**Controllers** - Business logic and state coordination

### 3. Domain Layer (`lib/core/models/`)

**Models** - Business entities (immutable with Freezed)
```dart
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

### 4. Data Layer (`lib/data/`)

**Repositories** - Data access abstraction
```dart
class CampaignRepository {
  Stream<List<Campaign>> watchAll();
  Future<Campaign?> getById(String id);
  Future<void> upsert(Campaign campaign);
}
```

**DAOs** (Data Access Objects) - Drift database queries
**Sync Engine** - Bidirectional Firebase sync with conflict resolution

See [Data Layer Guide](data-layer.md) and [Offline Sync Guide](offline-sync.md).

## Feature Organization

Each feature follows a consistent structure:

```
lib/features/[feature]/
├── views/           # UI screens
├── widgets/         # Feature-specific widgets
├── controllers/     # State management (if needed)
├── models/          # Feature-specific models (if not in core)
├── services/        # Feature-specific services
└── utils/           # Feature-specific utilities
```

Example features:
- `campaign/` - Campaign management
- `entities/` - NPCs, monsters, places, items
- `encounters/` - Encounter builder and initiative tracker
- `session/` - Session planning and logs
- `auth/` - Authentication flows

## Rich Text Editing

Moonforge uses **flutter_quill** for rich text content with custom extensions:

- **@Mentions**: Tag entities, scenes, chapters in text (see `lib/core/widgets/quill_mention/`)
- **Custom embeds**: Media, entity cards
- **Portable format**: JSON Delta format for cross-platform compatibility

Content is stored as:
```dart
class Content {
  final String type; // "doc"
  final List<Map<String, dynamic>> nodes; // Delta ops
}
```

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| **Windows** | ✅ Full | Multi-window, drag-and-drop |
| **Linux** | ✅ Full | Multi-window, drag-and-drop |
| **Web** | ✅ Full | Tabs instead of windows |
| **macOS** | 🚧 Planned | Runner exists, needs testing |
| **Android** | ⚠️ Limited | Mobile UI, limited media |
| **iOS** | 🚧 Planned | Not yet tested |

Platform-specific code lives in:
- `windows/`, `linux/`, `web/`, `macos/`, `android/`, `ios/`
- Platform conditionals in Dart: `Platform.isWindows`, `kIsWeb`

See [Platform-Specific Guide](../development/platform-specific.md).

## Design Patterns

### Repository Pattern
- Abstract data access behind repositories
- Repositories use Drift as source of truth
- Background sync with Firebase

### Provider Pattern (Riverpod)
- Dependency injection
- State management
- Reactive data flows

### Offline-First Pattern
- Local database is source of truth
- Optimistic updates
- Background sync with conflict resolution (CAS)

### Feature Module Pattern
- Self-contained feature folders
- Minimal cross-feature dependencies
- Clear public APIs

## Code Generation Strategy

Generated files are **committed to the repository**:
- `*.g.dart` - JSON serialization, Firestore ODM
- `*.freezed.dart` - Freezed models
- `*.gr.dart` - go_router routes
- `lib/gen/` - Asset helpers

Why commit generated code?
- CI/CD builds faster (no generation step)
- Easier code review (see what changed)
- Reduces build complexity

See [Code Generation Guide](../development/code-generation.md).

## Security Considerations

- **Firebase API Key**: Stored in `.env` (gitignored), not hardcoded
- **Firestore Rules**: Enforce user permissions on backend
- **Local Storage**: SQLite database not encrypted (desktop platforms)
- **Deep Links**: Validate all parameters from deep links

## Performance

- **Lazy Loading**: Entities, media loaded on demand
- **Pagination**: Large lists use pagination
- **Image Caching**: Cached images in Drift for offline use
- **Debouncing**: Autosave debounced (2s default)
- **Indexing**: Drift indexes for fast queries

## Monitoring & Debugging

- **Logging**: `logger` package via `lib/core/utils/logger.dart`
- **Error Tracking**: Console logs (production error tracking TODO)
- **Performance**: Flutter DevTools
- **Network**: Firebase console, Firestore emulator for testing

## Next Steps

- **[Data Layer](data-layer.md)** - Understand data flow and Firebase
- **[Offline Sync](offline-sync.md)** - Deep dive into Drift sync
- **[Routing](routing.md)** - Navigation and deep linking
- **[State Management](state-management.md)** - Riverpod patterns

## External Resources

- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Riverpod Architecture](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/)
- [Drift Best Practices](https://drift.simonbinder.eu/docs/advanced-features/migrations/)
- [Firebase for Flutter](https://firebase.flutter.dev/)
