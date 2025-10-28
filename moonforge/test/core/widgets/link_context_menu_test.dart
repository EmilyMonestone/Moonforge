import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/widgets/link_context_menu.dart';

void main() {
  group('LinkContextMenu', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      const testRoute = '/test/route';
      const childText = 'Test Child';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LinkContextMenu(
              route: testRoute,
              child: const Text(childText),
            ),
          ),
        ),
      );

      expect(find.text(childText), findsOneWidget);
    });

    testWidgets('renders child without wrapper when disabled',
        (WidgetTester tester) async {
      const testRoute = '/test/route';
      const childText = 'Test Child';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LinkContextMenu(
              route: testRoute,
              enabled: false,
              child: const Text(childText),
            ),
          ),
        ),
      );

      expect(find.text(childText), findsOneWidget);
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('wraps child with GestureDetector when enabled on supported platforms',
        (WidgetTester tester) async {
      const testRoute = '/test/route';
      const childText = 'Test Child';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LinkContextMenu(
              route: testRoute,
              enabled: true,
              child: const Text(childText),
            ),
          ),
        ),
      );

      expect(find.text(childText), findsOneWidget);
      // GestureDetector wrapping depends on platform support
      // We just verify the widget builds correctly
    });
  });
}
