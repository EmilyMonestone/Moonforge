import '../db/app_db.dart';
import '../db/tables.dart';
import 'package:drift/drift.dart';

/// Repository for MediaAsset operations
class MediaAssetRepository {
  final AppDb _db;

  MediaAssetRepository(this._db);

  /// Watch all media assets
  Stream<List<MediaAsset>> watchAll() => _db.mediaAssetDao.watchAll();

  /// Get a single media asset by ID
  Future<MediaAsset?> getById(String id) => _db.mediaAssetDao.getById(id);

  /// Create a new media asset
  Future<void> create(MediaAsset asset) async {
    await _db.transaction(() async {
      await _db.mediaAssetDao.upsert(
        MediaAssetsCompanion.insert(
          id: asset.id,
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
  }

  /// Update an existing media asset
  Future<void> update(MediaAsset asset) async {
    await _db.transaction(() async {
      await _db.mediaAssetDao.upsert(
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
  }

  /// Delete a media asset
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await _db.mediaAssetDao.deleteById(id);
      
      await _db.outboxDao.enqueue(
        table: 'mediaAssets',
        rowId: id,
        op: 'delete',
      );
    });
  }
}
