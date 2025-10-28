import 'package:drift/drift.dart';
import 'package:moonforge/data/firebase/models/session.dart';

/// Drift table for Session, reusing the Freezed model via @UseRowClass
@UseRowClass(Session)
class Sessions extends Table {
  TextColumn get id => text()();

  DateTimeColumn get createdAt => dateTime().nullable()();

  TextColumn get info =>
      text().nullable()(); // DM-only notes (quill delta json)
  DateTimeColumn get datetime => dateTime().nullable()();

  TextColumn get log => text().nullable()(); // Shared log (quill delta json)
  TextColumn get shareToken => text().nullable()(); // Token for public access
  BoolColumn get shareEnabled => boolean().withDefault(const Constant(false))();

  DateTimeColumn get shareExpiresAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  IntColumn get rev => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
