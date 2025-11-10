import 'package:logger/logger.dart';

/// Core logger instance
/// Use this throughout the app for consistent logging
/// Example:
///  logger.i('Informational message');
///  logger.e('Error message', error: exception, stackTrace: stackTrace);
///  logger.d('Debug message');
///  logger.w('Warning message');
Logger logger = Logger(
  printer: PrettyPrinter(
    noBoxingByDefault: true,
    errorMethodCount: 12,
    methodCount: 4,
  ),
);
