import 'package:drift/drift.dart';
import '../app_db.dart';
import '../tables.dart';

part 'scene_dao.g.dart';

@DriftAccessor(tables: [Scenes])
class SceneDao extends DatabaseAccessor<AppDb> with _$SceneDaoMixin {
  SceneDao(AppDb db) : super(db);

  Stream<List<Scene>> watchByAdventure(String adventureId) =>
      (select(scenes)
        ..where((s) => s.adventureId.equals(adventureId))
        ..orderBy([(s) => OrderingTerm.asc(s.order)]))
      .watch();

  Future<Scene?> getById(String id) =>
      (select(scenes)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<void> upsert(ScenesCompanion data) async =>
      into(scenes).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(scenes)..where((s) => s.id.equals(id))).go();
}
