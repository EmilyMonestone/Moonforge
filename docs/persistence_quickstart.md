# Quick Start Guide: Using Persistence Features

## Campaign Persistence

The current campaign is automatically persisted. No code changes needed!

**Behavior:**
- When you select a campaign, it's automatically saved
- On app restart/reload, the campaign is automatically restored
- Works across hot reload, hot restart, and full app restarts

## Autosave for Other Screens

To add autosave to any screen with a Quill editor:

### Step 1: Add the property

```dart
QuillAutosave? _autosave;
```

### Step 2: Initialize after loading content

```dart
@override
void initState() {
  super.initState();
  _contentController = QuillController.basic();
  
  // Load your content first
  // ...
  
  // Then initialize autosave
  _autosave = QuillAutosave(
    controller: _contentController,
    storageKey: 'unique_key_for_this_content', // Make it unique!
    delay: const Duration(seconds: 2), // Optional, default is 2 seconds
    autoRestore: false, // Set to true only if you want auto-restore
  );
  _autosave?.start();
}
```

### Step 3: Dispose properly

```dart
@override
void dispose() {
  _autosave?.dispose();
  _contentController.dispose();
  super.dispose();
}
```

### Step 4: Clear after successful save

```dart
Future<void> _save() async {
  // ... your save logic ...
  
  // Clear the autosaved draft after successful save
  await _autosave?.clear();
}
```

## Using PersistenceService Directly

For custom persistence needs:

```dart
import 'package:moonforge/core/services/persistence_service.dart';

final persistence = PersistenceService();

// Save
await persistence.write('my_key', 'my_value');

// Read
final value = persistence.read<String>('my_key');

// Remove
await persistence.remove('my_key');

// Check existence
final exists = persistence.hasData('my_key');
```

## Storage Key Conventions

Use descriptive keys with prefixes to avoid collisions:

- Campaign content: `campaign_{campaignId}_content_draft`
- Chapter content: `chapter_{chapterId}_content_draft`
- User preferences: `user_pref_{preference_name}`
- Filters: `filter_{feature_name}`

## Important Notes

1. **Always dispose**: Call `_autosave?.dispose()` in your dispose method
2. **Unique keys**: Use unique storage keys for each piece of content
3. **Clear drafts**: Clear autosaved content after successful remote saves
4. **Auto-restore**: Set `autoRestore: false` unless you specifically want automatic restoration
5. **Supported types**: String, int, double, Map, List (no custom objects without serialization)

## Examples in the Codebase

- **Campaign Persistence**: `lib/features/campaign/controllers/campaign_provider.dart`
- **Quill Autosave**: `lib/features/campaign/views/campaign_edit_screen.dart`
- **Full Documentation**: `docs/persistence.md`
