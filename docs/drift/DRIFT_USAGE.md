# Drift Offline-First - Usage Guide

## Quick Start

### 1. Generate Drift Code

After pulling these changes, run the code generator:

```bash
cd moonforge
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `app_database.g.dart`
- `campaigns_dao.g.dart`
- `outbox_dao.g.dart`

### 2. Set Up Web Assets (Web Platform Only)

For web support, you need to place WASM assets in the `/web` directory.

#### Option A: Extract from drift package
```bash
# After flutter pub get, find the drift package
find ~/.pub-cache -name "drift-*" -type d

# Copy assets
cp ~/.pub-cache/hosted/pub.dev/drift-*/web/sqlite3.wasm ./moonforge/web/
cp ~/.pub-cache/hosted/pub.dev/drift-*/web/drift_worker.dart.js ./moonforge/web/
```

#### Option B: Use drift_dev web command
```bash
cd moonforge
dart run drift_dev web
```

#### Option C: Manual download
Download from: https://github.com/simolus3/drift/tree/develop/drift/web
- `sqlite3.wasm`
- `drift_worker.dart.js`

Place both files in `moonforge/web/`.

**Important**: Ensure `sqlite3.wasm` is served with `Content-Type: application/wasm`.

See `docs/drift_web_setup.md` for hosting configuration.

### 3. Wire Up Providers

In your app initialization (e.g., `lib/main.dart` or `lib/app.dart`):

```dart
import 'package:moonforge/data/drift_providers.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ...driftProviders(), // Add Drift providers
        // ... your other providers
      ],
      child: MyApp(),
    ),
  );
}
```

### 4. Use in Widgets

#### Watch campaigns stream (reactive, local-first)

```dart
import 'package:flutter/material.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:provider/provider.dart';

class CampaignList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Instant, local-first updates
    final campaigns = context.watch<List<Campaign>>();
    
    return ListView.builder(
      itemCount: campaigns.length,
      itemBuilder: (context, index) {
        final campaign = campaigns[index];
        return ListTile(
          title: Text(campaign.name),
          subtitle: Text(campaign.description),
        );
      },
    );
  }
}
```

#### Create/update campaigns

```dart
import 'package:moonforge/data/repo/campaign_repository.dart';

class CampaignEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final repository = context.read<CampaignRepository>();
    
    return ElevatedButton(
      onPressed: () async {
        // Optimistic write (instant local, syncs later)
        await repository.upsertLocal(
          Campaign(
            id: 'campaign-${DateTime.now().millisecondsSinceEpoch}',
            name: 'New Campaign',
            description: 'Created offline',
            rev: 0,
          ),
        );
      },
      child: Text('Create Campaign'),
    );
  }
}
```

#### Patch operations (granular updates)

```dart
// Update single field
await repository.patchLocal(
  id: campaignId,
  baseRev: campaign.rev,
  ops: [
    {'type': 'set', 'field': 'name', 'value': 'Updated Name'},
  ],
);

// Add member to campaign
await repository.patchLocal(
  id: campaignId,
  baseRev: campaign.rev,
  ops: [
    {'type': 'addToSet', 'field': 'memberUids', 'value': 'new-uid'},
  ],
);

// Remove member
await repository.patchLocal(
  id: campaignId,
  baseRev: campaign.rev,
  ops: [
    {'type': 'removeFromSet', 'field': 'memberUids', 'value': 'old-uid'},
  ],
);

// Multiple operations in one patch
await repository.patchLocal(
  id: campaignId,
  baseRev: campaign.rev,
  ops: [
    {'type': 'set', 'field': 'name', 'value': 'Updated Name'},
    {'type': 'set', 'field': 'description', 'value': 'Updated Description'},
    {'type': 'addToSet', 'field': 'memberUids', 'value': 'new-uid'},
  ],
);
```

## Supported Patch Operations

| Operation | Description | Example |
|-----------|-------------|---------|
| `set` | Set a scalar field | `{'type': 'set', 'field': 'name', 'value': 'New'}` |
| `addToSet` | Add to list (if not present) | `{'type': 'addToSet', 'field': 'memberUids', 'value': 'uid'}` |
| `removeFromSet` | Remove from list | `{'type': 'removeFromSet', 'field': 'memberUids', 'value': 'uid'}` |
| `applyDelta` | Update content (LWW) | `{'type': 'applyDelta', 'field': 'content', 'value': '...'}` |

## How It Works

### Local-First Architecture

```
┌──────────────┐
│  UI (Widget) │ ← context.watch<List<Campaign>>()
└──────┬───────┘
       │
