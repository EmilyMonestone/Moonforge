import 'dart:convert';
import 'package:moonforge/core/models/data/scene.dart';
import 'package:moonforge/data/drift/app_database.dart';

/// Repository for Scene operations
class SceneRepository {
  final AppDatabase _db;

  SceneRepository(this._db);

  Stream<List<Scene>> watchAll() => _db.scenesDao.watchAll();

  Future<Scene?> getById(String id) => _db.scenesDao.getById(id);

  Future<void> upsertLocal(Scene scene) async {
    await _db.transaction(() async {
      await _db.scenesDao.upsert(scene, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'scenes',
        docId: scene.id,
        baseRev: scene.rev,
        opType: 'upsert',
        payload: jsonEncode(scene.toJson()),
      );
    });
  }

  Future<void> patchLocal({
    required String id,
    required int baseRev,
    required List<Map<String, dynamic>> ops,
  }) async {
    await _db.transaction(() async {
      final current = await _db.scenesDao.getById(id);
      if (current == null) return;

      Scene updated = current;
      for (final op in ops) {
        updated = _applyPatchOp(updated, op);
      }

      await _db.scenesDao.upsert(updated, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'scenes',
        docId: id,
        baseRev: baseRev,
        opType: 'patch',
        payload: jsonEncode({'ops': ops}),
      );
    });
  }

  Scene _applyPatchOp(Scene scene, Map<String, dynamic> op) {
    final type = op['type'] as String;
    final field = op['field'] as String;
    final value = op['value'];

    if (type == 'set') {
      switch (field) {
        case 'title':
          return scene.copyWith(title: value as String);
        case 'order':
          return scene.copyWith(order: value as int);
        case 'summary':
          return scene.copyWith(summary: value as String?);
        case 'content':
          return scene.copyWith(content: value as String?);
      }
    }
    return scene;
  }
}
