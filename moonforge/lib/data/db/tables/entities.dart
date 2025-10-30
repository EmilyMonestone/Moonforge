import 'package:drift/drift.dart';

/// Entities table - stores entity data (NPCs, locations, items, etc.)
class Entities extends Table {
  /// Primary key (entity ID)
  TextColumn get id => text()();
  
  /// Parent campaign ID
  TextColumn get campaignId => text()();
  
  /// Entity name
  TextColumn get name => text()();
  
  /// Entity type (npc, location, item, organization)
  TextColumn get entityType => text()();
  
  /// Entity description
  TextColumn get description => text().nullable()();
  
  /// Rich text content
  TextColumn get content => text().nullable()();
  
  /// Tags (JSON array)
  TextColumn get tags => text().withDefault(const Constant('[]'))();
  
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
