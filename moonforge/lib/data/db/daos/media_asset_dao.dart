import 'package:drift/drift.dart';

import '../app_db.dart';
import '../tables.dart';

part 'media_asset_dao.g.dart';

@DriftAccessor(tables: [MediaAssets])
class MediaAssetDao extends DatabaseAccessor<AppDb> with _$MediaAssetDaoMixin {
  MediaAssetDao(super.db);

  Stream<List<MediaAsset>> watchAll() => (select(
    mediaAssets,
  )..orderBy([(m) => OrderingTerm.desc(m.createdAt)])).watch();

  Future<List<MediaAsset>> getAll() => (select(
    mediaAssets,
  )..orderBy([(m) => OrderingTerm.desc(m.createdAt)])).get();

  Future<MediaAsset?> getById(String id) =>
      (select(mediaAssets)..where((m) => m.id.equals(id))).getSingleOrNull();

  Future<void> upsert(MediaAssetsCompanion data) async =>
      into(mediaAssets).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(mediaAssets)..where((m) => m.id.equals(id))).go();

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<MediaAsset>> customQuery({
    Expression<bool> Function(MediaAssets m)? filter,
    List<OrderingTerm Function(MediaAssets m)>? sort,
    int? limit,
  }) {
    final query = select(mediaAssets);

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
