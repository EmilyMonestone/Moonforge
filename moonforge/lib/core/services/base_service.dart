import 'package:moonforge/core/utils/logger.dart';

/// Base class for all service classes.
///
/// Provides common functionality like logging and error handling.
abstract class BaseService {
  /// Service name for logging
  String get serviceName;

  /// Log info message
  void logInfo(String message) {
    logger.i('[$serviceName] $message');
  }

  /// Log error
  void logError(String message, [Object? error, StackTrace? stackTrace]) {
    logger.e('[$serviceName] $message', error: error, stackTrace: stackTrace);
  }

  /// Execute operation with error handling
  Future<T> execute<T>(
    Future<T> Function() operation, {
    String? operationName,
  }) async {
    try {
      logInfo('${operationName ?? "Operation"} started');
      final result = await operation();
      logInfo('${operationName ?? "Operation"} completed');
      return result;
    } catch (error, stackTrace) {
      logError('${operationName ?? "Operation"} failed', error, stackTrace);
      rethrow;
    }
  }
}
