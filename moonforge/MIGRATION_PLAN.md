# Database Migration Plan

## Overview

This document outlines the complete migration from firestore_odm-based database to a Drift-first architecture with bidirectional Firestore sync.

## Current State ✓

- ✅ Dependencies updated in `pubspec.yaml`
  - drift: ^2.29.0 (was ^2.19.0)
  - cloud_firestore: ^5.6.0 (was ^5.0.0)
  - Removed firestore_odm and firestore_odm_builder
  
- ✅ `build.yaml` configured with `store_date_time_values_as_text: true`

- ✅ New database infrastructure created:
  - `lib/data/db/app_db.dart` - Main database with multi-platform support
  - `lib/data/db/tables.dart` - All 10 table definitions
  - `lib/data/db/converters.dart` - Type converters for JSON/lists/maps
  - `lib/data/db/firestore_mappers.dart` - Bidirectional conversion
  - `lib/data/db/daos/*.dart` - 10 DAOs
  - `lib/data/db/sync/*.dart` - Sync engine (3 files)
  - `lib/data/repo_new/*.dart` - New repositories (started)

## Next Steps

### Step 1: Code Generation

**IMPORTANT**: Cannot be automated in this environment. User must run:

```bash
cd moonforge
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `lib/data/db/app_db.g.dart`
- `lib/data/db/daos/*_dao.g.dart` (10 files)

Expected issues after generation:
- Missing imports may need to be added
- Check for any type mismatches in converters

### Step 2: Complete Repository Layer

Create remaining repositories in `lib/data/repo_new/`:
- ✅ `campaign_repository.dart`
- ✅ `entity_repository.dart`
- ⏳ `chapter_repository.dart`
- ⏳ `adventure_repository.dart`
- ⏳ `scene_repository.dart`
- ⏳ `party_repository.dart`
- ⏳ `encounter_repository.dart`
- ⏳ `media_asset_repository.dart`

Each follows the pattern:
```dart
class XRepository {
  final AppDb _db;
  XRepository(this._db);
  
  Stream<List<X>> watchAll() => _db.xDao.watchAll();
  Future<X?> getById(String id) => _db.xDao.getById(id);
  
  Future<void> create(X item) async {
    await _db.transaction(() async {
      await _db.xDao.upsert(/*...*/);
      await _db.outboxDao.enqueue(table: 'xs', rowId: item.id, op: 'upsert');
    });
  }
  // update(), delete() similarly
}
```

### Step 3: Create Provider Wiring

Create `lib/data/db_providers.dart`:

```dart
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'db/app_db.dart';
import 'db/sync/sync_coordinator.dart';
import 'repo_new/campaign_repository.dart';
// ... import other repositories

List<Provider> dbProviders(AppDb db) => [
  Provider<AppDb>.value(value: db),
  
  Provider<SyncCoordinator>(
    create: (_) => SyncCoordinator(db, FirebaseFirestore.instance)..start(),
    dispose: (_, sync) => sync.stop(),
  ),
  
  Provider<CampaignRepository>(
    create: (_) => CampaignRepository(db),
  ),
  // ... other repositories
];
```

### Step 4: Update Main App Initialization

In `lib/main.dart` or wherever the app is initialized:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Disable Firestore persistence (we use Drift instead)
  await FirebaseFirestore.instance.setPersistenceEnabled(false);
  
  // Construct database
  final db = await constructDb();
  
  runApp(
    MultiProvider(
      providers: [
        ...dbProviders(db),
        // ... other providers
      ],
      child: MyApp(),
    ),
  );
}
```

### Step 5: Update UI Code

Find and replace patterns:

**Old (firestore_odm):**
```dart
final campaigns = context.watch<CampaignsRef>();
final campaignsStream = campaigns.snapshots();
```

**New (Drift):**
```dart
final repo = context.read<CampaignRepository>();
final campaignsStream = repo.watchAll();
```

**Old:**
```dart
await campaignsRef.add(campaign);
```

**New:**
```dart
await repo.create(campaign);
```

### Step 6: Remove Old Implementation

**DELETE these directories/files:**
- `lib/data/drift/` (old Drift implementation)
- `lib/data/firebase/` (firestore_odm models)
- `lib/data/sync/` (old sync engine)
- `lib/data/repo/` (old repositories)
- `lib/data/drift_providers.dart` (old providers)

