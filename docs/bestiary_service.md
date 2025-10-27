# Bestiary Service

The `BestiaryService` provides access to DND 5e 2024 monsters (entities) with local caching for better performance.

## Overview

The service fetches monster data from the official 5etools mirror and stores it locally using the PersistenceService. It implements smart caching with ETag-based conditional requests to minimize bandwidth usage and provide fast access to bestiary data.

## Features

- **Remote data fetching**: Downloads bestiary JSON from https://raw.githubusercontent.com/5etools-mirror-3/5etools-src/refs/heads/main/data/bestiary/bestiary-xmm.json
- **Local caching**: Stores data in a dedicated 'bestiary' storage box for quick access
- **Smart sync**: Uses HTTP ETag headers for efficient conditional requests
- **Background updates**: Automatically checks for updates in the background (default: 24 hours)
- **Offline support**: Works with cached data when network is unavailable

## Usage

### Basic Setup

The bestiary box is automatically initialized in `main.dart`:

```dart
await PersistenceService.init(['bestiary']);
```

### Creating a Service Instance

```dart
import 'package:moonforge/core/services/bestiary_service.dart';
import 'package:moonforge/core/services/persistence_service.dart';

final persistence = PersistenceService();
final bestiaryService = BestiaryService(persistence);
```

### Fetching All Monsters

```dart
// Get all monsters (triggers background sync if data is stale)
final monsters = await bestiaryService.getAll();

// Get all monsters without triggering sync
final monsters = await bestiaryService.getAll(ensureFresh: false);
```

### Finding a Specific Monster

```dart
final goblin = await bestiaryService.getByName('Goblin');
if (goblin != null) {
  print('Found: ${goblin['name']}');
}
```

### Force Sync

```dart
// Force a fresh download from remote
final success = await bestiaryService.forceSync();
if (success) {
  print('Bestiary synced successfully');
}
```

### Cache Management

```dart
// Check if data is cached
if (bestiaryService.isCached()) {
  print('Bestiary data is available locally');
}

// Get last sync time
final lastSync = bestiaryService.getLastSyncTime();
if (lastSync != null) {
  print('Last synced: $lastSync');
}

// Clear all cached data
await bestiaryService.clearCache();
```

## Configuration

### Stale Threshold

By default, the service considers data stale after 24 hours. You can customize this:

```dart
final bestiaryService = BestiaryService(
  persistence,
  staleThreshold: Duration(hours: 12), // Check for updates every 12 hours
);
```

## Data Format

The service expects the remote JSON to have either:

1. A root-level `monster` array:
   ```json
   {
     "monster": [
       {"name": "Goblin", "type": "humanoid", ...},
       ...
     ]
   }
   ```

2. Or a direct array:
   ```json
   [
     {"name": "Goblin", "type": "humanoid", ...},
     ...
   ]
   ```

## Storage Keys

The service uses the following keys in the 'bestiary' storage box:

- `bestiary_json`: The full JSON payload (string)
- `bestiary_etag`: ETag value for conditional requests
- `bestiary_lastSync`: Timestamp of last successful sync (milliseconds since epoch)

## Integration with PersistenceService

The BestiaryService uses the enhanced PersistenceService which supports multiple storage boxes. This allows the bestiary data to be isolated from other app data while sharing the same storage infrastructure.

See [persistence.md](../moonforge/docs/persistence.md) for more details on the PersistenceService.

## Error Handling

The service handles errors gracefully:

- Network failures: Falls back to cached data if available
- JSON parsing errors: Logs error and returns empty list
- Missing data: Returns empty list or null as appropriate

All errors are logged using the app's logger utility.

## Testing

Tests are available in `test/core/services/bestiary_service_test.dart`. Run them with:

```sh
flutter test test/core/services/bestiary_service_test.dart
```

## Performance Considerations

- **First load**: Downloads full bestiary JSON (~several MB). This happens asynchronously on first access.
- **Subsequent loads**: Returns cached data immediately, checks for updates in background.
- **ETag optimization**: Server returns 304 Not Modified when data hasn't changed, saving bandwidth.
- **Memory**: JSON is stored as string; parsing happens on-demand when accessing data.

## Future Enhancements

Potential improvements:

- Parse JSON into typed Monster models for better type safety
- Add search/filter capabilities (by type, CR, etc.)
- Support multiple bestiary sources
- Implement delta updates instead of full JSON download
- Add progress callbacks for initial download
- Cache parsed models in memory for faster repeated access
