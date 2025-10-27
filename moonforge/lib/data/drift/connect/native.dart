import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Native platform database connection (Android, iOS, desktop)
QueryExecutor connect() {
  // Lazily open the database file from the application documents directory
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moonforge_db.sqlite'));

    if (kDebugMode) {
      debugPrint('✓ Drift native database at: ${file.path}');
    }

    // Use a background isolate for better performance
    return NativeDatabase.createInBackground(file);
  });
}
