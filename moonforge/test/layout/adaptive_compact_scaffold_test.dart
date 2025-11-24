import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/layout/widgets/adaptive_compact_scaffold.dart';

void main() {
  testWidgets('AdaptiveCompactScaffold shows bottom navigation', (
    tester,
  ) async {
    final tabs = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: AdaptiveCompactScaffold(
          tabs: tabs,
          body: const SizedBox.shrink(),
          selectedIndex: 0,
          onSelect: (c, i) {},
          breadcrumbs: const SizedBox.shrink(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(BottomNavigationBar), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
