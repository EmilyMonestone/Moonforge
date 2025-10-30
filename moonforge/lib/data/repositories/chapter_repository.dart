import 'package:isar/isar.dart';
import 'package:moonforge/data/models/chapter.dart';
import 'package:moonforge/data/repositories/base_repository.dart';

class ChapterRepository extends BaseRepository<Chapter> {
  ChapterRepository(super.isar) : super('chapters');

  @override
  IsarCollection<Chapter> get collection => isar.chapters;

  @override
  String getEntityId(Chapter entity) => entity.id;

  @override
  bool isDeleted(Chapter entity) => entity.deleted;

  @override
  void setDeleted(Chapter entity, bool value) => entity.deleted = value;

  @override
  void setUpdatedAt(Chapter entity, DateTime time) => entity.updatedAt = time;

  @override
  void setSyncStatus(Chapter entity, String status) => entity.syncStatus = status;

  @override
  void setLastSyncedAt(Chapter entity, DateTime time) => entity.lastSyncedAt = time;

  @override
  DateTime? getUpdatedAt(Chapter entity) => entity.updatedAt;

  @override
  String getSyncStatus(Chapter entity) => entity.syncStatus;

  @override
  int getRev(Chapter entity) => entity.rev;

  @override
  Map<String, dynamic> toFirestore(Chapter entity) => entity.toFirestore();
}
