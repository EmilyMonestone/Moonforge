import '../db/app_db.dart';
import '../db/tables.dart';
import 'package:drift/drift.dart';

/// Repository for Encounter operations
class EncounterRepository {
  final AppDb _db;

  EncounterRepository(this._db);

  /// Watch encounters for an origin (campaign/chapter/adventure/scene)
  Stream<List<Encounter>> watchByOrigin(String originId) => 
    _db.encounterDao.watchByOrigin(originId);

  /// Get a single encounter by ID
  Future<Encounter?> getById(String id) => _db.encounterDao.getById(id);

  /// Create a new encounter
  Future<void> create(Encounter encounter) async {
    await _db.transaction(() async {
      await _db.encounterDao.upsert(
        EncountersCompanion.insert(
          id: encounter.id,
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
  }

  /// Update an existing encounter
  Future<void> update(Encounter encounter) async {
    await _db.transaction(() async {
      await _db.encounterDao.upsert(
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
  }

  /// Delete an encounter
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.encounterDao.deleteById(id);
      
      await _db.outboxDao.enqueue(
        table: 'encounters',
        rowId: id,
        op: 'delete',
      );
    });
  }
}
