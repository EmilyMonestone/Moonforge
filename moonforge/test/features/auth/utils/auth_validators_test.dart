import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/features/auth/utils/auth_validators.dart';

void main() {
  group('AuthValidators', () {
    group('validateEmail', () {
      test('returns null for valid email', () {
        expect(AuthValidators.validateEmail('test@example.com'), isNull);
        expect(AuthValidators.validateEmail('user.name@domain.co.uk'), isNull);
        expect(AuthValidators.validateEmail('test+tag@example.com'), isNull);
      });

      test('returns error for empty email', () {
        expect(AuthValidators.validateEmail(''), isNotNull);
        expect(AuthValidators.validateEmail(null), isNotNull);
        expect(AuthValidators.validateEmail('   '), isNotNull);
      });

      test('returns error for invalid email format', () {
        expect(AuthValidators.validateEmail('notanemail'), isNotNull);
        expect(AuthValidators.validateEmail('missing@domain'), isNotNull);
        expect(AuthValidators.validateEmail('@nodomain.com'), isNotNull);
        expect(AuthValidators.validateEmail('no@.com'), isNotNull);
      });
    });

    group('validatePassword', () {
      test('returns null for valid password', () {
        expect(AuthValidators.validatePassword('password123'), isNull);
        expect(AuthValidators.validatePassword('123456'), isNull);
        expect(AuthValidators.validatePassword('P@ssw0rd!'), isNull);
      });

      test('returns error for empty password', () {
        expect(AuthValidators.validatePassword(''), isNotNull);
        expect(AuthValidators.validatePassword(null), isNotNull);
      });

      test('returns error for password too short', () {
        expect(AuthValidators.validatePassword('12345'), isNotNull);
        expect(AuthValidators.validatePassword('pass'), isNotNull);
      });
    });

    group('validatePasswordConfirmation', () {
      test('returns null when passwords match', () {
        expect(
          AuthValidators.validatePasswordConfirmation('password123', 'password123'),
          isNull,
        );
      });

      test('returns error when passwords do not match', () {
        expect(
          AuthValidators.validatePasswordConfirmation('password123', 'different'),
          isNotNull,
        );
      });

      test('returns error for empty confirmation', () {
        expect(
          AuthValidators.validatePasswordConfirmation('', 'password123'),
          isNotNull,
        );
        expect(
          AuthValidators.validatePasswordConfirmation(null, 'password123'),
          isNotNull,
        );
      });
    });

    group('validateDisplayName', () {
      test('returns null for valid display name', () {
        expect(AuthValidators.validateDisplayName('John Doe'), isNull);
        expect(AuthValidators.validateDisplayName('User123'), isNull);
        expect(AuthValidators.validateDisplayName('A' * 50), isNull);
      });

      test('returns error for empty display name', () {
        expect(AuthValidators.validateDisplayName(''), isNotNull);
        expect(AuthValidators.validateDisplayName(null), isNotNull);
        expect(AuthValidators.validateDisplayName('   '), isNotNull);
      });

      test('returns error for too short display name', () {
        expect(AuthValidators.validateDisplayName('A'), isNotNull);
      });

      test('returns error for too long display name', () {
        expect(AuthValidators.validateDisplayName('A' * 51), isNotNull);
      });
    });

    group('getPasswordStrength', () {
      test('returns 0 for empty password', () {
        expect(AuthValidators.getPasswordStrength(''), equals(0));
      });

      test('returns low score for weak password', () {
        expect(AuthValidators.getPasswordStrength('pass'), lessThan(2));
      });

      test('returns medium score for fair password', () {
        final score = AuthValidators.getPasswordStrength('password123');
        expect(score, greaterThanOrEqualTo(2));
      });

      test('returns high score for strong password', () {
        final score = AuthValidators.getPasswordStrength('P@ssw0rd123!');
        expect(score, greaterThanOrEqualTo(3));
      });

      test('caps score at 4', () {
        final score = AuthValidators.getPasswordStrength('VeryLongP@ssw0rd123!WithSpecialChars');
        expect(score, lessThanOrEqualTo(4));
      });
    });

    group('getPasswordStrengthLabel', () {
      test('returns correct labels for each strength level', () {
        expect(AuthValidators.getPasswordStrengthLabel(0), equals('Very Weak'));
        expect(AuthValidators.getPasswordStrengthLabel(1), equals('Weak'));
        expect(AuthValidators.getPasswordStrengthLabel(2), equals('Fair'));
        expect(AuthValidators.getPasswordStrengthLabel(3), equals('Good'));
        expect(AuthValidators.getPasswordStrengthLabel(4), equals('Strong'));
      });

      test('returns Unknown for invalid strength', () {
        expect(AuthValidators.getPasswordStrengthLabel(-1), equals('Unknown'));
        expect(AuthValidators.getPasswordStrengthLabel(5), equals('Unknown'));
      });
    });
  });
}
