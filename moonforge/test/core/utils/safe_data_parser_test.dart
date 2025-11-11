import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/utils/safe_data_parser.dart';

void main() {
  group('SafeDataParser - DateTime parsing', () {
    test('parses ISO8601 datetime strings', () {
      final result = SafeDataParser.tryParseDateTime('2024-01-15T10:30:00Z');
      expect(result, isNotNull);
      expect(result!.year, 2024);
      expect(result.month, 1);
      expect(result.day, 15);
    });

    test('parses malformed epoch with trailing Z', () {
      // This is the actual error from the issue: "1761490548Z"
      final result = SafeDataParser.tryParseDateTime('1761490548Z');
      expect(result, isNotNull);
      // 1761490548 seconds = Wed Oct 21 2025 (approx)
      expect(result!.year, greaterThanOrEqualTo(2025));
    });

    test('parses epoch in seconds', () {
      final result = SafeDataParser.tryParseDateTime(1609459200);
      expect(result, isNotNull);
      // 1609459200 seconds = Jan 1, 2021
      expect(result!.year, 2021);
      expect(result.month, 1);
      expect(result.day, 1);
    });

    test('parses epoch in milliseconds', () {
      final result = SafeDataParser.tryParseDateTime(1609459200000);
      expect(result, isNotNull);
      // 1609459200000 ms = Jan 1, 2021
      expect(result!.year, 2021);
      expect(result.month, 1);
      expect(result.day, 1);
    });

    test('parses string epoch in seconds', () {
      final result = SafeDataParser.tryParseDateTime('1609459200');
      expect(result, isNotNull);
      expect(result!.year, 2021);
    });

    test('parses string epoch in milliseconds', () {
      final result = SafeDataParser.tryParseDateTime('1609459200000');
      expect(result, isNotNull);
      expect(result!.year, 2021);
    });

    test('handles DateTime objects', () {
      final now = DateTime.now();
      final result = SafeDataParser.tryParseDateTime(now);
      expect(result, equals(now));
    });

    test('returns null for invalid strings', () {
      expect(SafeDataParser.tryParseDateTime('invalid'), isNull);
      expect(SafeDataParser.tryParseDateTime('not-a-date'), isNull);
      expect(SafeDataParser.tryParseDateTime('abc123'), isNull);
    });

    test('returns null for null input', () {
      expect(SafeDataParser.tryParseDateTime(null), isNull);
    });

    test('returns null for empty string', () {
      expect(SafeDataParser.tryParseDateTime(''), isNull);
      expect(SafeDataParser.tryParseDateTime('   '), isNull);
    });

    test('handles double values', () {
      final result = SafeDataParser.tryParseDateTime(1609459200000.0);
      expect(result, isNotNull);
      expect(result!.year, 2021);
    });
  });

  group('SafeDataParser - List<String> parsing', () {
    test('parses valid JSON array strings', () {
      final result = SafeDataParser.tryParseStringList('["a", "b", "c"]');
      expect(result, equals(['a', 'b', 'c']));
    });

    test('handles List<String> directly', () {
      final input = ['x', 'y', 'z'];
      final result = SafeDataParser.tryParseStringList(input);
      expect(result, equals(['x', 'y', 'z']));
    });

    test('converts mixed list types to strings', () {
      final result = SafeDataParser.tryParseStringList([1, 'two', 3.0]);
      expect(result, equals(['1', 'two', '3.0']));
    });

    test('filters out null and empty values', () {
      final result = SafeDataParser.tryParseStringList([null, 'a', '', 'b']);
      expect(result, equals(['a', 'b']));
    });

    test('returns empty list for null input', () {
      expect(SafeDataParser.tryParseStringList(null), isEmpty);
    });

    test('returns empty list for empty string', () {
      expect(SafeDataParser.tryParseStringList(''), isEmpty);
      expect(SafeDataParser.tryParseStringList('   '), isEmpty);
    });

    test('returns empty list for invalid JSON', () {
      expect(SafeDataParser.tryParseStringList('not-json'), isEmpty);
      expect(SafeDataParser.tryParseStringList('{invalid}'), isEmpty);
    });

    test('returns empty list for non-array JSON', () {
      expect(SafeDataParser.tryParseStringList('{"key": "value"}'), isEmpty);
      expect(SafeDataParser.tryParseStringList('123'), isEmpty);
    });
  });

  group('SafeDataParser - List<Map<String, dynamic>> parsing', () {
    test('parses valid JSON array of objects', () {
      final result = SafeDataParser.tryParseMapList('[{"a":1}, {"b":2}]');
      expect(result, hasLength(2));
      expect(result[0], equals({'a': 1}));
      expect(result[1], equals({'b': 2}));
    });

    test('handles List<Map<String, dynamic>> directly', () {
      final input = [
        {'x': 1},
        {'y': 2}
      ];
      final result = SafeDataParser.tryParseMapList(input);
      expect(result, hasLength(2));
      expect(result[0], equals({'x': 1}));
    });

    test('filters out non-map values', () {
      final result = SafeDataParser.tryParseMapList([
        {'a': 1},
        'not-a-map',
        123,
        {'b': 2}
      ]);
      expect(result, hasLength(2));
      expect(result[0], equals({'a': 1}));
      expect(result[1], equals({'b': 2}));
    });

    test('returns empty list for null input', () {
      expect(SafeDataParser.tryParseMapList(null), isEmpty);
    });

    test('returns empty list for invalid JSON', () {
      expect(SafeDataParser.tryParseMapList('invalid'), isEmpty);
    });

    test('returns empty list for non-array JSON', () {
      expect(SafeDataParser.tryParseMapList('{"key": "value"}'), isEmpty);
    });
  });

  group('SafeDataParser - Map<String, dynamic> parsing', () {
    test('parses valid JSON object strings', () {
      final result = SafeDataParser.tryParseMap('{"a": 1, "b": "two"}');
      expect(result, equals({'a': 1, 'b': 'two'}));
    });

    test('handles Map<String, dynamic> directly', () {
      final input = {'x': 1, 'y': 'two'};
      final result = SafeDataParser.tryParseMap(input);
      expect(result, equals({'x': 1, 'y': 'two'}));
    });

    test('converts generic Map to Map<String, dynamic>', () {
      final input = <dynamic, dynamic>{'key': 'value', 1: 2};
      final result = SafeDataParser.tryParseMap(input);
      expect(result, isA<Map<String, dynamic>>());
    });

    test('returns empty map for null input', () {
      expect(SafeDataParser.tryParseMap(null), isEmpty);
    });

    test('returns empty map for empty string', () {
      expect(SafeDataParser.tryParseMap(''), isEmpty);
      expect(SafeDataParser.tryParseMap('   '), isEmpty);
    });

    test('returns empty map for invalid JSON', () {
      expect(SafeDataParser.tryParseMap('not-json'), isEmpty);
      expect(SafeDataParser.tryParseMap('[1,2,3]'), isEmpty);
    });
  });

  group('SafeDataParser - DateTime conversion helpers', () {
    test('converts DateTime to epoch milliseconds', () {
      final dateTime = DateTime.utc(2021, 1, 1);
      final result = SafeDataParser.dateTimeToEpochMs(dateTime);
      expect(result, equals(1609459200000));
    });

    test('converts DateTime to ISO8601 string', () {
      final dateTime = DateTime.utc(2024, 1, 15, 10, 30, 0);
      final result = SafeDataParser.dateTimeToIso8601(dateTime);
      expect(result, equals('2024-01-15T10:30:00.000Z'));
    });

    test('returns null for null DateTime in epoch conversion', () {
      expect(SafeDataParser.dateTimeToEpochMs(null), isNull);
    });

    test('returns null for null DateTime in ISO8601 conversion', () {
      expect(SafeDataParser.dateTimeToIso8601(null), isNull);
    });
  });
}
