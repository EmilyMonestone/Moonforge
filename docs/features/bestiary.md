# Bestiary Integration

The Bestiary provides access to D&D 5e 2024 monster data with local caching for offline access and fast lookup.

## Overview

Moonforge integrates with the official 5etools bestiary data to provide:
- Complete D&D 5e monster statistics
- Local caching for offline access
- Smart sync with ETag-based conditional requests
- Background updates
- Search and filtering

## Features

- **Remote data**: Downloads from 5etools mirror
- **Local caching**: Stores in dedicated 'bestiary' storage box  
- **Smart sync**: Uses HTTP ETag headers for efficient updates
- **Background updates**: Checks for new data every 24 hours
- **Offline support**: Works with cached data offline

## BestiaryService

### Initialization

The bestiary box is initialized in `main.dart`:

```dart
await PersistenceService.init(['bestiary']);
```

### Creating Instance

```dart
import 'package:moonforge/core/services/bestiary_service.dart';

final persistence = PersistenceService();
final bestiaryService = BestiaryService(persistence);
```

### Fetching Monsters

```dart
// Get all monsters (triggers background sync if stale)
final monsters = await bestiaryService.getAll();

// Get all monsters without syncing
final monsters = await bestiaryService.getAll(ensureFresh: false);

// Find specific monster
final goblin = await bestiaryService.getByName('Goblin');
```

### Force Sync

```dart
// Force fresh download
final success = await bestiaryService.forceSync();
```

### Cache Management

```dart
// Check if cached
if (bestiaryService.isCached()) {
  // Data available
}

// Get last sync time
final lastSync = bestiaryService.getLastSyncTime();

// Clear cache
await bestiaryService.clearCache();
```

## Configuration

Customize stale threshold (default: 24 hours):

```dart
final bestiaryService = BestiaryService(
  persistence,
  staleThreshold: Duration(hours: 12),
);
```

## Data Format

Monster data structure:

```json
{
  "name": "Goblin",
  "source": "MM",
  "page": 166,
  "size": ["S"],
  "type": "humanoid",
  "alignment": ["N", "E"],
  "ac": [
    {
      "ac": 15,
      "from": ["leather armor", "shield"]
    }
  ],
  "hp": {
    "average": 7,
    "formula": "2d6"
  },
  "speed": {
    "walk": 30
  },
  "str": 8,
  "dex": 14,
  "con": 10,
  "int": 10,
  "wis": 8,
  "cha": 8,
  "skill": {
    "stealth": "+6"
  },
  "senses": ["darkvision 60 ft."],
  "passive": 9,
  "languages": ["Common", "Goblin"],
  "cr": "1/4",
  "trait": [...],
  "action": [...],
  "environment": ["forest", "grassland", "hill"]
}
```

## Storage Keys

Bestiary uses dedicated storage box with these keys:

- `bestiary_json` - Full monster data array
- `bestiary_etag` - ETag header for conditional requests
- `bestiary_lastSync` - Timestamp of last successful sync

## Usage in Features

### In Encounter Builder

```dart
// Load monsters for encounter
final monsters = await bestiaryService.getAll();

// Filter by CR
final cr1Monsters = monsters.where(
  (m) => m['cr'] == '1'
).toList();
```

### In Entity Creation

```dart
// Find monster template
final monster = await bestiaryService.getByName('Adult Dragon');

if (monster != null) {
  // Create entity from monster data
  final entity = Entity(
    id: uuid.v4(),
    kind: 'monster',
    name: monster['name'],
    statblock: {
      'source': 'srd',
      'srdRef': 'MM:${monster['name']}',
      'data': monster,
    },
  );
}
```

## Data Source

**URL**: https://raw.githubusercontent.com/5etools-mirror-3/5etools-src/refs/heads/main/data/bestiary/bestiary-xmm.json

**Format**: JSON array of monster objects

**License**: SRD 2024 content under OGL

## Smart Caching

### How It Works

1. **First fetch**: Downloads full bestiary, stores JSON and ETag
2. **Subsequent fetches**: Sends ETag in `If-None-Match` header
3. **304 Not Modified**: Uses cached data
4. **200 OK**: Updates cache with new data

### Benefits

- Reduces bandwidth usage
- Fast offline access
- Always up-to-date when online

## Background Sync

Service automatically checks for updates:

1. On first `getAll()` call
2. Every 24 hours (configurable)
3. Only if not manually synced recently

Manual sync:

```dart
await bestiaryService.forceSync();
```

## Error Handling

Service handles errors gracefully:

```dart
try {
  final monsters = await bestiaryService.getAll();
} catch (e) {
  // Falls back to cached data if available
  // Logs error and continues
}
```

## Performance

- **Cache hit**: <1ms (reading from storage)
- **304 Not Modified**: <100ms (network request only)
- **Full sync**: 1-5 seconds (downloading ~2MB JSON)

## Best Practices

1. **Initialize early**: Call in app startup
2. **Use cached data**: Set `ensureFresh: false` for UI that doesn't need latest
3. **Background sync**: Let service handle updates automatically
4. **Handle offline**: Check `isCached()` before requiring fresh data
5. **Filter wisely**: Cache contains 2000+ monsters, filter before displaying

## Limitations

- **No fuzzy search**: Exact name match only
- **No filtering by type**: Filter in-memory after fetching
- **Single source**: Only 5etools bestiary (could expand)
- **No homebrew**: Official SRD content only

## Troubleshooting

### Data not loading

- Check internet connection
- Verify bestiary box is initialized: `await PersistenceService.init(['bestiary'])`
- Check console for errors

### Slow first load

- First download is ~2MB, expected to take 1-5 seconds
- Subsequent loads use cache (instant)

### Stale data

- Call `forceSync()` to refresh
- Adjust `staleThreshold` if checking too frequently

## Related Documentation

- [Entities](entities.md) - Entity management
- [Encounters](encounters.md) - Encounter builder
- [Persistence](../architecture/data-layer.md) - Data storage

## External Resources

- [5etools](https://5e.tools/) - Original bestiary source
- [D&D SRD](https://dnd.wizards.com/resources/systems-reference-document) - Official rules