┌──────▼──────────┐
│  Repository     │ ← upsertLocal(), patchLocal()
└──────┬──────────┘
       │
┌──────▼──────────┐
│  Drift SQLite   │ ← Source of truth (instant local reads/writes)
│  (AppDatabase)  │
└──────┬──────────┘
       │
┌──────▼──────────┐
│  Outbox Queue   │ ← Mutations queued for sync
└──────┬──────────┘
       │
┌──────▼──────────┐
│  Sync Engine    │ ← Push/pull with Firestore
└──────┬──────────┘
       │
┌──────▼──────────┐
│  Firestore      │ ← Remote sync (eventual consistency)
└─────────────────┘
```

### Write Flow

1. **User action** → `repository.upsertLocal(campaign)`
2. **Optimistic write** → Drift (instant)
3. **Mark dirty** → Local metadata
4. **Enqueue** → Outbox
5. **UI updates** → Stream emits new data (instant feedback)
6. **Background sync** → Sync engine processes outbox
7. **CAS check** → Firestore transaction checks `rev` field
8. **Success** → Increment `rev`, mark clean, remove from outbox
9. **Conflict** → Replay local change on top of remote, retry

### Read Flow

1. **Widget** → `context.watch<List<Campaign>>()`
2. **Instant** → Reads from local Drift database
3. **Background pull** → Firestore snapshots listened
4. **Remote change** → Adopted if local not dirty or remote rev ≥ local
5. **UI updates** → Stream automatically emits

## Conflict Resolution

### Compare-And-Set (CAS)
Every write increments the `rev` field. Firestore transactions enforce:
- Create: `rev == 0`
- Update: `rev == resource.rev + 1`

### On Conflict
If `remoteRev != expectedRev`:
1. Fetch latest remote state
2. Replay local operation on top of remote
3. Increment remote rev
4. Apply to Firestore

### Merge Strategy
- **Scalars** (name, description): Last Write Wins
- **Lists** (memberUids): Set union (merge)
- **Content** (Quill delta): LWW (extensible for delta merges)

## Testing

Run tests:
```bash
cd moonforge
flutter test test/data/drift/
flutter test test/data/repo/
```

## Firestore Security Rules

Deploy the rules from `firebase/firestore.rules.drift`:

```bash
firebase deploy --only firestore:rules
```

Or integrate the CAS checks into your existing rules.

## Debugging

### Check sync status
```dart
final pendingCount = await context.read<AppDatabase>().outboxDao.pendingCount();
print('Pending sync operations: $pendingCount');
```

### Watch outbox
```dart
final outboxStream = context.read<AppDatabase>().outboxDao.watchAll();
outboxStream.listen((ops) {
  print('Outbox has ${ops.length} pending operations');
});
```

### Web backend verification
Open browser console when running on web. You should see:
```
✓ Drift web WASM backend: WasmDatabase
```

## Troubleshooting

### Code generation fails
```bash
flutter pub get
flutter clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Web: sqlite3.wasm not loading
- Verify file is in `/web` directory
- Check Content-Type header is `application/wasm`
- See `docs/drift_web_setup.md` for hosting config

### Sync not happening
- Check Firebase connection
- Verify SyncEngine is started (automatic via Provider)
- Check console for error messages
- Verify Firestore security rules allow writes

### Tests failing
Ensure you've run code generation first:
```bash
flutter pub run build_runner build
flutter test
```

## Example Full Widget

See `lib/data/examples/campaign_list_example.dart` for a complete example.

## Next Steps

1. Extend to other models (Chapter, Encounter, etc.)
2. Add sync status UI indicators
3. Implement manual sync triggers
4. Add offline detection and queueing feedback
5. Consider richer delta transforms for Quill content
