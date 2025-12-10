import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/layout/widgets/desktop_wide_scaffold.dart';

void main() {
  testWidgets('DesktopWideScaffold builds rail', (tester) async {
    final tabs = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DesktopWideScaffold(
          tabs: tabs,
          body: const SizedBox.shrink(),
          selectedIndex: 0,
          onSelect: (c, i) {},
          breadcrumbs: const SizedBox.shrink(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(NavigationRailM3E), findsOneWidget);
  });

  testWidgets('DesktopWideScaffold does not show bottom navigation', (
    tester,
  ) async {
    final tabs = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.settings, 'label': 'Settings'},
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: DesktopWideScaffold(
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
