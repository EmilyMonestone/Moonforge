import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/player.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/dao/local_meta_mixin.dart';
import 'package:moonforge/data/drift/tables/players.dart';
import 'package:moonforge/data/drift/tables/local_metas.dart';

part 'players_dao.g.dart';

@DriftAccessor(tables: [Players, LocalMetas])
class PlayersDao extends DatabaseAccessor<AppDatabase>
    with _$PlayersDaoMixin, LocalMetaMixin {
  PlayersDao(super.db);

  static const String collectionName = 'players';

  Stream<List<Player>> watchAll() => select(players).watch();

  Future<Player?> getById(String id) =>
      (select(players)..where((p) => p.id.equals(id))).getSingleOrNull();
  
  Future<List<Player>> getByIds(List<String> ids) =>
      (select(players)..where((p) => p.id.isIn(ids))).get();

  Future<void> upsert(Player player, {bool markDirty = false}) {
    return transaction(() async {
      await into(players).insert(
        PlayersCompanion.insert(
          id: player.id,
          name: player.name,
          partyId: Value(player.partyId),
          playerClass: Value(player.playerClass),
          level: Value(player.level),
          species: Value(player.species),
          info: Value(player.info),
          createdAt: Value(player.createdAt),
          updatedAt: Value(player.updatedAt),
          rev: Value(player.rev),
        ),
        mode: InsertMode.insertOrReplace,
      );
      if (markDirty) await this.markDirty(collectionName, player.id);
    });
  }

  Future<void> setClean(String id, int newRev) {
    return transaction(() async {
      await (update(players)..where((p) => p.id.equals(id)))
          .write(PlayersCompanion(rev: Value(newRev)));
      await markClean(collectionName, id);
    });
  }
}
