# Open5e API v2 Integration

A comprehensive, type-safe client for the Open5e API v2 (https://api.open5e.com) that fully implements the official API specification.

## Overview

This integration provides complete access to all 33 Open5e v2 API endpoints:
- **Creatures** (formerly Monsters), Creature Types, Creature Sets
- **Spells**, Spell Schools
- **Character Options**: Backgrounds, Feats, Species (formerly Races), Classes, Abilities, Skills
- **Equipment**: Items, Magic Items, Weapons, Weapon Properties, Armor
- **Game Mechanics**: Conditions, Damage Types, Languages, Alignments, Sizes, Environments
- **Documentation**: Documents, Licenses, Publishers, Game Systems
- **Rules**: Rules, Rule Sets
- **Media**: Images, Services
- **Item Organization**: Item Sets, Item Categories, Item Rarities

## Features

- **Pure v2 API**: All endpoints use v2 API (no legacy v1 endpoints)
- **Type-Safe**: All API responses mapped to strongly-typed Dart models with null safety
- **GameSystem Filtering**: Automatic filtering by game system (5e-2024, 5e-2014, or a5e)
- **Official API Compliance**: Full support for filtering, searching, ordering per official docs
- **Caching**: Built-in caching with ETag support for efficient API usage
- **Pagination**: Automatic handling of paginated API responses
- **Type-Safe Constants**: Pre-defined constants for game systems and documents
- **Error Handling**: Comprehensive error handling with logging
- **Modular Models**: Split into 7 logical modules for better maintainability

## Official v2 API Features Supported

### GameSystem Filtering
All requests filter by game system. Defaults to 5e-2024:
```dart
// Default to 5e-2024 (latest rules)
await service.getCreatures(
  options: Open5eQueryOptions(
    filters: {'challenge_rating_decimal': '3'},
  ),
);

// Use 5e-2014 rules
await service.getCreatures(
  options: Open5eQueryOptions(
    gameSystemKey: GameSystemKey.edition2014,
  ),
);

// Use Advanced 5e
await service.getCreatures(
  options: Open5eQueryOptions(
    gameSystemKey: GameSystemKey.advancedEdition,
  ),
);
```

### Document Filtering
Limit results to specific source documents using type-safe constants:
```dart
// Only creatures from Tome of Beasts
await service.getCreatures(
  options: Open5eQueryOptions(
    documentKey: DocumentKey.tomeOfBeasts,
  ),
);

// SRD 2024 content only
await service.getCreatures(
  options: Open5eQueryOptions(
    documentKey: DocumentKey.srd2024,
  ),
);
```

### Creature Type Filtering
Filter creatures by type (dragon, undead, humanoid, etc.):
```dart
// Get all dragons from 5e-2024
await service.getCreatures(
  options: Open5eQueryOptions(
    creatureType: 'dragon',
  ),
);

// Get all undead from Tome of Beasts
await service.getCreatures(
  options: Open5eQueryOptions(
    creatureType: 'undead',
    documentKey: DocumentKey.tomeOfBeasts,
  ),
);
```

### Case-Insensitive Search
Partial-word matching on resource names:
```dart
// Find all creatures containing "fir" (matches "fire", "fireball", etc.)
await service.getCreatures(
  options: Open5eQueryOptions(search: 'fir'),
);
```

### Ordering
Sort results by any field:
```dart
// Order creatures by challenge rating
await service.getCreatures(
  options: Open5eQueryOptions(ordering: 'challenge_rating_decimal'),
);

// Descending order (prefix with -)
await service.getCreatures(
  options: Open5eQueryOptions(ordering: '-name'),
);
```

### Pagination
Control page size and navigate pages:
```dart
// Custom page size (100 per page)
await service.getCreatures(
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

### Fetching Creatures (formerly Monsters)

```dart
// Get all creatures from 5e-2024 (default)
final creaturesResponse = await open5eService.getCreatures(
  options: Open5eQueryOptions(page: 1),
);

// Get CR 5 dragons from SRD 2024, ordered by name
final filtered = await open5eService.getCreatures(
  options: Open5eQueryOptions(
    filters: {'challenge_rating_decimal': '5'},
    creatureType: 'dragon',
    documentKey: DocumentKey.srd2024,
    ordering: 'name',
  ),
);

// Search for dragons in 5e-2014 rules
final dragons = await open5eService.getCreatures(
  options: Open5eQueryOptions(
    search: 'dragon',
    gameSystemKey: GameSystemKey.edition2014,
  ),
);

// Get a specific creature by key
final aboleth = await open5eService.getCreatureByKey('srd-2024_aboleth');

// Get all creature types
final types = await open5eService.getCreatureTypes();
```

### Fetching Spells

```dart
// Get 3rd level spells from 5e-2024
final level3Spells = await open5eService.getSpells(
  options: Open5eQueryOptions(filters: {'level': '3'}),
);

// Search for fire spells from 5e-2014
final fireSpells = await open5eService.getSpells(
  options: Open5eQueryOptions(
    search: 'fire',
    gameSystemKey: GameSystemKey.edition2014,
  ),
);

// Get specific spell by key
final fireball = await open5eService.getSpellByKey('fireball');

// Get spell schools
final schools = await open5eService.getSpellSchools();
```

### Fetching Character Options

```dart
// Get all species (formerly races)
final speciesResponse = await open5eService.getSpecies();

// Get classes ordered by name
final classes = await open5eService.getClasses(
  options: Open5eQueryOptions(ordering: 'name'),
);

// Get backgrounds from SRD 2024
final backgrounds = await open5eService.getBackgrounds(
  options: Open5eQueryOptions(documentKey: DocumentKey.srd2024),
);

// Get feats
final feats = await open5eService.getFeats();

// Get abilities and skills
final abilities = await open5eService.getAbilities();
final skills = await open5eService.getSkills();
```

### Fetching Equipment

```dart
// Get all items
final items = await open5eService.getItems();

// Get magic items from Tome of Beasts
final magicItems = await open5eService.getMagicItems(
  options: Open5eQueryOptions(
    documentKey: DocumentKey.tomeOfBeasts,
  ),
);

// Search for swords
final swords = await open5eService.getWeapons(
  options: Open5eQueryOptions(search: 'sword'),
);

// Get armor
final armor = await open5eService.getArmor();

// Get weapon properties
final weaponProps = await open5eService.getWeaponProperties();

// Get item organization
final itemSets = await open5eService.getItemSets();
final itemCategories = await open5eService.getItemCategories();
final itemRarities = await open5eService.getItemRarities();
```

### Fetching Game Mechanics

```dart
// Get conditions
final conditions = await open5eService.getConditions();

// Get damage types
final damageTypes = await open5eService.getDamageTypes();

// Get languages
final languages = await open5eService.getLanguages();

// Get alignments, sizes, environments
final alignments = await open5eService.getAlignments();
final sizes = await open5eService.getSizes();
final environments = await open5eService.getEnvironments();
```

### Fetching Documentation

```dart
// Get all documents
final documents = await open5eService.getDocuments();

// Get game systems
final gameSystems = await open5eService.getGameSystems();

// Get publishers
final publishers = await open5eService.getPublishers();

// Get licenses
final licenses = await open5eService.getLicenses();
```

### Cache Management

```dart
// Clear all cached data
await open5eService.clearCache();

// Fetch with fresh data (bypass cache)
final fresh = await open5eService.getCreatures(useCache: false);
```

## Query Options

The `Open5eQueryOptions` class supports all official v2 API parameters:

```dart
class Open5eQueryOptions {
  final String? search;           // Case-insensitive partial-word search
  final String? gameSystemKey;    // Game system filter (use GameSystemKey constants)
  final String? documentKey;      // Source document filter (use DocumentKey constants)
  final String? creatureType;     // Creature type filter (e.g., 'dragon', 'undead')
  final String? ordering;         // Sort field (prefix with - for descending)
  final int page;                 // Page number (default: 1)
  final int? limit;               // Results per page
  final Map<String, String>? filters;  // Additional filters (e.g., {'challenge_rating_decimal': '5'})
}
```

### Type-Safe Constants

Use pre-defined constants for common values:

```dart
// Game Systems
GameSystemKey.edition2024        // '5e-2024' (default)
GameSystemKey.edition2014        // '5e-2014'
GameSystemKey.advancedEdition    // 'a5e'

// Documents
DocumentKey.srd2024             // 'srd-2024'
DocumentKey.srd2014             // 'srd'
DocumentKey.tomeOfBeasts        // 'tob'
DocumentKey.tomeOfBeasts2       // 'tob2'
DocumentKey.tomeOfBeasts3       // 'tob3'
DocumentKey.creatureCodex       // 'cc'
// ... and more
```

You can also fetch available values dynamically:
```dart
// Get all available game systems
final gameSystems = await service.getGameSystems();

// Get all available documents
final documents = await service.getDocuments();

// Get all creature types for filtering
final creatureTypes = await service.getCreatureTypes();
```

## Model Structure

Models are organized into 7 logical modules:

- **common.dart**: `PaginatedResponse`, `Document`, `GameSystem`, `Publisher`, `License`
- **character.dart**: `Background`, `Feat`, `Species`, `CharacterClass`, `Ability`, `Skill`
- **spells.dart**: `Open5eSpell`, `SpellSchool`
- **equipment.dart**: `Item`, `MagicItem`, `Weapon`, `Armor`, `ItemSet`, `ItemCategory`, `ItemRarity`, `WeaponProperty`
- **mechanics.dart**: `Condition`, `DamageType`, `Language`, `Alignment`, `Size`, `Environment`
- **creatures.dart**: `Creature`, `CreatureType`, `CreatureSet`
- **rules.dart**: `Rule`, `RuleSet`, `Open5eImage`, `Open5eService`

All v2 models have:
- `url`: API endpoint URL
- `key`: Unique identifier
- `name`: Display name
- `desc`: Description
- `document`: Source document with nested publisher and gamesystem (where applicable)

## Error Handling

All service methods:
- Return `null` on error (for single items)
- Return `null` on error (for paginated lists)
- Log errors using `LogContext.network`

Example:
```dart
final spell = await open5eService.getSpellByKey('fireball');
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

For full API documentation, see:
- Official docs: https://open5e.com/api-docs
- GitHub v2 API: https://github.com/open5e/open5e-api/tree/staging/api_v2

## Version Support

This integration uses **API v2 only** for all endpoints, providing:
- Consistent structure across all resources
- GameSystem filtering
- Rich document metadata with publisher information
- More comprehensive resource coverage (33 endpoints)

## Migration from BestiaryService

The old `BestiaryService` has been removed. Use `Open5eService` directly:

```dart
// OLD (v1/mixed API)
final monsters = await bestiaryService.getAll(page: 1, pageSize: 20);
final dragon = await bestiaryService.getByName('Red Dragon');

// NEW (v2 API)
final creatures = await open5eService.getCreatures(
  options: Open5eQueryOptions(page: 1, limit: 20),
);
final dragon = await open5eService.getCreatureByKey('srd-2024_ancient-red-dragon');
```

## Breaking Changes from v1

- `monsters` → `creatures`
- `races` → `species`
- `getMonsterBySlug()` → `getCreatureByKey()`
- `documentSlug` → `documentKey`
- `slug` identifier → `key` identifier
- All endpoints now use v2 URLs
- GameSystem filtering is now automatic (defaults to 5e-2024)
- Query parameter names changed (e.g., `cr` → `challenge_rating_decimal`)
