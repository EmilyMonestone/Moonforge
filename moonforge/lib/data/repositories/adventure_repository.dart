import 'package:isar/isar.dart';
import 'package:moonforge/data/models/adventure.dart';
import 'package:moonforge/data/repositories/base_repository.dart';

class AdventureRepository extends BaseRepository<Adventure> {
  AdventureRepository(super.isar) : super('adventures');

  @override
  IsarCollection<Adventure> get collection => isar.adventures;

  @override
  String getEntityId(Adventure entity) => entity.id;

  @override
  bool isDeleted(Adventure entity) => entity.deleted;

  @override
  void setDeleted(Adventure entity, bool value) => entity.deleted = value;

  @override
  void setUpdatedAt(Adventure entity, DateTime time) => entity.updatedAt = time;

  @override
  void setSyncStatus(Adventure entity, String status) => entity.syncStatus = status;

  @override
  void setLastSyncedAt(Adventure entity, DateTime time) => entity.lastSyncedAt = time;

  @override
  DateTime? getUpdatedAt(Adventure entity) => entity.updatedAt;

  @override
  String getSyncStatus(Adventure entity) => entity.syncStatus;

  @override
  int getRev(Adventure entity) => entity.rev;

  @override
  Map<String, dynamic> toFirestore(Adventure entity) => entity.toFirestore();
}
