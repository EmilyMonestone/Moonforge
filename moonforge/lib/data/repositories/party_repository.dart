import 'package:isar/isar.dart';
import 'package:moonforge/data/models/party.dart';
import 'package:moonforge/data/repositories/base_repository.dart';

class PartyRepository extends BaseRepository<Party> {
  PartyRepository(super.isar) : super('parties');

  @override
  IsarCollection<Party> get collection => isar.parties;

  @override
  String getEntityId(Party entity) => entity.id;

  @override
  bool isDeleted(Party entity) => entity.deleted;

  @override
  void setDeleted(Party entity, bool value) => entity.deleted = value;

  @override
  void setUpdatedAt(Party entity, DateTime time) => entity.updatedAt = time;

  @override
  void setSyncStatus(Party entity, String status) => entity.syncStatus = status;

  @override
  void setLastSyncedAt(Party entity, DateTime time) => entity.lastSyncedAt = time;

  @override
  DateTime? getUpdatedAt(Party entity) => entity.updatedAt;

  @override
  String getSyncStatus(Party entity) => entity.syncStatus;

  @override
  int getRev(Party entity) => entity.rev;

  @override
  Map<String, dynamic> toFirestore(Party entity) => entity.toFirestore();
}
