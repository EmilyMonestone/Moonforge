import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

/// Native platform database connection (Android, iOS, desktop)
DatabaseConnection connect() {
  return DatabaseConnection.delayed(Future.sync(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moonforge_db.sqlite'));

    if (kDebugMode) {
      debugPrint('✓ Drift native database at: ${file.path}');
    }

    return NativeDatabase.createInBackground(file);
  }));
}
