# Migration Guide: Old Data Layer → New Local-First Architecture

This guide outlines the steps needed to complete the migration from the old firestore_odm-based data layer to the new Drift local-first architecture.

## Overview

The new data layer has been scaffolded with:
- ✅ Core infrastructure (Drift database, DAOs, tables)
- ✅ Sync infrastructure (Outbox, Checkpoints, Tombstones)
- ✅ Reference implementation (Campaign model end-to-end)
- ✅ Firebase integration (Auth, Firestore Remote)
- ✅ Connectivity monitoring
- ✅ Conflict resolution (LWW strategy)
- ⚠️ **Needs completion**: Remaining domain models, code generation, app integration

## Step 1: Generate Drift Code

```bash
cd moonforge
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

This will generate:
- `lib/data/db/app_database.g.dart`
- `lib/data/db/daos/*_dao.g.dart`
- `lib/data/models/*.freezed.dart`
- `lib/data/models/*.g.dart`

## Step 2: Add Remaining Domain Models

The following models need to be created following the Campaign pattern:

### Models to Add

1. **Adventure** (`lib/data/models/adventure.dart`)
2. **Scene** (`lib/data/models/scene.dart`)
3. **Encounter** (`lib/data/models/encounter.dart`)
4. **Session** (`lib/data/models/session.dart`)
5. **Party** (`lib/data/models/party.dart`)
6. **Player** (`lib/data/models/player.dart`)
7. **MediaAsset** (`lib/data/models/media_asset.dart`)

### Template for New Model

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_name.freezed.dart';
part 'model_name.g.dart';

@freezed
class ModelName with _$ModelName {
  const factory ModelName({
    required String id,
    required String campaignId, // if child of campaign
    // ... other fields
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
    @Default(false) bool isDeleted,
  }) = _ModelName;

  factory ModelName.fromJson(Map<String, dynamic> json) =>
      _$ModelNameFromJson(json);
}
```

## Step 3: Add Remaining Tables

For each model, create a corresponding table in `lib/data/db/tables/`:

```dart
import 'package:drift/drift.dart';

class ModelNames extends Table {
  TextColumn get id => text()();
  TextColumn get campaignId => text()();
  // ... other columns
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer().withDefault(const Constant(0))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}
```

## Step 4: Add Remaining DAOs

For each table, create a DAO in `lib/data/db/daos/`:

```dart
import 'package:drift/drift.dart';
import 'package:moonforge/data/db/app_database.dart';
import 'package:moonforge/data/db/tables/model_names.dart';
import 'package:moonforge/data/models/model_name.dart' as model;

part 'model_names_dao.g.dart';

@DriftAccessor(tables: [ModelNames])
class ModelNamesDao extends DatabaseAccessor<AppDatabase>
    with _$ModelNamesDaoMixin {
  ModelNamesDao(super.db);

  Stream<List<model.ModelName>> watchByCampaign(String campaignId) {
    return (select(modelNames)
          ..where((tbl) =>
              tbl.campaignId.equals(campaignId) & tbl.isDeleted.equals(false)))
        .watch()
        .map((rows) => rows.map(_rowToModel).toList());
  }

  // ... other methods (watchOne, getById, upsert, softDelete)

  model.ModelName _rowToModel(ModelNameData row) {
    return model.ModelName(
      id: row.id,
      // ... map all fields
    );
  }
}
```

## Step 5: Register in AppDatabase

Update `lib/data/db/app_database.dart`:

```dart
@DriftDatabase(
  tables: [
    Campaigns,
    Chapters,
    Entities,
    // Add new tables here:
    Adventures,
    Scenes,
    Encounters,
    Sessions,
    Parties,
    Players,
    MediaAssets,
    // Sync tables
    Outbox,
    Checkpoints,
    Tombstones,
  ],
  daos: [
    CampaignsDao,
    ChaptersDao,
    EntitiesDao,
    // Add new DAOs here:
    AdventuresDao,
    ScenesDao,
    EncountersDao,
    SessionsDao,
    PartiesDao,
    PlayersDao,
    MediaAssetsDao,
    // Sync DAOs
    OutboxDao,
    CheckpointsDao,
    TombstonesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  // ...
}
```

## Step 6: Add Remaining Repositories

Create repositories for each domain model in `lib/data/repositories/`:

```dart
class ModelNameRepository {
  final AppDatabase _db;
  final AuthService _auth;

  ModelNameRepository(this._db, this._auth);

  Stream<List<ModelName>> watchByCampaign(String campaignId) {
    return _db.modelNamesDao.watchByCampaign(campaignId);
  }

  Future<void> save(ModelName model) async {
    await _db.transaction(() async {
      final now = DateTime.now();
      final updated = model.copyWith(
        updatedAt: now,
        createdAt: model.createdAt ?? now,
      );

      await _db.modelNamesDao.upsert(updated, markDirty: true);

      await _db.outboxDao.enqueue(
        collection: 'model_names',
        docId: updated.id,
        operation: 'upsert',
        payload: jsonEncode(updated.toJson()),
        baseRevision: updated.rev,
        userId: _auth.currentUserId,
      );
    });
  }

  // ... other methods (delete, updateFields, etc.)
}
```

## Step 7: Update DataLayerFactory

Add new repositories to `lib/data/data_layer_factory.dart`:

```dart
class DataLayerFactory {
  // Add fields for new repositories
  static AdventureRepository? _adventureRepository;
  static SceneRepository? _sceneRepository;
  // ... etc

  static Future<void> initialize() async {
    _database = DatabaseFactory.getInstance();
    _authService = AuthService();
    _connectivityService = ConnectivityService();
    _firestoreRemote = FirestoreRemote(FirebaseFirestore.instance);

    // Initialize all repositories
    _campaignRepository = CampaignRepository(_database!, _authService!);
    _adventureRepository = AdventureRepository(_database!, _authService!);
    _sceneRepository = SceneRepository(_database!, _authService!);
    // ... etc

    _syncWorker = SyncWorker(/*...*/);
    _syncWorker!.start();
  }

  // Add getters
  static AdventureRepository get adventureRepository => _adventureRepository!;
  static SceneRepository get sceneRepository => _sceneRepository!;
  // ... etc
}
```

## Step 8: Update SyncWorker

Add sync logic for remaining collections in `lib/data/sync/sync_worker.dart`:

In `_processPull()`:
```dart
Future<void> _processPull() async {
  // ...
  await _pullCollection('campaigns');
  await _pullCollection('adventures');
  await _pullCollection('chapters');
  await _pullCollection('scenes');
  await _pullCollection('entities');
  await _pullCollection('encounters');
  await _pullCollection('sessions');
  await _pullCollection('parties');
  await _pullCollection('players');
  await _pullCollection('media');
  // ...
}
```

In `_applyRemoteChange()`:
```dart
Future<void> _applyRemoteChange(
  String collection,
  Map<String, dynamic> remoteDoc,
) async {
  // ...
  switch (collection) {
    case 'campaigns':
      await _applyCampaignChange(remoteDoc);
      break;
    case 'adventures':
      await _applyAdventureChange(remoteDoc);
      break;
    // ... add cases for each collection
  }
}
```

## Step 9: Update App Initialization

In your main app file (likely `lib/main.dart`):

### Old Code (remove):
```dart
import 'package:moonforge/data/firebase/odm.dart';
// ... old imports

