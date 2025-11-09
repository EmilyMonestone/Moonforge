import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/features/auth/utils/auth_error_handler.dart';

void main() {
  group('AuthErrorHandler', () {
    group('getErrorMessage', () {
      test('returns correct message for invalid-email', () {
        final exception = FirebaseAuthException(code: 'invalid-email');
        expect(
          AuthErrorHandler.getErrorMessage(exception),
          equals('The email address is not valid.'),
        );
      });

      test('returns correct message for user-disabled', () {
        final exception = FirebaseAuthException(code: 'user-disabled');
        expect(
          AuthErrorHandler.getErrorMessage(exception),
          contains('disabled'),
        );
      });

      test('returns correct message for user-not-found', () {
        final exception = FirebaseAuthException(code: 'user-not-found');
        expect(
          AuthErrorHandler.getErrorMessage(exception),
          contains('No account found'),
        );
      });

      test('returns correct message for wrong-password', () {
        final exception = FirebaseAuthException(code: 'wrong-password');
        expect(
          AuthErrorHandler.getErrorMessage(exception),
          contains('Incorrect password'),
        );
      });

      test('returns correct message for email-already-in-use', () {
        final exception = FirebaseAuthException(code: 'email-already-in-use');
        expect(
          AuthErrorHandler.getErrorMessage(exception),
          contains('already exists'),
        );
      });

      test('returns correct message for weak-password', () {
        final exception = FirebaseAuthException(code: 'weak-password');
        expect(
          AuthErrorHandler.getErrorMessage(exception),
          contains('too weak'),
        );
      });

      test('returns correct message for network-request-failed', () {
        final exception = FirebaseAuthException(code: 'network-request-failed');
        expect(
          AuthErrorHandler.getErrorMessage(exception),
          contains('Network error'),
        );
      });

      test('returns correct message for too-many-requests', () {
        final exception = FirebaseAuthException(code: 'too-many-requests');
        expect(
          AuthErrorHandler.getErrorMessage(exception),
          contains('Too many attempts'),
        );
      });

      test('returns correct message for requires-recent-login', () {
        final exception = FirebaseAuthException(code: 'requires-recent-login');
        expect(
          AuthErrorHandler.getErrorMessage(exception),
          contains('recent authentication'),
        );
      });

      test('returns Firebase message for unknown error code', () {
        final exception = FirebaseAuthException(
          code: 'unknown-error',
          message: 'Custom error message',
        );
        expect(
          AuthErrorHandler.getErrorMessage(exception),
          equals('Custom error message'),
        );
      });

      test('returns generic message when Firebase message is null', () {
        final exception = FirebaseAuthException(code: 'unknown-error');
        expect(
          AuthErrorHandler.getErrorMessage(exception),
          contains('authentication error'),
        );
      });
    });

    group('getErrorCode', () {
      test('returns the error code', () {
        final exception = FirebaseAuthException(code: 'invalid-email');
        expect(AuthErrorHandler.getErrorCode(exception), equals('invalid-email'));
      });
    });

    group('isNetworkError', () {
      test('returns true for network-request-failed', () {
        final exception = FirebaseAuthException(code: 'network-request-failed');
        expect(AuthErrorHandler.isNetworkError(exception), isTrue);
      });

      test('returns false for other errors', () {
        final exception = FirebaseAuthException(code: 'invalid-email');
        expect(AuthErrorHandler.isNetworkError(exception), isFalse);
      });
    });

    group('requiresReauth', () {
      test('returns true for requires-recent-login', () {
        final exception = FirebaseAuthException(code: 'requires-recent-login');
        expect(AuthErrorHandler.requiresReauth(exception), isTrue);
      });

      test('returns false for other errors', () {
        final exception = FirebaseAuthException(code: 'invalid-email');
        expect(AuthErrorHandler.requiresReauth(exception), isFalse);
      });
    });

    group('isTooManyRequests', () {
      test('returns true for too-many-requests', () {
        final exception = FirebaseAuthException(code: 'too-many-requests');
        expect(AuthErrorHandler.isTooManyRequests(exception), isTrue);
      });

      test('returns false for other errors', () {
        final exception = FirebaseAuthException(code: 'invalid-email');
        expect(AuthErrorHandler.isTooManyRequests(exception), isFalse);
      });
    });
  });
}
