import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/media_asset.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/dao/local_meta_mixin.dart';
import 'package:moonforge/data/drift/tables/media_assets.dart';
import 'package:moonforge/data/drift/tables/local_metas.dart';

part 'media_assets_dao.g.dart';

@DriftAccessor(tables: [MediaAssets, LocalMetas])
class MediaAssetsDao extends DatabaseAccessor<AppDatabase>
    with _$MediaAssetsDaoMixin, LocalMetaMixin {
  MediaAssetsDao(super.db);

  static const String collectionName = 'media_assets';

  Stream<List<MediaAsset>> watchAll() => select(mediaAssets).watch();

  Future<MediaAsset?> getById(String id) =>
      (select(mediaAssets)..where((m) => m.id.equals(id))).getSingleOrNull();

  Future<void> upsert(MediaAsset asset, {bool markDirty = false}) {
    return transaction(() async {
      await into(mediaAssets).insertOnConflictUpdate(asset);
      if (markDirty) await this.markDirty(collectionName, asset.id);
    });
  }

  Future<void> setClean(String id, int newRev) {
    return transaction(() async {
      await (update(mediaAssets)..where((m) => m.id.equals(id)))
          .write(MediaAssetsCompanion(rev: Value(newRev)));
      await markClean(collectionName, id);
    });
  }

  /// Get download status for a media asset
  Future<String?> getDownloadStatus(String id) async {
    final meta = await getLocalMeta(collectionName, id);
    return meta?.downloadStatus;
  }

  /// Get local file path for a downloaded media asset
  Future<String?> getLocalPath(String id) async {
    final meta = await getLocalMeta(collectionName, id);
    return meta?.localPath;
  }
}
