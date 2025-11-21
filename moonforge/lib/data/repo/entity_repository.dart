import 'package:drift/drift.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

/// Repository for Entity operations
class EntityRepository {
  final AppDb _db;

  EntityRepository(this._db);

  /// Watch all entities (excluding deleted)
  Stream<List<Entity>> watchAll() => _db.entityDao.watchAll();

  Future<List<Entity>> getAll() => _db.entityDao.getAll();

  /// Watch entities by origin
  Stream<List<Entity>> watchByOrigin(String originId) =>
      _db.entityDao.watchByOrigin(originId);

  /// Get a single entity by ID
  Future<Entity?> getById(String id) => _db.entityDao.getById(id);

  /// Create a new entity
  Future<void> create(Entity entity) async {
    await _db.transaction(() async {
      await _db.entityDao.upsert(
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
  }

  /// Update an existing entity
  Future<void> update(Entity entity) async {
    await _db.transaction(() async {
      await _db.entityDao.upsert(
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
  }

  /// Optimistic local upsert (no rev bump here)
  Future<void> upsertLocal(Entity entity) async {
    await _db.entityDao.upsert(
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
  }

  /// Soft delete an entity
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.entityDao.softDeleteById(id);

      await _db.outboxDao.enqueue(table: 'entities', rowId: id, op: 'delete');
    });
  }

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Entity>> customQuery({
    Expression<bool> Function(Entities e)? filter,
    List<OrderingTerm Function(Entities e)>? sort,
    int? limit,
  }) {
    return _db.entityDao.customQuery(filter: filter, sort: sort, limit: limit);
  }
}
