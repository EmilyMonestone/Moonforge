# D&D Beyond Character Import - Implementation Summary

## Overview

This implementation adds a complete service for importing D&D Beyond characters into Moonforge. Users can import characters by entering either a numeric character ID or a full D&D Beyond URL.

## What Was Implemented

### 1. Database Schema Changes
- Added `dndBeyondCharacterId` field to the `Entities` table
- Updated schema version from 1 to 2
- Added database migration to support existing installations

### 2. Core Service (`DndBeyondCharacterService`)
A comprehensive service that:
- Extracts character IDs from URLs or accepts numeric IDs directly
- Fetches character data from D&D Beyond's public API
- Maps D&D Beyond's ability score IDs to ability names
- Transforms character data into Moonforge's entity format
- Supports both importing new characters and updating existing ones
- Handles errors gracefully with proper logging

### 3. Data Mapping
The service maps the following D&D Beyond data:

**Ability Scores:**
- Maps D&D Beyond's numeric IDs (1-6) to ability names
- Stores both raw scores and calculated modifiers

**Combat Stats:**
- Hit Points (max and current)
- Armor Class
- Speed
- Initiative bonus
- Proficiency bonus

**Character Info:**
- Name
- Classes and levels (supports multiclassing)
- Race
- Auto-generated summary

### 4. User Interface Integration
- Created `importDndBeyondCharacter` utility function
- Provides user-friendly dialog for input
- Shows loading indicators during import
- Displays success/error notifications
- Navigates to imported character automatically

### 5. Service Registration
- Integrated with Flutter Provider system
- Available throughout the app via dependency injection

### 6. Comprehensive Documentation
Three detailed documentation files:
1. **dnd_beyond_import.md** - Feature overview and API reference
2. **dnd_beyond_build_instructions.md** - Build and testing guide
3. **dnd_beyond_ui_integration.md** - UI integration examples

## Files Modified

### Core Service Files (New)
- `moonforge/lib/core/services/dnd_beyond_character_service.dart` (353 lines)
- `moonforge/lib/features/entities/utils/import_dnd_beyond_character.dart` (120 lines)

### Database Schema
- `moonforge/lib/data/db/tables.dart` - Added new field
- `moonforge/lib/data/db/app_db.dart` - Schema version and migration

### Repository Layer
- `moonforge/lib/data/repo/entity_repository.dart` - Support new field in CRUD operations

### Provider Registration
- `moonforge/lib/data/db_providers.dart` - Register service

### Entity Creation Utilities (Updated for new field)
- `moonforge/lib/features/entities/utils/create_entity.dart`
- `moonforge/lib/features/entities/utils/create_entity_in_adventure.dart`
- `moonforge/lib/features/entities/utils/create_entity_in_chapter.dart`
- `moonforge/lib/features/entities/utils/create_entity_in_scene.dart`

### Documentation (New)
- `docs/dnd_beyond_import.md`
- `docs/dnd_beyond_build_instructions.md`
- `docs/dnd_beyond_ui_integration.md`

## Usage Example

```dart
// Import a character
import 'package:moonforge/features/entities/utils/import_dnd_beyond_character.dart';

// In a widget or action handler
await importDndBeyondCharacter(context, campaign);

// Update an existing character
final service = context.read<DndBeyondCharacterService>();
await service.updateCharacter(entityId);
```

## API Endpoint

The service uses D&D Beyond's public character API:
```
GET https://character-service.dndbeyond.com/character/v5/character/{id}
```

## Testing

### Manual Testing Steps
1. Run `dart run build_runner build --delete-conflicting-outputs` to regenerate Drift code
2. Launch the app
3. Navigate to a campaign
4. Trigger the import function (see UI integration guide)
5. Enter a test character ID (e.g., 152320860) or URL
6. Verify character data is imported correctly

### What to Test
- ✓ Import with numeric ID
- ✓ Import with full URL
- ✓ Error handling for invalid input
- ✓ Error handling for network issues
- ✓ Character data mapping accuracy
- ✓ Ability scores and modifiers
- ✓ HP, AC, and combat stats
- ✓ Class and race information
- ✓ Update functionality for existing characters

## Known Limitations

1. **No Authentication**: Only works with publicly shared D&D Beyond characters
2. **Basic Stat Mapping**: Currently maps only core stats; spells, items, and features not yet included
3. **No Image Import**: Character portraits are not imported
4. **No Background Sync**: Characters must be manually updated
5. **Single Character Import**: No batch import functionality yet

## Future Enhancements

Potential improvements that could be added:
- Import character portraits/avatars
- Map spells, items, and class features
- Background sync to keep characters up-to-date
- Batch import multiple characters
- Import from other sources (Roll20, Beyond Tabletop, etc.)
- Support for authenticated access to private characters
- More detailed statblock mapping

## Maintenance Notes

### When Adding New Entity Fields
If new fields are added to the Entity model, update:
1. `create_entity.dart` and related creation utilities
2. `entity_repository.dart` CRUD methods
3. Any direct Entity instantiations

### When Updating D&D Beyond API
If D&D Beyond changes their API structure:
1. Update `transformToStatblock` method in the service
2. Add/modify field mappings as needed
3. Update documentation

### Database Migrations
When adding more D&D Beyond related fields:
1. Add fields to `tables.dart`
2. Increment schema version in `app_db.dart`
3. Add migration logic for existing installations
4. Regenerate Drift code

## Support

For issues or questions about this feature:
- Review the documentation in `docs/dnd_beyond_*.md`
- Check the D&D Beyond API documentation
- Examine the service implementation in `dnd_beyond_character_service.dart`

## License

This implementation follows the same license as the Moonforge project.
