import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:moonforge/data/db/daos/media_asset_dao.dart';
import 'package:moonforge/data/repo/base_repository.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

class MediaAssetRepository extends BaseRepository<MediaAsset, String> {
  MediaAssetRepository(this._db);

  final AppDb _db;

  MediaAssetDao get _dao => _db.mediaAssetDao;

  @override
  Future<MediaAsset?> getById(String id) =>
      handleError(() => _dao.getById(id), context: 'media.getById');

  @override
  Future<List<MediaAsset>> getAll() =>
      handleError(() => _dao.watchAll().first, context: 'media.getAll');

  @override
  Stream<List<MediaAsset>> watchAll() =>
      handleStreamError(_dao.watchAll, context: 'media.watchAll');

  @override
  Stream<MediaAsset?> watchById(String id) => handleStreamError(
    () =>
        _dao.watchAll().map((list) => list.firstWhereOrNull((m) => m.id == id)),
    context: 'media.watchById',
  );

  @override
  Future<MediaAsset> create(MediaAsset asset) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        MediaAssetsCompanion.insert(
          id: Value(asset.id),
          filename: asset.filename,
          size: asset.size,
          mime: asset.mime,
          captions: Value(asset.captions),
          alt: Value(asset.alt),
          variants: Value(asset.variants),
          createdAt: Value(asset.createdAt ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          rev: asset.rev,
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'mediaAssets',
        rowId: asset.id,
        op: 'upsert',
      );
    });
    return asset;
  }, context: 'media.create');

  @override
  Future<MediaAsset> update(MediaAsset asset) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        MediaAssetsCompanion(
          id: Value(asset.id),
          filename: Value(asset.filename),
          size: Value(asset.size),
          mime: Value(asset.mime),
          captions: Value(asset.captions),
          alt: Value(asset.alt),
          variants: Value(asset.variants),
          updatedAt: Value(DateTime.now()),
          rev: Value(asset.rev + 1),
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'mediaAssets',
        rowId: asset.id,
        op: 'upsert',
      );
    });
    return asset;
  }, context: 'media.update');

  @override
  Future<void> delete(String id) => handleError(() async {
    await _db.transaction(() async {
      await _dao.deleteById(id);
      await _db.outboxDao.enqueue(
        table: 'mediaAssets',
        rowId: id,
        op: 'delete',
      );
    });
  }, context: 'media.delete');

  Future<List<MediaAsset>> customQuery({
    Expression<bool> Function(MediaAssets m)? filter,
    List<OrderingTerm Function(MediaAssets m)>? sort,
    int? limit,
  }) => handleError(
    () => _dao.customQuery(filter: filter, sort: sort, limit: limit),
    context: 'media.customQuery',
  );
}
