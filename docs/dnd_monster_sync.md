# D&D 5e Monster Sync Feature

Last updated: 2025-10-26

This document describes the D&D 5e 2024 monster synchronization feature in Moonforge.

## Overview

The `DndMonsterSyncService` provides functionality to download and cache the default D&D 5e 2024 monsters from the 5etools repository. The data is fetched from:

```
https://raw.githubusercontent.com/5etools-mirror-3/5etools-src/refs/heads/main/data/bestiary/bestiary-xmm.json
```

The service caches the monster data locally using the `PersistenceService` (backed by get_storage) for better performance and offline access.

## Features

- **Remote Sync**: Downloads the latest monster data from the 5etools GitHub repository
- **Local Caching**: Stores monster data locally with a 7-day cache validity period
- **Offline Support**: Falls back to cached data if remote sync fails
- **Entity Conversion**: Converts 5etools monster format to Moonforge Entity model
- **Cache Management**: Provides methods to check cache status and clear cache

## Usage

### Basic Usage

```dart
import 'package:moonforge/core/services/dnd_monster_sync_service.dart';

final service = DndMonsterSyncService();

// Sync monsters (uses cache if valid)
final monsters = await service.syncMonsters();

// Force refresh from remote
final freshMonsters = await service.syncMonsters(forceRefresh: true);

// Get cached monsters without syncing
final cached = service.getCachedMonsters();

// Convert a monster to Entity
final entity = service.convertToEntity(monsterData, entityId);
```

### Cache Management

```dart
// Get cache information
final info = service.getCacheInfo();
if (info != null) {
  print('Cached at: ${info['cached_at']}');
  print('Monster count: ${info['monster_count']}');
  print('Is valid: ${info['is_valid']}');
}

// Clear cache
await service.clearCache();
```

## Data Structure

### 5etools Monster Format

The monster data from 5etools includes comprehensive stat blocks with fields like:
- `name`: Monster name
- `size`: Size category (e.g., "M" for Medium)
- `type`: Creature type (e.g., "elemental", "humanoid")
- `cr`: Challenge Rating
- `ac`: Armor Class
- `hp`: Hit Points (with formula)
- `speed`: Movement speeds
- `str`, `dex`, `con`, `int`, `wis`, `cha`: Ability scores
- `action`: Actions and attacks
- `spellcasting`: Spellcasting abilities
- And many more fields...

### Entity Conversion

When converting to Moonforge's Entity model:
- The full monster data is stored in the `statblock` field
- `kind` is set to "monster"
- `name` is extracted from the monster data
- `summary` is generated from CR, size, and type
- `tags` includes "dnd-5e-2024" and "xmm" (source book)

Example converted Entity:
```dart
Entity(
  id: 'unique-id',
  kind: 'monster',
  name: 'Aarakocra Aeromancer',
  summary: 'CR 4 M elemental',
  statblock: {/* full 5etools monster data */},
  tags: ['dnd-5e-2024', 'xmm'],
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
)
```

## Cache Storage

The service uses two cache keys in PersistenceService:
- `dnd_5e_monsters_cache`: The actual monster data array
- `dnd_5e_monsters_cache_timestamp`: Timestamp of when data was cached

Cache is considered valid for 7 days by default.

## Error Handling

The service includes robust error handling:
- If remote fetch fails, it attempts to return cached data
- If no cached data exists and fetch fails, the error is rethrown
- All operations are logged using the app's logger service

## Integration Points

### PersistenceService
Uses `PersistenceService` (backed by get_storage) for local data storage.

### Entity Model
Converts monsters to the `Entity` model defined in `lib/core/models/data/entity.dart`.

### HTTP Client
Uses the `http` package for fetching remote data.

## Testing

Tests are located in `test/core/services/dnd_monster_sync_service_test.dart`.

The test suite includes:
- Entity conversion tests with various monster formats
- Cache management tests
- Integration test for syncing (requires network, skipped by default)

Run tests with:
```bash
flutter test test/core/services/dnd_monster_sync_service_test.dart
```

## Future Enhancements

Potential improvements:
- Support for additional monster sources (e.g., Monster Manual, other sourcebooks)
- Incremental updates instead of full re-download
- Search and filter capabilities
- Import monsters directly into campaigns
- Custom monster creation based on templates
