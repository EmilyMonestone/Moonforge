// Test config helpers for Moonforge tests
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wrap a widget with MaterialApp, localization delegates, and theme so widget
/// tests render correctly.
Widget wrapWithMaterialApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
    localizationsDelegates: const [],
  );
}

/// Pump a widget into the tester with a MaterialApp wrapper
Future<void> pumpWidget(WidgetTester tester, Widget widget) async {
  await tester.pumpWidget(wrapWithMaterialApp(widget));
  await tester.pumpAndSettle();
}
