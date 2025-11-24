import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Loads a JSON fixture from the test/fixtures/ directory
Future<Map<String, dynamic>> loadJsonFixture(String name) async {
  final data = await rootBundle.loadString('test/fixtures/$name');
  return jsonDecode(data) as Map<String, dynamic>;
}

/// Wrap widget with MaterialApp and provide a basic theme
Widget wrapWithApp(Widget child) {
  return MaterialApp(
    home: Scaffold(body: child),
    theme: ThemeData.light(),
    localizationsDelegates: const [],
  );
}
