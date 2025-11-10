import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'scene_dao.g.dart';

@DriftAccessor(tables: [Scenes])
class SceneDao extends DatabaseAccessor<AppDb> with _$SceneDaoMixin {
  SceneDao(super.db);

  Stream<List<Scene>> watchAll() =>
      (select(scenes)..orderBy([(s) => OrderingTerm.asc(s.order)])).watch();

  Future<List<Scene>> getAll() =>
      (select(scenes)..orderBy([(s) => OrderingTerm.asc(s.order)])).get();

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

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Scene>> customQuery({
    Expression<bool> Function(Scenes s)? filter,
    List<OrderingTerm Function(Scenes s)>? sort,
    int? limit,
  }) {
    final query = select(scenes);

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
