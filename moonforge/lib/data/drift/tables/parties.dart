import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/party.dart';
import 'package:moonforge/data/drift/converters/string_list_converter.dart';

/// Drift table for Party, reusing the Freezed model via @UseRowClass
@UseRowClass(Party)
class Parties extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get summary => text().nullable()();
  TextColumn get memberEntityIds => text().nullable().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