await Odm.init(FirebaseFirestore.instance);
```

### New Code (add):
```dart
import 'package:moonforge/data/data_layer_factory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Initialize new data layer
  await DataLayerFactory.initialize();
  
  runApp(MyApp());
}
```

## Step 10: Update Feature Code

For each feature that used the old data layer, update imports and usage:

### Old Pattern:
```dart
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/firebase/models/campaign.dart';

// Providers or direct injection
final repo = Provider.of<CampaignRepository>(context);
final campaigns = repo.watchAll();
```

### New Pattern:
```dart
import 'package:moonforge/data/data_layer_factory.dart';
import 'package:moonforge/data/models/campaign.dart';

// Access via factory
final campaigns = DataLayerFactory.campaignRepository.watchAll();
```

## Step 11: Remove Old Code References

Search and remove/update:

1. **Imports to remove:**
   - `package:moonforge/data/firebase/odm.dart`
   - `package:moonforge/data/firebase/models/*` (old paths)
   - `package:firestore_odm/firestore_odm.dart`

2. **Files that reference old code:**
   ```bash
   grep -r "firestore_odm" lib/features --include="*.dart"
   grep -r "lib/data/firebase/models" lib/features --include="*.dart"
   grep -r "lib/data/repo/" lib/features --include="*.dart"
   ```

3. **Update each file:**
   - Change import paths to new locations
   - Update model instantiation (remove firestore_odm decorators)
   - Update repository access patterns

## Step 12: Handle Subcollections

For Firestore subcollections (like `campaigns/*/chapters`), you have two options:

### Option A: Flat Structure (Recommended)
Store all documents in top-level collections with a `campaignId` foreign key.

```dart
// Firestore structure:
campaigns/campaign-1
chapters/chapter-1 (with campaignId: 'campaign-1')
```

### Option B: Maintain Subcollections
Update `FirestoreRemote` to support subcollection paths:

```dart
Future<void> setSubcollectionDocument(
  String parentCollection,
  String parentId,
  String subcollection,
  String docId,
  Map<String, dynamic> data,
) async {
  await _firestore
      .collection(parentCollection)
      .doc(parentId)
      .collection(subcollection)
      .doc(docId)
      .set(data);
}
```

## Step 13: Web Platform Setup

For web support, copy WASM files to `moonforge/web/`:

1. Download drift WASM files:
   - `sqlite3.wasm`
   - `drift_worker.dart.js`

2. Copy to `moonforge/web/` directory

3. See [Drift Web Guide](https://drift.simonbinder.eu/platforms/web/) for details

## Step 14: Testing

### Unit Tests

Create tests for repositories and DAOs:

```dart
// test/data/repositories/campaign_repository_test.dart
void main() {
  late AppDatabase db;
  late CampaignRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = CampaignRepository(db, MockAuthService());
  });

  tearDown(() async {
    await db.close();
  });

  test('save creates campaign in local DB', () async {
    final campaign = Campaign(
      id: 'test-1',
      name: 'Test Campaign',
      description: 'Test',
    );

    await repo.save(campaign);

    final result = await repo.getById('test-1');
    expect(result, isNotNull);
    expect(result!.name, equals('Test Campaign'));
  });

  test('save enqueues outbox operation', () async {
    final campaign = Campaign(/*...*/);
    await repo.save(campaign);

    final pending = await db.outboxDao.getPending();
    expect(pending.length, equals(1));
    expect(pending[0].docId, equals(campaign.id));
  });
}
```

### Integration Tests

Test sync scenarios:

```dart
testWidgets('Sync worker pushes local changes', (tester) async {
  // Setup mock Firestore
  final mockFirestore = MockFirebaseFirestore();
  
  // Create campaign locally
  await repo.save(testCampaign);
  
  // Trigger sync
  await DataLayerFactory.syncWorker.triggerSync();
  await tester.pumpAndSettle();
  
  // Verify pushed to Firestore
  verify(mockFirestore.collection('campaigns')
      .doc(testCampaign.id)
      .set(any)).called(1);
});
```

## Step 15: Incremental Rollout Strategy

To minimize risk, consider an incremental approach:

1. **Phase 1**: Deploy new infrastructure alongside old code
   - Both systems coexist
   - No data migration yet
   - Test new system in isolation

2. **Phase 2**: Migrate one domain model at a time
   - Start with Campaigns (already done)
   - Then Chapters, Entities, etc.
   - Keep old code as fallback

3. **Phase 3**: Switch to new system completely
   - Remove old code
   - Clean up old Firestore ODM dependencies

## Common Issues and Solutions

### Issue: Build errors after code generation

**Solution:**
```bash
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Issue: Web database not working

