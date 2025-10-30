import 'package:isar/isar.dart';
import 'package:moonforge/data/models/campaign.dart';
import 'package:moonforge/data/repositories/base_repository.dart';

/// Repository for Campaign operations with local-first Isar storage
class CampaignRepository extends BaseRepository<Campaign> {
  CampaignRepository(super.isar) : super('campaigns');

  @override
  IsarCollection<Campaign> get collection => isar.campaigns;

  @override
  String getEntityId(Campaign entity) => entity.id;

  @override
  bool isDeleted(Campaign entity) => entity.deleted;

  @override
  void setDeleted(Campaign entity, bool value) => entity.deleted = value;

  @override
  void setUpdatedAt(Campaign entity, DateTime time) => entity.updatedAt = time;

  @override
  void setSyncStatus(Campaign entity, String status) => entity.syncStatus = status;

  @override
  void setLastSyncedAt(Campaign entity, DateTime time) => entity.lastSyncedAt = time;

  @override
  DateTime? getUpdatedAt(Campaign entity) => entity.updatedAt;

  @override
  String getSyncStatus(Campaign entity) => entity.syncStatus;

  @override
  int getRev(Campaign entity) => entity.rev;

  @override
  Map<String, dynamic> toFirestore(Campaign entity) => entity.toFirestore();
}