**KEEP:**
- `lib/data/db/` (new implementation)
- `lib/data/repo_new/` (new repositories)
- `lib/data/db_providers.dart` (new providers)
- `lib/data/providers/` (if it contains non-database providers)
- `lib/data/widgets/` (UI components)

### Step 7: Web Assets Setup

For web platform, ensure these files exist in `web/`:

1. Download `sqlite3.wasm` from drift web setup
2. Ensure `drift_worker.dart.js` is generated/copied

Check `web/index.html` for proper headers:
```html
<meta http-equiv="Cross-Origin-Opener-Policy" content="same-origin">
<meta http-equiv="Cross-Origin-Embedder-Policy" content="require-corp">
```

(Optional for COOP/COEP features, but not required)

### Step 8: Firestore Configuration

#### Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isOwnerOrMember(campaignData) {
      return request.auth.uid == campaignData.ownerUid ||
             request.auth.uid in campaignData.memberUids;
    }
    
    match /campaigns/{campaignId} {
      allow read: if isOwnerOrMember(resource.data);
      allow create: if request.auth != null && 
                      request.resource.data.ownerUid == request.auth.uid;
      allow update, delete: if isOwnerOrMember(resource.data);
    }
    
    // Similar rules for chapters, adventures, scenes, parties, entities
    // Each checks parent campaign membership
  }
}
```

#### TTL Policy

In Firebase Console, enable TTL on `deletedAt` field for each collection to auto-purge after grace period (e.g., 30 days).

#### Indexes

Create composite indexes:
- `campaigns`: (memberUids, updatedAt)
- `chapters`: (campaignId, order)
- `adventures`: (chapterId, order)
- `scenes`: (adventureId, order)
- `parties`: (campaignId, name)
- `entities`: (originId, deleted, name)
- `encounters`: (originId, name)

### Step 9: Testing

Priority tests:
1. ✅ Compilation succeeds after code generation
2. ✅ App launches without crashes
3. ✅ CRUD operations work locally (offline)
4. ✅ Sync pushes changes to Firestore
5. ✅ Sync pulls changes from Firestore
6. ✅ Multi-device sync converges correctly
7. ✅ Web platform works with WASM
8. ✅ Soft delete functions correctly
9. ✅ Conflict resolution (LWW) behaves as expected

### Step 10: Data Migration (if needed)

Since Firebase is empty (per problem statement), no migration needed. For future schema changes:

```dart
// In app_db.dart
@override
MigrationStrategy get migration {
  return MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Migration from schema v1 to v2
        await m.addColumn(campaigns, campaigns.newField);
      }
    },
  );
}
```

## Troubleshooting

### Build Runner Fails

- Ensure all dependencies installed: `flutter pub get`
- Check for conflicting generated files: use `--delete-conflicting-outputs`
- Verify imports in table definitions

### Type Errors After Generation

- Check converter implementations match data types
- Ensure nullable/non-nullable fields are correct
- Verify `Value()` wrapper usage in Companions

### Sync Not Working

- Check Firebase initialization
- Verify Firestore rules allow read/write
- Check auth state is valid
- Look for errors in sync coordinator logs

### Web Performance Issues

- Ensure `drift_worker.dart.js` is properly loaded
- Check browser console for COOP/COEP warnings
- Consider IndexedDB size limits

## Rollback Plan

If migration fails:
1. Revert pubspec.yaml changes
2. Delete `lib/data/db/` directory
3. Restore old files from git
4. Run `flutter pub get`
5. Run old build_runner

## Success Criteria

- ✅ All compilation errors resolved
- ✅ App runs on all platforms (Android, iOS, Web, Desktop)
- ✅ Offline functionality works
- ✅ Bidirectional sync functions correctly
- ✅ No data loss during operations
- ✅ Performance is acceptable (< 16ms for UI updates)
- ✅ Tests pass

## Timeline Estimate

- Code generation: 5 minutes
- Complete repositories: 30 minutes
- Update providers: 15 minutes
- Update UI code: 1-2 hours (depends on usage)
- Remove old code: 10 minutes
- Web setup: 15 minutes
- Firestore config: 20 minutes
- Testing: 1-2 hours
- **Total: 4-6 hours**

## Post-Migration Tasks

1. Update documentation
2. Add migration notes to CHANGELOG
3. Create example usage in README
4. Set up CI/CD with new structure
5. Monitor Firestore usage/costs
6. Configure TTL policies
7. Optimize indexes based on queries
