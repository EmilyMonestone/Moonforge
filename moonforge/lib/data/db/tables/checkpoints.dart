import 'package:drift/drift.dart';

/// Checkpoints table for tracking last sync cursor per collection
/// Enables incremental pull sync from Firestore
class Checkpoints extends Table {
  /// Collection name (e.g., 'campaigns', 'chapters')
  TextColumn get collection => text()();
  
  /// User ID (for multi-user support)
  TextColumn get userId => text().nullable()();
  
  /// Last sync cursor (timestamp or token)
  TextColumn get lastCursor => text().nullable()();
  
  /// Last successful sync timestamp
  DateTimeColumn get lastSyncAt => dateTime().nullable()();
  
  /// Additional metadata (JSON)
  TextColumn get metadata => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {collection, userId};
}
