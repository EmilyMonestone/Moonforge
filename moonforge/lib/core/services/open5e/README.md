# Open5e API Integration

A comprehensive, type-safe client for the Open5e API (https://api.open5e.com).

## Overview

This integration provides a robust way to interact with all Open5e API endpoints, including:
- Monsters, Spells, Backgrounds, Feats, Conditions
- Races, Classes, Magic Items, Weapons, Armor
- Documents, Planes, Sections, Spell Lists, and Manifest

## Features

- **Type-Safe**: All API responses are mapped to strongly-typed Dart models
- **Caching**: Built-in caching with ETag support for efficient API usage
- **Pagination**: Automatic handling of paginated API responses
- **Search**: Search functionality for applicable endpoints
- **Error Handling**: Comprehensive error handling with logging
- **Easy to Use**: Simple, intuitive API for all endpoints

## Usage

### Basic Setup

```dart
import 'package:moonforge/core/services/open5e/index.dart';
import 'package:moonforge/core/services/persistence_service.dart';

// Create the service
final persistenceService = PersistenceService();
final open5eService = Open5eService(persistenceService);
```

### Fetching Monsters

```dart
// Get all monsters (paginated)
final monstersResponse = await open5eService.getMonsters(page: 1);
if (monstersResponse != null) {
  print('Total monsters: ${monstersResponse.count}');
  for (final monster in monstersResponse.results) {
    print('${monster.name} - CR ${monster.cr}');
  }
}

// Get a specific monster by slug
final dragon = await open5eService.getMonsterBySlug('ancient-red-dragon');
if (dragon != null) {
  print('${dragon.name} has ${dragon.hp?.average} HP');
}

// Search for monsters
final searchResults = await open5eService.searchMonsters('dragon');
```

### Fetching Spells

```dart
// Get all spells (paginated)
final spellsResponse = await open5eService.getSpells(page: 1, pageSize: 20);
if (spellsResponse != null) {
  for (final spell in spellsResponse.results) {
    print('${spell.name} - Level ${spell.level} ${spell.school}');
  }
}

// Get a specific spell
final fireball = await open5eService.getSpellBySlug('fireball');
if (fireball != null) {
  print('${fireball.name}: ${fireball.desc}');
}

// Search for spells
final fireSpells = await open5eService.searchSpells('fire');
```

### Fetching Character Options

```dart
// Get races
final racesResponse = await open5eService.getRaces();
racesResponse?.results.forEach((race) {
  print('${race.name}: ${race.asi}');
});

// Get classes
final classesResponse = await open5eService.getClasses();
classesResponse?.results.forEach((characterClass) {
  print('${characterClass.name} - Hit Die: ${characterClass.hitDice}');
});

// Get backgrounds
final backgroundsResponse = await open5eService.getBackgrounds();

// Get feats
final featsResponse = await open5eService.getFeats();
```

### Fetching Equipment

```dart
// Get weapons
final weaponsResponse = await open5eService.getWeapons();
weaponsResponse?.results.forEach((weapon) {
  print('${weapon.name} - ${weapon.damage} ${weapon.damageType}');
});

// Get armor
final armorResponse = await open5eService.getArmor();

// Get magic items
final magicItemsResponse = await open5eService.getMagicItems();
final magicSword = await open5eService.getMagicItemBySlug('flame-tongue');
```

### Fetching Reference Data

```dart
// Get conditions
final conditionsResponse = await open5eService.getConditions();

// Get planes
final planesResponse = await open5eService.getPlanes();

// Get sections (rules/lore)
final sectionsResponse = await open5eService.getSections();

// Get documents (source books)
final documentsResponse = await open5eService.getDocuments();
```

### Cache Management

```dart
// Clear all cached data
await open5eService.clearCache();

// Fetch with fresh data (bypass cache)
final freshMonsters = await open5eService.getMonsters(useCache: false);
```

## API Models

All models have the following common properties:
- `slug`: Unique identifier for the resource
- `name`: Display name
- `desc`: Description
- `document`: Source document (optional)

### Key Models

- **Monster**: Complete 5e monster stat block
- **Open5eSpell**: Spell with casting time, components, level, etc.
- **Background**: Character background with proficiencies
- **Race**: Character race with ability score improvements
- **CharacterClass**: Character class with proficiencies and features
- **Feat**: Character feat with prerequisites
- **Weapon**: Weapon with damage and properties
- **Armor**: Armor with AC and requirements
- **MagicItem**: Magic item with rarity and attunement
- **Condition**: Game condition effects
- **Plane**: Plane of existence
- **Section**: Rules or lore section
- **Document**: Source book/document
- **SpellList**: Collection of spells
- **ManifestEntry**: API resource metadata

## Pagination

Most list endpoints return a `PaginatedResponse<T>`:

```dart
class PaginatedResponse<T> {
  final int count;          // Total number of results
  final String? next;       // URL for next page
  final String? previous;   // URL for previous page
  final List<T> results;    // Current page results
}
```

## Caching Strategy

The client uses two levels of caching:

1. **ETag Caching**: Validates cached data with the server using ETags
2. **Local Storage**: Stores responses in PersistenceService

Cache keys are automatically managed based on:
- Endpoint URL
- Page number
- Query parameters

## Error Handling

All service methods:
- Return `null` on error (for single items)
- Return `null` on error (for lists)
- Log errors using the app's logger with `LogContext.network`

Example:
```dart
final spell = await open5eService.getSpellBySlug('fireball');
if (spell == null) {
  // Handle error - check logs for details
  print('Failed to fetch spell');
}
```

## Backward Compatibility

The existing `BestiaryService` has been refactored to use `Open5eService` internally while maintaining full backward compatibility. All existing code continues to work without changes.

## Testing

Unit tests are available in `test/core/services/open5e_service_test.dart`.

Run tests:
```bash
flutter test test/core/services/open5e_service_test.dart
```

## API Documentation

For full API documentation, see: https://api.open5e.com/schema/redoc/

## Version Support

- **API v1**: monsters, spell lists, planes, sections, races, classes, magic items
- **API v2**: spells, documents, backgrounds, feats, conditions, weapons, armor

Both versions are fully supported with type-safe models.