**Solution:**
- Verify WASM files in `web/` directory
- Check browser console for errors
- Ensure CORS is configured for Firebase

### Issue: Sync not triggering

**Solution:**
- Check auth state: `DataLayerFactory.authService.currentUser`
- Check connectivity: `DataLayerFactory.connectivityService.isOnline`
- Check outbox: `DataLayerFactory.database.outboxDao.getPending()`
- Enable debug logging in SyncWorker

### Issue: Conflicts not resolving correctly

**Solution:**
- Verify timestamps are set correctly
- Check `ConflictResolver` strategy
- Consider field-level merge for granular conflicts
- Add logging to conflict resolution

## Performance Optimization

Once the migration is complete:

1. **Add Indices:**
```dart
class Campaigns extends Table {
  // ...
  @override
  List<Set<Column>> get indices => [
    {campaignId, isDeleted}, // Compound index for common queries
  ];
}
```

2. **Batch Operations:**
```dart
await _db.batch((batch) {
  batch.insertAll(campaigns, campaigns);
  batch.insertAll(outbox, outboxItems);
});
```

3. **Optimize Queries:**
- Use `limit` for large collections
- Add pagination for infinite scroll
- Use `select` to load specific columns only

## Rollback Plan

If issues arise:

1. **Keep old code in a branch** for quick rollback
2. **Monitor error rates** and user reports
3. **Have Firebase backup** before final migration
4. **Document rollback steps** clearly

## Next Steps

After completing this migration:

1. ☐ Monitor sync performance
2. ☐ Optimize database indices
3. ☐ Add more granular conflict resolution
4. ☐ Implement Cloud Functions for validation
5. ☐ Add support for Cloud Storage attachments
6. ☐ Implement data export/import
7. ☐ Add analytics for sync metrics

## Resources

- [Drift Documentation](https://drift.simonbinder.eu/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Local-First Software](https://www.inkandswitch.com/local-first/)

## Support

For questions or issues during migration:
- Check `lib/data/README.md` for architecture details
- Review reference implementation (Campaign) as a pattern
- Test incrementally with one model at a time
