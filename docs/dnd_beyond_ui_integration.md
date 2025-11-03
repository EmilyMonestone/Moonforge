# D&D Beyond Character Import - UI Integration Guide

This guide shows how to integrate the D&D Beyond character import feature into the Moonforge UI.

## Option 1: Add to Campaign Menu

Add an "Import D&D Beyond Character" action to the campaign menu by updating `moonforge/lib/core/repositories/menu_registry.dart`:

### Step 1: Import the utility

Add this import at the top of the file:

```dart
import 'package:moonforge/features/entities/utils/import_dnd_beyond_character.dart'
    as import_dnd_beyond;
```

### Step 2: Add the menu action

Add a new static method in the `MenuRegistry` class:

```dart
static MenuBarAction importDndBeyondCharacter(AppLocalizations l10n) {
  return MenuBarAction(
    label: 'Import D&D Beyond Character',
    icon: Icons.download,
    onTap: (ctx) async {
      final campaignProvider = ctx.read<CampaignProvider>();
      final campaign = campaignProvider.currentCampaign;
      
      if (campaign == null) {
        notification.error(
          ctx,
          title: const Text('No Campaign Selected'),
          description: const Text('Please select a campaign first.'),
        );
        return;
      }
      
      await import_dnd_beyond.importDndBeyondCharacter(ctx, campaign);
    },
  );
}
```

### Step 3: Add to the campaign menu

Update the `_campaignMenu` method to include the new action:

```dart
static List<MenuBarAction> _campaignMenu(BuildContext ctx) {
  final l10n = AppLocalizations.of(ctx)!;
  final campaign = ctx.watch<CampaignProvider>().currentCampaign;

  if (campaign == null) return [];

  return <MenuBarAction>[
    newChapter(l10n),
    newEntity(l10n),
    importDndBeyondCharacter(l10n), // Add this line
    newEncounter(l10n),
  ];
}
```

## Option 2: Add to Entity Screen

Add a button or action to the entity list/management screen.

### Example: Add to Entity List Actions

In `moonforge/lib/features/entities/views/entity_screen.dart` (or similar), add a FloatingActionButton or action button:

```dart
FloatingActionButton.extended(
  onPressed: () async {
    final campaign = /* get current campaign */;
    await import_dnd_beyond.importDndBeyondCharacter(context, campaign);
  },
  icon: const Icon(Icons.download),
  label: const Text('Import from D&D Beyond'),
)
```

## Option 3: Add to Context Menu

Add the import option to entity context menus or right-click menus:

```dart
PopupMenuItem(
  child: const ListTile(
    leading: Icon(Icons.download),
    title: Text('Import D&D Beyond Character'),
  ),
  onTap: () async {
    final campaign = /* get current campaign */;
    await import_dnd_beyond.importDndBeyondCharacter(context, campaign);
  },
),
```

## Option 4: Add to Settings/Tools

Create a dedicated import/export section in settings or tools:

```dart
ListTile(
  leading: const Icon(Icons.cloud_download),
  title: const Text('Import from D&D Beyond'),
  subtitle: const Text('Import characters from D&D Beyond by ID or URL'),
  onTap: () async {
    final campaign = /* get current campaign */;
    await import_dnd_beyond.importDndBeyondCharacter(context, campaign);
  },
)
```

## Updating Characters

To add an "Update from D&D Beyond" option for entities that have been imported:

### Example: Add to Entity Actions

In the entity detail or edit screen, add a button for syncing:

```dart
// Check if entity has a D&D Beyond character ID
if (entity.dndBeyondCharacterId != null) {
  IconButton(
    icon: const Icon(Icons.sync),
    tooltip: 'Update from D&D Beyond',
    onPressed: () async {
      final service = context.read<DndBeyondCharacterService>();
      final success = await service.updateCharacter(entity.id);
      
      if (success) {
        notification.success(
          context,
          title: const Text('Character Updated'),
          description: const Text('Successfully synced with D&D Beyond'),
        );
      } else {
        notification.error(
          context,
          title: const Text('Update Failed'),
          description: const Text('Failed to sync with D&D Beyond'),
        );
      }
    },
  )
}
```

## User Experience Considerations

### Loading States

The import function already shows a loading indicator via SnackBar. For better UX, consider:

1. **Progress indicator:** Show progress during import
2. **Cancellation:** Allow users to cancel long-running imports
3. **Batch imports:** Support importing multiple characters at once

### Error Handling

The current implementation handles common errors:
- Invalid ID/URL format
- Network errors
- API errors (404, 500, etc.)
- Malformed response data

Consider adding:
- Retry logic for transient failures
- Better error messages for specific failure cases
- Offline queue for imports when network is unavailable

### Character Preview

Before finalizing the import, consider showing a preview:

```dart
// After fetching character data, show preview dialog
showDialog(
  context: context,
  builder: (ctx) => AlertDialog(
    title: Text('Import ${characterName}?'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Level $level $className'),
        Text('Race: $race'),
        // ... more character details
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(ctx, false),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(ctx, true),
        child: const Text('Import'),
      ),
    ],
  ),
);
```

## Localization

Remember to add localized strings for the import feature:

```arb
"importDndBeyondCharacter": "Import D&D Beyond Character",
"importDndBeyondCharacterDescription": "Import a character from D&D Beyond by ID or URL",
"dndBeyondCharacterId": "D&D Beyond Character ID",
"enterCharacterIdOrUrl": "Enter character ID or URL",
"importingCharacter": "Importing character from D&D Beyond...",
"characterImported": "Character imported successfully!",
"importFailed": "Import failed",
"characterSynced": "Character synced with D&D Beyond",
"syncFailed": "Failed to sync character"
```

## Testing Checklist

- [ ] Import with numeric ID works
- [ ] Import with full URL works
- [ ] Error handling for invalid ID/URL
- [ ] Error handling for network failures
- [ ] Error handling for non-existent characters (404)
- [ ] Update functionality works for existing imported characters
- [ ] Character data is correctly mapped to entity fields
- [ ] Ability scores are correctly extracted
- [ ] HP, AC, and other stats are correct
- [ ] Class and race information is preserved
- [ ] UI integration is smooth and responsive
- [ ] Loading states are clear
- [ ] Error messages are helpful
