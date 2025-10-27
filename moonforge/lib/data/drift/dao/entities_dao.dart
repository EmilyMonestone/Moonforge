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
      await into(entities).insert(
        EntitiesCompanion.insert(
          id: entity.id,
          kind: entity.kind,
          name: entity.name,
          summary: Value(entity.summary),
          tags: Value(entity.tags),
          statblock: Value(entity.statblock),
          placeType: Value(entity.placeType),
          parentPlaceId: Value(entity.parentPlaceId),
          coords: Value(entity.coords),
          content: Value(entity.content),
          images: Value(entity.images),
          createdAt: Value(entity.createdAt),
          updatedAt: Value(entity.updatedAt),
          rev: Value(entity.rev),
          deleted: Value(entity.deleted),
          members: Value(entity.members),
        ),
        mode: InsertMode.insertOrReplace,
      );
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
