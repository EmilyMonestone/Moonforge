import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

/// Web-specific database connection using WASM backend
DatabaseConnection connect() {
  return DatabaseConnection.delayed(() async {
    final result = await WasmDatabase.open(
      databaseName: 'moonforge_db',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );

    if (kDebugMode) {
      debugPrint('✓ Drift web WASM backend: ${result.resolvedExecutor.runtimeType}');
    }

    // Optional: Can check for OPFS support
    if (result.missingFeatures.isNotEmpty) {
      debugPrint('⚠️ Missing features for optimal performance: '
          '${result.missingFeatures}. Consider enabling COOP/COEP headers.');
    }

    return result.resolvedExecutor;
  });
}
