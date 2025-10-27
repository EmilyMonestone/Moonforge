import 'package:drift/drift.dart';

/// Tracks Firebase Storage file operations (downloads and uploads)
class StorageQueue extends Table {
  /// Auto-incrementing primary key
  IntColumn get id => integer().autoIncrement()();
  
  /// Storage path in Firebase Storage (e.g., "media/campaign-123/image.jpg")
  TextColumn get storagePath => text()();
  
  /// Associated MediaAsset ID (if applicable)
  TextColumn get assetId => text().nullable()();
  
  /// Operation type: 'download', 'upload'
  TextColumn get opType => text()();
  
  /// Local file path (for downloads: destination, for uploads: source)
  TextColumn get localPath => text().nullable()();
  
  /// Download/upload status: pending, in_progress, completed, failed
  TextColumn get status => text().withDefault(const Constant('pending'))();
  
  /// Progress percentage (0-100)
  IntColumn get progress => integer().withDefault(const Constant(0))();
  
  /// File size in bytes
  IntColumn get fileSize => integer().nullable()();
  
  /// MIME type
  TextColumn get mimeType => text().nullable()();
  
  /// Error message if failed
  TextColumn get errorMessage => text().nullable()();
  
  /// Number of retry attempts
  IntColumn get attempt => integer().withDefault(const Constant(0))();
  
  /// Timestamp when operation was enqueued
  DateTimeColumn get enqueuedAt => dateTime()();
  
  /// Timestamp when operation started
  DateTimeColumn get startedAt => dateTime().nullable()();
  
  /// Timestamp when operation completed
  DateTimeColumn get completedAt => dateTime().nullable()();
  
  /// Priority (higher = more important)
  IntColumn get priority => integer().withDefault(const Constant(0))();
}
