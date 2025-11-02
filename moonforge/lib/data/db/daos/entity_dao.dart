import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'entity_dao.g.dart';

@DriftAccessor(tables: [Entities])
class EntityDao extends DatabaseAccessor<AppDb> with _$EntityDaoMixin {
  EntityDao(AppDb db) : super(db);

  Stream<List<Entity>> watchAll() =>
      (select(entities)
            ..where((e) => e.deleted.equals(false))
            ..orderBy([(e) => OrderingTerm.asc(e.name)]))
          .watch();

  Future<List<Entity>> getAll() =>
      (select(entities)..where((e) => e.deleted.equals(false))).get();

  Stream<List<Entity>> watchByOrigin(String originId) =>
      (select(entities)
            ..where(
              (e) => e.originId.equals(originId) & e.deleted.equals(false),
            )
            ..orderBy([(e) => OrderingTerm.asc(e.name)]))
          .watch();

  Future<Entity?> getById(String id) =>
      (select(entities)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<void> upsert(EntitiesCompanion data) async =>
      into(entities).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(entities)..where((e) => e.id.equals(id))).go();

  Future<int> softDeleteById(String id) =>
      (update(entities)..where((e) => e.id.equals(id))).write(
        EntitiesCompanion(deleted: Value(true)),
      );

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Entity>> customQuery({
    Expression<bool> Function(Entities e)? filter,
    List<OrderingTerm Function(Entities e)>? sort,
    int? limit,
  }) {
    final query = select(entities);

    if (filter != null) {
      query.where(filter);
    }

    if (sort != null && sort.isNotEmpty) {
      query.orderBy(sort);
    }

    if (limit != null) {
      query.limit(limit);
    }

    return query.get();
  }
}
