# Drift Offline-First Implementation - CHANGELOG

## Overview
This implementation adds a complete local-first data architecture using Drift (SQLite) as the source of truth, with bidirectional sync to Firestore using Compare-And-Set (CAS) conflict resolution on a revision field.

## Files Added

### Core Database Infrastructure

#### Dependencies (pubspec.yaml)
- `drift: ^2.19.0` - Core database library
- `drift_flutter: ^0.2.2` - Flutter integration
- `sqlite3_flutter_libs: ^0.5.24` - Native SQLite
- `path_provider: ^2.1.1` - File system access
- `path: ^1.9.0` - Path utilities
- `drift_dev: ^2.19.0` (dev) - Code generation

#### Platform Connection Layer
- `lib/data/drift/connect/web.dart` - WASM backend for web
- `lib/data/drift/connect/native.dart` - Native backend for mobile/desktop
- `lib/data/drift/connect/connect.dart` - Conditional export shim

#### Converters & Tables
- `lib/data/drift/converters/string_list_converter.dart` - JSON conversion for List<String>
- `lib/data/drift/tables/campaigns.dart` - Campaign table using @UseRowClass(Campaign)
- `lib/data/drift/tables/campaign_local_metas.dart` - Separate local metadata (dirty flags, sync timestamps)
- `lib/data/drift/tables/outbox_ops.dart` - Queued mutations for sync

#### Data Access Objects (DAOs)
- `lib/data/drift/dao/campaigns_dao.dart`
  - watchAll(), getById(), upsertCampaign(), setClean()
  - Handles dirty flag management
- `lib/data/drift/dao/outbox_dao.dart`
  - enqueue(), nextOp(), markAttempt(), remove()
  - FIFO queue for sync operations

#### Main Database
- `lib/data/drift/app_database.dart`
  - Schema version 1
  - Migration strategy
  - Registers tables and DAOs
  - Test constructor for in-memory databases

### Application Layer

#### Repository
- `lib/data/repo/campaign_repository.dart`
  - Local-first API: watchAll(), getById()
  - Optimistic writes: upsertLocal(), patchLocal()
  - Patch operations: set, addToSet, removeFromSet, applyDelta
  - Automatic outbox queueing

#### Sync Engine
- `lib/data/sync/sync_engine.dart`
  - **Pull**: Firestore snapshots → Drift (adopts remote when local clean or remote rev ≥ local)
  - **Push**: Outbox → Firestore transaction with CAS on rev field
  - **Conflict Resolution**: 
    - LWW (Last Write Wins) for scalar fields
    - Set operations for lists (union merge)
    - Replay local changes on top of remote on conflict
  - Exponential backoff (up to 10 attempts)

#### Provider Wiring
- `lib/data/drift_providers.dart`
  - Provider<AppDatabase> singleton
  - ProxyProvider<CampaignRepository>
  - ProxyProvider<SyncEngine> (auto-start/stop)
  - StreamProvider<List<Campaign>> for UI consumption

### Examples & Documentation

- `lib/data/examples/campaign_list_example.dart` - Widget demonstrating usage
- `docs/drift_web_setup.md` - Web assets and MIME configuration guide
- `firebase/firestore.rules.drift` - Firestore security rules with CAS enforcement

### Tests

- `test/data/drift/dao_test.dart`
  - CampaignsDao: upsert, update, dirty flags, streams
  - OutboxDao: enqueue, FIFO ordering, remove, count
- `test/data/drift/migration_test.dart`
  - Schema creation verification
  - Template for future migrations
- `test/data/repo/campaign_repository_test.dart`
  - Optimistic upserts and patches
  - Patch operations (set, addToSet, removeFromSet)
  - Stream watching
  - Multi-operation patches

## Design Decisions

### 1. Domain Model Reuse
- Used `@UseRowClass(Campaign)` to mirror existing Freezed models 1:1
- No pollution of domain model with sync metadata
- Separate `CampaignLocalMetas` table for dirty flags and sync timestamps

### 2. Outbox Pattern
- All local writes enqueue operations for eventual sync
- Operations stored with base revision for CAS
- FIFO processing with retry logic
- Supports upsert, patch, and (future) delete operations

### 3. Conflict Resolution Strategy
- **Scalars**: Last Write Wins (replay local on remote)
- **Lists**: Set operations with merge (union)
- **Content (Quill delta)**: LWW for now, extensible for delta transforms
- CAS on `rev` field prevents lost updates

### 4. Web WASM Support
- Conditional exports for web vs native
- WasmDatabase with sqlite3.wasm and drift_worker.dart.js
- OPFS support detection with fallback warnings

### 5. Provider-Based Architecture
- Pure Provider (no Riverpod per requirements)
- Lifecycle-aware: auto-start/stop sync engine
- StreamProvider for reactive UI

### 6. Transaction Safety
- All multi-step local operations in Drift transactions
- Firestore writes use transactions for atomic CAS checks

## Breaking Changes
None - this is an additive feature. Existing firebase_odm code remains functional.

## Migration Path
To adopt Drift offline-first:
1. Add `driftProviders()` to app MultiProvider
2. Replace Firestore direct queries with `context.watch<List<Campaign>>()`
3. Replace Firestore writes with `repository.upsertLocal()` or `repository.patchLocal()`
4. Sync engine handles Firestore sync transparently

## Future Enhancements
- Additional models (Chapter, Encounter, Entity, etc.)
- Richer delta transforms for Quill content
- Conflict UI for user-driven resolution
- Sync status indicators and manual sync triggers
- Optimized index strategies
- Batch operations for initial sync
