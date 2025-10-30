import 'package:drift/drift.dart';

/// Chapters table - stores chapter data locally
class Chapters extends Table {
  /// Primary key (chapter ID)
  TextColumn get id => text()();
  
  /// Parent campaign ID
  TextColumn get campaignId => text()();
  
  /// Chapter name
  TextColumn get name => text()();
  
  /// Chapter description
  TextColumn get description => text()();
  
  /// Rich text content
  TextColumn get content => text().nullable()();
  
  /// Order index within campaign
  IntColumn get orderIndex => integer().nullable()();
  
  /// Created timestamp
  DateTimeColumn get createdAt => dateTime().nullable()();
  
  /// Last updated timestamp
  DateTimeColumn get updatedAt => dateTime().nullable()();
  
  /// Revision number
  IntColumn get rev => integer().withDefault(const Constant(0))();
  
  /// Soft delete flag
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
  
  /// Dirty flag
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();
  
  @override
  Set<Column> get primaryKey => {id};
}
