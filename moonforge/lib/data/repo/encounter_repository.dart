import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:moonforge/data/db/daos/encounter_dao.dart';
import 'package:moonforge/data/repo/base_repository.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

/// Repository for Encounter operations
class EncounterRepository extends BaseRepository<Encounter, String> {
  EncounterRepository(this._db);

  final AppDb _db;

  EncounterDao get _dao => _db.encounterDao;

  /// Watch encounters for an origin (campaign/chapter/adventure/scene)
  Stream<List<Encounter>> watchByOrigin(String originId) => handleStreamError(
    () => _dao.watchByOrigin(originId),
    context: 'encounter.watchByOrigin',
  );

  /// List encounters for an origin
  Future<List<Encounter>> getByOrigin(String originId) => handleError(
    () => _dao.getByOrigin(originId),
    context: 'encounter.getByOrigin',
  );

  @override
  Future<Encounter?> getById(String id) =>
      handleError(() => _dao.getById(id), context: 'encounter.getById');

  @override
  Future<List<Encounter>> getAll() =>
      handleError(() => _dao.watchAll().first, context: 'encounter.getAll');

  @override
  Future<Encounter> create(Encounter encounter) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        EncountersCompanion.insert(
          id: Value(encounter.id),
          name: encounter.name,
          originId: encounter.originId,
          preset: encounter.preset,
          notes: Value(encounter.notes),
          loot: Value(encounter.loot),
          combatants: Value(encounter.combatants),
          entityIds: encounter.entityIds,
          createdAt: Value(encounter.createdAt ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          rev: encounter.rev,
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'encounters',
        rowId: encounter.id,
        op: 'upsert',
      );
    });
    return encounter;
  }, context: 'encounter.create');

  @override
  Future<Encounter> update(Encounter encounter) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        EncountersCompanion(
          id: Value(encounter.id),
          name: Value(encounter.name),
          originId: Value(encounter.originId),
          preset: Value(encounter.preset),
          notes: Value(encounter.notes),
          loot: Value(encounter.loot),
          combatants: Value(encounter.combatants),
          entityIds: Value(encounter.entityIds),
          updatedAt: Value(DateTime.now()),
          rev: Value(encounter.rev + 1),
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'encounters',
        rowId: encounter.id,
        op: 'upsert',
      );
    });
    return encounter;
  }, context: 'encounter.update');

  /// Optimistic local upsert (no rev bump here)
  Future<void> upsertLocal(Encounter encounter) => handleError(() async {
    await _dao.upsert(
      EncountersCompanion(
        id: Value(encounter.id),
        name: Value(encounter.name),
        originId: Value(encounter.originId),
        preset: Value(encounter.preset),
        notes: Value(encounter.notes),
        loot: Value(encounter.loot),
        combatants: Value(encounter.combatants),
        entityIds: Value(encounter.entityIds),
        createdAt: Value(encounter.createdAt ?? DateTime.now()),
        updatedAt: Value(DateTime.now()),
        rev: Value(encounter.rev),
      ),
    );
    await _db.outboxDao.enqueue(
      table: 'encounters',
      rowId: encounter.id,
      op: 'upsert',
    );
  }, context: 'encounter.upsertLocal');

  @override
  Future<void> delete(String id) => handleError(() async {
    await _db.transaction(() async {
      await _dao.deleteById(id);
      await _db.outboxDao.enqueue(table: 'encounters', rowId: id, op: 'delete');
    });
  }, context: 'encounter.delete');

  @override
  Stream<List<Encounter>> watchAll() =>
      handleStreamError(_dao.watchAll, context: 'encounter.watchAll');

  @override
  Stream<Encounter?> watchById(String id) => handleStreamError(
    () =>
        _dao.watchAll().map((list) => list.firstWhereOrNull((e) => e.id == id)),
    context: 'encounter.watchById',
  );

  /// Custom query passthrough
  Future<List<Encounter>> customQuery({
    Expression<bool> Function(Encounters e)? filter,
    List<OrderingTerm Function(Encounters e)>? sort,
    int? limit,
  }) => handleError(
    () => _dao.customQuery(filter: filter, sort: sort, limit: limit),
    context: 'encounter.customQuery',
  );
}
