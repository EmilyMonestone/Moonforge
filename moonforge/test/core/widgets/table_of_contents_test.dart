import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/controllers/toc_controller.dart';
import 'package:moonforge/core/models/toc_entry.dart';
import 'package:moonforge/core/widgets/table_of_contents.dart';

void main() {
  group('TableOfContents', () {
    testWidgets('renders empty TOC when no entries', (tester) async {
      final scrollController = ScrollController();
      final controller = TocController(
        scrollController: scrollController,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableOfContents(controller: controller),
          ),
        ),
      );

      expect(find.byType(TableOfContents), findsOneWidget);
      expect(find.text('Contents'), findsNothing);

      scrollController.dispose();
      controller.dispose();
    });

    testWidgets('renders TOC with entries', (tester) async {
      final scrollController = ScrollController();
      final entries = [
        TocEntry(key: GlobalKey(), title: 'Entry 1', icon: Icons.info),
        TocEntry(key: GlobalKey(), title: 'Entry 2', icon: Icons.star),
      ];
      final controller = TocController(
        scrollController: scrollController,
        entries: entries,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableOfContents(controller: controller),
          ),
        ),
      );

      expect(find.text('Contents'), findsOneWidget);
      expect(find.text('Entry 1'), findsOneWidget);
      expect(find.text('Entry 2'), findsOneWidget);

      scrollController.dispose();
      controller.dispose();
    });

    testWidgets('highlights active entry', (tester) async {
      final scrollController = ScrollController();
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

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableOfContents(controller: controller),
          ),
        ),
      );

      // Set first entry as active
      controller.setActiveEntry(key1);
      await tester.pump();

      // Find the container for the first entry
      final firstEntryContainers = find.ancestor(
        of: find.text('Entry 1'),
        matching: find.byType(Container),
      );
      expect(firstEntryContainers, findsWidgets);

      scrollController.dispose();
      controller.dispose();
    });
  });

  group('TocButton', () {
    testWidgets('does not render when no entries', (tester) async {
      final scrollController = ScrollController();
      final controller = TocController(
        scrollController: scrollController,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TocButton(controller: controller),
          ),
        ),
      );

      expect(find.byType(IconButton), findsNothing);

      scrollController.dispose();
      controller.dispose();
    });

    testWidgets('renders button when entries exist', (tester) async {
      final scrollController = ScrollController();
      final entries = [
        TocEntry(key: GlobalKey(), title: 'Entry 1'),
      ];
      final controller = TocController(
        scrollController: scrollController,
        entries: entries,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TocButton(controller: controller),
          ),
        ),
      );

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.list_outlined), findsOneWidget);

      scrollController.dispose();
      controller.dispose();
    });

    testWidgets('opens bottom sheet when tapped', (tester) async {
      final scrollController = ScrollController();
      final entries = [
        TocEntry(key: GlobalKey(), title: 'Entry 1'),
        TocEntry(key: GlobalKey(), title: 'Entry 2'),
      ];
      final controller = TocController(
        scrollController: scrollController,
        entries: entries,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TocButton(controller: controller),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify bottom sheet is shown
      expect(find.text('Contents'), findsOneWidget);
      expect(find.text('Entry 1'), findsOneWidget);
      expect(find.text('Entry 2'), findsOneWidget);

      scrollController.dispose();
      controller.dispose();
    });
  });
}
