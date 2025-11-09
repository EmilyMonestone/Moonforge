import 'package:firebase_auth/firebase_auth.dart';

/// Utility class for handling and translating Firebase Auth errors
/// into user-friendly messages.
class AuthErrorHandler {
  AuthErrorHandler._();

  /// Converts a Firebase Auth exception into a user-friendly error message.
  ///
  /// Maps Firebase error codes to localized, understandable messages.
  static String getErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      // Sign in errors
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid credentials. Please check your email and password.';

      // Registration errors
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';

      // Password reset errors
      case 'missing-email':
        return 'Please enter your email address.';
      case 'invalid-action-code':
        return 'This reset link is invalid or has expired.';
      case 'expired-action-code':
        return 'This reset link has expired. Please request a new one.';

      // Account management errors
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign in again.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in method.';

      // Network and general errors
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      // Generic error
      case 'USER_NULL':
        return 'Authentication failed. Please try again.';

      default:
        // Return the Firebase message if available, otherwise a generic error
        return exception.message ?? 'An authentication error occurred. Please try again.';
    }
  }

  /// Returns a shorter error code for logging purposes.
  static String getErrorCode(FirebaseAuthException exception) {
    return exception.code;
  }

  /// Checks if an error is network-related.
  static bool isNetworkError(FirebaseAuthException exception) {
    return exception.code == 'network-request-failed';
  }

  /// Checks if an error requires re-authentication.
  static bool requiresReauth(FirebaseAuthException exception) {
    return exception.code == 'requires-recent-login';
  }

  /// Checks if an error is due to too many attempts.
  static bool isTooManyRequests(FirebaseAuthException exception) {
    return exception.code == 'too-many-requests';
  }
}
