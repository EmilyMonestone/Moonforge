import 'package:flutter/material.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/player_repository.dart';

/// Provider for managing current player character state
class PlayerProvider with ChangeNotifier {
  final PlayerRepository _repository;

  Player? _currentPlayer;

  Player? get currentPlayer => _currentPlayer;

  PlayerProvider(this._repository);

  /// Set the current player character
  void setCurrentPlayer(Player? player) {
    _currentPlayer = player;
    notifyListeners();
    if (player != null) {
      logger.i('Set current player: ${player.name} (${player.id})');
    } else {
      logger.i('Cleared current player');
    }
  }

  /// Load a player by ID and set as current
  Future<void> loadPlayer(String playerId) async {
    try {
      final player = await _repository.getById(playerId);
      setCurrentPlayer(player);
    } catch (e) {
      logger.e('Failed to load player: $e');
    }
  }

  /// Update HP (current, max, or temp)
  Future<void> updateHp({int? current, int? max, int? temp}) async {
    if (_currentPlayer == null) return;

    final updatedPlayer = Player(
      id: _currentPlayer!.id,
      campaignId: _currentPlayer!.campaignId,
      playerUid: _currentPlayer!.playerUid,
      name: _currentPlayer!.name,
      className: _currentPlayer!.className,
      subclass: _currentPlayer!.subclass,
      level: _currentPlayer!.level,
      race: _currentPlayer!.race,
      background: _currentPlayer!.background,
      alignment: _currentPlayer!.alignment,
      str: _currentPlayer!.str,
      dex: _currentPlayer!.dex,
      con: _currentPlayer!.con,
      intl: _currentPlayer!.intl,
      wis: _currentPlayer!.wis,
      cha: _currentPlayer!.cha,
      hpMax: max ?? _currentPlayer!.hpMax,
      hpCurrent: current ?? _currentPlayer!.hpCurrent,
      hpTemp: temp ?? _currentPlayer!.hpTemp,
      ac: _currentPlayer!.ac,
      proficiencyBonus: _currentPlayer!.proficiencyBonus,
      speed: _currentPlayer!.speed,
      savingThrowProficiencies: _currentPlayer!.savingThrowProficiencies,
      skillProficiencies: _currentPlayer!.skillProficiencies,
      languages: _currentPlayer!.languages,
      equipment: _currentPlayer!.equipment,
      features: _currentPlayer!.features,
      spells: _currentPlayer!.spells,
      notes: _currentPlayer!.notes,
      bio: _currentPlayer!.bio,
      ddbCharacterId: _currentPlayer!.ddbCharacterId,
      lastDdbSync: _currentPlayer!.lastDdbSync,
      createdAt: _currentPlayer!.createdAt,
      updatedAt: DateTime.now(),
      rev: _currentPlayer!.rev,
      deleted: _currentPlayer!.deleted,
    );

    await _repository.update(updatedPlayer);
    _currentPlayer = updatedPlayer;
    notifyListeners();
    logger.i('Updated HP for ${_currentPlayer!.name}');
  }

  /// Take damage
  Future<void> takeDamage(int damage) async {
    if (_currentPlayer == null) return;

    int currentHp = _currentPlayer!.hpCurrent ?? 0;
    int tempHp = _currentPlayer!.hpTemp ?? 0;

    // Apply damage to temp HP first
    if (tempHp > 0) {
      if (damage <= tempHp) {
        await updateHp(temp: tempHp - damage);
        return;
      } else {
        damage -= tempHp;
        tempHp = 0;
      }
    }

    // Apply remaining damage to current HP
    currentHp = (currentHp - damage).clamp(0, _currentPlayer!.hpMax ?? 0);
    await updateHp(current: currentHp, temp: tempHp);
  }

  /// Heal HP
  Future<void> heal(int amount) async {
    if (_currentPlayer == null) return;

    final currentHp = _currentPlayer!.hpCurrent ?? 0;
    final maxHp = _currentPlayer!.hpMax ?? 0;
    final newHp = (currentHp + amount).clamp(0, maxHp);

    await updateHp(current: newHp);
  }

