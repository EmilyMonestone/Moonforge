# Data Layer Architecture - Isar Local-First with Firebase Sync

This document describes the Moonforge data layer architecture, which uses Isar for local-first storage with Firebase Firestore synchronization.

## Overview

The data layer uses a unified Isar-based local-first architecture that syncs with Firebase Firestore. All data operations go through Isar for instant access, with background synchronization to Firestore.

### Key Components

1. **Isar Models** (`lib/data/models/`)
   - Single source of truth for all data models
   - Decorated with `@collection` annotation for Isar
   - Include sync metadata: `syncStatus`, `lastSyncedAt`, `deleted`
   - Provide `toFirestore()` and `fromFirestore()` methods for serialization

2. **Repositories** (`lib/data/repositories/`)
   - Provide CRUD operations on Isar collections
   - Inherit from `BaseRepository` for common functionality
   - Automatically enqueue changes to the outbox for sync
   - Support reactive queries via Isar streams

3. **Sync Engine** (`lib/data/sync_service/isar_sync_engine.dart`)
   - Bidirectional sync between Isar and Firestore
   - Push: Processes outbox operations and uploads to Firestore
   - Pull: Listens to Firestore snapshots and updates Isar
   - Conflict resolution: Last-write-wins based on `updatedAt`
   - Retry logic for failed operations

4. **Isar Service** (`lib/data/services/isar_service.dart`)
   - Manages Isar database instance lifecycle
   - Initializes all schemas and opens database
   - Provides global access to Isar instance

5. **Providers** (`lib/data/isar_providers.dart`)
   - Dependency injection setup for repositories and sync engine
   - Stream providers for reactive data access
   - Integrates with Flutter Provider package

## Quick Start

1. **Generate Isar code**:
   ```bash
   cd moonforge
   flutter pub get
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Use in your app**:
   ```dart
   import 'package:moonforge/data/isar_providers.dart';
   import 'package:moonforge/data/services/isar_service.dart';
   
   // In main.dart, before runApp:
   final isar = await IsarService.init();
   
   runApp(
     MultiProviderWrapper(
       isar: isar,
       child: App(),
     ),
   );
   ```

## Architecture

```
UI Widget
    ↓ context.watch<List<Campaign>>()
Repository (watchAll stream)
    ↓ Isar query with fireImmediately
Isar Database (source of truth)
    ↓ upsert + enqueue to outbox
OutboxOperation Queue
    ↓ background processing (every 5s)
IsarSyncEngine
    ↓ Firestore write with serverTimestamp
Firestore (remote sync)
    ↓ Firestore listener
IsarSyncEngine (pull)
    ↓ Apply to Isar
Repository stream updates UI
```

## Migration from Drift + firestore_odm

### What Changed

**Before:**
- Separate models for local (Drift tables) and cloud (Firestore ODM)
- Manual mapping between formats
- Complex synchronization logic
- Two sources of truth

**After:**
- Single model type for both local and cloud
- Automatic sync via outbox pattern
- Simplified conflict resolution
- Local-first with single source of truth

### Breaking Changes

- All model imports must be updated from `lib/data/firebase/models/` to `lib/data/models/`
- Repository methods may have slightly different signatures
- No more `@freezed` models - using plain Dart classes with Isar annotations
- No more separate DAOs - repositories handle all operations

## Adding New Models

To add offline-first support for a new model:

1. Create model in `models/my_entity.dart`:
   ```dart
   @collection
   class MyEntity {
     Id isarId = Isar.autoIncrement;
     @Index(unique: true)
     late String id;
     // ... fields
     DateTime? updatedAt;
     int rev = 0;
     bool deleted = false;
     String syncStatus = 'synced';
     DateTime? lastSyncedAt;
     
     Map<String, dynamic> toFirestore() { ... }
     factory MyEntity.fromFirestore(Map<String, dynamic> data, String docId) { ... }
   }
   ```

2. Create repository in `repositories/my_entity_repository.dart`:
   ```dart
   class MyEntityRepository extends BaseRepository<MyEntity> {
     MyEntityRepository(super.isar) : super('myentities');
     // Implement abstract methods
   }
   ```

3. Register in `services/isar_service.dart` schema list

4. Add to providers in `isar_providers.dart`

5. Run code generation

## Key Features

- **Local-First**: Instant reads/writes from Isar
- **Offline Support**: Full functionality without network
- **Automatic Sync**: Background sync with Firestore
- **Conflict Resolution**: Last-write-wins based on timestamps
- **Cross-Platform**: Mobile, desktop, and web
- **Type-Safe**: Strongly typed queries and models
- **Fast**: Isar is optimized for Flutter/Dart

## Testing

```bash
# Unit tests
flutter test test/data/

# Integration tests (when implemented)
flutter test integration_test/
```

## Performance Notes

- Isar is faster than SQLite for most operations
- Indexes on `id` fields for fast lookups
- Batch operations available for bulk inserts
- Lazy loading via Isar links (to be implemented)

## Future Enhancements

- Isar Links for relationships
- Incremental sync (only changed fields)
- Selective sync (choose which campaigns)
- Compression for large content fields
- Background sync with WorkManager
