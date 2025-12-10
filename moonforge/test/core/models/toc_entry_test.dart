import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/models/toc_entry.dart';

void main() {
  group('TocEntry', () {
    test('creates a TOC entry with required fields', () {
      final key = GlobalKey();
      final entry = TocEntry(
        key: key,
        title: 'Test Entry',
      );

      expect(entry.key, equals(key));
      expect(entry.title, equals('Test Entry'));
      expect(entry.icon, isNull);
      expect(entry.level, equals(0));
    });

    test('creates a TOC entry with all fields', () {
      final key = GlobalKey();
      final entry = TocEntry(
        key: key,
        title: 'Test Entry',
        icon: Icons.info,
        level: 2,
      );

      expect(entry.key, equals(key));
      expect(entry.title, equals('Test Entry'));
      expect(entry.icon, equals(Icons.info));
      expect(entry.level, equals(2));
    });

    test('equality comparison works correctly', () {
      final key1 = GlobalKey();
      final key2 = GlobalKey();

      final entry1 = TocEntry(key: key1, title: 'Test');
      final entry2 = TocEntry(key: key1, title: 'Test');
      final entry3 = TocEntry(key: key2, title: 'Test');

      expect(entry1, equals(entry2));
      expect(entry1, isNot(equals(entry3)));
    });

    test('hashCode is consistent', () {
      final key = GlobalKey();
      final entry1 = TocEntry(key: key, title: 'Test');
      final entry2 = TocEntry(key: key, title: 'Test');

      expect(entry1.hashCode, equals(entry2.hashCode));
    });
  });
}
