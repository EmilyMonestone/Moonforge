# D&D Beyond Character Import

This feature allows importing D&D Beyond characters into Moonforge by character ID or URL.

## Overview

The `DnDBeyondImportService` provides functionality to:
- Import a character from D&D Beyond by ID or URL
- Update an existing character by syncing with D&D Beyond
- Store the D&D Beyond character ID for future updates

## Usage

### Importing a Character

```dart
// Initialize the service
final appDb = AppDb();
final playerRepository = PlayerRepository(appDb);
final importService = DnDBeyondImportService(playerRepository);

// Import a character (accepts ID or URL)
final result = await importService.importCharacter(
  'https://www.dndbeyond.com/characters/152320860',
  campaignId,
);

// Or just the ID
final result = await importService.importCharacter('152320860', campaignId);

// Check the result
if (result.success) {
  print('Character imported with ID: ${result.playerId}');
} else {
  print('Import failed: ${result.errorMessage}');
}
```

### Updating a Character

```dart
// Update an existing character from D&D Beyond
final result = await importService.updateCharacter(playerId);

if (result.success) {
  print('Character updated successfully');
} else {
  print('Update failed: ${result.errorMessage}');
}
```

## Supported Input Formats

The service accepts multiple input formats:

1. **Numeric ID**: `152320860`
2. **Full URL**: `https://www.dndbeyond.com/characters/152320860`
3. **Builder URL**: `https://www.dndbeyond.com/characters/152320860/builder`

## Data Mapping

### Ability Scores
The service maps D&D Beyond stat IDs to ability scores:
- ID 1 → Strength (STR)
- ID 2 → Dexterity (DEX)
- ID 3 → Constitution (CON)
- ID 4 → Intelligence (INT)
- ID 5 → Wisdom (WIS)
- ID 6 → Charisma (CHA)

### Character Fields
The following fields are imported from D&D Beyond:
- Name, race, class, subclass, level
- Background and alignment
- Ability scores (STR, DEX, CON, INT, WIS, CHA)
- HP (max and current), AC, speed
- Proficiency bonus (calculated from level)

### Local-Only Fields
When updating a character, these fields are preserved from the local database:
- Player UID (Firebase Auth)
- Temporary HP
- Notes and biography (Quill rich text)
- Created/updated timestamps

## Database Schema

### New Fields in Players Table
- `ddbCharacterId` (TEXT, nullable): Stores the D&D Beyond character ID
- `lastDdbSync` (DATETIME, nullable): Timestamp of last sync from D&D Beyond

## Error Handling

The service handles various error scenarios:

1. **Invalid Input**: Returns error if the ID/URL format is invalid
2. **Character Not Found**: D&D Beyond API returns 404
3. **Private Character**: D&D Beyond API returns 403
4. **Network Errors**: HTTP request failures
5. **Already Imported**: Prevents duplicate imports
6. **Not Linked**: Update fails if character isn't linked to D&D Beyond

## API Endpoint

The service uses D&D Beyond's character service API:
```
https://character-service.dndbeyond.com/character/v5/character/{characterId}
```

## Notes

- Characters must be public on D&D Beyond to be importable
- The import preserves local notes and bio fields during updates
- Each character can only be imported once per campaign
- Updates sync all character data except local-only fields

## Setup Required

After making changes to the schema or service, run:

```bash
cd moonforge
dart run build_runner build --delete-conflicting-outputs
```

This will regenerate the Drift database code to include the new fields.
