import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'combatant_dao.g.dart';

@DriftAccessor(tables: [Combatants])
class CombatantDao extends DatabaseAccessor<AppDb> with _$CombatantDaoMixin {
  CombatantDao(super.db);

  Stream<List<Combatant>> watchByEncounter(String encounterId) =>
      (select(combatants)
            ..where((c) => c.encounterId.equals(encounterId))
            ..orderBy([(c) => OrderingTerm.asc(c.order)]))
          .watch();

  Future<Combatant?> getById(String id) =>
      (select(combatants)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<void> upsert(CombatantsCompanion data) async =>
      into(combatants).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(combatants)..where((c) => c.id.equals(id))).go();

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Combatant>> customQuery({
    Expression<bool> Function(Combatants c)? filter,
    List<OrderingTerm Function(Combatants c)>? sort,
    int? limit,
  }) {
    final query = select(combatants);

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
