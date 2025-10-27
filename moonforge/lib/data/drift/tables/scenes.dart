import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/scene.dart';
import 'package:moonforge/data/drift/converters/json_list_converter.dart';

/// Drift table for Scene, reusing the Freezed model via @UseRowClass
@UseRowClass(Scene)
class Scenes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  IntColumn get order => integer().withDefault(const Constant(0))();
  TextColumn get summary => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get mentions => text().nullable().map(const JsonListConverter())();
  TextColumn get mediaRefs => text().nullable().map(const JsonListConverter())();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  IntColumn get rev => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
