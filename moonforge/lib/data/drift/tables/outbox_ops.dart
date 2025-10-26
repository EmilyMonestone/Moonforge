import 'package:drift/drift.dart';

/// Outbox table for queued mutations to be synced with Firestore
class OutboxOps extends Table {
  /// Auto-incrementing primary key for outbox entries
  IntColumn get id => integer().autoIncrement()();
  
  /// Firestore collection path (e.g., "campaigns")
  TextColumn get docPath => text()();
  
  /// Document ID in Firestore
  TextColumn get docId => text()();
  
  /// Base revision number this operation is based on
  IntColumn get baseRev => integer()();
  
  /// Operation type: 'upsert', 'patch', 'delete'
  TextColumn get opType => text()();
  
  /// JSON-encoded operation payload
  /// For upsert: full document
  /// For patch: { "ops": [{"type": "set", "field": "name", "value": "..."}] }
  /// For delete: null
  TextColumn get payload => text()();
  
  /// Timestamp when operation was enqueued
  DateTimeColumn get enqueuedAt => dateTime()();
  
  /// Number of push attempts made
  IntColumn get attempt => integer().withDefault(const Constant(0))();
}
