// This is a basic Flutter widget smoke test.
//
// It pumps the App and verifies the adaptive navigation renders.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/app.dart';

void main() {
  testWidgets('App renders adaptive navigation', (WidgetTester tester) async {
    await tester.pumpWidget(App());
    await tester.pumpAndSettle();

    // Accept either compact (NavigationBar) or wide (NavigationRail)
    final hasRail = find.byType(NavigationRail).evaluate().isNotEmpty;
    final hasBar = find.byType(NavigationBar).evaluate().isNotEmpty;
    expect(hasRail || hasBar, isTrue);
  });
}
