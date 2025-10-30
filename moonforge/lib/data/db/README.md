# New Database Implementation

This directory contains the completely rewritten database layer using Drift (SQLite) as the local-first source of truth with bidirectional Firestore sync.

## Structure

```
lib/data/db/
├── app_db.dart              # Main database class with multi-platform support
├── tables.dart              # All table definitions
├── converters.dart          # Type converters for complex types
├── firestore_mappers.dart   # Bidirectional Firestore <-> Drift conversion
├── daos/                    # Data Access Objects
│   ├── campaign_dao.dart
│   ├── chapter_dao.dart
│   ├── adventure_dao.dart
│   ├── scene_dao.dart
│   ├── party_dao.dart
│   ├── encounter_dao.dart
│   ├── entity_dao.dart
│   ├── combatant_dao.dart
│   ├── media_asset_dao.dart
│   └── outbox_dao.dart
└── sync/                    # Sync engine
    ├── outbox_processor.dart    # Outbound: Drift → Firestore
    ├── inbound_listener.dart    # Inbound: Firestore → Drift
    └── sync_coordinator.dart    # Orchestrates bidirectional sync
```

## Architecture

**Local-first design:**
- Drift (SQLite) is the **single source of truth**
- UI reads **only** from Drift streams (never directly from Firestore)
- All writes go to Drift first, then enqueued for sync

**Multi-platform:**
- Uses `drift_flutter` package for automatic platform detection
- **Native** (Android, iOS, desktop): Stores in app documents directory via `driftDatabase()`
- **Web**: Uses WASM SQLite with IndexedDB persistence

**Sync:**
- **Outbound**: Outbox pattern with periodic flush (every 5 seconds)
- **Inbound**: Real-time Firestore listeners with LWW conflict resolution
- **Conflict Resolution**: Last-Write-Wins by `updatedAt` (server timestamp) + `rev` guard
- **Soft Delete**: `deleted=true` + `deletedAt` with Firestore TTL for auto-purge

## Code Generation

This implementation requires code generation via `build_runner`:

```bash
cd moonforge
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `app_db.g.dart` - Database implementation
- `*_dao.g.dart` - DAO mixins
- Table companions and query helpers

## Tables

All tables follow a consistent schema:

- **Primary Key**: `id` (TEXT, user-provided UUID)
- **Timestamps**: `createdAt`, `updatedAt` (DATETIME as ISO-8601 TEXT)
- **Revision**: `rev` (INTEGER, for CAS conflict resolution)
- **Content**: Quill Delta JSON stored as TEXT (via `MapJsonConverter`)
- **Lists/Maps**: JSON stored as TEXT (via converters)

### Main Tables

1. **Campaigns** - Top-level containers
2. **Chapters** - Campaign subdivisions (FK: campaignId)
3. **Adventures** - Chapter subdivisions (FK: chapterId)
4. **Scenes** - Adventure subdivisions (FK: adventureId)
5. **Parties** - Player groups (FK: campaignId)
6. **Encounters** - Combat/interaction scenarios
7. **Entities** - Characters, NPCs, places, items, etc.
8. **Combatants** - Encounter participants (FK: encounterId)
9. **MediaAssets** - Files and images
10. **OutboxEntries** - Sync queue

## Type Converters

Defined in `converters.dart`:

- **MapJsonConverter**: `Map<String,dynamic>` ↔ JSON TEXT
- **StringListConverter**: `List<String>` ↔ JSON TEXT
- **MapListConverter**: `List<Map<String,dynamic>>` ↔ JSON TEXT
- **quillConv**: Alias for MapJsonConverter (Quill Delta)

## Firestore Schema

Collections mirror tables with flat structure:

```
campaigns/{id}
  - name: string
  - description: string
  - content: map (Quill Delta)
  - ownerUid: string
  - memberUids: array<string>
  - entityIds: array<string>
  - createdAt: timestamp
  - updatedAt: timestamp (server)
  - rev: int

chapters/{id}
  - campaignId: string
  - name: string
  - order: int
  - ...

(Similar for all other collections)
```

**Soft Delete**: Add `deleted: true` + `deletedAt: timestamp` then use Firestore TTL to auto-purge.

## DAOs

Each DAO provides:
- `watchAll()` or `watchBy*()` - Reactive streams
- `getById(id)` - Single item fetch
- `upsert(companion)` - Insert or update
- `deleteById(id)` - Remove

Example:
```dart
final campaigns = await db.campaignDao.watchAll();
```

## Repositories

Repositories wrap DAOs and handle:
1. Transactional writes
2. Outbox queueing
3. Business logic

Example:
```dart
final repo = CampaignRepository(db);
await repo.create(campaign); // Writes to Drift + queues for Firestore
```

## Sync Coordinator

Start sync on app init:
```dart
final coordinator = SyncCoordinator(db, firestore);
coordinator.start(); // Starts listeners + periodic outbox flush
```

Stop on app dispose:
```dart
coordinator.stop();
```

Manual sync trigger:
```dart
await coordinator.triggerSync();
```

## Migration from Old Implementation

To complete the migration:

1. ✅ Remove `firestore_odm` and `firestore_odm_builder` from pubspec.yaml
2. ✅ Update `build.yaml` with Drift options
3. ✅ Create new database structure in `lib/data/db/`
4. ⏳ Run `build_runner` to generate code
5. ⏳ Update providers to use new database
6. ⏳ Replace all repository usages
7. ⏳ Remove old `lib/data/drift/`, `lib/data/firebase/`, `lib/data/sync/`
8. ⏳ Update UI to use new streams
9. ⏳ Test thoroughly

## Testing

Create test database:
```dart
final db = AppDb(NativeDatabase.memory());
```

## Performance Notes

- **Native**: Background isolate prevents UI jank
- **Web**: Worker-based queries for non-blocking operation
- **Indexing**: Add indices to `onUpgrade` migrations as needed
- **Pagination**: Use `limit()` + `offset()` in DAOs for large lists

## Security

- Firestore rules: Check `ownerUid` or `memberUids` array membership
- No sensitive data in SQLite (it's local-only, but still practice good hygiene)
- Use Firebase Authentication for user identity

## Known Limitations

1. **Combatants** are embedded in Encounter JSON (not a separate Firestore collection)
2. **TTL** requires manual Firestore configuration (not in SDK)
3. **Cloud Storage** integration requires separate `StorageSyncService` (TBD)
4. **Cascade deletes** must be handled manually in repositories

## References

- [Drift Documentation](https://drift.simonbinder.eu/)
- [Drift Web Support](https://drift.simonbinder.eu/Platforms/web/)
- [Firestore TTL](https://firebase.google.com/docs/firestore/ttl)
- [Firestore Offline](https://firebase.google.com/docs/firestore/manage-data/enable-offline)
