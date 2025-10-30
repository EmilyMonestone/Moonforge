import 'package:isar/isar.dart';
import 'package:moonforge/data/models/media_asset.dart';
import 'package:moonforge/data/repositories/base_repository.dart';

class MediaAssetRepository extends BaseRepository<MediaAsset> {
  MediaAssetRepository(super.isar) : super('media');

  @override
  IsarCollection<MediaAsset> get collection => isar.mediaAssets;

  @override
  String getEntityId(MediaAsset entity) => entity.id;

  @override
  bool isDeleted(MediaAsset entity) => entity.deleted;

  @override
  void setDeleted(MediaAsset entity, bool value) => entity.deleted = value;

  @override
  void setUpdatedAt(MediaAsset entity, DateTime time) => entity.updatedAt = time;

  @override
  void setSyncStatus(MediaAsset entity, String status) => entity.syncStatus = status;

  @override
  void setLastSyncedAt(MediaAsset entity, DateTime time) => entity.lastSyncedAt = time;

  @override
  DateTime? getUpdatedAt(MediaAsset entity) => entity.updatedAt;

  @override
  String getSyncStatus(MediaAsset entity) => entity.syncStatus;

  @override
  int getRev(MediaAsset entity) => entity.rev;

  @override
  Map<String, dynamic> toFirestore(MediaAsset entity) => entity.toFirestore();
}
