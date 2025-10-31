import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'encounter_dao.g.dart';

@DriftAccessor(tables: [Encounters])
class EncounterDao extends DatabaseAccessor<AppDb> with _$EncounterDaoMixin {
  EncounterDao(AppDb db) : super(db);

  Stream<List<Encounter>> watchAll() =>
      (select(encounters)..orderBy([(e) => OrderingTerm.asc(e.name)])).watch();

  Stream<List<Encounter>> watchByOrigin(String originId) =>
      (select(encounters)
            ..where((e) => e.originId.equals(originId))
            ..orderBy([(e) => OrderingTerm.asc(e.name)]))
          .watch();

  Future<Encounter?> getById(String id) =>
      (select(encounters)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<void> upsert(EncountersCompanion data) async =>
      into(encounters).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(encounters)..where((e) => e.id.equals(id))).go();
}
