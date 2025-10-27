# Extended Drift Implementation - All Models + Firebase Storage

## Overview

This extension adds offline-first support for **all** Firebase models and implements Firebase Storage sync for media files.

## Supported Models

### Core Content Models (with rev field for CAS)
1. **Campaign** - Main campaign container
2. **Adventure** - Adventures within campaigns
3. **Chapter** - Chapters within adventures  
4. **Scene** - Scenes within chapters
5. **Encounter** - Combat encounters
6. **Entity** - NPCs, monsters, places, items, handouts
7. **Session** - Game session records
8. **MediaAsset** - Media file metadata

### Data Structure

```
Campaign
  └── Adventures
        └── Chapters
              └── Scenes

Encounters (independent or linked)
Entities (independent or linked)
Sessions (linked to campaigns)
MediaAssets (referenced by content)
```

## Generic Infrastructure

### LocalMetas Table
Unified metadata tracking for ALL models:
- `docRef`: Collection + ID (e.g., "campaigns/doc-123")
- `collection`: Collection name
- `docId`: Document ID
- `dirty`: Has unsync'd local changes
- `lastSyncedAt`: Last successful sync
- `downloadStatus`: For media files (pending, downloading, cached, failed)
- `localPath`: Local file path for cached media
- `cacheExpiry`: When to re-download

### LocalMetaMixin
Shared DAO functionality:
- `markDirty(collection, docId)` - Mark document as having local changes
- `markClean(collection, docId)` - Mark document as sync'd
- `isDirty(collection, docId)` - Check if document has local changes
- `updateDownloadStatus(...)` - Track media download status

### StorageQueue Table
Firebase Storage operation queue:
- Downloads: Firestore → Local filesystem/IndexedDB
- Uploads: Local file → Firebase Storage
- Priority-based processing
- Progress tracking (0-100%)
- Retry logic with attempt counter
- Status: pending, in_progress, completed, failed

## Firebase Storage Sync

### Download Flow
1. MediaAsset created/updated in Firestore
2. StorageSyncService enqueues download
3. Background processor downloads file
4. File cached locally (mobile: filesystem, web: IndexedDB/URL)
5. LocalMetas updated with local path and cache expiry
6. App uses cached file until expiry

### Upload Flow  
1. User selects/creates media file
2. File saved to local storage
3. MediaAsset created in Drift
4. StorageSyncService enqueues upload
5. Background processor uploads to Firebase Storage
6. MediaAsset updated with Storage URL
7. Firestore sync propagates metadata

### Caching Strategy
- **Mobile/Desktop**: Files stored in app documents directory (`media_cache/`)
- **Web**: Download URLs cached (browser handles actual caching)
- **Expiry**: 30 days for mobile, 7 days for web
- **Cleanup**: Periodic removal of expired cache entries

## Generic Sync Engine

### CollectionSyncConfig
Template for syncing any collection:
- `collectionName`: Firestore collection name
- `getById`: Get document from local DB
- `upsert`: Insert/update document locally
- `setClean`: Mark document as sync'd with new rev
- `isDirty`: Check if document has local changes
- `getRevFromDoc`: Extract rev field from document
- `mergeConflict`: Merge remote and local changes on conflict
- `applyPatchOp`: Apply a patch operation

### Usage Example

```dart
final campaignsConfig = CollectionSyncConfig(
  collectionName: 'campaigns',
  getById: (db, id) async {
    final c = await db.campaignsDao.getById(id);
    return c?.toJson();
  },
  upsert: (db, doc, {markDirty = false}) async {
    final campaign = Campaign.fromJson(doc);
    await db.campaignsDao.upsertCampaign(campaign, markDirty: markDirty);
  },
  setClean: (db, id, rev) => db.campaignsDao.setClean(id, rev),
  isDirty: (db, id) => db.campaignsDao.isDirty('campaigns', id),
  getRevFromDoc: (doc) => doc?['rev'] as int?,
  mergeConflict: (remote, local) => _mergeCampaign(remote, local),
  applyPatchOp: (doc, op) => _applyPatchOp(doc, op),
);

engine.registerCollection(campaignsConfig);
```

## DAOs Overview

All DAOs follow the same pattern:

### Common Methods
- `watchAll()` - Stream of all documents
- `getById(id)` - Get single document
- `upsert(doc, {markDirty})` - Insert/update document
- `setClean(id, newRev)` - Mark as sync'd with new rev

### Special Methods
- **MediaAssetsDao**:
  - `getDownloadStatus(id)` - Check download status
  - `getLocalPath(id)` - Get local file path

- **SessionsDao**:
  - No `setClean()` (Session model lacks rev field)

## Integration Steps

### 1. Update Drift Providers

```dart
List<SingleChildWidget> driftProviders() {
  return [
    // Database
    Provider<AppDatabase>(
      create: (_) => AppDatabase(),
      dispose: (_, db) => db.close(),
    ),

    // Repositories (one per model)
    ProxyProvider<AppDatabase, CampaignRepository>(...),
    ProxyProvider<AppDatabase, AdventureRepository>(...),
    // ... etc for all models

    // Generic Sync Engine
    ProxyProvider<AppDatabase, GenericSyncEngine>(
      update: (_, db, previous) {
        final engine = previous ?? GenericSyncEngine(db, FirebaseFirestore.instance);
        if (previous == null) {
          // Register all collections
          engine.registerCollection(campaignsConfig);
          engine.registerCollection(adventuresConfig);
          // ... etc
          engine.start();
        }
        return engine;
      },
      dispose: (_, engine) => engine.stop(),
    ),

    // Storage Sync Service
    ProxyProvider<AppDatabase, StorageSyncService>(
      update: (_, db, previous) {
        final service = previous ?? StorageSyncService(db, FirebaseStorage.instance);
        if (previous == null) {
          service.initialize().then((_) => service.start());
        }
        return service;
      },
      dispose: (_, service) => service.stop(),
    ),

    // StreamProviders for UI
    StreamProvider<List<Campaign>>(
      create: (c) => c.read<CampaignRepository>().watchAll(),
      initialData: const [],
    ),
    // ... etc for all models
  ];
}
```

