import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:moonforge/data/db/daos/entity_dao.dart';
import 'package:moonforge/data/repo/base_repository.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

/// Repository for Entity operations
class EntityRepository extends BaseRepository<Entity, String> {
  EntityRepository(this._db);

  final AppDb _db;

  EntityDao get _dao => _db.entityDao;

  @override
  Future<Entity?> getById(String id) =>
      handleError(() => _dao.getById(id), context: 'entity.getById');

  @override
  Future<List<Entity>> getAll() =>
      handleError(() => _dao.getAll(), context: 'entity.getAll');

  /// Watch all entities (excluding deleted)
  @override
  Stream<List<Entity>> watchAll() =>
      handleStreamError(_dao.watchAll, context: 'entity.watchAll');

  /// Watch entities by origin
  Stream<List<Entity>> watchByOrigin(String originId) => handleStreamError(
    () => _dao.watchByOrigin(originId),
    context: 'entity.watchByOrigin',
  );

  @override
  Future<Entity> create(Entity entity) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        EntitiesCompanion.insert(
          id: Value(entity.id),
          kind: entity.kind,
          name: entity.name,
          originType: Value(entity.originType),
          originId: entity.originId,
          summary: Value(entity.summary),
          tags: Value(entity.tags),
          statblock: entity.statblock,
          placeType: Value(entity.placeType),
          parentPlaceId: Value(entity.parentPlaceId),
          coords: entity.coords,
          content: Value(entity.content),
          images: Value(entity.images),
          createdAt: Value(entity.createdAt ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          rev: entity.rev,
          deleted: Value(entity.deleted),
          members: Value(entity.members),
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'entities',
        rowId: entity.id,
        op: 'upsert',
      );
    });
    return entity;
  }, context: 'entity.create');

  @override
  Future<Entity> update(Entity entity) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        EntitiesCompanion(
          id: Value(entity.id),
          kind: Value(entity.kind),
          name: Value(entity.name),
          originType: Value(entity.originType),
          originId: Value(entity.originId),
          summary: Value(entity.summary),
          tags: Value(entity.tags),
          statblock: Value(entity.statblock),
          placeType: Value(entity.placeType),
          parentPlaceId: Value(entity.parentPlaceId),
          coords: Value(entity.coords),
          content: Value(entity.content),
          images: Value(entity.images),
          updatedAt: Value(DateTime.now()),
          rev: Value(entity.rev + 1),
          deleted: Value(entity.deleted),
          members: Value(entity.members),
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'entities',
        rowId: entity.id,
        op: 'upsert',
      );
    });
    return entity;
  }, context: 'entity.update');

  /// Optimistic local upsert (no rev bump here)
  Future<void> upsertLocal(Entity entity) => handleError(() async {
    await _dao.upsert(
      EntitiesCompanion(
        id: Value(entity.id),
        kind: Value(entity.kind),
        name: Value(entity.name),
        originType: Value(entity.originType),
        originId: Value(entity.originId),
        summary: Value(entity.summary),
        tags: Value(entity.tags),
        statblock: Value(entity.statblock),
        placeType: Value(entity.placeType),
        parentPlaceId: Value(entity.parentPlaceId),
        coords: Value(entity.coords),
        content: Value(entity.content),
        images: Value(entity.images),
        createdAt: Value(entity.createdAt ?? DateTime.now()),
        updatedAt: Value(DateTime.now()),
        rev: Value(entity.rev),
        deleted: Value(entity.deleted),
        members: Value(entity.members),
      ),
    );
    await _db.outboxDao.enqueue(
      table: 'entities',
      rowId: entity.id,
      op: 'upsert',
    );
  }, context: 'entity.upsertLocal');

  @override
  Future<void> delete(String id) => handleError(() async {
    await _db.transaction(() async {
      await _dao.softDeleteById(id);
      await _db.outboxDao.enqueue(table: 'entities', rowId: id, op: 'delete');
    });
  }, context: 'entity.delete');

  /// Custom query passthrough
  Future<List<Entity>> customQuery({
    Expression<bool> Function(Entities e)? filter,
    List<OrderingTerm Function(Entities e)>? sort,
    int? limit,
  }) => handleError(
    () => _dao.customQuery(filter: filter, sort: sort, limit: limit),
    context: 'entity.customQuery',
  );

  @override
  Stream<Entity?> watchById(String id) => handleStreamError(
    () =>
        _dao.watchAll().map((list) => list.firstWhereOrNull((e) => e.id == id)),
    context: 'entity.watchById',
  );
}
