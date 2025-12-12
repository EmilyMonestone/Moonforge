import 'package:moonforge/core/utils/logger.dart';

/// Example: How to use conditional logging in Moonforge
///
/// This file demonstrates practical usage patterns for the conditional logging feature.
void main() {
  // ============================================================================
  // EXAMPLE 1: Default behavior - general logs always shown
  // ============================================================================
  
  logger.i('App started'); // This will be logged
  logger.d('Debug info'); // This will be logged
  
  // ============================================================================
  // EXAMPLE 2: Context-specific logging (disabled by default)
  // ============================================================================
  
  // These won't be logged unless the context is enabled
  logger.i('Sync operation started', context: LogContext.sync);
  logger.d('Database query: SELECT * FROM campaigns', context: LogContext.database);
  logger.w('Network timeout', context: LogContext.network);
  
  // ============================================================================
  // EXAMPLE 3: Debugging sync issues
  // ============================================================================
  
  print('\n=== Debugging Sync Issues ===');
  
  // Enable sync logging to see what's happening
  logger.enableContext(LogContext.sync);
  
  // Now these logs will appear
  logger.i('SyncCoordinator started', context: LogContext.sync);
  logger.d('Processing 5 outbox entries', context: LogContext.sync);
  logger.i('Sync completed successfully', context: LogContext.sync);
  
  // Disable when done debugging
  logger.disableContext(LogContext.sync);
  
  // This won't be logged anymore
  logger.d('Hidden sync log', context: LogContext.sync);
  
  // ============================================================================
  // EXAMPLE 4: Errors are always logged
  // ============================================================================
  
  print('\n=== Error Handling ===');
  
  // Even if sync context is disabled, errors are ALWAYS logged
  logger.e('Sync failed: Connection timeout', context: LogContext.sync);
  logger.f('Fatal database corruption', context: LogContext.database);
  
  // ============================================================================
  // EXAMPLE 5: Debugging multiple areas simultaneously
  // ============================================================================
  
  print('\n=== Multi-Context Debugging ===');
  
  // Enable multiple contexts to debug interactions
  logger.enableContexts([
    LogContext.sync,
    LogContext.database,
    LogContext.network,
  ]);
  
  // All of these will now be logged
  logger.i('Starting sync', context: LogContext.sync);
  logger.d('DB transaction started', context: LogContext.database);
  logger.d('HTTP POST to /api/campaigns', context: LogContext.network);
  logger.i('Sync and DB operations complete', context: LogContext.sync);
  
  // Clean up - disable all at once
  logger.disableContexts([
    LogContext.sync,
    LogContext.database,
    LogContext.network,
  ]);
  
  // ============================================================================
  // EXAMPLE 6: Conditional debugging code
  // ============================================================================
  
  print('\n=== Conditional Code Execution ===');
  
  // Check if a context is enabled before doing expensive operations
  if (logger.isContextEnabled(LogContext.sync)) {
    // Only compute this expensive debug info if we're actually logging it
    final debugInfo = computeExpensiveDebugInfo();
    logger.d('Detailed sync state: $debugInfo', context: LogContext.sync);
  }
  
  // ============================================================================
  // EXAMPLE 7: Real-world debugging session
  // ============================================================================
  
  print('\n=== Real-World Debugging Session ===');
  
  // User reports: "My campaigns aren't syncing"
  
  // Step 1: Enable sync logging
  logger.enableContext(LogContext.sync);
  
  // Step 2: Reproduce the issue
  simulateSyncOperation();
  
  // Step 3: Review logs (they'll show in console)
  // - Check if SyncCoordinator started
  // - Check if auth succeeded
  // - Check if InboundListener subscribed
  // - Check if OutboxProcessor flushed
  
  // Step 4: If you need more detail, enable database context too
  logger.enableContext(LogContext.database);
  
  // Step 5: Try again
  simulateSyncOperation();
  
  // Step 6: Found the issue! Clean up
  logger.disableContexts([LogContext.sync, LogContext.database]);
  
  // ============================================================================
  // EXAMPLE 8: Production-safe patterns
  // ============================================================================
  
  print('\n=== Production Patterns ===');
  
  // In production, you might only enable contexts during support sessions
  final isDebugSession = false; // Set via remote config or support flag
  
  if (isDebugSession) {
    logger.enableContexts([LogContext.sync, LogContext.database]);
  }
  
  // Logs will only appear during debug sessions
  logger.i('Campaign sync triggered', context: LogContext.sync);
  
  // But errors ALWAYS get through
  logger.e('Failed to save campaign', context: LogContext.database);
}

// Mock functions for the example
String computeExpensiveDebugInfo() {
  return 'Mock debug info';
}

void simulateSyncOperation() {
  logger.i('SyncCoordinator: Starting...', context: LogContext.sync);
  logger.d('InboundListener: Subscribed to campaigns', context: LogContext.sync);
  logger.d('OutboxProcessor: Flushing 3 entries', context: LogContext.sync);
  logger.i('Sync completed', context: LogContext.sync);
}
