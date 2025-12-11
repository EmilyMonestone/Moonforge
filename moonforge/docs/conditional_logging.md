# Conditional Logging Feature

## Overview

The conditional logging feature allows you to enable or disable logging for specific contexts without modifying code. This is particularly useful for debugging specific areas of the application (like sync operations) without being overwhelmed by logs from other areas.

## LogContext Enum

The following log contexts are available:

- `LogContext.general` - General application logs (always enabled, cannot be disabled)
- `LogContext.sync` - Sync-related operations (SyncCoordinator, InboundListener, OutboxProcessor)
- `LogContext.database` - Database operations
- `LogContext.auth` - Authentication and user management
- `LogContext.navigation` - Navigation and routing
- `LogContext.ui` - UI state and widget lifecycle
- `LogContext.network` - Network requests and responses
- `LogContext.data` - Data parsing and transformation

## Usage

### Basic Logging

By default, all logging uses the `general` context:

```dart
import 'package:moonforge/core/utils/logger.dart';

// These logs are always shown (general context is always enabled)
logger.i('Application started');
logger.w('Warning message');
logger.e('Error occurred', error: exception);
```

### Context-Specific Logging

To log with a specific context:

```dart
// This log will only appear if LogContext.sync is enabled
logger.i('Sync started', context: LogContext.sync);

// This log will only appear if LogContext.database is enabled
logger.d('Database query executed', context: LogContext.database);

// Error and fatal messages are ALWAYS logged regardless of context
logger.e('Critical sync error', context: LogContext.sync); // Always shown
```

### Enabling/Disabling Contexts

You can enable or disable contexts at runtime:

```dart
import 'package:moonforge/core/utils/logger.dart';

// Enable sync logging to debug sync issues
logger.enableContext(LogContext.sync);

// Disable sync logging when done
logger.disableContext(LogContext.sync);

// Enable multiple contexts at once
logger.enableContexts([
  LogContext.sync,
  LogContext.database,
  LogContext.network,
]);

// Disable multiple contexts
logger.disableContexts([
  LogContext.sync,
  LogContext.database,
]);

// Check if a context is enabled
if (logger.isContextEnabled(LogContext.sync)) {
  print('Sync logging is enabled');
}
```

### Common Use Cases

#### Debugging Sync Issues

Enable sync logging to see detailed sync operations:

```dart
// Enable sync logging
logger.enableContext(LogContext.sync);

// Now you'll see all sync-related logs:
// - SyncCoordinator lifecycle (start, stop, auth changes)
// - InboundListener operations (Firestore changes, syncing data)
// - OutboxProcessor operations (flushing pending changes)

// Trigger the sync operation you want to debug
// ... perform actions ...

// Disable when done
logger.disableContext(LogContext.sync);
```

#### Debugging Database Operations

```dart
logger.enableContext(LogContext.database);
// Perform database operations
logger.disableContext(LogContext.database);
```

#### Debugging Multiple Areas

```dart
// Debug sync and database together
logger.enableContexts([LogContext.sync, LogContext.database]);

// Perform operations
// ...

// Clean up
logger.disableContexts([LogContext.sync, LogContext.database]);
```

## Implementation Details

### Sync Instrumentation

The sync components now include extensive logging:

**SyncCoordinator** (`lib/data/db/sync/sync_coordinator.dart`):
- Initialization, start, and stop events
- Auth state changes and user authentication
- Push loop operations
- Flush operations and errors

**InboundListener** (`lib/data/db/sync/inbound_listener.dart`):
- Start/stop with subscription counts
- Firestore snapshot changes
- Campaign and related entity sync operations
- Number of items synced per collection

**OutboxProcessor** (`lib/data/db/sync/outbox_processor.dart`):
- Flush operations with pending item counts
- Individual entry processing (upsert/delete operations)
- Success/error counts
- Warnings for missing data

### Error Handling

**Important**: Error and fatal messages are ALWAYS logged, regardless of whether their context is enabled. This ensures critical issues are never missed.

```dart
// These are ALWAYS logged
logger.e('Error', context: LogContext.sync);
logger.f('Fatal error', context: LogContext.database);

// These respect context settings
logger.i('Info', context: LogContext.sync);
logger.d('Debug', context: LogContext.database);
logger.w('Warning', context: LogContext.network);
```

## Testing

Unit tests are provided in `test/core/utils/logger_test.dart` to verify:
- Context enable/disable functionality
- Message filtering based on context
- Error messages always being logged
- Multiple context management
- Global logger instance behavior

Run tests with:
```bash
flutter test test/core/utils/logger_test.dart
```

## Best Practices

1. **Use appropriate contexts**: Choose the most specific context for your logs
2. **Don't overuse general context**: Reserve it for truly general application events
3. **Enable contexts temporarily**: Enable for debugging, disable when done
4. **Use debug/trace for verbose logs**: These are filtered by level AND context
5. **Always use error/fatal for errors**: They bypass context filtering for safety
6. **Consider production**: In production builds, you may want to disable debug/trace logs entirely

## Migration Guide

### Updating Existing Code

The global `logger` instance remains backward compatible. Existing code continues to work:

```dart
// Old code - still works (uses general context)
logger.i('Message');
logger.e('Error');

// New code - with contexts
logger.i('Message', context: LogContext.sync);
logger.e('Error', context: LogContext.database);
```

### Adding Contexts to Your Code

1. Import the logger:
   ```dart
   import 'package:moonforge/core/utils/logger.dart';
   ```

2. Add context to your logs:
   ```dart
   logger.i('Starting operation', context: LogContext.appropriate_context);
   ```

3. Choose the appropriate context based on the component's purpose

## Future Enhancements

Potential future improvements:
- Configuration file to set default enabled contexts
- UI toggle for contexts in debug builds
- Log level filtering per context
- Performance metrics per context
- Context hierarchies (e.g., sync.inbound, sync.outbound)
