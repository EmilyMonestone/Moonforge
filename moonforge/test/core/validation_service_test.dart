import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/services/validation_service.dart';

void main() {
  group('ValidationService', () {
    test('validateRequired returns null for valid value', () {
      expect(ValidationService.validateRequired('test', 'Field'), isNull);
    });

    test('validateRequired returns error for null', () {
      expect(
        ValidationService.validateRequired(null, 'Field'),
        'Field is required',
      );
    });

    test('validateMinLength returns null when sufficient', () {
      expect(ValidationService.validateMinLength('hello', 3, 'Field'), isNull);
    });

    test('validateMinLength returns error when short', () {
      expect(
        ValidationService.validateMinLength('hi', 3, 'Field'),
        'Field must be at least 3 characters',
      );
    });

    test('validateNumberRange returns null for valid', () {
      expect(ValidationService.validateNumberRange(5, 1, 10, 'Field'), isNull);
    });

    test('validateNumberRange returns error when out of range', () {
      expect(
        ValidationService.validateNumberRange(0, 1, 10, 'Field'),
        'Field must be between 1 and 10',
      );
    });
  });
}
