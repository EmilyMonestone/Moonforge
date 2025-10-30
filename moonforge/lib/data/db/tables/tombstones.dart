import 'package:drift/drift.dart';

/// Tombstones table for tracking deleted documents
/// Prevents resurrection of deleted items during sync
class Tombstones extends Table {
  /// Collection name
  TextColumn get collection => text()();
  
  /// Document ID
  TextColumn get docId => text()();
  
  /// Deletion timestamp
  DateTimeColumn get deletedAt => dateTime()();
  
  /// User who deleted the document
  TextColumn get deletedBy => text().nullable()();
  
  /// Reason for deletion (optional)
  TextColumn get reason => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {collection, docId};
}
