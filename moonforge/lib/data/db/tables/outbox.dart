import 'package:drift/drift.dart';

/// Outbox table for queuing local writes for remote sync
/// Implements durable queue pattern for reliable sync
class Outbox extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// Firestore collection name (e.g., 'campaigns', 'chapters')
  TextColumn get collection => text()();
  
  /// Document ID in Firestore
  TextColumn get docId => text()();
  
  /// Operation type: 'create', 'update', 'delete'
  TextColumn get operation => text()();
  
  /// JSON-encoded payload (full document for create/update, null for delete)
  TextColumn get payload => text().nullable()();
  
  /// Base revision number this operation is based on
  IntColumn get baseRevision => integer()();
  
  /// Timestamp when operation was enqueued
  DateTimeColumn get enqueuedAt => dateTime()();
  
  /// Number of retry attempts made
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  
  /// Last error message (if any)
  TextColumn get lastError => text().nullable()();
  
  /// Remote acknowledgment data (e.g., ETag, server timestamp)
  TextColumn get remoteAck => text().nullable()();
  
  /// User ID (for multi-user support)
  TextColumn get userId => text().nullable()();
  
  /// Priority (higher number = higher priority)
  IntColumn get priority => integer().withDefault(const Constant(0))();
}
