import 'package:isar/isar.dart';
import 'package:moonforge/data/models/entity.dart';
import 'package:moonforge/data/repositories/base_repository.dart';

class EntityRepository extends BaseRepository<Entity> {
  EntityRepository(super.isar) : super('entities');

  @override
  IsarCollection<Entity> get collection => isar.entities;

  @override
  String getEntityId(Entity entity) => entity.id;

  @override
  bool isDeleted(Entity entity) => entity.deleted;

  @override
  void setDeleted(Entity entity, bool value) => entity.deleted = value;

  @override
  void setUpdatedAt(Entity entity, DateTime time) => entity.updatedAt = time;

  @override
  void setSyncStatus(Entity entity, String status) => entity.syncStatus = status;

  @override
  void setLastSyncedAt(Entity entity, DateTime time) => entity.lastSyncedAt = time;

  @override
  DateTime? getUpdatedAt(Entity entity) => entity.updatedAt;

  @override
  String getSyncStatus(Entity entity) => entity.syncStatus;

  @override
  int getRev(Entity entity) => entity.rev;

  @override
  Map<String, dynamic> toFirestore(Entity entity) => entity.toFirestore();
}
