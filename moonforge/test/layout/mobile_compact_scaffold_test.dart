import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/layout/destinations.dart';
import 'package:moonforge/layout/widgets/mobile_compact_scaffold.dart';

void main() {
  testWidgets('MobileCompactScaffold shows bottom navigation', (
    tester,
  ) async {
    final tabs = [
      const TabSpec(icon: Icons.home, label: 'Home', location: '/'),
      const TabSpec(icon: Icons.settings, label: 'Settings', location: '/settings'),
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
      const TabSpec(icon: Icons.home, label: 'Home', location: '/'),
      const TabSpec(icon: Icons.settings, label: 'Settings', location: '/settings'),
      const TabSpec(icon: Icons.search, label: 'Search', location: '/search'),
      const TabSpec(icon: Icons.person, label: 'Profile', location: '/profile'),
      const TabSpec(icon: Icons.notifications, label: 'Notifications', location: '/notifications'),
      const TabSpec(icon: Icons.message, label: 'Messages', location: '/messages'),
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
