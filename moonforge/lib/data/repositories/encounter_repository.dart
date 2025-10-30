import 'package:isar/isar.dart';
import 'package:moonforge/data/models/encounter.dart';
import 'package:moonforge/data/repositories/base_repository.dart';

class EncounterRepository extends BaseRepository<Encounter> {
  EncounterRepository(super.isar) : super('encounters');

  @override
  IsarCollection<Encounter> get collection => isar.encounters;

  @override
  String getEntityId(Encounter entity) => entity.id;

  @override
  bool isDeleted(Encounter entity) => entity.deleted;

  @override
  void setDeleted(Encounter entity, bool value) => entity.deleted = value;

  @override
  void setUpdatedAt(Encounter entity, DateTime time) => entity.updatedAt = time;

  @override
  void setSyncStatus(Encounter entity, String status) => entity.syncStatus = status;

  @override
  void setLastSyncedAt(Encounter entity, DateTime time) => entity.lastSyncedAt = time;

  @override
  DateTime? getUpdatedAt(Encounter entity) => entity.updatedAt;

  @override
  String getSyncStatus(Encounter entity) => entity.syncStatus;

  @override
  int getRev(Encounter entity) => entity.rev;

  @override
  Map<String, dynamic> toFirestore(Encounter entity) => entity.toFirestore();
}
