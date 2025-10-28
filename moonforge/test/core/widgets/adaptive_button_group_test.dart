import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/models/menu_bar_actions.dart';
import 'package:moonforge/core/widgets/adaptive_button_group.dart';

void main() {
  group('AdaptiveButtonGroup', () {
    testWidgets('renders empty when no actions', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AdaptiveButtonGroup(
              actions: [],
              showLabels: true,
            ),
          ),
        ),
      );

      expect(find.byType(AdaptiveButtonGroup), findsOneWidget);
    });

    testWidgets('renders single action', (WidgetTester tester) async {
      final action = MenuBarAction(
        label: 'Save',
        icon: Icons.save,
        onPressed: (context) {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveButtonGroup(
              actions: [action],
              showLabels: true,
            ),
          ),
        ),
      );

      expect(find.text('Save'), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('renders multiple actions', (WidgetTester tester) async {
      final actions = [
        MenuBarAction(
          label: 'Save',
          icon: Icons.save,
          onPressed: (context) {},
        ),
        MenuBarAction(
          label: 'Delete',
          icon: Icons.delete,
          onPressed: (context) {},
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveButtonGroup(
              actions: actions,
              showLabels: true,
            ),
          ),
        ),
      );

      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('handles button press', (WidgetTester tester) async {
      bool pressed = false;
      final action = MenuBarAction(
        label: 'Test',
        icon: Icons.check,
        onPressed: (context) => pressed = true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveButtonGroup(
              actions: [action],
              showLabels: true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test'));
      await tester.pump();
      expect(pressed, isTrue);
    });

    testWidgets('respects maxWidth constraint', (WidgetTester tester) async {
      final actions = [
        MenuBarAction(
          label: 'Action1',
          onPressed: (context) {},
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveButtonGroup(
              actions: actions,
              showLabels: true,
              maxWidth: 300,
            ),
          ),
        ),
      );

      final widget = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(widget.width, equals(300));
    });
  });
}
