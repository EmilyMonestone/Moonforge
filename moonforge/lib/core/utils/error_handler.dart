import 'package:moonforge/core/utils/logger.dart';

class ErrorHandler {
  const ErrorHandler._();

  static String message(Object error) {
    if (error is UserFriendlyError) {
      return error.message;
    }
    return 'Something went wrong. Please try again.';
  }

  static void log(Object error, [StackTrace? stackTrace]) {
    logger.e('Async error', error: error, stackTrace: stackTrace);
  }
}

class UserFriendlyError implements Exception {
  final String message;

  const UserFriendlyError(this.message);

  @override
  String toString() => message;
}
