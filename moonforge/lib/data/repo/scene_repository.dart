import 'package:drift/drift.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

/// Repository for Scene operations
class SceneRepository {
  final AppDb _db;

  SceneRepository(this._db);

  /// Watch scenes for an adventure
  Stream<List<Scene>> watchByAdventure(String adventureId) =>
      _db.sceneDao.watchByAdventure(adventureId);

  /// List scenes for an adventure
  Future<List<Scene>> getByAdventure(String adventureId) =>
      _db.sceneDao.customQuery(
        filter: (s) => s.adventureId.equals(adventureId),
        sort: [(s) => OrderingTerm.asc(s.order)],
      );

  /// Get a single scene by ID
  Future<Scene?> getById(String id) => _db.sceneDao.getById(id);

  /// Create a new scene
  Future<void> create(Scene scene) async {
    await _db.transaction(() async {
      await _db.sceneDao.upsert(
        ScenesCompanion.insert(
          id: scene.id,
          adventureId: scene.adventureId,
          name: scene.name,
          order: scene.order,
          summary: Value(scene.summary),
          content: Value(scene.content),
          entityIds: scene.entityIds,
          createdAt: Value(scene.createdAt ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          rev: scene.rev,
        ),
      );

      await _db.outboxDao.enqueue(
        table: 'scenes',
        rowId: scene.id,
        op: 'upsert',
      );
    });
  }

  /// Update an existing scene
  Future<void> update(Scene scene) async {
    await _db.transaction(() async {
      await _db.sceneDao.upsert(
        ScenesCompanion(
          id: Value(scene.id),
          adventureId: Value(scene.adventureId),
          name: Value(scene.name),
          order: Value(scene.order),
          summary: Value(scene.summary),
          content: Value(scene.content),
          entityIds: Value(scene.entityIds),
          updatedAt: Value(DateTime.now()),
          rev: Value(scene.rev + 1),
        ),
      );

      await _db.outboxDao.enqueue(
        table: 'scenes',
        rowId: scene.id,
        op: 'upsert',
      );
    });
  }

  /// Optimistic local upsert (no rev bump here)
  Future<void> upsertLocal(Scene scene) async {
    await _db.sceneDao.upsert(
      ScenesCompanion(
        id: Value(scene.id),
        adventureId: Value(scene.adventureId),
        name: Value(scene.name),
        order: Value(scene.order),
        summary: Value(scene.summary),
        content: Value(scene.content),
        entityIds: Value(scene.entityIds),
        createdAt: Value(scene.createdAt ?? DateTime.now()),
        updatedAt: Value(DateTime.now()),
        rev: Value(scene.rev),
      ),
    );
    await _db.outboxDao.enqueue(table: 'scenes', rowId: scene.id, op: 'upsert');
  }

  /// Delete a scene
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.sceneDao.deleteById(id);

      await _db.outboxDao.enqueue(table: 'scenes', rowId: id, op: 'delete');
    });
  }

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Scene>> customQuery({
    Expression<bool> Function(Scenes s)? filter,
    List<OrderingTerm Function(Scenes s)>? sort,
    int? limit,
  }) {
    return _db.sceneDao.customQuery(filter: filter, sort: sort, limit: limit);
  }
}
