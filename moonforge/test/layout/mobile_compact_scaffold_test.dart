import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/layout/widgets/mobile_compact_scaffold.dart';

void main() {
  testWidgets('MobileCompactScaffold shows bottom navigation', (
    tester,
  ) async {
    final tabs = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MobileCompactScaffold(
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

  testWidgets('MobileCompactScaffold handles overflow with NavigationRail', (
    tester,
  ) async {
    final tabs = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.settings, 'label': 'Settings'},
      {'icon': Icons.search, 'label': 'Search'},
      {'icon': Icons.person, 'label': 'Profile'},
      {'icon': Icons.notifications, 'label': 'Notifications'},
      {'icon': Icons.message, 'label': 'Messages'},
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MobileCompactScaffold(
          tabs: tabs,
          body: const SizedBox.shrink(),
          selectedIndex: 0,
          onSelect: (c, i) {},
          breadcrumbs: const SizedBox.shrink(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Should show NavigationBar for first 5 tabs
    expect(find.byType(NavigationBar), findsOneWidget);
    // Should show NavigationRail for overflow tabs
    expect(find.byType(NavigationRail), findsOneWidget);
  });
}
