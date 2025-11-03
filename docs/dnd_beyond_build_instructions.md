# Build Instructions for D&D Beyond Character Import Feature

This document provides instructions for building and testing the D&D Beyond character import feature.

## Prerequisites

- Flutter SDK installed
- Dart SDK installed
- All dependencies from `pubspec.yaml` installed

## Build Steps

### 1. Install Dependencies

```bash
cd moonforge
flutter pub get
```

### 2. Regenerate Drift Database Code

After adding the `dndBeyondCharacterId` field to the Entities table, you need to regenerate the Drift database code:

```bash
cd moonforge
dart run build_runner build --delete-conflicting-outputs
```

This will regenerate:
- `moonforge/lib/data/db/app_db.g.dart`
- `moonforge/lib/data/db/daos/entity_dao.g.dart`

### 3. Verify the Build

```bash
cd moonforge
flutter analyze
```

This should complete without errors related to the new schema changes.

## Testing the Feature

### Manual Testing

1. Run the app:
   ```bash
   cd moonforge
   flutter run
   ```

2. Navigate to a campaign

3. Use the import function (may need to be added to menu or UI)

4. Enter a D&D Beyond character ID or URL:
   - Example ID: `152320860`
   - Example URL: `https://www.dndbeyond.com/characters/152320860`

5. Verify the character is imported with:
   - Name
   - Ability scores (STR, DEX, CON, INT, WIS, CHA)
   - HP, AC, speed
   - Class and level information
   - Race

### Testing Update Functionality

1. Import a character
2. Make changes to the character on D&D Beyond
3. Use the update function with the entity ID
4. Verify the local entity is updated with the new data

### Example Test Character IDs

You can test with publicly shared D&D Beyond characters. Note that only public characters can be accessed via the API without authentication.

## Database Migration

The database migration from schema version 1 to 2 adds the `dndBeyondCharacterId` column. This migration runs automatically when the app is launched with the new schema version.

### Migration Details

**From:** Schema version 1
**To:** Schema version 2

**Changes:**
- Add `dndBeyondCharacterId TEXT` column to `entities` table (nullable)

The migration is defined in `moonforge/lib/data/db/app_db.dart`:

```dart
if (from == 1 && to >= 2) {
  await m.addColumn(entities, entities.dndBeyondCharacterId);
}
```

## Troubleshooting

### Build Runner Errors

If you encounter errors during code generation:

1. Clean the build cache:
   ```bash
   flutter clean
   flutter pub get
   dart run build_runner clean
   ```

2. Try building again:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Database Migration Issues

If the database doesn't migrate properly:

1. The app will need to be uninstalled and reinstalled (for development)
2. Or the database file needs to be deleted manually
3. Location varies by platform:
   - Android: `/data/data/<package>/databases/moonforge_db`
   - iOS: `Library/Application Support/moonforge_db`
   - Desktop: Platform-specific app data directory

## Integration Points

To integrate the import feature into the UI, you can:

1. **Add to menu bar:** Update `moonforge/lib/core/repositories/menu_registry.dart`
2. **Add button to entity list:** Update entity list view
3. **Add action to campaign screen:** Add an import button to the campaign detail screen

Example menu bar integration:

```dart
static MenuBarAction importDndBeyondCharacter(AppLocalizations l10n) {
  return MenuBarAction(
    label: 'Import D&D Beyond Character',
    onTap: (ctx) {
      final campaign = /* get current campaign */;
      import_dnd_beyond.importDndBeyondCharacter(ctx, campaign);
    },
  );
}
```

## API Documentation

### D&D Beyond API

**Endpoint:** `https://character-service.dndbeyond.com/character/v5/character/{id}`

**Method:** GET

**Authentication:** Not required for public characters

**Rate Limiting:** Unknown, but recommended to implement client-side throttling

**Response:** JSON object containing character data

See `docs/dnd_beyond_import.md` for detailed API response mapping.
