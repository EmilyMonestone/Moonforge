import 'dart:convert';

import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/firebase/models/entity.dart';

/// Repository for Entity operations
class EntityRepository {
  final AppDatabase _db;

  EntityRepository(this._db);

  Stream<List<Entity>> watchAll() => _db.entitiesDao.watchAll();

  Future<Entity?> getById(String id) => _db.entitiesDao.getById(id);

  Future<void> upsertLocal(Entity entity) async {
    await _db.transaction(() async {
      await _db.entitiesDao.upsert(entity, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'entities',
        docId: entity.id,
        baseRev: entity.rev,
        opType: 'upsert',
        payload: jsonEncode(entity.toJson()),
      );
    });
  }

  Future<void> patchLocal({
    required String id,
    required int baseRev,
    required List<Map<String, dynamic>> ops,
  }) async {
    await _db.transaction(() async {
      final current = await _db.entitiesDao.getById(id);
      if (current == null) return;

      Entity updated = current;
      for (final op in ops) {
        updated = _applyPatchOp(updated, op);
      }

      await _db.entitiesDao.upsert(updated, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'entities',
        docId: id,
        baseRev: baseRev,
        opType: 'patch',
        payload: jsonEncode({'ops': ops}),
      );
    });
  }

  Entity _applyPatchOp(Entity entity, Map<String, dynamic> op) {
    final type = op['type'] as String;
    final field = op['field'] as String;
    final value = op['value'];

    if (type == 'set') {
      switch (field) {
        case 'kind':
          return entity.copyWith(kind: value as String);
        case 'name':
          return entity.copyWith(name: value as String);
        case 'summary':
          return entity.copyWith(summary: value as String?);
        case 'content':
          return entity.copyWith(content: value as String?);
        case 'placeType':
          return entity.copyWith(placeType: value as String?);
        case 'deleted':
          return entity.copyWith(deleted: value as bool);
      }
    } else if (type == 'addToSet' && field == 'tags') {
      final current = entity.tags ?? [];
      if (!current.contains(value)) {
        return entity.copyWith(tags: [...current, value as String]);
      }
    } else if (type == 'removeFromSet' && field == 'tags') {
      final current = entity.tags ?? [];
      return entity.copyWith(tags: current.where((t) => t != value).toList());
    }
    return entity;
  }
}
