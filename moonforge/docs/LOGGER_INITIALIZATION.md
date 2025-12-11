# Logger Initialization Flow

This document explains how the conditional logger is initialized and configured in the Moonforge application.

## Architecture Overview

```
┌──────────────────────────────────────────────────────────────┐
│                    Application Startup                        │
└──────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────┐
│  lib/main.dart                                                │
│                                                               │
│  main() {                                                     │
│    WidgetsFlutterBinding.ensureInitialized();                │
│                                                               │
│    _initializeLogger(); ◄──── Configures logger contexts     │
│    ...                                                        │
│  }                                                            │
└────────────────────────┬──────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│  _initializeLogger()                                          │
│                                                               │
│  if (kDebugMode) {                                           │
│    logger.enableContexts([                                   │
│      LogContext.sync,      ◄──── Sync debugging             │
│      LogContext.database,  ◄──── DB debugging               │
│    ]);                                                       │
│  }                                                           │
│  // Release: only general context (default)                 │
└────────────────────────┬──────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│  lib/core/utils/logger.dart                                  │
│                                                               │
│  // SINGLETON INSTANCE                                       │
│  final ConditionalLogger logger = ConditionalLogger(...)     │
│                                                               │
│  • One instance for entire app                               │
│  • Accessed by all components                                │
│  • Context filtering applied                                 │
└──────────────────────────────────────────────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        ▼                ▼                ▼
  ┌──────────┐    ┌──────────┐    ┌──────────┐
  │ Sync     │    │ Database │    │ Other    │
  │ Components│    │ Components│    │ Components│
  │          │    │          │    │          │
  │ Uses     │    │ Uses     │    │ Uses     │
  │ logger   │    │ logger   │    │ logger   │
  └──────────┘    └──────────┘    └──────────┘
```

## Singleton Pattern

### Definition Location
The logger is defined in **`lib/core/utils/logger.dart`**:

```dart
/// SINGLETON INSTANCE - One logger for the entire app
final ConditionalLogger logger = ConditionalLogger(
  Logger(
    printer: PrettyPrinter(
      noBoxingByDefault: true,
      errorMethodCount: 12,
      methodCount: 4,
    ),
  ),
);
```

### Why It's a Singleton
1. **`final` keyword**: Cannot be reassigned
2. **Top-level variable**: Created once when first accessed
3. **Consistent import path**: All files import from `package:moonforge/core/utils/logger.dart`
4. **Dart guarantees**: Top-level `final` variables are initialized lazily but only once

### Usage Across the App
Every component imports the same instance:

```dart
import 'package:moonforge/core/utils/logger.dart';

// All components use the same 'logger' instance
logger.i('Message');
```

## Initialization in main.dart

### When It Happens
Logger contexts are configured **immediately** after `WidgetsFlutterBinding.ensureInitialized()` in `main()`:

```dart
Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Step 1: Configure logger contexts
  _initializeLogger();

  // Step 2: Continue with other initialization
  await dotenv.load(fileName: ".env");
  await AppVersion.init();
  await Firebase.initializeApp(...);
  // ...
}
```

### Configuration Function

```dart
void _initializeLogger() {
  // In debug mode, enable additional logging contexts for development
  if (kDebugMode) {
    logger.enableContexts([
      LogContext.sync,      // Enable sync logging to debug sync operations
      LogContext.database,  // Enable database logging for query debugging
      // LogContext.auth,      // Uncomment to debug authentication issues
      // LogContext.navigation, // Uncomment to debug navigation issues
      // LogContext.ui,        // Uncomment to debug UI state issues
      // LogContext.network,   // Uncomment to debug network requests
      // LogContext.data,      // Uncomment to debug data parsing issues
    ]);
    logger.i('Logger initialized with contexts: ${logger.enabledContexts}');
  }
  
  // In release mode, only general context is enabled (default)
  // This reduces log noise in production while keeping errors visible
}
```

## Default Contexts by Build Mode

### Debug Mode (Development)
```
✅ LogContext.general   - Always enabled (errors, warnings)
✅ LogContext.sync       - Enabled for debugging sync operations
✅ LogContext.database   - Enabled for debugging database queries
❌ LogContext.auth       - Disabled (uncomment to enable)
❌ LogContext.navigation - Disabled (uncomment to enable)
❌ LogContext.ui         - Disabled (uncomment to enable)
❌ LogContext.network    - Disabled (uncomment to enable)
❌ LogContext.data       - Disabled (uncomment to enable)
```

### Release Mode (Production)
```
✅ LogContext.general   - Always enabled (errors, warnings)
❌ All other contexts   - Disabled (minimal logging)
```

## Runtime Context Control

Even after initialization, contexts can be enabled/disabled at runtime:

```dart
// Enable additional context during app execution
logger.enableContext(LogContext.network);

// Disable when done
logger.disableContext(LogContext.network);

// Check status
if (logger.isContextEnabled(LogContext.sync)) {
  // Context is enabled
}
```

## Customizing Default Contexts

To change which contexts are enabled by default:

1. Open **`lib/main.dart`**
2. Find the `_initializeLogger()` function
3. Modify the context list:

```dart
void _initializeLogger() {
  if (kDebugMode) {
    logger.enableContexts([
      LogContext.sync,
      LogContext.database,
      LogContext.auth,       // ← Add this line
      LogContext.network,    // ← Add this line
      // Customize as needed
    ]);
  }
}
```

## Benefits of This Approach

1. **Centralized Configuration**: All default contexts defined in one place
2. **Build Mode Aware**: Different logging verbosity for debug vs release
3. **Easy to Customize**: Simple to add/remove default contexts
4. **Runtime Flexibility**: Can still enable/disable contexts during execution
5. **Singleton Guarantee**: One logger instance, no confusion
6. **Clear Intent**: Comments explain what each context is for

## Logging Flow Example

```
┌──────────────────────────────────────────────────────────────┐
│  Component calls logger                                       │
│  logger.i('Sync started', context: LogContext.sync);         │
└────────────────────────┬──────────────────────────────────────┘
                         │
                         ▼
┌──────────────────────────────────────────────────────────────┐
│  ConditionalLogger checks enabled contexts                   │
│  if (_enabledContexts.contains(LogContext.sync))             │
└────────────────────────┬──────────────────────────────────────┘
                         │
          ┌──────────────┴──────────────┐
          ▼                             ▼
    ┌──────────┐                  ┌──────────┐
    │ Enabled  │                  │ Disabled │
    │          │                  │          │
    │ Log to   │                  │ Skip     │
    │ console  │                  │ logging  │
    └──────────┘                  └──────────┘
```

## Verification

To verify the logger is configured correctly:

1. Run the app in debug mode
2. Check the console output
3. You should see: `Logger initialized with contexts: {general, sync, database}`

This confirms the logger singleton is working and contexts are enabled.
