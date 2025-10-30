# Data Layer - Local-First Architecture with Drift and Firestore

This directory contains the complete data layer implementation for Moonforge, built from scratch with a local-first architecture using Drift (SQLite) and Firestore sync.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                          UI Layer                                │
│                   (Widgets, Providers)                           │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Repository Layer                             │
│               (Business Logic, Validation)                       │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Drift Database (Local)                        │
│                   (Source of Truth, SQLite)                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Campaigns  │  │   Chapters   │  │   Entities   │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │    Outbox    │  │  Checkpoints │  │  Tombstones  │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                       Sync Worker                                │
│              (Push/Pull, Conflict Resolution)                    │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                   Firestore (Remote)                             │
│              (Remote Source of Truth, Cloud)                     │
└─────────────────────────────────────────────────────────────────┘
```

## Key Features

### 1. Local-First
- **Instant reads/writes**: All operations go through local SQLite first
- **Offline support**: Full functionality without network connection
- **Optimistic updates**: UI updates immediately from local DB

### 2. Reliable Sync
- **Outbox pattern**: Durable queue for pending remote operations
- **Exponential backoff**: Automatic retry with backoff on failures
- **Conflict resolution**: Last-Write-Wins (LWW) with server timestamps
- **Tombstones**: Prevent resurrection of deleted items

### 3. Real-Time Updates
- **Push sync**: Background worker pushes local changes to Firestore
- **Pull sync**: Incremental pulls with checkpoints/cursors
- **Firestore listeners**: Real-time updates from remote changes

### 4. Cross-Platform
- **Native (Mobile/Desktop)**: SQLite via drift_flutter
- **Web**: WebAssembly SQLite with IndexedDB persistence

## Directory Structure

```
lib/data/
├── db/                         # Drift database infrastructure
│   ├── connection/             # Platform-specific connections
│   │   ├── database_factory.dart
│   │   ├── connection_native.dart
│   │   └── connection_web.dart
│   ├── converters/             # Type converters for Drift
│   │   └── json_list_converter.dart
│   ├── daos/                   # Data Access Objects
│   │   ├── campaigns_dao.dart
│   │   ├── chapters_dao.dart
│   │   ├── entities_dao.dart
│   │   ├── outbox_dao.dart
│   │   ├── checkpoints_dao.dart
│   │   └── tombstones_dao.dart
│   ├── tables/                 # Table definitions
│   │   ├── campaigns.dart
│   │   ├── chapters.dart
│   │   ├── entities.dart
│   │   ├── outbox.dart
│   │   ├── checkpoints.dart
│   │   └── tombstones.dart
│   └── app_database.dart       # Main database class
├── models/                     # Domain models (Freezed)
│   ├── campaign.dart
│   ├── chapter.dart
│   └── entity.dart
├── repositories/               # Repository layer
│   └── campaign_repository.dart
├── sync/                       # Sync infrastructure
│   ├── sync_worker.dart
│   └── conflict_resolution.dart
├── firebase/                   # Firebase integration
│   ├── auth_service.dart
│   └── firestore_remote.dart
├── connectivity/               # Network monitoring
│   └── connectivity_service.dart
└── data_layer_factory.dart     # Factory for wiring up services
```

## Getting Started

### 1. Setup Dependencies

Add to `pubspec.yaml`:
```yaml
dependencies:
  drift: ^2.19.0
  drift_flutter: ^0.2.2
  sqlite3_flutter_libs: ^0.5.24
  connectivity_plus: ^6.1.2
  firebase_core: ^3.15.2
  firebase_auth: ^5.7.0
  cloud_firestore: ^5.0.0

dev_dependencies:
  drift_dev: ^2.19.0
  build_runner: ^2.5.4
```

### 2. Generate Drift Code

```bash
cd moonforge
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 3. Initialize in Your App

```dart
import 'package:moonforge/data/data_layer_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize data layer
  await DataLayerFactory.initialize();
  
  runApp(MyApp());
}
```

### 4. Use in Widgets

```dart
// Watch campaigns
Stream<List<Campaign>> campaigns = 
    DataLayerFactory.campaignRepository.watchAll();

// Create a campaign
await DataLayerFactory.campaignRepository.save(
  Campaign(
    id: 'campaign-1',
    name: 'My Campaign',
    description: 'An epic adventure',
  ),
);

// Update a campaign
await DataLayerFactory.campaignRepository.updateFields(
  'campaign-1',
  {'name': 'Updated Name'},
);

// Delete a campaign
await DataLayerFactory.campaignRepository.delete('campaign-1');
```

## How It Works

### Write Path (UI → Local → Remote)

