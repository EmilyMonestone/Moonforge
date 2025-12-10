import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/layout/destinations.dart';
import 'package:moonforge/layout/widgets/mobile_wide_scaffold.dart';

void main() {
  testWidgets('MobileWideScaffold builds rail', (tester) async {
    final tabs = [
      const TabSpec(icon: Icons.home, label: 'Home', location: '/'),
      const TabSpec(icon: Icons.settings, label: 'Settings', location: '/settings'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MobileWideScaffold(
          tabs: tabs,
          body: const SizedBox.shrink(),
          selectedIndex: 0,
          onSelect: (c, i) {},
          breadcrumbs: const SizedBox.shrink(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
  });

  testWidgets('MobileWideScaffold does not show bottom navigation', (
    tester,
  ) async {
    final tabs = [
      const TabSpec(icon: Icons.home, label: 'Home', location: '/'),
      const TabSpec(icon: Icons.settings, label: 'Settings', location: '/settings'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: MobileWideScaffold(
          tabs: tabs,
          body: const SizedBox.shrink(),
          selectedIndex: 0,
          onSelect: (c, i) {},
          breadcrumbs: const SizedBox.shrink(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(BottomNavigationBar), findsNothing);
  });
}
