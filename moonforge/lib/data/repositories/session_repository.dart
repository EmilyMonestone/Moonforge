import 'package:isar/isar.dart';
import 'package:moonforge/data/models/session.dart';
import 'package:moonforge/data/repositories/base_repository.dart';

class SessionRepository extends BaseRepository<Session> {
  SessionRepository(super.isar) : super('sessions');

  @override
  IsarCollection<Session> get collection => isar.sessions;

  @override
  String getEntityId(Session entity) => entity.id;

  @override
  bool isDeleted(Session entity) => entity.deleted;

  @override
  void setDeleted(Session entity, bool value) => entity.deleted = value;

  @override
  void setUpdatedAt(Session entity, DateTime time) => entity.updatedAt = time;

  @override
  void setSyncStatus(Session entity, String status) => entity.syncStatus = status;

  @override
  void setLastSyncedAt(Session entity, DateTime time) => entity.lastSyncedAt = time;

  @override
  DateTime? getUpdatedAt(Session entity) => entity.updatedAt;

  @override
  String getSyncStatus(Session entity) => entity.syncStatus;

  @override
  int getRev(Session entity) => entity.rev;

  @override
  Map<String, dynamic> toFirestore(Session entity) => entity.toFirestore();
}
