import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/entity.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/dao/local_meta_mixin.dart';
import 'package:moonforge/data/drift/tables/entities.dart';
import 'package:moonforge/data/drift/tables/local_metas.dart';

part 'entities_dao.g.dart';

@DriftAccessor(tables: [Entities, LocalMetas])
class EntitiesDao extends DatabaseAccessor<AppDatabase>
    with _$EntitiesDaoMixin, LocalMetaMixin {
  EntitiesDao(super.db);

  static const String collectionName = 'entities';

  Stream<List<Entity>> watchAll() => select(entities).watch();

  Future<Entity?> getById(String id) =>
      (select(entities)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<void> upsert(Entity entity, {bool markDirty = false}) {
    return transaction(() async {
      await into(entities).insertOnConflictUpdate(entity);
      if (markDirty) await this.markDirty(collectionName, entity.id);
    });
  }

  Future<void> setClean(String id, int newRev) {
    return transaction(() async {
      await (update(entities)..where((e) => e.id.equals(id)))
          .write(EntitiesCompanion(rev: Value(newRev)));
      await markClean(collectionName, id);
    });
  }
}
