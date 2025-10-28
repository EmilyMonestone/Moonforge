import 'package:drift/drift.dart';
import 'package:moonforge/data/drift/converters/json_list_converter.dart';
import 'package:moonforge/data/drift/converters/non_null_string_list_converter.dart';
import 'package:moonforge/data/firebase/models/encounter.dart';

/// Drift table for Encounter, reusing the Freezed model via @UseRowClass
@UseRowClass(Encounter)
class Encounters extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  BoolColumn get preset => boolean().withDefault(const Constant(false))();

  TextColumn get notes => text().nullable()();

  TextColumn get loot => text().nullable()();

  TextColumn get combatants =>
      text().nullable().map(const JsonListConverter())();

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
