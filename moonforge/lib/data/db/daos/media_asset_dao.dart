import 'package:drift/drift.dart';
import '../app_db.dart';
import '../tables.dart';

part 'media_asset_dao.g.dart';

@DriftAccessor(tables: [MediaAssets])
class MediaAssetDao extends DatabaseAccessor<AppDb> with _$MediaAssetDaoMixin {
  MediaAssetDao(AppDb db) : super(db);

  Stream<List<MediaAsset>> watchAll() =>
      (select(mediaAssets)..orderBy([(m) => OrderingTerm.desc(m.createdAt)])).watch();

  Future<MediaAsset?> getById(String id) =>
      (select(mediaAssets)..where((m) => m.id.equals(id))).getSingleOrNull();

  Future<void> upsert(MediaAssetsCompanion data) async =>
      into(mediaAssets).insertOnConflictUpdate(data);

  Future<int> deleteById(String id) =>
      (delete(mediaAssets)..where((m) => m.id.equals(id))).go();
}
