import 'package:drift/drift.dart';
import 'package:moonforge/data/db/daos/combatant_dao.dart';
import 'package:moonforge/data/repo/base_repository.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

class CombatantRepository extends BaseRepository<Combatant, String> {
  CombatantRepository(this._db);

  final AppDb _db;

  CombatantDao get _dao => _db.combatantDao;

  Stream<List<Combatant>> watchByEncounter(String encounterId) =>
      handleStreamError(
        () => _dao.watchByEncounter(encounterId),
        context: 'combatant.watchByEncounter',
      );

  @override
  Future<Combatant?> getById(String id) =>
      handleError(() => _dao.getById(id), context: 'combatant.getById');

  @override
  Future<List<Combatant>> getAll() =>
      handleError(() => _dao.customQuery(), context: 'combatant.getAll');

  @override
  Stream<List<Combatant>> watchAll() => handleStreamError(
    () => Stream.fromFuture(_dao.customQuery()),
    context: 'combatant.watchAll',
  );

  @override
  Stream<Combatant?> watchById(String id) => handleStreamError(
    () => Stream.fromFuture(_dao.getById(id)),
    context: 'combatant.watchById',
  );

  @override
  Future<Combatant> create(Combatant combatant) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        CombatantsCompanion.insert(
          id: Value(combatant.id),
          encounterId: combatant.encounterId,
          name: combatant.name,
          type: combatant.type,
          isAlly: combatant.isAlly,
          currentHp: combatant.currentHp,
          maxHp: combatant.maxHp,
          armorClass: combatant.armorClass,
          initiative: Value(combatant.initiative),
          initiativeModifier: combatant.initiativeModifier,
          entityId: Value(combatant.entityId),
          bestiaryName: Value(combatant.bestiaryName),
          cr: Value(combatant.cr),
          xp: combatant.xp,
          conditions: combatant.conditions,
          notes: Value(combatant.notes),
          order: combatant.order,
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'combatants',
        rowId: combatant.id,
        op: 'upsert',
      );
    });
    return combatant;
  }, context: 'combatant.create');

  @override
  Future<Combatant> update(Combatant combatant) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        CombatantsCompanion(
          id: Value(combatant.id),
          encounterId: Value(combatant.encounterId),
          name: Value(combatant.name),
          type: Value(combatant.type),
          isAlly: Value(combatant.isAlly),
          currentHp: Value(combatant.currentHp),
          maxHp: Value(combatant.maxHp),
          armorClass: Value(combatant.armorClass),
          initiative: Value(combatant.initiative),
          initiativeModifier: Value(combatant.initiativeModifier),
          entityId: Value(combatant.entityId),
          bestiaryName: Value(combatant.bestiaryName),
          cr: Value(combatant.cr),
          xp: Value(combatant.xp),
          conditions: Value(combatant.conditions),
          notes: Value(combatant.notes),
          order: Value(combatant.order),
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'combatants',
        rowId: combatant.id,
        op: 'upsert',
      );
    });
    return combatant;
  }, context: 'combatant.update');

  @override
  Future<void> delete(String id) => handleError(() async {
    await _db.transaction(() async {
      await _dao.deleteById(id);
      await _db.outboxDao.enqueue(table: 'combatants', rowId: id, op: 'delete');
    });
  }, context: 'combatant.delete');

  Future<List<Combatant>> customQuery({
    Expression<bool> Function(Combatants c)? filter,
    List<OrderingTerm Function(Combatants c)>? sort,
    int? limit,
  }) => handleError(
    () => _dao.customQuery(filter: filter, sort: sort, limit: limit),
    context: 'combatant.customQuery',
  );
}
