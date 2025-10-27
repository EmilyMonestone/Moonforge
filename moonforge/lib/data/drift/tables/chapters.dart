import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/chapter.dart';

/// Drift table for Chapter, reusing the Freezed model via @UseRowClass
@UseRowClass(Chapter)
class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get order => integer().withDefault(const Constant(0))();
  TextColumn get summary => text().nullable()();
  TextColumn get content => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
