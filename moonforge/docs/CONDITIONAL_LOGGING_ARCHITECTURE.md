# Conditional Logging Architecture

## Overview Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                     Application Code                             │
│  (Any component can use logger with optional context)           │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│              ConditionalLogger (logger instance)                 │
│                                                                   │
│  ┌──────────────────────────────────────────────────┐          │
│  │  Enabled Contexts Set                             │          │
│  │  { general, sync }  ← User can modify at runtime │          │
│  └──────────────────────────────────────────────────┘          │
│                                                                   │
│  Methods:                                                        │
│  • enableContext(LogContext)                                    │
│  • disableContext(LogContext)                                   │
│  • isContextEnabled(LogContext) → bool                          │
│  • d/i/w/e/f(message, context: LogContext)                      │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
                   ┌──────────┐
                   │  Filter   │
                   │  Logic    │
                   └─────┬────┘
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
    ┌─────────┐    ┌─────────┐    ┌─────────┐
    │ Context │    │ Error/  │    │ Context │
    │ Enabled │    │ Fatal   │    │Disabled │
    │         │    │ Always  │    │         │
    │   ✅    │    │  Log    │    │   ❌    │
    └────┬────┘    └────┬────┘    └────┬────┘
         │              │              │
         └──────┬───────┴──────────────┘
                ▼
    ┌───────────────────────┐
    │    Base Logger        │
    │  (PrettyPrinter)      │
    │                       │
    │    Output to          │
    │    Console            │
    └───────────────────────┘
```

## LogContext Categories

```
┌──────────────────────────────────────────────────────────┐
│                    LogContext Enum                        │
├──────────────────────────────────────────────────────────┤
│                                                           │
│  general      ← Always enabled, cannot be disabled       │
│  sync         ← SyncCoordinator, InboundListener, etc.   │
│  database     ← Database operations                       │
│  auth         ← Authentication & user management          │
│  navigation   ← Navigation & routing                      │
│  ui           ← UI state & widget lifecycle              │
│  network      ← Network requests & responses              │
│  data         ← Data parsing & transformation            │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

## Sync Component Instrumentation

```
┌─────────────────────────────────────────────────────────────┐
│                    Sync Components                           │
│                 (All use LogContext.sync)                    │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────────────────────────────────────────────┐           │
│  │  SyncCoordinator                             │           │
│  │  • Initialization                            │           │
│  │  • Start/Stop events                         │           │
│  │  • Auth state changes                        │           │
│  │  • Push loop operations                      │           │
│  │  • Flush operations                          │           │
│  └─────────────────────────────────────────────┘           │
│                                                              │
│  ┌─────────────────────────────────────────────┐           │
│  │  InboundListener                             │           │
│  │  • Start/Stop with subscription counts       │           │
│  │  • Firestore snapshot changes                │           │
│  │  • Campaign sync operations                  │           │
│  │  • Related entity sync (chapters, etc.)      │           │
│  └─────────────────────────────────────────────┘           │
│                                                              │
│  ┌─────────────────────────────────────────────┐           │
│  │  OutboxProcessor                             │           │
│  │  • Flush with pending item counts            │           │
│  │  • Individual entry processing               │           │
│  │  • Success/Error counts                      │           │
│  │  • Upsert/Delete operations                  │           │
│  └─────────────────────────────────────────────┘           │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Usage Flow

```
┌────────────────────────────────────────────────────────────┐
│              Typical Debugging Workflow                     │
└────────────────────────────────────────────────────────────┘

  1. Issue Reported: "Sync not working"
     │
     ▼
  2. Enable sync logging
     logger.enableContext(LogContext.sync)
     │
     ▼
  3. Reproduce the issue
     │
     ▼
  4. Review logs (now visible):
     ✅ SyncCoordinator: Starting...
     ✅ InboundListener: Starting for user xxx
     ✅ OutboxProcessor: Flushing 5 entries
     │
     ▼
  5. Identify the problem from detailed logs
     │
     ▼
  6. Fix the issue
     │
     ▼
  7. Disable sync logging
     logger.disableContext(LogContext.sync)
     │
     ▼
  8. Done! No code changes needed for logging
```

## Performance Optimization Pattern

```dart
// ❌ BAD - Always computes expensive debug info
logger.d('Data: ${computeExpensiveOperation()}', context: LogContext.sync);

// Even if LogContext.sync is disabled, computeExpensiveOperation() 
// still runs because it's in the parameter expression!

┌──────────────────────────────────────────────────────┐
│                                                       │
│  String interpolation happens BEFORE method call     │
│                                                       │
└──────────────────────────────────────────────────────┘

// ✅ GOOD - Only computes when context is enabled
if (logger.isContextEnabled(LogContext.sync)) {
  final debugInfo = computeExpensiveOperation();
  logger.d('Data: $debugInfo', context: LogContext.sync);
}

┌──────────────────────────────────────────────────────┐
│                                                       │
│  Expensive operation skipped when context disabled   │
│                                                       │
└──────────────────────────────────────────────────────┘
```

## Error Handling

```
┌────────────────────────────────────────────────────────────┐
│              Error/Fatal Message Flow                       │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  logger.e('Error', context: LogContext.sync)               │
│  logger.f('Fatal', context: LogContext.database)           │
│                                                             │
│         ↓                                                   │
│                                                             │
│  ┌─────────────────────────────────────┐                  │
│  │  Context Check: BYPASSED             │                  │
│  │  Errors always log regardless        │                  │
│  │  of context enable/disable state     │                  │
│  └─────────────────────────────────────┘                  │
│                                                             │
│         ↓                                                   │
│                                                             │
│  ✅ ALWAYS LOGGED                                          │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

## Key Benefits

1. **No Code Churn**: Enable/disable logging without editing source files
2. **Targeted Debugging**: Focus on specific areas (e.g., sync only)
3. **Production Safe**: Disable verbose logging in production
4. **Performance**: Skip expensive debug operations when context disabled
5. **Error Safety**: Critical errors always logged
6. **Easy to Use**: Simple API (enableContext/disableContext)
7. **Backward Compatible**: Existing code continues to work

## Testing Coverage

```
┌────────────────────────────────────────────────────────────┐
│             logger_test.dart Coverage                       │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  ✅ Context enable/disable                                 │
│  ✅ Multiple context operations                            │
│  ✅ Message filtering by context                           │
│  ✅ Error messages always logged                           │
│  ✅ Fatal messages always logged                           │
│  ✅ Debug/Info/Warning respect context                     │
│  ✅ General context cannot be disabled                     │
│  ✅ isContextEnabled checks                                │
│  ✅ Global logger instance                                 │
│                                                             │
│  Total: 173 lines of test code                             │
│                                                             │
└────────────────────────────────────────────────────────────┘
```