  /// Update ability scores
  Future<void> updateAbilityScores({
    int? str,
    int? dex,
    int? con,
    int? intl,
    int? wis,
    int? cha,
  }) async {
    if (_currentPlayer == null) return;

    final updatedPlayer = Player(
      id: _currentPlayer!.id,
      campaignId: _currentPlayer!.campaignId,
      playerUid: _currentPlayer!.playerUid,
      name: _currentPlayer!.name,
      className: _currentPlayer!.className,
      subclass: _currentPlayer!.subclass,
      level: _currentPlayer!.level,
      race: _currentPlayer!.race,
      background: _currentPlayer!.background,
      alignment: _currentPlayer!.alignment,
      str: str ?? _currentPlayer!.str,
      dex: dex ?? _currentPlayer!.dex,
      con: con ?? _currentPlayer!.con,
      intl: intl ?? _currentPlayer!.intl,
      wis: wis ?? _currentPlayer!.wis,
      cha: cha ?? _currentPlayer!.cha,
      hpMax: _currentPlayer!.hpMax,
      hpCurrent: _currentPlayer!.hpCurrent,
      hpTemp: _currentPlayer!.hpTemp,
      ac: _currentPlayer!.ac,
      proficiencyBonus: _currentPlayer!.proficiencyBonus,
      speed: _currentPlayer!.speed,
      savingThrowProficiencies: _currentPlayer!.savingThrowProficiencies,
      skillProficiencies: _currentPlayer!.skillProficiencies,
      languages: _currentPlayer!.languages,
      equipment: _currentPlayer!.equipment,
      features: _currentPlayer!.features,
      spells: _currentPlayer!.spells,
      notes: _currentPlayer!.notes,
      bio: _currentPlayer!.bio,
      ddbCharacterId: _currentPlayer!.ddbCharacterId,
      lastDdbSync: _currentPlayer!.lastDdbSync,
      createdAt: _currentPlayer!.createdAt,
      updatedAt: DateTime.now(),
      rev: _currentPlayer!.rev,
      deleted: _currentPlayer!.deleted,
    );

    await _repository.update(updatedPlayer);
    _currentPlayer = updatedPlayer;
    notifyListeners();
    logger.i('Updated ability scores for ${_currentPlayer!.name}');
  }

  /// Level up the character
  Future<void> levelUp() async {
    if (_currentPlayer == null) return;

    final newLevel = _currentPlayer!.level + 1;

    final updatedPlayer = Player(
      id: _currentPlayer!.id,
      campaignId: _currentPlayer!.campaignId,
      playerUid: _currentPlayer!.playerUid,
      name: _currentPlayer!.name,
      className: _currentPlayer!.className,
      subclass: _currentPlayer!.subclass,
      level: newLevel,
      race: _currentPlayer!.race,
      background: _currentPlayer!.background,
      alignment: _currentPlayer!.alignment,
      str: _currentPlayer!.str,
      dex: _currentPlayer!.dex,
      con: _currentPlayer!.con,
      intl: _currentPlayer!.intl,
      wis: _currentPlayer!.wis,
      cha: _currentPlayer!.cha,
      hpMax: _currentPlayer!.hpMax,
      hpCurrent: _currentPlayer!.hpCurrent,
      hpTemp: _currentPlayer!.hpTemp,
      ac: _currentPlayer!.ac,
      proficiencyBonus: _calculateProficiencyBonus(newLevel),
      speed: _currentPlayer!.speed,
      savingThrowProficiencies: _currentPlayer!.savingThrowProficiencies,
      skillProficiencies: _currentPlayer!.skillProficiencies,
      languages: _currentPlayer!.languages,
      equipment: _currentPlayer!.equipment,
      features: _currentPlayer!.features,
      spells: _currentPlayer!.spells,
      notes: _currentPlayer!.notes,
      bio: _currentPlayer!.bio,
      ddbCharacterId: _currentPlayer!.ddbCharacterId,
      lastDdbSync: _currentPlayer!.lastDdbSync,
      createdAt: _currentPlayer!.createdAt,
      updatedAt: DateTime.now(),
      rev: _currentPlayer!.rev,
      deleted: _currentPlayer!.deleted,
    );

    await _repository.update(updatedPlayer);
    _currentPlayer = updatedPlayer;
    notifyListeners();
    logger.i('Leveled up ${_currentPlayer!.name} to level $newLevel');
  }

  /// Calculate proficiency bonus based on level
  int _calculateProficiencyBonus(int level) {
    return ((level - 1) ~/ 4) + 2;
  }
}
