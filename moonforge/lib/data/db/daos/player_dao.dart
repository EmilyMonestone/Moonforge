import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'player_dao.g.dart';

@DriftAccessor(tables: [Players])
class PlayerDao extends DatabaseAccessor<AppDb> with _$PlayerDaoMixin {
  PlayerDao(super.db);

  Stream<List<Player>> watchAll() =>
      (select(players)
        ..orderBy([(p) => OrderingTerm.asc(p.name)])).watch();

  Stream<List<Player>> watchByCampaign(String campaignId) =>
      (select(players)
        ..where((p) => p.campaignId.equals(campaignId))
        ..orderBy([(p) => OrderingTerm.asc(p.name)]))
          .watch();

  Future<Player?> getById(String id) =>
      (select(players)
        ..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<void> upsert(PlayersCompanion data) async =>
      into(players).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(players)
        ..where((p) => p.id.equals(id))).go();

  /// Soft-delete by setting the `deleted` flag to true and updating `updatedAt`.
  Future<int> softDeleteById(String id) =>
      (update(players)
        ..where((p) => p.id.equals(id))).write(
        PlayersCompanion(
            deleted: Value(true), updatedAt: Value(DateTime.now())),
      );

  Future<List<Player>> customQuery({
    Expression<bool> Function(Players p)? filter,
    List<OrderingTerm Function(Players p)>? sort,
    int? limit,
  }) {
    final query = select(players);

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
