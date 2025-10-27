import 'dart:convert';
import 'package:moonforge/core/models/data/encounter.dart';
import 'package:moonforge/data/drift/app_database.dart';

/// Repository for Encounter operations
class EncounterRepository {
  final AppDatabase _db;

  EncounterRepository(this._db);

  Stream<List<Encounter>> watchAll() => _db.encountersDao.watchAll();

  Future<Encounter?> getById(String id) => _db.encountersDao.getById(id);

  Future<void> upsertLocal(Encounter encounter) async {
    await _db.transaction(() async {
      await _db.encountersDao.upsert(encounter, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'encounters',
        docId: encounter.id,
        baseRev: encounter.rev,
        opType: 'upsert',
        payload: jsonEncode(encounter.toJson()),
      );
    });
  }

  Future<void> patchLocal({
    required String id,
    required int baseRev,
    required List<Map<String, dynamic>> ops,
  }) async {
    await _db.transaction(() async {
      final current = await _db.encountersDao.getById(id);
      if (current == null) return;

      Encounter updated = current;
      for (final op in ops) {
        updated = _applyPatchOp(updated, op);
      }

      await _db.encountersDao.upsert(updated, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'encounters',
        docId: id,
        baseRev: baseRev,
        opType: 'patch',
        payload: jsonEncode({'ops': ops}),
      );
    });
  }

  Encounter _applyPatchOp(Encounter encounter, Map<String, dynamic> op) {
    final type = op['type'] as String;
    final field = op['field'] as String;
    final value = op['value'];

    if (type == 'set') {
      switch (field) {
        case 'name':
          return encounter.copyWith(name: value as String);
        case 'preset':
          return encounter.copyWith(preset: value as bool);
        case 'notes':
          return encounter.copyWith(notes: value as String?);
        case 'loot':
          return encounter.copyWith(loot: value as String?);
      }
    }
    return encounter;
  }
}
