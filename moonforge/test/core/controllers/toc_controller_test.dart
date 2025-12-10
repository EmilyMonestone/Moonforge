import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/controllers/toc_controller.dart';
import 'package:moonforge/core/models/toc_entry.dart';

void main() {
  group('TocController', () {
    late ScrollController scrollController;

    setUp(() {
      scrollController = ScrollController();
    });

    tearDown(() {
      scrollController.dispose();
    });

    test('initializes with empty entries', () {
      final controller = TocController(
        scrollController: scrollController,
      );

      expect(controller.entries, isEmpty);
      expect(controller.activeKey, isNull);

      controller.dispose();
    });

    test('initializes with provided entries', () {
      final entries = [
        TocEntry(key: GlobalKey(), title: 'Entry 1'),
        TocEntry(key: GlobalKey(), title: 'Entry 2'),
      ];

      final controller = TocController(
        scrollController: scrollController,
        entries: entries,
      );

      expect(controller.entries, equals(entries));
      expect(controller.activeKey, isNull);

      controller.dispose();
    });

    test('updates entries', () {
      final controller = TocController(
        scrollController: scrollController,
      );

      final entries = [
        TocEntry(key: GlobalKey(), title: 'Entry 1'),
        TocEntry(key: GlobalKey(), title: 'Entry 2'),
      ];

      controller.updateEntries(entries);

      expect(controller.entries, equals(entries));

      controller.dispose();
    });

    test('sets active entry', () {
      final key1 = GlobalKey();
      final key2 = GlobalKey();
      final entries = [
        TocEntry(key: key1, title: 'Entry 1'),
        TocEntry(key: key2, title: 'Entry 2'),
      ];

      final controller = TocController(
        scrollController: scrollController,
        entries: entries,
      );

      controller.setActiveEntry(key1);
      expect(controller.activeKey, equals(key1));

      controller.setActiveEntry(key2);
      expect(controller.activeKey, equals(key2));

      controller.dispose();
    });

    test('notifies listeners when active entry changes', () {
      final key = GlobalKey();
      final controller = TocController(
        scrollController: scrollController,
        entries: [TocEntry(key: key, title: 'Entry')],
      );

      var notified = false;
      controller.addListener(() {
        notified = true;
      });

      controller.setActiveEntry(key);
      expect(notified, isTrue);

      controller.dispose();
    });

    test('does not notify when setting same active entry', () {
      final key = GlobalKey();
      final controller = TocController(
        scrollController: scrollController,
        entries: [TocEntry(key: key, title: 'Entry')],
      );

      controller.setActiveEntry(key);

      var notificationCount = 0;
      controller.addListener(() {
        notificationCount++;
      });

      controller.setActiveEntry(key);
      expect(notificationCount, equals(0));

      controller.dispose();
    });
  });
}
