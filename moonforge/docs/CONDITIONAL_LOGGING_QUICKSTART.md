# Conditional Logging - Quick Start

## What is it?

Conditional logging lets you turn logging on/off for specific parts of the app (like sync, database, network) without changing code.

## Quick Example

```dart
import 'package:moonforge/core/utils/logger.dart';

// Enable sync logging
logger.enableContext(LogContext.sync);

// All sync logs will now appear
// Perform your sync operations...

// Disable when done
logger.disableContext(LogContext.sync);
```

## Common Scenarios

### Debug Sync Issues

```dart
// Turn on sync logging
logger.enableContext(LogContext.sync);

// You'll now see:
// - When SyncCoordinator starts/stops
// - Auth state changes
// - Firestore subscriptions
// - Outbox flush operations
// - Individual sync operations

// Turn off when done
logger.disableContext(LogContext.sync);
```

### Debug Multiple Areas

```dart
// Turn on multiple contexts
logger.enableContexts([
  LogContext.sync,
  LogContext.database,
  LogContext.network,
]);

// Debug your operations...

// Turn all off
logger.disableContexts([
  LogContext.sync,
  LogContext.database,
  LogContext.network,
]);
```

## Available Contexts

- `LogContext.general` - Always enabled, can't be disabled
- `LogContext.sync` - Sync operations (SyncCoordinator, InboundListener, OutboxProcessor)
- `LogContext.database` - Database operations
- `LogContext.auth` - Authentication
- `LogContext.navigation` - Navigation/routing
- `LogContext.ui` - UI state/lifecycle
- `LogContext.network` - Network requests
- `LogContext.data` - Data parsing/transformation

## Important Notes

1. **Errors are always logged** - Even if a context is disabled, error and fatal messages still appear
2. **General context is always on** - It can't be disabled
3. **Enable temporarily** - Turn on contexts for debugging, turn off when done
4. **No code changes needed** - Just enable/disable contexts at runtime

## Learn More

See [conditional_logging.md](conditional_logging.md) for complete documentation.

See [conditional_logging_examples.dart](conditional_logging_examples.dart) for detailed examples.
