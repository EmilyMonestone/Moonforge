import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:moonforge/data/db/daos/player_dao.dart';
import 'package:moonforge/data/repo/base_repository.dart';

import '../db/app_db.dart';
import '../db/tables.dart';

class PlayerRepository extends BaseRepository<Player, String> {
  PlayerRepository(this._db);

  final AppDb _db;

  PlayerDao get _dao => _db.playerDao;

  @override
  Future<Player?> getById(String id) =>
      handleError(() => _dao.getById(id), context: 'player.getById');

  @override
  Future<List<Player>> getAll() =>
      handleError(() => _dao.watchAll().first, context: 'player.getAll');

  @override
  Stream<List<Player>> watchAll() =>
      handleStreamError(_dao.watchAll, context: 'player.watchAll');

  Stream<List<Player>> watchByCampaign(String campaignId) => handleStreamError(
    () => _dao.watchByCampaign(campaignId),
    context: 'player.watchByCampaign',
  );

  Future<Player?> getByDdbCharacterId(String ddbCharacterId) =>
      handleError(() async {
        final players = await _dao.customQuery(
          filter: (p) => p.ddbCharacterId.equals(ddbCharacterId),
          limit: 1,
        );
        return players.isEmpty ? null : players.first;
      }, context: 'player.getByDdbCharacterId');

  @override
  Future<Player> create(Player player) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(_buildPlayerCompanion(player, isCreate: true));
      await _db.outboxDao.enqueue(
        table: 'players',
        rowId: player.id,
        op: 'upsert',
      );
    });
    return player;
  }, context: 'player.create');

  @override
  Future<Player> update(Player player) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(_buildPlayerCompanion(player, isCreate: false));
      await _db.outboxDao.enqueue(
        table: 'players',
        rowId: player.id,
        op: 'upsert',
      );
    });
    return player;
  }, context: 'player.update');

  PlayersCompanion _buildPlayerCompanion(
    Player player, {
    required bool isCreate,
  }) {
    if (isCreate) {
      return PlayersCompanion.insert(
        id: Value(player.id),
        campaignId: player.campaignId,
        playerUid: Value(player.playerUid),
        name: player.name,
        className: player.className,
        subclass: Value(player.subclass),
        level: Value(player.level),
        race: Value(player.race),
        background: Value(player.background),
        alignment: Value(player.alignment),
        str: Value(player.str),
        dex: Value(player.dex),
        con: Value(player.con),
        intl: Value(player.intl),
        wis: Value(player.wis),
        cha: Value(player.cha),
        hpMax: Value(player.hpMax),
        hpCurrent: Value(player.hpCurrent),
        hpTemp: Value(player.hpTemp),
        ac: Value(player.ac),
        proficiencyBonus: Value(player.proficiencyBonus),
        speed: Value(player.speed),
        savingThrowProficiencies: Value(player.savingThrowProficiencies),
        skillProficiencies: Value(player.skillProficiencies),
        languages: Value(player.languages),
        equipment: Value(player.equipment),
        features: Value(player.features),
        spells: Value(player.spells),
        notes: Value(player.notes),
        bio: Value(player.bio),
        ddbCharacterId: Value(player.ddbCharacterId),
        lastDdbSync: Value(player.lastDdbSync),
        createdAt: Value(player.createdAt ?? DateTime.now()),
        updatedAt: Value(DateTime.now()),
        rev: Value(player.rev),
        deleted: Value(player.deleted),
      );
    } else {
      return PlayersCompanion(
        id: Value(player.id),
        campaignId: Value(player.campaignId),
        playerUid: Value(player.playerUid),
        name: Value(player.name),
        className: Value(player.className),
        subclass: Value(player.subclass),
        level: Value(player.level),
        race: Value(player.race),
        background: Value(player.background),
        alignment: Value(player.alignment),
        str: Value(player.str),
        dex: Value(player.dex),
        con: Value(player.con),
        intl: Value(player.intl),
        wis: Value(player.wis),
        cha: Value(player.cha),
        hpMax: Value(player.hpMax),
        hpCurrent: Value(player.hpCurrent),
        hpTemp: Value(player.hpTemp),
        ac: Value(player.ac),
        proficiencyBonus: Value(player.proficiencyBonus),
        speed: Value(player.speed),
        savingThrowProficiencies: Value(player.savingThrowProficiencies),
        skillProficiencies: Value(player.skillProficiencies),
        languages: Value(player.languages),
        equipment: Value(player.equipment),
        features: Value(player.features),
        spells: Value(player.spells),
        notes: Value(player.notes),
        bio: Value(player.bio),
        ddbCharacterId: Value(player.ddbCharacterId),
        lastDdbSync: Value(player.lastDdbSync),
        updatedAt: Value(DateTime.now()),
        rev: Value(player.rev + 1),
        deleted: Value(player.deleted),
      );
    }
  }

  @override
  Future<void> delete(String id) => handleError(() async {
    await _db.transaction(() async {
      await _dao.softDeleteById(id);
      await _db.outboxDao.enqueue(table: 'players', rowId: id, op: 'delete');
    });
  }, context: 'player.delete');

  @override
  Stream<Player?> watchById(String id) => handleStreamError(
    () =>
        _dao.watchAll().map((list) => list.firstWhereOrNull((p) => p.id == id)),
    context: 'player.watchById',
  );

  Future<List<Player>> customQuery({
    Expression<bool> Function(Players p)? filter,
    List<OrderingTerm Function(Players p)>? sort,
    int? limit,
  }) => handleError(
    () => _dao.customQuery(filter: filter, sort: sort, limit: limit),
    context: 'player.customQuery',
  );
}
