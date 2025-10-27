import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/entity.dart';
import 'package:moonforge/data/drift/converters/string_list_converter.dart';
import 'package:moonforge/data/drift/converters/json_map_converter.dart';
import 'package:moonforge/data/drift/converters/json_list_converter.dart';

/// Drift table for Entity, reusing the Freezed model via @UseRowClass
@UseRowClass(Entity)
class Entities extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get name => text()();
  TextColumn get summary => text().nullable()();
  TextColumn get tags => text().nullable().map(const StringListConverter())();
  TextColumn get statblock => text().map(const JsonMapConverter())();
  TextColumn get placeType => text().nullable()();
  TextColumn get parentPlaceId => text().nullable()();
  TextColumn get coords => text().map(const JsonMapConverter())();
  TextColumn get content => text().nullable()();
  TextColumn get images => text().nullable().map(const JsonListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer().withDefault(const Constant(0))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  TextColumn get members => text().nullable().map(const StringListConverter())();

  @override
  Set<Column> get primaryKey => {id};
}
