import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Web database connection using WebAssembly SQLite
/// 
/// Used on web platform with IndexedDB for persistence
QueryExecutor connect() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'moonforge_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      // Log warning about missing features
      print('Missing web database features: ${result.missingFeatures}');
    }

    return result.resolvedExecutor;
  });
}
