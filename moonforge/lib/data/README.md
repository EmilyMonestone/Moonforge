# ⚠️ MIGRATION IN PROGRESS ⚠️

This directory is undergoing a complete rewrite. See **MIGRATION_PLAN.md** in the project root for details.

## New Structure (v2)

```
lib/data/
├── db/                 # NEW: Complete rewrite with Drift-first architecture
│   ├── app_db.dart         # Main database (multi-platform)
│   ├── tables.dart         # All table definitions
│   ├── converters.dart     # Type converters
│   ├── firestore_mappers.dart  # Firestore ↔ Drift conversion
│   ├── daos/           # Data Access Objects (10 DAOs)
│   ├── sync/           # Bidirectional sync engine
│   └── README.md       # Detailed documentation
├── repo_new/           # NEW: Repositories (8 files)
├── db_providers.dart   # NEW: Provider wiring
│
├── drift/              # OLD: To be removed after migration
├── firebase/           # OLD: To be removed after migration
├── repo/               # OLD: To be removed after migration
├── sync/               # OLD: To be removed after migration
└── drift_providers.dart  # OLD: To be removed after migration
```

## Migration Status

- [x] New database implementation complete
- [x] All repositories created
- [x] Provider wiring ready
- [ ] Code generation (run `flutter pub run build_runner build`)
- [ ] Update main.dart
- [ ] Remove old implementation
- [ ] Update UI code

## Quick Start (After Migration)

1. **Run code generation:**
   ```bash
   cd moonforge
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Update your main.dart:**
   ```dart
   import 'package:moonforge/data/db/app_db.dart';
   import 'package:moonforge/data/db_providers.dart';

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     await FirebaseFirestore.instance.setPersistenceEnabled(false);
     
     final db = await constructDb();
     
     runApp(
       MultiProvider(
         providers: [...dbProviders(db)],
         child: MyApp(),
       ),
     );
   }
   ```

3. **Use repositories in your code:**
   ```dart
   // Watch campaigns
   final repo = context.read<CampaignRepository>();
   StreamBuilder<List<Campaign>>(
     stream: repo.watchAll(),
     builder: (context, snapshot) {
       final campaigns = snapshot.data ?? [];
       // ...
     },
   );
   
   // Create campaign
   await repo.create(Campaign(
     id: uuid.v4(),
     name: 'My Campaign',
     // ...
   ));
   ```

## Architecture Highlights

**Local-First:**
- Drift (SQLite) is the single source of truth
- UI reads only from Drift streams
- Instant offline functionality

**Multi-Platform:**
- Native (Android/iOS/Desktop): NativeDatabase
- Web: WasmDatabase with IndexedDB

**Sync:**
- Outbound: Outbox pattern with periodic flush
- Inbound: Real-time Firestore listeners
- Conflict Resolution: Last-Write-Wins by `updatedAt`

**Type-Safe:**
- Drift code generation
- Type converters for complex types
- Quill Delta support

## Documentation

- **lib/data/db/README.md** - Detailed new implementation docs
- **MIGRATION_PLAN.md** - Step-by-step migration guide
- **Drift Docs** - https://drift.simonbinder.eu/

## Support

For migration issues, refer to MIGRATION_PLAN.md or check the troubleshooting section.

## Quick Start

1. **Generate code**:
   ```bash
   cd moonforge
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Set up web assets** (for web platform):
   - Copy `sqlite3.wasm` and `drift_worker.dart.js` to `/web` directory
   - See `../../../docs/drift_web_setup.md` for details

3. **Use in your app**:
   ```dart
   import 'package:moonforge/data/drift_providers.dart';
   
   MultiProvider(
     providers: [
       ...driftProviders(),
       // ... other providers
     ],
     child: MyApp(),
   )
   ```

## Key Features

- **Local-First**: Instant reads/writes from SQLite
- **Offline Support**: Full functionality without network
- **Automatic Sync**: Background sync with Firestore
- **Conflict Resolution**: CAS (Compare-And-Set) on revision field
- **Cross-Platform**: Mobile, desktop, and web (WASM)
- **Type-Safe**: Uses existing Freezed models via `@UseRowClass`

## Architecture

```
UI Widget
    ↓ context.watch<List<Campaign>>()
Repository
    ↓ upsertLocal() / patchLocal()
Drift SQLite (source of truth)
    ↓ transaction + enqueue
Outbox Queue
    ↓ background processing
Sync Engine (CAS conflict resolution)
    ↓ Firestore transaction
Firestore (remote sync)
```

## Documentation

- **Full Usage Guide**: `../../../DRIFT_USAGE.md`
- **Architecture & Design**: `../../../DRIFT_CHANGELOG.md`
- **Web Setup**: `../../../docs/drift_web_setup.md`

## Testing

```bash
flutter test test/data/drift/    # DAO and migration tests
flutter test test/data/repo/     # Repository tests
```

## Adding New Models

To add offline-first support for a new model (e.g., `Chapter`):

1. Create table in `drift/tables/chapter.dart`:
   ```dart
   @UseRowClass(Chapter)
   class Chapters extends Table { ... }
   ```

2. Create DAO in `drift/dao/chapters_dao.dart`

3. Register in `app_database.dart`:
   ```dart
   @DriftDatabase(
     tables: [Campaigns, Chapters, ...],
     daos: [CampaignsDao, ChaptersDao, ...],
   )
   ```

4. Create repository in `repo/chapter_repository.dart`

5. Wire up providers in `drift_providers.dart`

6. Bump `schemaVersion` and add migration if needed

## Generated Files

These files are generated by `build_runner` and should **not** be edited manually:

- `drift/app_database.g.dart`
- `drift/dao/campaigns_dao.g.dart`
- `drift/dao/outbox_dao.g.dart`

## Helper Script

Run `../../../scripts/drift_setup.sh` to automate code generation and web asset setup.
