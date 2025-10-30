import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Native database connection using SQLite
/// 
/// Used on mobile and desktop platforms
QueryExecutor connect() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moonforge.db'));
    return NativeDatabase(file);
  });
}
