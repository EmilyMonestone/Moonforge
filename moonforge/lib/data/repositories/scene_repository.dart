import 'package:isar/isar.dart';
import 'package:moonforge/data/models/scene.dart';
import 'package:moonforge/data/repositories/base_repository.dart';

class SceneRepository extends BaseRepository<Scene> {
  SceneRepository(super.isar) : super('scenes');

  @override
  IsarCollection<Scene> get collection => isar.scenes;

  @override
  String getEntityId(Scene entity) => entity.id;

  @override
  bool isDeleted(Scene entity) => entity.deleted;

  @override
  void setDeleted(Scene entity, bool value) => entity.deleted = value;

  @override
  void setUpdatedAt(Scene entity, DateTime time) => entity.updatedAt = time;

  @override
  void setSyncStatus(Scene entity, String status) => entity.syncStatus = status;

  @override
  void setLastSyncedAt(Scene entity, DateTime time) => entity.lastSyncedAt = time;

  @override
  DateTime? getUpdatedAt(Scene entity) => entity.updatedAt;

  @override
  String getSyncStatus(Scene entity) => entity.syncStatus;

  @override
  int getRev(Scene entity) => entity.rev;

  @override
  Map<String, dynamic> toFirestore(Scene entity) => entity.toFirestore();
}
