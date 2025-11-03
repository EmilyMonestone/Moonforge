# D&D Beyond Character Import Service

This service allows importing D&D Beyond characters into Moonforge by their character ID or full URL.

## Usage

### Importing a Character

Use the `importDndBeyondCharacter` utility function from the entities feature:

```dart
import 'package:moonforge/features/entities/utils/import_dnd_beyond_character.dart';

// In your widget or action handler:
await importDndBeyondCharacter(context, campaign);
```

This will show a dialog prompting the user to enter either:
- A numeric character ID (e.g., `152320860`)
- A full D&D Beyond character URL (e.g., `https://www.dndbeyond.com/characters/152320860`)

### Updating an Existing Character

To sync an already-imported character with D&D Beyond:

```dart
final service = context.read<DndBeyondCharacterService>();
final success = await service.updateCharacter(entityId);
```

## API

The D&D Beyond Character Service API endpoint used:
```
GET https://character-service.dndbeyond.com/character/v5/character/{id}
```

## Data Mapping

### Ability Scores
D&D Beyond uses numeric IDs for ability scores:
- 1 = Strength
- 2 = Dexterity
- 3 = Constitution
- 4 = Intelligence
- 5 = Wisdom
- 6 = Charisma

These are mapped to the `abilities` object in the entity's statblock with both values and modifiers.

### Statblock Fields
The service extracts and maps the following data:

| D&D Beyond Field | Statblock Field | Notes |
|-----------------|-----------------|-------|
| stats | abilities | Includes both value and modifier for each ability |
| baseHitPoints + bonusHitPoints | hp_max | Maximum hit points |
| removedHitPoints | hp | Current HP = max - removed |
| temporaryHitPoints | temp_hp | Temporary hit points |
| armorClass | ac | Armor class |
| bonusSpeed + race.weightSpeeds.normal.walk | speed | Walking speed |
| proficiencyBonus | proficiency_bonus | Proficiency bonus |
| initiativeBonus | initiative_bonus | Initiative bonus |
| classes | classes | Array of {name, level} objects |
| race.fullName or race.baseName | race | Character race |

### Entity Fields
- `kind`: Set to 'npc' by default
- `name`: Character name from D&D Beyond
- `summary`: Generated from class/level and race
- `dndBeyondCharacterId`: Stores the D&D Beyond character ID for future updates

## Database Schema

Added `dndBeyondCharacterId` column to the `Entities` table:
- Type: TEXT (nullable)
- Purpose: Store the D&D Beyond character ID for syncing and updates
- Migration: Schema version 1 → 2

## Service Registration

The service is automatically registered as a provider in `db_providers.dart`:

```dart
ProxyProvider<EntityRepository, DndBeyondCharacterService>(
  update: (_, entityRepo, __) => DndBeyondCharacterService(entityRepo),
),
```

## Error Handling

The service handles:
- Invalid character IDs or URLs
- Network errors when fetching data
- Malformed API responses
- Missing required fields in character data

Errors are logged using the app's logger and displayed to the user via notifications.

## Future Enhancements

Potential improvements:
- Batch import multiple characters
- Background sync to keep characters up-to-date
- Import character portraits/images
- More detailed statblock mapping (spells, items, features, etc.)
- Support for other external character sheet sources
