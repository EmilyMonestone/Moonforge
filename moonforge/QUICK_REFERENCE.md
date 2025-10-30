# Database Quick Reference

## 🚀 Getting Started

```bash
# Run code generation
cd moonforge
flutter pub get
./migrate_db.sh
```

## 📦 Import & Setup

```dart
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/db_providers.dart';
import 'package:moonforge/data/repo_new/campaign_repository.dart';

// In main.dart
final db = await constructDb();
runApp(
  MultiProvider(
    providers: [...dbProviders(db)],
    child: MyApp(),
  ),
);
```

## 💾 Using Repositories

### Watch (Stream)
```dart
// In Widget
final repo = context.read<CampaignRepository>();

StreamBuilder<List<Campaign>>(
  stream: repo.watchAll(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    final campaigns = snapshot.data!;
    return ListView.builder(/*...*/);
  },
);
```

### Create
```dart
final repo = context.read<CampaignRepository>();
await repo.create(Campaign(
  id: uuid.v4(),
  name: 'My Campaign',
  description: 'Epic adventure',
  content: {'ops': []}, // Quill Delta
  ownerUid: currentUser.uid,
  memberUids: [currentUser.uid],
  entityIds: [],
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  rev: 0,
));
```

### Update
```dart
final campaign = await repo.getById(id);
if (campaign != null) {
  await repo.update(campaign.copyWith(
    name: 'Updated Name',
  ));
}
```

### Delete
```dart
await repo.delete(campaignId);
```

## 🗂️ Available Repositories

```dart
context.read<CampaignRepository>()
context.read<ChapterRepository>()
context.read<AdventureRepository>()
context.read<SceneRepository>()
context.read<PartyRepository>()
context.read<EncounterRepository>()
context.read<EntityRepository>()
context.read<MediaAssetRepository>()
context.read<SessionRepository>()
```

## 🔄 Sync Coordinator

```dart
// Manual sync trigger
final sync = context.read<SyncCoordinator>();
await sync.triggerSync();

// Sync runs automatically every 5 seconds
```

## 📊 Table Relationships

```
Campaign
  └─ Chapters (campaignId)
      └─ Adventures (chapterId)
          └─ Scenes (adventureId)
  └─ Parties (campaignId)
  └─ Entities (originId = campaignId)

Encounter
  └─ Combatants (encounterId)
  └─ Entities (via entityIds)

Session (standalone)

MediaAsset (standalone)
```

## 🎨 Quill Delta Content

```dart
// Content fields store Quill Delta JSON
final campaign = Campaign(
  content: {
    'ops': [
      {'insert': 'Hello '},
      {'insert': 'world', 'attributes': {'bold': true}},
      {'insert': '\n'}
    ]
  },
  // ...
);
```

## 🔍 Common Queries

### Get single item
```dart
final campaign = await repo.getById(id);
```

### Watch filtered
```dart
// Chapters for a campaign
final chapterRepo = context.read<ChapterRepository>();
Stream<List<Chapter>> chapters = chapterRepo.watchByCampaign(campaignId);

// Adventures for a chapter
final adventureRepo = context.read<AdventureRepository>();
Stream<List<Adventure>> adventures = adventureRepo.watchByChapter(chapterId);

// Entities by origin (excluding deleted)
final entityRepo = context.read<EntityRepository>();
Stream<List<Entity>> entities = entityRepo.watchByOrigin(campaignId);
```

## 🌐 Firestore Collections

```
campaigns/{id}
chapters/{id}
adventures/{id}
scenes/{id}
parties/{id}
encounters/{id}
entities/{id}
mediaAssets/{id}
sessions/{id}
```

All have:
- `createdAt`: Timestamp
- `updatedAt`: Timestamp (server)
- `rev`: int (for conflict resolution)

Entities also have:
- `deleted`: boolean
- `deletedAt`: Timestamp (for TTL)

## 🔒 Soft Delete

```dart
// Entity soft delete
final entityRepo = context.read<EntityRepository>();
await entityRepo.delete(entityId);  // Sets deleted=true locally

// Firestore: deleted=true, deletedAt=serverTimestamp
// TTL auto-purges after grace period
```

## 🧪 Testing

```dart
// Create in-memory database for tests
final db = AppDb(NativeDatabase.memory());
final repo = CampaignRepository(db);

test('create campaign', () async {
  await repo.create(testCampaign);
  final result = await repo.getById(testCampaign.id);
  expect(result, isNotNull);
});
```

## 🐛 Common Issues

### "Cannot access database before it's created"
```dart
// Ensure await constructDb() in main()
final db = await constructDb();
```

### "No provider found for AppDb"
```dart
// Add dbProviders to MultiProvider
providers: [...dbProviders(db)]
```

### "Table doesn't exist"
```dart
// Run code generation first
flutter pub run build_runner build --delete-conflicting-outputs
```

### Web: "sqlite3.wasm not found"
```dart
// Copy sqlite3.wasm to web/ directory
// Generate drift_worker.dart.js
```

## 📱 Platform Notes

### Native (iOS/Android/Desktop)
- Uses NativeDatabase
- SQLite stored in app documents directory
- Background isolate for queries

### Web
- Uses WasmDatabase  
- SQLite stored in IndexedDB
- Worker-based queries
- Requires sqlite3.wasm in web/

## 🔗 Useful Links

- [Drift Docs](https://drift.simonbinder.eu/)
- [Drift Web Setup](https://drift.simonbinder.eu/Platforms/web/)
- [Migration Plan](MIGRATION_PLAN.md)
- [Full Summary](DATABASE_REWRITE_SUMMARY.md)
- [Technical Docs](lib/data/db/README.md)

## 💡 Tips

1. **Always use repositories, never DAOs directly** from UI
2. **Watch streams, don't poll** - Drift streams update automatically
3. **Transaction in repos** - Create/update/delete already wrapped
4. **Test offline first** - Sync is automatic
5. **Check outbox** if sync seems stuck - inspect `outboxEntries` table
6. **Server timestamps** - Firestore sets `updatedAt` automatically

## 🎯 Migration Checklist

- [ ] Run `./migrate_db.sh`
- [ ] Update main.dart with new providers
- [ ] Replace firestore_odm refs with repositories
- [ ] Delete old lib/data/drift/, firebase/, repo/, sync/
- [ ] Rename lib/data/repo_new/ to lib/data/repo/
- [ ] Test locally (offline)
- [ ] Test sync (online)
- [ ] Deploy Firestore rules
- [ ] Enable TTL policies
- [ ] Create indexes
- [ ] Test multi-device sync

---

**Need help?** See MIGRATION_PLAN.md for detailed guidance.
