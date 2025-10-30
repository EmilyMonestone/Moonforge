import 'package:drift/drift.dart';

/// Campaigns table - stores campaign data locally
class Campaigns extends Table {
  /// Primary key (campaign ID)
  TextColumn get id => text()();
  
  /// Campaign name
  TextColumn get name => text()();
  
  /// Campaign description
  TextColumn get description => text()();
  
  /// Rich text content (Quill delta JSON)
  TextColumn get content => text().nullable()();
  
  /// Owner user ID
  TextColumn get ownerUid => text().nullable()();
  
  /// Member user IDs (JSON array)
  TextColumn get memberUids => text().withDefault(const Constant('[]'))();
  
  /// Related entity IDs (JSON array)
  TextColumn get entityIds => text().withDefault(const Constant('[]'))();
  
  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().nullable()();
  
  /// Last updated timestamp
  DateTimeColumn get updatedAt => dateTime().nullable()();
  
  /// Revision number for conflict resolution
  IntColumn get rev => integer().withDefault(const Constant(0))();
  
  /// Soft delete flag
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  
  /// Dirty flag (has unsync changes)
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}
