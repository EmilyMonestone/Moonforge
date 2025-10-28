import 'package:drift/drift.dart';
import 'package:moonforge/data/firebase/models/player.dart';

/// Drift table for Player, reusing the Freezed model via @UseRowClass
@UseRowClass(Player)
class Players extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get partyId => text().nullable()();

  TextColumn get playerClass => text().nullable()();

  IntColumn get level => integer().withDefault(const Constant(1))();

  TextColumn get species => text().nullable()();

  TextColumn get info => text().nullable()();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  IntColumn get rev => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
