import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/scene.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/dao/local_meta_mixin.dart';
import 'package:moonforge/data/drift/tables/scenes.dart';
import 'package:moonforge/data/drift/tables/local_metas.dart';

part 'scenes_dao.g.dart';

@DriftAccessor(tables: [Scenes, LocalMetas])
class ScenesDao extends DatabaseAccessor<AppDatabase>
    with _$ScenesDaoMixin, LocalMetaMixin {
  ScenesDao(super.db);

  static const String collectionName = 'scenes';

  Stream<List<Scene>> watchAll() => select(scenes).watch();

  Future<Scene?> getById(String id) =>
      (select(scenes)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<void> upsert(Scene scene, {bool markDirty = false}) {
    return transaction(() async {
      await into(scenes).insertOnConflictUpdate(scene);
      if (markDirty) await this.markDirty(collectionName, scene.id);
    });
  }

  Future<void> setClean(String id, int newRev) {
    return transaction(() async {
      await (update(scenes)..where((s) => s.id.equals(id)))
          .write(ScenesCompanion(rev: Value(newRev)));
      await markClean(collectionName, id);
    });
  }
}
