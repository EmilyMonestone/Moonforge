# D&D Beyond Import - Quick Reference

## Quick Start

```dart
// 1. Initialize
final appDb = AppDb();
final playerRepo = PlayerRepository(appDb);
final importService = DnDBeyondImportService(playerRepo);

// 2. Import a character
final result = await importService.importCharacter(
  'https://www.dndbeyond.com/characters/152320860',
  campaignId,
);

// 3. Check result
if (result.success) {
  print('Imported: ${result.playerId}');
} else {
  print('Error: ${result.errorMessage}');
}
```

## Common Operations

### Import Character
```dart
// By URL
await importService.importCharacter(
  'https://www.dndbeyond.com/characters/152320860',
  campaignId,
);

// By ID
await importService.importCharacter('152320860', campaignId);
```

### Update Character
```dart
await importService.updateCharacter(playerId);
```

### Check if Imported
```dart
final player = await playerRepo.getByDdbCharacterId('152320860');
final isImported = player != null;
```

### Get Character Details
```dart
final player = await playerRepo.getById(playerId);
print('Name: ${player.name}');
print('Level: ${player.level}');
print('DDB ID: ${player.ddbCharacterId}');
print('Last Sync: ${player.lastDdbSync}');
```

## Error Codes

| Error | Meaning |
|-------|---------|
| Invalid D&D Beyond character ID or URL | Input format not recognized |
| Character already imported | Use update instead of import |
| Failed to fetch character data | 404 (not found) or 403 (private) |
| Player not found | Invalid playerId for update |
| Player is not linked to a D&D Beyond character | No ddbCharacterId set |

## Database Fields

### Players Table (New Fields)
- `ddbCharacterId` (TEXT, nullable) - D&D Beyond character ID
- `lastDdbSync` (DATETIME, nullable) - Last sync timestamp

## Ability Score Mapping

```
ID 1 → STR (Strength)
ID 2 → DEX (Dexterity)
ID 3 → CON (Constitution)
ID 4 → INT (Intelligence)
ID 5 → WIS (Wisdom)
ID 6 → CHA (Charisma)
```

## API Endpoint

```
GET https://character-service.dndbeyond.com/character/v5/character/{characterId}
```

## After Installing

Run code generation:
```bash
cd moonforge
dart run build_runner build --delete-conflicting-outputs
```

## Preserved Fields During Update

When updating from D&D Beyond, these local fields are preserved:
- Player UID (Firebase Auth)
- Temporary HP
- Notes (Quill rich text)
- Bio (Quill rich text)
- Created timestamp

## Example UI Flow

1. **Import Screen**
   - Text input for URL/ID
   - Import button
   - Error message display
   - Success confirmation

2. **Player Detail Screen**
   - "Sync from D&D Beyond" button (if ddbCharacterId exists)
   - Last sync timestamp display
   - Update status indicator

## Files to Know

```
lib/core/services/dndbeyond_import_service.dart    - Main service
lib/data/repo/player_repository.dart               - Player repo
lib/data/db/tables.dart                             - Schema
lib/data/db/app_db.dart                             - Migrations
docs/features/dndbeyond-import.md                  - Full docs
```

## Testing Checklist

- [ ] Import by numeric ID
- [ ] Import by full URL
- [ ] Import by builder URL
- [ ] Error on invalid input
- [ ] Error on non-existent character
- [ ] Error on private character
- [ ] Error on duplicate import
- [ ] Update existing character
- [ ] Verify preserved local fields
- [ ] Check database migration

## Support

See full documentation:
- `docs/features/dndbeyond-import.md` - Feature guide
- `docs/development/migration-v2-to-v3.md` - Migration guide
- `lib/core/services/dndbeyond_import_example.dart` - Usage examples
