import 'package:drift/drift.dart';

/// Generic local metadata table for tracking sync state of any document
/// Replaces model-specific metadata tables with a unified approach
class LocalMetas extends Table {
  /// Foreign key: collection name + document ID (e.g., "campaigns/doc-id")
  TextColumn get docRef => text()();
  
  /// Collection name (e.g., "campaigns", "chapters")
  TextColumn get collection => text()();
  
  /// Document ID within the collection
  TextColumn get docId => text()();
  
  /// Whether this document has unsync'd local changes
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  
  /// Last successful sync timestamp
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();
  
  /// Download status for media files: pending, downloading, cached, failed
  TextColumn get downloadStatus => text().nullable()();
  
  /// Local file path for downloaded media (mobile/desktop)
  TextColumn get localPath => text().nullable()();
  
  /// Cache expiry timestamp for media
  DateTimeColumn get cacheExpiry => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {docRef};
}
