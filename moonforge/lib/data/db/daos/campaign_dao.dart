import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'campaign_dao.g.dart';

@DriftAccessor(tables: [Campaigns])
class CampaignDao extends DatabaseAccessor<AppDb> with _$CampaignDaoMixin {
  CampaignDao(super.db);

  Stream<List<Campaign>> watchAll() =>
      (select(campaigns)..orderBy([(c) => OrderingTerm.asc(c.name)])).watch();

  Future<Campaign?> getById(String id) =>
      (select(campaigns)..where((c) => c.id.equals(id))).getSingleOrNull();

  Future<void> upsert(CampaignsCompanion data) async =>
      into(campaigns).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(campaigns)..where((c) => c.id.equals(id))).go();

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Campaign>> customQuery({
    Expression<bool> Function(Campaigns c)? filter,
    List<OrderingTerm Function(Campaigns c)>? sort,
    int? limit,
  }) {
    final query = select(campaigns);

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

  Stream<Campaign?> watchById(String id) =>
      (select(campaigns)..where((c) => c.id.equals(id))).watchSingleOrNull();

  Future<List<Campaign>> getAll() =>
      (select(campaigns)..orderBy([(c) => OrderingTerm.asc(c.name)])).get();

  Future<List<Campaign>> getPaginated({
    required int limit,
    required int offset,
  }) {
    final query = select(campaigns)
      ..orderBy([(c) => OrderingTerm.asc(c.name)])
      ..limit(limit, offset: offset);
    return query.get();
  }

  Future<int> count() => customSelect(
    'SELECT COUNT(*) as cnt FROM campaigns',
  ).getSingle().then((row) => row.read<int>('cnt'));

  Future<List<Campaign>> getCampaignsByUser(String userId) =>
      (select(campaigns)..where(
            (c) => c.ownerUid.equals(userId) | c.memberUids.like('%$userId%'),
          ))
          .get();

  Stream<List<Campaign>> watchCampaignsByUser(String userId) =>
      (select(campaigns)..where(
            (c) => c.ownerUid.equals(userId) | c.memberUids.like('%$userId%'),
          ))
          .watch();
}
