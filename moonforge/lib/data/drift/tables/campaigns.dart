import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/data/drift/converters/string_list_converter.dart';

/// Drift table for Campaign, reusing the Freezed model via @UseRowClass
@UseRowClass(Campaign)
class Campaigns extends Table {
  /// Primary key matching Firestore document ID
  TextColumn get id => text()();
  
  TextColumn get name => text()();
  
  TextColumn get description => text()();
  
  /// Quill delta JSON string
  TextColumn get content => text().nullable()();
  
  TextColumn get ownerUid => text().nullable()();
  
  /// JSON-encoded list of member UIDs
  TextColumn get memberUids => text().nullable().map(const StringListConverter())();
  
  DateTimeColumn get createdAt => dateTime().nullable()();
  
  DateTimeColumn get updatedAt => dateTime().nullable()();
  
  /// Revision number for CAS (Compare-And-Set) conflict resolution
  IntColumn get rev => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
