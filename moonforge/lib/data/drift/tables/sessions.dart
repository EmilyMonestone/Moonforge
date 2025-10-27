import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/session.dart';

/// Drift table for Session, reusing the Freezed model via @UseRowClass
@UseRowClass(Session)
class Sessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  TextColumn get info => text().nullable()();
  DateTimeColumn get datetime => dateTime().nullable()();
  TextColumn get log => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
