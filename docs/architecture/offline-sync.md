# Offline-First Sync with Drift

Deep dive into Moonforge's offline-first implementation using Drift (SQLite) with bidirectional Firebase sync.

## Overview

Moonforge uses Drift as the local source of truth with background bidirectional sync to Firebase Firestore.

## Architecture

```
┌─────────────────────────────────────┐
│         Application Layer           │
│    (Repositories, Providers)        │
└──────────────┬──────────────────────┘
               │
┌──────────────┴──────────────────────┐
│          Drift Database             │
│       (SQLite - Source of Truth)    │
│  ┌──────────────────────────────┐   │
│  │ App Tables (Campaigns, etc.) │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │   LocalMetas (Sync State)    │   │
│  └──────────────────────────────┘   │
│  ┌──────────────────────────────┐   │
│  │  OutboxOps (Pending Uploads) │   │
│  └──────────────────────────────┘   │
└──────────────┬──────────────────────┘
               │
┌──────────────┴──────────────────────┐
│          Sync Engine                │
│   (Background Bidirectional Sync)   │
└──────────────┬──────────────────────┘
               │
┌──────────────┴──────────────────────┐
│       Firebase Firestore            │
│      (Remote Cloud Database)        │
└─────────────────────────────────────┘
```

## Key Tables

### Application Tables

Model-specific tables (e.g., `Campaigns`):

```dart
class Campaigns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firebaseId => text().unique()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get rev => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}
```

### LocalMetas Table

Tracks sync state for all documents:

```dart
class LocalMetas extends Table {
  TextColumn get docRef => text()(); // "campaigns/doc-id"
  TextColumn get collection => text()();
  TextColumn get docId => text()();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  
  @override
  Set<Column> get primaryKey => {docRef};
}
```

### OutboxOps Table

Queue for pending uploads:

```dart
class OutboxOps extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get collection => text()();
  TextColumn get docId => text()();
  TextColumn get operation => text()(); // 'upsert' or 'delete'
  TextColumn get payload => text()(); // JSON
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
}
```

## Sync Flow

### Write Flow (Local → Firebase)

1. **User saves data** → Repository.upsert()
2. **DAO writes to Drift** → Campaign inserted/updated
3. **Mark dirty** → LocalMetas.dirty = true
4. **Queue outbox op** → OutboxOps.insert(operation, payload)
5. **Sync engine polls** → Picks up outbox operations
6. **Upload to Firebase** → Firestore.set() with CAS check
7. **Mark clean** → LocalMetas.dirty = false, OutboxOps.delete()

### Read Flow (Firebase → Local)

1. **Sync engine polls Firestore** → Query for changes since last sync
2. **Download changed docs** → Fetch updated/new documents
3. **DAO writes to Drift** → Update local database
4. **Update metadata** → LocalMetas.lastSyncedAt = now()
5. **UI auto-updates** → Streams emit new data

## Conflict Resolution

Uses **Compare-And-Set (CAS)** with `rev` field:

```dart
// Local write increments rev
campaign = campaign.copyWith(rev: campaign.rev + 1);

// Firebase rules enforce CAS
allow update: if request.resource.data.rev == resource.data.rev + 1;
```

If conflict detected:
1. Download latest from Firebase
2. Merge changes (or use last-writer-wins)
3. Retry upload with new rev

## Sync Engine

Located in `lib/data/sync/sync_engine.dart`.

### Responsibilities

- Poll outbox for pending operations
- Upload dirty records to Firebase
- Poll Firebase for remote changes
- Download and apply remote changes
- Handle conflicts and retries
- Track sync state

### Configuration

```dart
class SyncEngine {
  final Duration pollInterval; // Default: 5 seconds
  final int maxRetries; // Default: 3
  final Duration retryDelay; // Default: exponential backoff
}
```

## Data Access Objects (DAOs)

### Example: CampaignsDao

```dart
@DriftAccessor(tables: [Campaigns, LocalMetas])
class CampaignsDao extends DatabaseAccessor<AppDatabase> {
  CampaignsDao(AppDatabase db) : super(db);
  
  // Watch all campaigns (reactive stream)
  Stream<List<Campaign>> watchAll() {
    return select(campaigns).watch();
  }
  
  // Get by ID
  Future<Campaign?> getById(String id) {
    return (select(campaigns)..where((c) => c.firebaseId.equals(id)))
        .getSingleOrNull();
  }
  
  // Upsert (insert or update)
  Future<void> upsert(Campaign campaign) {
    return into(campaigns).insertOnConflictUpdate(campaign);
  }
  
  // Mark as synced (called by sync engine)
  Future<void> setClean(String id) {
    return (update(localMetas)..where((m) => m.docId.equals(id)))
        .write(LocalMetasCompanion(dirty: Value(false)));
  }
}
```

## Adding New Models to Sync

### 1. Define Table

```dart
class Entities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firebaseId => text().unique()();
  TextColumn get name => text()();
  IntColumn get rev => integer().withDefault(const Constant(1))();
  // ... other fields
}
```

### 2. Create DAO

```dart
@DriftAccessor(tables: [Entities, LocalMetas])
class EntitiesDao extends DatabaseAccessor<AppDatabase> {
  // ... standard DAO methods
}
```

### 3. Register in AppDatabase

```dart
@DriftDatabase(tables: [Campaigns, Entities, LocalMetas, OutboxOps])
class AppDatabase extends _$AppDatabase {
  // ... include new DAO
  late final EntitiesDao entitiesDao = EntitiesDao(this);
}
```

### 4. Create Repository

```dart
class EntityRepository {
  final EntitiesDao _dao;
  
  Stream<List<Entity>> watchAll() => _dao.watchAll();
  Future<void> upsert(Entity entity) => _dao.upsert(entity);
}
```

### 5. Update Sync Engine

Add handling for new collection in sync engine.

## Migrations

Schema changes require migrations:

```dart
@override
int get schemaVersion => 2;

@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) {
      return m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1) {
        // Add new column
        await m.addColumn(campaigns, campaigns.description);
      }
    },
  );
}
```

## Testing

Drift supports in-memory databases for testing:

```dart
final db = AppDatabase.testInMemory();
try {
  // Run tests
} finally {
  await db.close();
}
```

## Performance Considerations

- **Indexes**: Add for frequently queried columns
- **Batch operations**: Group writes in transactions
- **Lazy loading**: Don't load all data at once
- **Pagination**: Limit query results
- **Debouncing**: Don't sync on every keystroke

## Debugging

Enable Drift logging:

```dart
import 'package:drift/drift.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  // ... rest of main
}
```

Check sync state:

```dart
final dirtyDocs = await database.localMetas
    .select()
    .where((m) => m.dirty.equals(true))
    .get();
print('Dirty documents: ${dirtyDocs.length}');
```

## Related Documentation

- [Data Layer](data-layer.md) - Overview of data architecture
- [Firebase Schema](../reference/firebase-schema.md) - Firestore structure
- [Code Generation](../development/code-generation.md) - Generating Drift code

## External Resources

- [Drift Documentation](https://drift.simonbinder.eu/)
- [Drift Migrations](https://drift.simonbinder.eu/docs/advanced-features/migrations/)
- [SQLite Performance](https://www.sqlite.org/speed.html)
