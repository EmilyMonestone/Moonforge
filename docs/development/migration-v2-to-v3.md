# Database Migration Guide - Schema v2 to v3

## Overview

This migration adds D&D Beyond character import support by adding two new fields to the Players table.

## Changes

### Schema Version
- **From**: v2
- **To**: v3

### New Fields in Players Table

1. **ddbCharacterId** (TEXT, nullable)
   - Stores the D&D Beyond character ID
   - Used to link local player records with D&D Beyond characters
   - Enables character updates from D&D Beyond

2. **lastDdbSync** (DATETIME, nullable)
   - Timestamp of last synchronization from D&D Beyond
   - Useful for tracking when character data was last updated

## Migration Steps

### Automatic Migration

The migration will run automatically when the app starts after updating to this version. The Drift migration system will:

1. Check the current schema version in the database
2. If version < 3, add the new columns to the Players table
3. Update the schema version to 3

### Manual Migration (if needed)

If you need to manually verify or run the migration:

```sql
-- Add D&D Beyond character ID column
ALTER TABLE players ADD COLUMN ddb_character_id TEXT;

-- Add last sync timestamp column
ALTER TABLE players ADD COLUMN last_ddb_sync INTEGER;

-- Update schema version (stored in user_version pragma)
PRAGMA user_version = 3;
```

## Code Generation Required

After pulling these changes, you must regenerate the Drift database code:

```bash
cd moonforge
dart run build_runner build --delete-conflicting-outputs
```

This will generate:
- Updated table definitions in `lib/data/db/tables.dart`
- Updated DAO methods
- Updated database accessor code

## Backward Compatibility

- The migration is **non-destructive** - no existing data will be lost
- New fields are **nullable** - existing records remain valid
- The app will continue to work with existing player records
- Only newly imported or updated characters will have D&D Beyond IDs

## Testing Migration

To test the migration on a development database:

1. Start with a v2 database (or create one from scratch)
2. Run the app with the new code
3. The migration will execute on first launch
4. Verify new columns exist:
   ```sql
   PRAGMA table_info(players);
   ```
5. Check schema version:
   ```sql
   PRAGMA user_version;
   ```
   Should return `3`

## Rollback (if needed)

If you need to rollback to v2:

1. Revert the code changes in:
   - `lib/data/db/tables.dart`
   - `lib/data/db/app_db.dart`
2. Regenerate code: `dart run build_runner build --delete-conflicting-outputs`
3. For existing databases, manually remove the columns:
   ```sql
   -- SQLite doesn't support DROP COLUMN directly
   -- You'll need to recreate the table without these columns
   -- or just leave them (they won't cause issues)
   ```

## Related Files

- `lib/data/db/tables.dart` - Table schema definitions
- `lib/data/db/app_db.dart` - Database class and migration logic
- `lib/data/repo/player_repository.dart` - Player repository with D&D Beyond support
- `lib/core/services/dndbeyond_import_service.dart` - Import service implementation

## Next Steps

After the migration is complete:

1. Use the D&D Beyond import service to import characters
2. Characters will automatically have their `ddbCharacterId` set
3. Use the update functionality to sync changes from D&D Beyond
4. Check `lastDdbSync` to see when each character was last updated

## Support

If you encounter issues with the migration:

1. Check the app logs for migration errors
2. Verify Drift code generation completed successfully
3. Ensure database file permissions are correct
4. Try clearing app data and starting fresh (development only!)

## Migration Code Reference

From `lib/data/db/app_db.dart`:

```dart
onUpgrade: (Migrator m, int from, int to) async {
  if (from < 2) {
    // Add Players table
    await m.createTable(players);
    // Add memberPlayerIds to Parties if it doesn't exist
    await m.addColumn(parties, parties.memberPlayerIds);
  }
  if (from < 3) {
    // Add D&D Beyond integration fields to Players
    await m.addColumn(players, players.ddbCharacterId);
    await m.addColumn(players, players.lastDdbSync);
  }
}
```
