# Persistence with get_storage

This document describes the persistence features implemented using the `get_storage` package.

## Overview

The application now uses `get_storage` for lightweight, synchronous key-value persistence. This enables:
1. Auto-loading of the last selected campaign when the app starts or hot reloads
2. Auto-saving of Quill editor content while editing

## Features Implemented

### 1. Campaign Persistence

The `CampaignProvider` now automatically persists the currently selected campaign ID. When you select a campaign, its ID is saved to local storage. When the app restarts (including after hot restart/reload), the campaign is automatically restored.

**How it works:**
- When a campaign is selected via `setCurrentCampaign()`, the campaign ID is persisted
- On app initialization, `AppStateInitializer` loads the persisted campaign ID
- The campaign data is fetched from Firestore and restored to the provider
- If the campaign no longer exists, the persisted ID is cleared

**Location:** 
- `lib/features/campaign/controllers/campaign_provider.dart`
- `lib/core/widgets/app_state_initializer.dart`

### 2. Quill Editor Autosave

The `QuillAutosave` utility provides automatic saving of Quill editor content with the following features:
- Debounced saving (default: 2 seconds after last edit)
- Local persistence using get_storage
- Optional callback for remote saving
- Automatic restoration of unsaved drafts
- Manual save and clear operations

**Usage Example:**

```dart
late QuillController _contentController;
QuillAutosave? _autosave;

@override
void initState() {
  super.initState();
  _contentController = QuillController.basic();
  
  // Initialize autosave after loading content
  _autosave = QuillAutosave(
    controller: _contentController,
    storageKey: 'campaign_${campaign.id}_content_draft',
    delay: const Duration(seconds: 2),
    autoRestore: false, // Don't automatically restore; we load from Firestore
    onSave: (content) async {
      // Optional: Also save to remote storage
      logger.d('Content autosaved locally');
    },
  );
  _autosave?.start();
}

@override
void dispose() {
  _autosave?.dispose();
  _contentController.dispose();
  super.dispose();
}

// Clear autosaved draft after successful save
Future<void> _saveCampaign() async {
  // ... save logic ...
  await _autosave?.clear();
}
```

**Location:** `lib/core/utils/quill_autosave.dart`

### 3. Persistence Service

The `PersistenceService` provides a centralized API for managing persistent storage with support for multiple storage boxes (namespaces):

```dart
final persistence = PersistenceService();

// Write a value to default box
await persistence.write('key', 'value');

// Write a value to a specific box
await persistence.write('key', 'value', boxName: 'bestiary');

// Read a value from default box
final value = persistence.read<String>('key');

// Read a value from a specific box
final value = persistence.read<String>('key', boxName: 'bestiary');

// Remove a value from default box
await persistence.remove('key');

// Remove a value from a specific box
await persistence.remove('key', boxName: 'bestiary');

// Check if key exists in default box
final exists = persistence.hasData('key');

// Check if key exists in a specific box
final exists = persistence.hasData('key', boxName: 'bestiary');

// Listen to changes on a key in default box
persistence.listenKey('key', (value) {
  print('Key changed: $value');
});

// Listen to changes on a key in a specific box
persistence.listenKey('key', (value) {
  print('Key changed: $value');
}, boxName: 'bestiary');

// Clear all data from default box
await persistence.erase();

// Clear all data from a specific box
await persistence.erase(boxName: 'bestiary');
```

**Storage Boxes:**

The service supports multiple isolated storage boxes. Each box is a separate namespace for key-value pairs:

- `moonforge_storage` (default): General app storage, campaign selections, user preferences
- `bestiary`: DND 5e monster/entity data cache (used by BestiaryService)
- Add more boxes as needed for different data domains

**Location:** `lib/core/services/persistence_service.dart`

## Initialization

The persistence system is initialized in `main.dart` before the app starts:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ... other initialization ...
  
  // Initialize get_storage for persistence
  // Pass additional box names to initialize multiple boxes
  await PersistenceService.init(['bestiary']);
  
  // ... rest of initialization ...
  
  runApp(MultiProviderWrapper(child: App()));
}
```

The `init` method accepts an optional list of additional box names to initialize. The default `moonforge_storage` box is always initialized.

## Storage Keys

The following keys are currently used in persistent storage:

**Default box (`moonforge_storage`):**
- `current_campaign_id`: Stores the ID of the currently selected campaign
- `campaign_{campaignId}_content_draft`: Stores autosaved Quill editor drafts per campaign

**Bestiary box:**
- `bestiary_json`: Full bestiary JSON data from remote source
- `bestiary_etag`: ETag header for conditional HTTP requests
- `bestiary_lastSync`: Timestamp of last successful sync

See [bestiary_service.md](bestiary_service.md) for details on the bestiary data cache.

## Best Practices

1. **Storage Keys**: Use descriptive, unique keys with prefixes to avoid collisions
2. **Storage Boxes**: Use separate boxes for different data domains (e.g., 'bestiary', 'spells')
3. **Data Types**: get_storage supports String, int, double, Map, and List
4. **Cleanup**: Clear autosaved drafts after successful remote saves
5. **Error Handling**: The persistence service logs errors but doesn't throw exceptions
6. **Performance**: get_storage is synchronous in memory with async disk backup

## When to Use get_storage

✅ **Good for:**
- Simple key-value storage
- User preferences and settings
- Caching HTTP requests
- Simple persistent state (like current selection)
- Draft/autosave functionality

❌ **Not suitable for:**
- Large datasets requiring indexing
- Complex queries
- Relational data

For complex data, continue using Firestore/Firebase.

## Testing

The persistence features work across:
- App restarts
- Hot reloads (Flutter)
- Hot restarts (Flutter)
- Platform switches (Web, Mobile, Desktop)

## Future Enhancements

Potential improvements:
1. Persist other provider states (e.g., filters, view preferences)
2. Add autosave for other rich text editors in the app
3. Implement offline draft queue for when network is unavailable
4. Add user preference for autosave interval
5. Add visual indicator when autosave is active/completed
