import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

/// Web-specific database connection using WASM backend
QueryExecutor connect() {
  // Lazily open the WASM database and return the resolved executor
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'moonforge_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );

    if (kDebugMode) {
      debugPrint('✓ Drift web WASM backend: ${result.resolvedExecutor.runtimeType}');
    }
    if (result.missingFeatures.isNotEmpty) {
      debugPrint('⚠️ Missing features for optimal performance: '
          '${result.missingFeatures}. Consider enabling COOP/COEP headers.');
    }

    return result.resolvedExecutor;
  });
}
