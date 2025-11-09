import 'package:drift/drift.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

/// Repository for Combatant operations
class CombatantRepository {
  final AppDb _db;

  CombatantRepository(this._db);

  /// Watch combatants for an encounter
  Stream<List<Combatant>> watchByEncounter(String encounterId) =>
      _db.combatantDao.watchByEncounter(encounterId);

  /// Get a single combatant by ID
  Future<Combatant?> getById(String id) => _db.combatantDao.getById(id);

  /// Create a new combatant
  Future<void> create(Combatant combatant) async {
    await _db.transaction(() async {
      await _db.combatantDao.upsert(
        CombatantsCompanion.insert(
          id: combatant.id,
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
  }

  /// Update an existing combatant
  Future<void> update(Combatant combatant) async {
    await _db.transaction(() async {
      await _db.combatantDao.upsert(
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
  }

  /// Delete a combatant
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.combatantDao.deleteById(id);

      await _db.outboxDao.enqueue(
        table: 'combatants',
        rowId: id,
        op: 'delete',
      );
    });
  }

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Combatant>> customQuery({
    Expression<bool> Function(Combatants c)? filter,
    List<OrderingTerm Function(Combatants c)>? sort,
    int? limit,
  }) {
    return _db.combatantDao.customQuery(
      filter: filter,
      sort: sort,
      limit: limit,
    );
  }
}