1. **User action** triggers a write (create/update/delete)
2. **Repository** validates and processes the request
3. **Drift transaction**:
   - Apply change to local tables
   - Append entry to Outbox table
4. **UI updates** optimistically from Drift stream
5. **SyncWorker** (background):
   - Checks connectivity
   - Batches Outbox items
   - Sends to Firestore
   - Marks as acknowledged on success
   - Retries with backoff on failure

### Sync Loop (Pull & Push)

**On App Start:**
- Observe Firebase Auth state
- Load UI immediately from Drift (offline-first)
- Monitor network connectivity

**When Online:**
- **Push phase**: Process Outbox queue → Firestore
- **Pull phase**: 
  - Query Firestore since last checkpoint
  - Apply changes to Drift with conflict resolution
  - Update checkpoint cursor
  - UI updates via Drift streams

**When Offline:**
- Queue writes in Outbox
- Retry with exponential backoff
- UI continues working from local DB

### Conflict Resolution

**Last-Write-Wins (LWW):**
- Compare `updatedAt` timestamps
- If equal, compare `rev` (revision number)
- Winner is written to local DB
- Loser is discarded

**Tombstones:**
- Deleted items create tombstone entries
- Prevents resurrection during sync
- Tombstones expire after 30 days

## Platform-Specific Setup

### Native (Mobile/Desktop)
No additional setup required. Uses `drift_flutter` with native SQLite.

### Web
Copy WASM files to `web/` directory:
- `sqlite3.wasm`
- `drift_worker.dart.js`

See [Drift Web Setup Guide](https://drift.simonbinder.eu/platforms/web/)

## Testing

### Unit Tests

```dart
test('Campaign repository saves to local DB', () async {
  final db = AppDatabase(NativeDatabase.memory());
  final repo = CampaignRepository(db, mockAuth);
  
  await repo.save(testCampaign);
  
  final result = await repo.getById(testCampaign.id);
  expect(result, equals(testCampaign));
});
```

### Integration Tests

```dart
testWidgets('Sync worker pushes local changes', (tester) async {
  // Create local change
  await repo.save(campaign);
  
  // Wait for sync
  await tester.pumpAndSettle();
  
  // Verify pushed to Firestore
  final remoteDoc = await firestore.collection('campaigns')
      .doc(campaign.id).get();
  expect(remoteDoc.exists, isTrue);
});
```

## Adding New Domain Models

To add a new domain model (e.g., `Session`):

1. **Create model** in `models/session.dart`:
```dart
@freezed
class Session with _$Session {
  const factory Session({
    required String id,
    // ... other fields
  }) = _Session;
}
```

2. **Create table** in `db/tables/sessions.dart`:
```dart
class Sessions extends Table {
  TextColumn get id => text()();
  // ... other columns
}
```

3. **Create DAO** in `db/daos/sessions_dao.dart`:
```dart
@DriftAccessor(tables: [Sessions])
class SessionsDao extends DatabaseAccessor<AppDatabase> {
  // ... CRUD methods
}
```

4. **Register in AppDatabase**:
```dart
@DriftDatabase(
  tables: [Campaigns, Sessions, ...],
  daos: [CampaignsDao, SessionsDao, ...],
)
```

5. **Create repository** in `repositories/session_repository.dart`

6. **Run code generation**:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Troubleshooting

### Build Errors
- Run `flutter clean && flutter pub get`
- Regenerate: `dart run build_runner build --delete-conflicting-outputs`

### Sync Not Working
- Check Firebase Auth: `DataLayerFactory.authService.currentUser`
- Check connectivity: `DataLayerFactory.connectivityService.isOnline`
- Check outbox: `DataLayerFactory.database.outboxDao.getPending()`

### Web Database Issues
- Verify WASM files are in `web/` directory
- Check browser console for errors
- Ensure CORS is configured for Firebase

## Performance Tips

1. **Batch Operations**: Use transactions for multiple writes
2. **Indexed Queries**: Add indices to frequently queried columns
3. **Pagination**: Use `limit` in queries for large collections
4. **Cleanup**: Regularly clean up old Outbox and Tombstone entries

## Security

- **Firestore Rules**: Enforce ownership and ACLs server-side
- **Server Timestamps**: Use `FieldValue.serverTimestamp()` for authoritative time
- **Cloud Functions**: Optional validation/merge logic
- **Local Encryption**: Consider encrypting sensitive local data

## References

- [Drift Documentation](https://drift.simonbinder.eu/)
- [Drift Setup Guide](https://drift.simonbinder.eu/setup/)
- [Drift Web Support](https://drift.simonbinder.eu/platforms/web/)
- [Firebase Documentation](https://firebase.google.com/docs)

## License

MIT License - See LICENSE file for details
