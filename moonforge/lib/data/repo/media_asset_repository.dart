import 'dart:convert';

import 'package:moonforge/data/drift/app_database.dart' show AppDatabase;
import 'package:moonforge/data/firebase/models/media_asset.dart'
    show MediaAsset;

/// Repository for MediaAsset operations
class MediaAssetRepository {
  final AppDatabase _db;

  MediaAssetRepository(this._db);

  Stream<List<MediaAsset>> watchAll() => _db.mediaAssetsDao.watchAll();

  Future<MediaAsset?> getById(String id) => _db.mediaAssetsDao.getById(id);

  Future<void> upsertLocal(MediaAsset asset) async {
    await _db.transaction(() async {
      await _db.mediaAssetsDao.upsert(asset, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'media_assets',
        docId: asset.id,
        baseRev: asset.rev,
        opType: 'upsert',
        payload: jsonEncode(asset.toJson()),
      );
    });
  }

  Future<void> patchLocal({
    required String id,
    required int baseRev,
    required List<Map<String, dynamic>> ops,
  }) async {
    await _db.transaction(() async {
      final current = await _db.mediaAssetsDao.getById(id);
      if (current == null) return;

      MediaAsset updated = current;
      for (final op in ops) {
        updated = _applyPatchOp(updated, op);
      }

      await _db.mediaAssetsDao.upsert(updated, markDirty: true);
      await _db.outboxDao.enqueue(
        docPath: 'media_assets',
        docId: id,
        baseRev: baseRev,
        opType: 'patch',
        payload: jsonEncode({'ops': ops}),
      );
    });
  }

  MediaAsset _applyPatchOp(MediaAsset asset, Map<String, dynamic> op) {
    final type = op['type'] as String;
    final field = op['field'] as String;
    final value = op['value'];

    if (type == 'set') {
      switch (field) {
        case 'filename':
          return asset.copyWith(filename: value as String);
        case 'alt':
          return asset.copyWith(alt: value as String?);
      }
    } else if (type == 'addToSet' && field == 'captions') {
      final current = asset.captions ?? [];
      if (!current.contains(value)) {
        return asset.copyWith(captions: [...current, value as String]);
      }
    } else if (type == 'removeFromSet' && field == 'captions') {
      final current = asset.captions ?? [];
      return asset.copyWith(
        captions: current.where((c) => c != value).toList(),
      );
    }
    return asset;
  }

  /// Get download status for a media asset
  Future<String?> getDownloadStatus(String id) {
    return _db.mediaAssetsDao.getDownloadStatus(id);
  }

  /// Get local file path for a cached media asset
  Future<String?> getLocalPath(String id) {
    return _db.mediaAssetsDao.getLocalPath(id);
  }
}
