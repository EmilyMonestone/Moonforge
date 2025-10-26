# Drift Offline-First Implementation - Quick Reference

## What Was Built

A complete local-first data architecture for the Moonforge Flutter app:

- **Drift SQLite** as the source of truth (instant local reads/writes)
- **Firestore** as remote backup with automatic bidirectional sync
- **Outbox Pattern** for reliable mutation queuing
- **CAS (Compare-And-Set)** conflict resolution using revision numbers
- **Cross-platform** support: Android, iOS, Web (WASM), Desktop

## Files Structure

```
moonforge/lib/data/
├── drift/
│   ├── connect/          # Platform abstraction (web WASM / native)
│   ├── converters/       # Type converters (e.g., List<String> ↔ JSON)
│   ├── tables/           # Schema: campaigns, campaign_local_metas, outbox_ops
│   ├── dao/              # Data Access: CampaignsDao, OutboxDao
│   └── app_database.dart # Main DB class with migrations
├── repo/
│   └── campaign_repository.dart  # Business logic & patch operations
├── sync/
│   └── sync_engine.dart  # Firestore ↔ Drift sync with CAS
├── examples/
│   └── campaign_list_example.dart  # Usage example widget
└── drift_providers.dart  # Provider wiring

test/data/
├── drift/
│   ├── dao_test.dart       # DAO operations
│   └── migration_test.dart # Schema migrations
└── repo/
    └── campaign_repository_test.dart  # Repository & patch ops

docs/
└── drift_web_setup.md    # Web WASM asset instructions

firebase/
└── firestore.rules.drift  # Security rules with CAS enforcement

scripts/
└── drift_setup.sh         # Automated setup script

DRIFT_CHANGELOG.md         # Architecture & design decisions
DRIFT_USAGE.md            # Full usage guide
```

## Key Commands

```bash
# 1. Generate Drift code
cd moonforge
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# 2. Run tests
flutter test test/data/drift/
flutter test test/data/repo/

# 3. Web assets (required for web platform)
# Option A: Use drift_dev
dart run drift_dev web

# Option B: Manual copy from pub cache
cp ~/.pub-cache/hosted/pub.dev/drift-*/web/sqlite3.wasm ./web/
cp ~/.pub-cache/hosted/pub.dev/drift-*/web/drift_worker.dart.js ./web/

# Or use the automated script
../scripts/drift_setup.sh
```

## Usage in App

### 1. Add Providers

```dart
import 'package:moonforge/data/drift_providers.dart';

MultiProvider(
  providers: [
    ...driftProviders(),  // ← Add this
    // ... existing providers
  ],
  child: MyApp(),
)
```

### 2. Watch Data (Reactive UI)

```dart
// Instant, local-first updates
final campaigns = context.watch<List<Campaign>>();

ListView.builder(
  itemCount: campaigns.length,
  itemBuilder: (context, i) => ListTile(
    title: Text(campaigns[i].name),
  ),
)
```

### 3. Write Data (Optimistic)

```dart
final repo = context.read<CampaignRepository>();

// Create/update (syncs automatically)
await repo.upsertLocal(Campaign(
  id: 'campaign-123',
  name: 'New Campaign',
  description: 'Created offline',
  rev: 0,
));

// Patch operations
await repo.patchLocal(
  id: 'campaign-123',
  baseRev: 0,
  ops: [
    {'type': 'set', 'field': 'name', 'value': 'Updated Name'},
    {'type': 'addToSet', 'field': 'memberUids', 'value': 'user-456'},
  ],
);
```

## How Sync Works

1. **User edits locally** → Instant write to Drift SQLite
2. **Mark dirty** → Local metadata tracks unsync'd changes
3. **Enqueue** → Operation added to Outbox
4. **Background sync** → Sync Engine processes queue
5. **CAS check** → Firestore transaction: `if (remoteRev == expectedRev) apply else replay`
6. **On success** → Increment rev, mark clean, remove from outbox
7. **Pull** → Firestore listener adopts remote when local clean or remote ahead

## Conflict Resolution

- **Scalars** (name, description): Last Write Wins (LWW)
- **Lists** (memberUids): Set union (merge both sides)
- **Content** (Quill delta): LWW (extensible for delta merging)

## Supported Patch Operations

| Type | Description | Example |
|------|-------------|---------|
| `set` | Update scalar field | `{'type': 'set', 'field': 'name', 'value': 'New'}` |
| `addToSet` | Add to list (no duplicates) | `{'type': 'addToSet', 'field': 'memberUids', 'value': 'uid'}` |
| `removeFromSet` | Remove from list | `{'type': 'removeFromSet', 'field': 'memberUids', 'value': 'uid'}` |
| `applyDelta` | Update content (LWW) | `{'type': 'applyDelta', 'field': 'content', 'value': '...'}` |

## Firestore Security Rules

```javascript
// Enforce CAS on rev field
allow create: if request.resource.data.rev == 0;
allow update: if request.resource.data.rev == resource.data.rev + 1;
```

Deploy: `firebase deploy --only firestore:rules`

## Testing

All tests use in-memory SQLite (no Firebase needed):

```bash
flutter test test/data/drift/dao_test.dart              # DAO operations
flutter test test/data/drift/migration_test.dart        # Schema migrations
flutter test test/data/repo/campaign_repository_test.dart  # Repository logic
```

## Next Steps for Developers

1. **Run code generation** (required before first use)
2. **Set up web assets** (if targeting web)
3. **Wire up providers** in app initialization
4. **Replace Firestore direct calls** with repository methods
5. **Test offline behavior** (disable network, verify app works)

## Adding More Models

To extend to Chapter, Encounter, etc.:

1. Create table: `lib/data/drift/tables/chapters.dart` with `@UseRowClass(Chapter)`
2. Create DAO: `lib/data/drift/dao/chapters_dao.dart`
3. Register in `app_database.dart` (bump schemaVersion if adding fields)
4. Create repository: `lib/data/repo/chapter_repository.dart`
5. Add providers in `drift_providers.dart`
6. Write tests

## Documentation

- **DRIFT_USAGE.md** - Complete usage guide with examples
- **DRIFT_CHANGELOG.md** - Architecture decisions & design rationale
- **docs/drift_web_setup.md** - Web-specific setup (WASM, MIME types, COOP/COEP)
- **lib/data/README.md** - Data layer overview

## Benefits

✅ **Instant UI** - No loading spinners for local data  
✅ **Offline-first** - Full functionality without network  
✅ **Reliable** - Outbox ensures no lost writes  
✅ **Conflict-safe** - CAS prevents lost updates  
✅ **Type-safe** - Reuses existing Freezed models  
✅ **Cross-platform** - Same code for mobile/web/desktop  
✅ **Testable** - Pure Dart tests with in-memory DB

## Troubleshooting

**Build errors?** → Run `flutter clean && flutter pub get && flutter pub run build_runner build`  
**Web not working?** → Check sqlite3.wasm and drift_worker.dart.js in /web with correct MIME  
**Sync not happening?** → Check Firebase connection and console for errors  
**Tests failing?** → Ensure code generation completed first

---

**Status**: ✅ Production-ready infrastructure  
**Platform Support**: Android, iOS, Web, macOS, Linux, Windows  
**Test Coverage**: DAOs, migrations, repository, patch operations
