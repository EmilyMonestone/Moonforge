# Open5e API Integration

A comprehensive, type-safe client for the Open5e API (https://api.open5e.com) that fully implements the official API specification.

## Overview

This integration provides a robust way to interact with all Open5e API endpoints:
- Monsters, Spells, Backgrounds, Feats, Conditions
- Races, Classes, Magic Items, Weapons, Armor
- Documents, Planes, Sections, Spell Lists, and Manifest

## Features

- **Type-Safe**: All API responses mapped to strongly-typed Dart models
- **Official API Compliance**: Full support for filtering, searching, ordering per https://open5e.com/api-docs
- **Caching**: Built-in caching with ETag support for efficient API usage
- **Pagination**: Automatic handling of paginated API responses
- **Document Filtering**: Filter by source documents (e.g., '5esrd', 'tob')
- **Error Handling**: Comprehensive error handling with logging
- **Modular Models**: Split into logical groups for better maintainability

## Official API Features Supported

### Filtering
Filter resources by various properties:
```dart
// Get all CR 3 monsters
await service.getMonsters(
  options: Open5eQueryOptions(filters: {'cr': '3'}),
);
```

### Document Filtering
Limit results to specific source documents:
```dart
// Only monsters from Tome of Beasts
await service.getMonsters(
  options: Open5eQueryOptions(documentSlug: 'tob'),
);
```

### Case-Insensitive Search
Partial-word matching on resource names:
```dart
// Find all monsters containing "fir" (matches "fire", "fireball", etc.)
await service.getMonsters(
  options: Open5eQueryOptions(search: 'fir'),
);
```

### Ordering
Sort results by any field:
```dart
// Order monsters by challenge rating
await service.getMonsters(
  options: Open5eQueryOptions(ordering: 'challenge_rating'),
);

// Descending order (prefix with -)
await service.getMonsters(
  options: Open5eQueryOptions(ordering: '-name'),
);
```

### Pagination
Control page size and navigate pages:
```dart
// Custom page size
await service.getMonsters(
  options: Open5eQueryOptions(page: 2, limit: 100),
);
```

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
final monstersResponse = await open5eService.getMonsters(
  options: Open5eQueryOptions(page: 1),
);

// Get CR 5 monsters from SRD, ordered by name
final filtered = await open5eService.getMonsters(
  options: Open5eQueryOptions(
    filters: {'cr': '5'},
    documentSlug: '5esrd',
    ordering: 'name',
  ),
);

// Search for dragons
final dragons = await open5eService.getMonsters(
  options: Open5eQueryOptions(search: 'dragon'),
);

// Get a specific monster by slug
final dragon = await open5eService.getMonsterBySlug('ancient-red-dragon');
```

### Fetching Spells

```dart
// Get 3rd level spells
final level3Spells = await open5eService.getSpells(
  options: Open5eQueryOptions(filters: {'level': '3'}),
);

// Search for fire spells
final fireSpells = await open5eService.getSpells(
  options: Open5eQueryOptions(search: 'fire'),
);

// Get specific spell
final fireball = await open5eService.getSpellBySlug('fireball');
```

### Fetching Character Options

```dart
// Get all races
final racesResponse = await open5eService.getRaces();

// Get classes ordered by name
final classes = await open5eService.getClasses(
  options: Open5eQueryOptions(ordering: 'name'),
);

// Get backgrounds from a specific document
final backgrounds = await open5eService.getBackgrounds(
  options: Open5eQueryOptions(documentSlug: '5esrd'),
);

// Get feats
final feats = await open5eService.getFeats();
```

### Fetching Equipment

```dart
// Get all weapons
final weapons = await open5eService.getWeapons();

// Search for swords
final swords = await open5eService.getWeapons(
  options: Open5eQueryOptions(search: 'sword'),
);

// Get armor
final armor = await open5eService.getArmor();

// Get magic items
final magicItems = await open5eService.getMagicItems();
```

### Cache Management

```dart
// Clear all cached data
await open5eService.clearCache();

// Fetch with fresh data (bypass cache)
final fresh = await open5eService.getMonsters(useCache: false);
```

## Query Options

The `Open5eQueryOptions` class supports all official API parameters:

```dart
class Open5eQueryOptions {
  final String? search;           // Case-insensitive partial-word search
  final String? documentSlug;     // Filter by source document
  final String? ordering;         // Sort field (prefix with - for descending)
  final int page;                 // Page number (default: 1)
  final int? limit;               // Results per page
  final Map<String, String>? filters;  // Additional filters
}
```

## Model Structure

Models are organized into logical modules:

- **common.dart**: `PaginatedResponse`, `Document`, `ManifestEntry`
- **character.dart**: `Background`, `Feat`, `Race`, `CharacterClass`
- **spells.dart**: `Open5eSpell`, `SpellList`
- **equipment.dart**: `MagicItem`, `Weapon`, `Armor`
- **mechanics.dart**: `Condition`, `Plane`, `Section`

All models have:
- `slug`: Unique identifier
- `name`: Display name
- `desc`: Description
- `document`: Source document (optional)

## Error Handling

All service methods:
- Return `null` on error (for single items)
- Return `null` on error (for paginated lists)
- Log errors using `LogContext.network`

Example:
```dart
final spell = await open5eService.getSpellBySlug('fireball');
if (spell == null) {
  // Handle error - check logs for details
  print('Failed to fetch spell');
}
```

## Testing

Unit tests are available in `test/core/services/open5e_service_test.dart`.

Run tests:
```bash
flutter test test/core/services/open5e_service_test.dart
```

## API Documentation

For full API documentation, see: https://open5e.com/api-docs

## Version Support

- **API v1**: monsters, spell lists, planes, sections, races, classes, magic items
- **API v2**: spells, documents, backgrounds, feats, conditions, weapons, armor

Both versions are fully supported with type-safe models.

## Migration from BestiaryService

The old `BestiaryService` has been removed. Use `Open5eService` directly:

```dart
// OLD
final monsters = await bestiaryService.getAll(page: 1, pageSize: 20);
final dragon = await bestiaryService.getByName('Red Dragon');

// NEW
final monsters = await open5eService.getMonsters(
  options: Open5eQueryOptions(page: 1, limit: 20),
);
final dragon = await open5eService.getMonsterBySlug('ancient-red-dragon');
```
