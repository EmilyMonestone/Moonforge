import 'package:drift/drift.dart';
import 'package:moonforge/data/db/app_database.dart';
import 'package:moonforge/data/db/connection/connection_native.dart'
    if (dart.library.html) 'package:moonforge/data/db/connection/connection_web.dart'
    as impl;

/// Factory for creating AppDatabase instances
/// 
/// Uses conditional imports to provide platform-specific implementations:
/// - Native (mobile/desktop): SQLite via drift_flutter
/// - Web: IndexedDB or Web SQL via drift/web
class DatabaseFactory {
  static AppDatabase? _instance;

  /// Get or create the singleton database instance
  static AppDatabase getInstance() {
    _instance ??= AppDatabase(impl.connect());
    return _instance!;
  }

  /// Close the current database instance
  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }

  /// Create a test database (in-memory)
  static AppDatabase createForTesting(QueryExecutor executor) {
    return AppDatabase(executor);
  }
}