### 2. Create Repositories

Each model needs a repository with:
- `watchAll()` - Stream for reactive UI
- `upsertLocal(model)` - Optimistic write + enqueue
- `patchLocal({id, baseRev, ops})` - Granular updates

See `CampaignRepository` as template.

### 3. Register Collections

Create `CollectionSyncConfig` for each model and register with `GenericSyncEngine`.

### 4. Handle Media Downloads

```dart
// Enqueue download
await storageSyncService.enqueueDownload(
  assetId: mediaAsset.id,
  storagePath: 'media/${mediaAsset.filename}',
  mimeType: mediaAsset.mime,
  fileSize: mediaAsset.size,
  priority: 10, // High priority
);

// Check if cached
final isCached = await storageSyncService.isCached(assetId);

// Get local path
final localPath = await storageSyncService.getLocalPath(assetId);
```

### 5. Handle Media Uploads

```dart
// User picks file
final file = await FilePicker.getFile();

// Save locally
final localPath = await saveToLocalStorage(file);

// Create MediaAsset
final asset = MediaAsset(
  id: uuid.v4(),
  filename: file.name,
  size: file.size,
  mime: file.mimeType,
  rev: 0,
);

// Enqueue upload
await storageSyncService.enqueueUpload(
  localPath: localPath,
  storagePath: 'media/${asset.id}/${asset.filename}',
  assetId: asset.id,
  mimeType: asset.mime,
  fileSize: asset.size,
);

// Save asset metadata
await mediaAssetRepository.upsertLocal(asset);
```

## Migration from v1 to v2

### Database Schema
- v1: Campaign only
- v2: All models + LocalMetas + StorageQueue

Migration is automatic:
```dart
if (from < 2) {
  await m.createTable(adventures);
  await m.createTable(chapters);
  // ... etc for all new tables
}
```

### Existing Data
- Campaign data and sync state preserved
- CampaignLocalMetas kept for backward compatibility
- New collections start empty

## Testing

### DAO Tests
```dart
test('AdventuresDao upsert', () async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final adventure = Adventure(id: 'test', name: 'Test', order: 0, rev: 0);
  
  await db.adventuresDao.upsert(adventure, markDirty: true);
  
  expect(await db.adventuresDao.isDirty('adventures', 'test'), isTrue);
  await db.close();
});
```

### Storage Sync Tests
```dart
test('StorageSyncService downloads file', () async {
  // Mock Firebase Storage
  // Enqueue download
  // Verify file cached locally
});
```

## Performance Considerations

### Download Prioritization
- User-requested media: High priority (10)
- Visible thumbnails: Medium priority (5)
- Background prefetch: Low priority (0)

### Batch Operations
- Sync processes one operation at a time
- Storage queue processes one download/upload at a time
- Can be enhanced with parallel processing if needed

### Cache Management
- Periodic cleanup of expired entries
- LRU eviction if storage limit reached
- Manual cache clear option in settings

## Security

### Firestore Rules
Same CAS rules apply to all collections with rev field:
```javascript
allow create: if request.resource.data.rev == 0;
allow update: if request.resource.data.rev == resource.data.rev + 1;
```

### Storage Rules
```javascript
match /media/{allPaths=**} {
  allow read: if request.auth != null;
  allow write: if request.auth != null && request.resource.size < 10 * 1024 * 1024; // 10MB limit
}
```

## Future Enhancements

1. **Batch Sync**: Sync multiple documents in one transaction
2. **Partial Sync**: Only sync documents user has accessed
3. **Background Sync**: Use WorkManager/BackgroundFetch for periodic sync
4. **Conflict UI**: Show conflicts to user for manual resolution
5. **Offline Indicators**: Show sync status in UI
6. **Smart Prefetch**: Predict and prefetch media user likely to access
7. **Progressive Loading**: Load low-res thumbnails first, hi-res later
8. **Delta Sync**: Only sync changed fields, not full documents
9. **Compression**: Compress media before upload
10. **WebP Conversion**: Convert images to WebP for smaller size

## Troubleshooting

### Downloads Not Starting
- Check Firebase Storage permissions
- Verify storage path is correct
- Check network connectivity
- Look for errors in StorageQueue table

### Uploads Failing
- Verify file exists at local path
- Check file size limits
- Verify Firebase Storage write permissions
- Check available storage quota

### Sync Not Happening
- Verify Firestore permissions
- Check if documents are marked dirty
- Look for errors in console
- Verify collections are registered with GenericSyncEngine

### Cache Not Working
- Check LocalMetas for download status
- Verify local file paths are correct
- Check cache expiry timestamps
- Look for filesystem permissions issues

## Next Steps

1. ✅ Create tables and DAOs for all models
2. ✅ Create generic sync engine
3. ✅ Create storage sync service
4. ⏳ Update providers with all collections
5. ⏳ Create repositories for all models
6. ⏳ Write tests for all DAOs
7. ⏳ Write tests for storage sync
8. ⏳ Update documentation
9. ⏳ Create example usage widgets
