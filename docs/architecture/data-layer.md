# Data Layer

Moonforge's data layer combines Firebase (cloud) with Drift (local SQLite) in an offline-first architecture.

## Architecture

```
UI Layer
    ↓
Repositories (Domain Logic)
    ↓
Drift DAOs (Local SQLite - Source of Truth)
    ↓ ↑
Sync Engine (Bidirectional Sync)
    ↓ ↑
Firebase (Firestore + Storage)
```

## Key Concepts

### Offline-First

- **Local database is source of truth**: All reads from Drift
- **Optimistic updates**: Write locally first, sync in background
- **Always available**: App works without network
- **Background sync**: Automatic bidirectional sync with Firebase

### Compare-And-Set (CAS)

Conflict resolution using monotonic `rev` field:

```dart
// Increment rev on every write
campaign = campaign.copyWith(rev: campaign.rev + 1);

// Firebase rules check rev before allowing write
allow update: if request.resource.data.rev == resource.data.rev + 1;
```

## Components

### Repositories (`lib/data/repo/`)

Business logic layer between UI and data:

```dart
class Campaign Repository {
  Stream<List<Campaign>> watchAll(); // Stream from Drift
  Future<Campaign?> getById(String id);
  Future<void> upsert(Campaign campaign); // Writes to Drift + queues sync
}
```

### Drift DAOs (`lib/data/drift/dao/`)

Database access objects for Drift queries:

```dart
class CampaignsDao {
  Stream<List<Campaign>> watchAll();
  Future<Campaign?> getById(String id);
  Future<void> upsert(Campaign campaign);
  Future<void> setClean(String id); // Mark as synced
}
```

### Sync Engine (`lib/data/sync/`)

Handles bidirectional sync between Drift and Firestore:

1. **Local → Firebase**: Uploads dirty records
2. **Firebase → Local**: Downloads remote changes
3. **Conflict Resolution**: Uses CAS with `rev` field

### Firebase

**Firestore**: Document database for structured data
- See [Firebase Schema](../reference/firebase-schema.md) for details

**Storage**: Blob storage for media files
- Campaign media, assets, images
- Background upload/download queues

## Data Flow

### Read Flow

```
UI requests data
    ↓
Repository.watchAll()
    ↓
Drift DAO query
    ↓
Stream<List<Model>> to UI
```

### Write Flow

```
UI saves data
    ↓
Repository.upsert()
    ↓
Drift DAO.upsert() + mark dirty
    ↓
Sync Engine picks up dirty record
    ↓
Upload to Firestore with CAS
    ↓
Mark clean in Drift
```

## Models

Models use Freezed for immutability:

```dart
@freezed
class Campaign with _$Campaign {
  const factory Campaign({
    required String id,
    required String name,
    String? description,
    @Default(1) int rev, // For CAS
  }) = _Campaign;
  
  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);
}
```

## Local Metadata

Separate table tracks sync state:

```dart
class LocalMetas extends Table {
  TextColumn get docRef => text()(); // "campaigns/doc-id"
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
}
```

## Firebase Configuration

### Firestore Rules

See `firebase/firestore.rules` for security rules.

Key pattern:
```
allow read, write: if request.auth.uid in resource.data.memberUids;
allow update: if request.resource.data.rev == resource.data.rev + 1;
```

### Storage Rules

See `firebase/storage.rules` for media file access.

## Offline Behavior

- **Reads**: Always succeed (from local database)
- **Writes**: Always succeed locally, sync when online
- **Conflicts**: CAS prevents lost updates, last-writer-wins on same rev
- **Network changes**: Sync engine pauses/resumes automatically

## Performance

- **Local reads**: <1ms (SQLite indexed queries)
- **Local writes**: <10ms (SQLite transaction)
- **Sync latency**: 100-500ms per operation
- **Batch sync**: Groups operations for efficiency

## Related Documentation

- [Offline Sync](offline-sync.md) - Deep dive into Drift sync
- [Firebase Schema](../reference/firebase-schema.md) - Database structure
- [Architecture Overview](overview.md) - System architecture

## External Resources

- [Drift Documentation](https://drift.simonbinder.eu/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
