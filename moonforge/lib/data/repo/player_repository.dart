import 'package:drift/drift.dart';
import 'package:moonforge/data/db/tables.dart';

import '../db/app_db.dart';

/// Repository for Player operations
class PlayerRepository {
  final AppDb _db;

  PlayerRepository(this._db);

  Stream<List<Player>> watchAll() => _db.playerDao.watchAll();

  /// Watch players for a campaign
  Stream<List<Player>> watchByCampaign(String campaignId) =>
      _db.playerDao.watchByCampaign(campaignId);

  /// Get a single player by ID
  Future<Player?> getById(String id) => _db.playerDao.getById(id);

  /// Get a player by D&D Beyond character ID
  Future<Player?> getByDdbCharacterId(String ddbCharacterId) async {
    final players = await _db.playerDao.customQuery(
      filter: (p) => p.ddbCharacterId.equals(ddbCharacterId),
      limit: 1,
    );
    return players.isEmpty ? null : players.first;
  }

  /// Create a new player
  Future<void> create(Player player) async {
    await _db.transaction(() async {
      await _db.playerDao.upsert(_buildPlayerCompanion(player, isCreate: true));

      await _db.outboxDao.enqueue(
        table: 'players',
        rowId: player.id,
        op: 'upsert',
      );
    });
  }

  /// Update an existing player
  Future<void> update(Player player) async {
    await _db.transaction(() async {
      await _db.playerDao.upsert(
        _buildPlayerCompanion(player, isCreate: false),
      );

      await _db.outboxDao.enqueue(
        table: 'players',
        rowId: player.id,
        op: 'upsert',
      );
    });
  }

  /// Build a PlayersCompanion from a Player object
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

  /// Delete a player (soft delete)
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      // Soft delete by setting deleted flag
      await _db.playerDao.upsert(
        PlayersCompanion(
          id: Value(id),
          deleted: Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await _db.outboxDao.enqueue(table: 'players', rowId: id, op: 'delete');
    });
  }

  /// Custom query with custom filter, custom sort and custom limit
  Future<List<Player>> customQuery({
    Expression<bool> Function(Players p)? filter,
    List<OrderingTerm Function(Players p)>? sort,
    int? limit,
  }) {
    return _db.playerDao.customQuery(filter: filter, sort: sort, limit: limit);
  }
}
