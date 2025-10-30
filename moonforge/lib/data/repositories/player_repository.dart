import 'package:isar/isar.dart';
import 'package:moonforge/data/models/player.dart';
import 'package:moonforge/data/repositories/base_repository.dart';

class PlayerRepository extends BaseRepository<Player> {
  PlayerRepository(super.isar) : super('players');

  @override
  IsarCollection<Player> get collection => isar.players;

  @override
  String getEntityId(Player entity) => entity.id;

  @override
  bool isDeleted(Player entity) => entity.deleted;

  @override
  void setDeleted(Player entity, bool value) => entity.deleted = value;

  @override
  void setUpdatedAt(Player entity, DateTime time) => entity.updatedAt = time;

  @override
  void setSyncStatus(Player entity, String status) => entity.syncStatus = status;

  @override
  void setLastSyncedAt(Player entity, DateTime time) => entity.lastSyncedAt = time;

  @override
  DateTime? getUpdatedAt(Player entity) => entity.updatedAt;

  @override
  String getSyncStatus(Player entity) => entity.syncStatus;

  @override
  int getRev(Player entity) => entity.rev;

  @override
  Map<String, dynamic> toFirestore(Player entity) => entity.toFirestore();
}
