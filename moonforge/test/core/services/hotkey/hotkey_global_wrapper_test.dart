import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/services/hotkey/hotkey_global_wrapper.dart';

void main() {
  group('HotkeyGlobalWrapper', () {
    testWidgets('should initialize without throwing', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HotkeyGlobalWrapper(
            child: Scaffold(
              body: Text('Test'),
            ),
          ),
        ),
      );

      // Allow initialization to complete
      await tester.pumpAndSettle();

      // Verify the child is rendered
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should not throw when disposed', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HotkeyGlobalWrapper(
            child: Scaffold(
              body: Text('Test'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Dispose by replacing with a different widget
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Text('Different'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Test passes if no exception is thrown during disposal
    });

    testWidgets('should handle empty shortcuts list gracefully',
        (WidgetTester tester) async {
      // This tests that the wrapper handles the case where shortcuts
      // haven't been initialized yet (empty list)
      await tester.pumpWidget(
        const MaterialApp(
          home: HotkeyGlobalWrapper(
            child: Scaffold(
              body: Text('Test'),
            ),
          ),
        ),
      );

      // Immediately after first build, shortcuts may not be loaded yet
      await tester.pump();

      // Verify no exception is thrown
      expect(find.text('Test'), findsOneWidget);

      // Allow full initialization
      await tester.pumpAndSettle();
    });
  });
}
