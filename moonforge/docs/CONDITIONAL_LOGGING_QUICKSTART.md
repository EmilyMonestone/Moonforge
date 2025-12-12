# Conditional Logging - Quick Start

## What is it?

Conditional logging lets you turn logging on/off for specific parts of the app (like sync, database, network) without changing code.

## Logger Initialization

The logger is a **singleton instance** automatically initialized in `lib/main.dart`:

- **Debug mode**: Sync and database contexts are enabled by default for development
- **Release mode**: Only general context is enabled (errors always log)

You can enable/disable additional contexts at runtime as needed.

## Quick Example

```dart
import 'package:moonforge/core/utils/logger.dart';

// Enable sync logging (if not already enabled)
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

1. **Singleton logger** - One instance across the app in `lib/core/utils/logger.dart`
2. **Auto-initialized** - Configured in `main.dart` based on build mode (debug/release)
3. **Errors are always logged** - Even if a context is disabled, error and fatal messages still appear
4. **General context is always on** - It can't be disabled
5. **Enable temporarily** - Turn on contexts for debugging, turn off when done
6. **No code changes needed** - Just enable/disable contexts at runtime

## Default Configuration

**Debug Mode** (development):
- ✅ `LogContext.general` - Always enabled
- ✅ `LogContext.sync` - Enabled for debugging sync operations
- ✅ `LogContext.database` - Enabled for debugging database queries
- ❌ Other contexts disabled by default (can be enabled in `main.dart` or at runtime)

**Release Mode** (production):
- ✅ `LogContext.general` - Always enabled
- ❌ All other contexts disabled (reduces log noise)

## Learn More

See [conditional_logging.md](conditional_logging.md) for complete documentation.

See [conditional_logging_examples.dart](conditional_logging_examples.dart) for detailed examples.
