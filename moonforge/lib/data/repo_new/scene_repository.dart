import '../db/app_db.dart';
import '../db/tables.dart';
import 'package:drift/drift.dart';

/// Repository for Scene operations
class SceneRepository {
  final AppDb _db;

  SceneRepository(this._db);

  /// Watch scenes for an adventure
  Stream<List<Scene>> watchByAdventure(String adventureId) => 
    _db.sceneDao.watchByAdventure(adventureId);

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

  /// Delete a scene
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.sceneDao.deleteById(id);
      
      await _db.outboxDao.enqueue(
        table: 'scenes',
        rowId: id,
        op: 'delete',
      );
    });
  }
}
