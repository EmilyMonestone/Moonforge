import 'package:drift/drift.dart';
import 'package:moonforge/data/drift/converters/non_null_string_list_converter.dart';
import 'package:moonforge/data/firebase/models/adventure.dart';

/// Drift table for Adventure, reusing the Freezed model via @UseRowClass
@UseRowClass(Adventure)
class Adventures extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  IntColumn get order => integer().withDefault(const Constant(0))();

  TextColumn get summary => text().nullable()();

  TextColumn get content => text().nullable()();

  /// JSON-encoded list of related entity IDs
  TextColumn get entityIds => text()
      .map(const NonNullStringListConverter())
      .withDefault(const Constant('[]'))();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  IntColumn get rev => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
