import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/widgets/adaptive_breadcrumb.dart';

void main() {
  group('AdaptiveBreadcrumb', () {
    testWidgets('renders single item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveBreadcrumb(
              items: const [
                AdaptiveBreadcrumbItem(content: Text('Home')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('renders multiple items with dividers', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveBreadcrumb(
              items: const [
                AdaptiveBreadcrumbItem(content: Text('Home')),
                AdaptiveBreadcrumbItem(content: Text('Campaign')),
                AdaptiveBreadcrumbItem(content: Text('Chapter')),
              ],
              divider: const Icon(Icons.chevron_right),
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Campaign'), findsOneWidget);
      expect(find.text('Chapter'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsWidgets);
    });

    testWidgets('handles tap on item', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveBreadcrumb(
              items: [
                AdaptiveBreadcrumbItem(
                  content: const Text('Home'),
                  onTap: () => tapped = true,
                ),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.text('Home'));
      expect(tapped, isTrue);
    });

    testWidgets('respects maxWidth constraint', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdaptiveBreadcrumb(
              items: const [
                AdaptiveBreadcrumbItem(content: Text('Home')),
                AdaptiveBreadcrumbItem(content: Text('Campaign')),
              ],
              maxWidth: 200,
            ),
          ),
        ),
      );

      final widget = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(widget.width, equals(200));
    });
  });
}
