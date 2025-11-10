import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'encounter_dao.g.dart';

@DriftAccessor(tables: [Encounters])
class EncounterDao extends DatabaseAccessor<AppDb> with _$EncounterDaoMixin {
  EncounterDao(super.db);

  Stream<List<Encounter>> watchAll() =>
      (select(encounters)..orderBy([(e) => OrderingTerm.asc(e.name)])).watch();

  Future<List<Encounter>> getAll() =>
      (select(encounters)..orderBy([(e) => OrderingTerm.asc(e.name)])).get();

  Stream<List<Encounter>> watchByOrigin(String originId) =>
      (select(encounters)
            ..where((e) => e.originId.equals(originId))
            ..orderBy([(e) => OrderingTerm.asc(e.name)]))
          .watch();

  Future<List<Encounter>> getByOrigin(String originId) =>
      (select(encounters)
            ..where((e) => e.originId.equals(originId))
            ..orderBy([(e) => OrderingTerm.asc(e.name)]))
          .get();

  Future<Encounter?> getById(String id) =>
      (select(encounters)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<void> upsert(EncountersCompanion data) async =>
      into(encounters).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(encounters)..where((e) => e.id.equals(id))).go();

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Encounter>> customQuery({
    Expression<bool> Function(Encounters e)? filter,
    List<OrderingTerm Function(Encounters e)>? sort,
    int? limit,
  }) {
    final query = select(encounters);

    if (filter != null) {
      query.where(filter);
    }

    if (sort != null && sort.isNotEmpty) {
      query.orderBy(sort);
    }

    if (limit != null) {
      query.limit(limit);
    }

    return query.get();
  }
}
