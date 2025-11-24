import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:moonforge/data/db/daos/scene_dao.dart';
import 'package:moonforge/data/repo/base_repository.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

/// Repository for Scene operations
class SceneRepository extends BaseRepository<Scene, String> {
  SceneRepository(this._db);

  final AppDb _db;

  SceneDao get _dao => _db.sceneDao;

  @override
  Future<Scene?> getById(String id) =>
      handleError(() => _dao.getById(id), context: 'scene.getById');

  @override
  Future<List<Scene>> getAll() =>
      handleError(() => _dao.watchAll().first, context: 'scene.getAll');

  /// Watch scenes for an adventure
  Stream<List<Scene>> watchByAdventure(String adventureId) => handleStreamError(
    () => _dao.watchByAdventure(adventureId),
    context: 'scene.watchByAdventure',
  );

  /// List scenes for an adventure
  Future<List<Scene>> getByAdventure(String adventureId) => handleError(
    () => _dao.customQuery(
      filter: (s) => s.adventureId.equals(adventureId),
      sort: [(s) => OrderingTerm.asc(s.order)],
    ),
    context: 'scene.getByAdventure',
  );

  @override
  Future<Scene> create(Scene scene) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        ScenesCompanion.insert(
          id: Value(scene.id),
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
    return scene;
  }, context: 'scene.create');

  @override
  Future<Scene> update(Scene scene) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
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
    return scene;
  }, context: 'scene.update');

  @override
  Future<void> delete(String id) => handleError(() async {
    await _db.transaction(() async {
      await _dao.deleteById(id);
      await _db.outboxDao.enqueue(table: 'scenes', rowId: id, op: 'delete');
    });
  }, context: 'scene.delete');

  @override
  Stream<Scene?> watchById(String id) => handleStreamError(
    () =>
        _dao.watchAll().map((list) => list.firstWhereOrNull((s) => s.id == id)),
    context: 'scene.watchById',
  );

  @override
  Stream<List<Scene>> watchAll() =>
      handleStreamError(_dao.watchAll, context: 'scene.watchAll');

  /// Optimistic local upsert (no rev bump here)
  Future<void> upsertLocal(Scene scene) => handleError(() async {
    await _dao.upsert(
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
  }, context: 'scene.upsertLocal');

  /// Custom query passthrough
  Future<List<Scene>> customQuery({
    Expression<bool> Function(Scenes s)? filter,
    List<OrderingTerm Function(Scenes s)>? sort,
    int? limit,
  }) => handleError(
    () => _dao.customQuery(filter: filter, sort: sort, limit: limit),
    context: 'scene.customQuery',
  );
}
