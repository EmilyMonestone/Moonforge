import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';

void main() {
  group('DateTime Utils', () {
    group('isValidDateTime', () {
      test('returns false for null', () {
        expect(isValidDateTime(null), isFalse);
      });

      test('returns false for dates before 1900', () {
        expect(isValidDateTime(DateTime(1899, 12, 31)), isFalse);
        expect(isValidDateTime(DateTime(1800)), isFalse);
        expect(isValidDateTime(DateTime(0)), isFalse);
        // This is the problematic sentinel value from the issue
        expect(isValidDateTime(DateTime.fromMicrosecondsSinceEpoch(0)), isFalse);
      });

      test('returns true for valid dates from 1900 onwards', () {
        expect(isValidDateTime(DateTime(1900, 1, 1)), isTrue);
        expect(isValidDateTime(DateTime(2000)), isTrue);
        expect(isValidDateTime(DateTime(2024)), isTrue);
        expect(isValidDateTime(DateTime.now()), isTrue);
      });
    });

    group('formatDateTime', () {
      test('returns placeholder for null', () {
        expect(formatDateTime(null), equals('—'));
      });

      test('returns custom placeholder for null', () {
        expect(formatDateTime(null, placeholder: 'N/A'), equals('N/A'));
      });

      test('returns placeholder for invalid dates', () {
        expect(formatDateTime(DateTime(1899)), equals('—'));
        expect(formatDateTime(DateTime(0)), equals('—'));
      });

      test('returns formatted string for valid dates', () {
        final testDate = DateTime(2024, 10, 26, 13, 30, 45);
        final result = formatDateTime(testDate);
        // Just check it's not the placeholder and contains some date parts
        expect(result, isNot(equals('—')));
        expect(result, contains('2024'));
        expect(result, contains('10'));
        expect(result, contains('26'));
      });

      test('converts to local time', () {
        final utcDate = DateTime.utc(2024, 10, 26, 13, 30);
        final result = formatDateTime(utcDate);
        expect(result, isNot(equals('—')));
        // The result should be in local time, not UTC
        expect(result, isNot(contains('Z')));
      });
    });
  });
}
