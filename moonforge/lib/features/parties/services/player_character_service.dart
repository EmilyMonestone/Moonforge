import 'package:moonforge/core/services/base_service.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/player_repository.dart';
import 'package:moonforge/features/parties/utils/character_calculations.dart';

/// Service for player character operations with D&D 5e calculations
class PlayerCharacterService extends BaseService {
  final PlayerRepository _repository;

  @override
  String get serviceName => 'PlayerCharacterService';

  PlayerCharacterService(this._repository);

  /// Get ability modifier for a player
  int getAbilityModifier(Player player, String ability) {
    final score = _getAbilityScore(player, ability);
    return CharacterCalculations.calculateAbilityModifier(score);
  }

  /// Get saving throw modifier
  int getSavingThrowModifier(Player player, String ability) {
    final abilityScore = _getAbilityScore(player, ability);
    final isProficient =
        player.savingThrowProficiencies?.contains(ability) ?? false;
    final proficiencyBonus =
        player.proficiencyBonus ??
        CharacterCalculations.calculateProficiencyBonus(player.level);

    return CharacterCalculations.calculateSavingThrowModifier(
      abilityScore: abilityScore,
      proficiencyBonus: proficiencyBonus,
      isProficient: isProficient,
    );
  }

  /// Get skill modifier
  int getSkillModifier(Player player, String skill) {
    final ability = CharacterCalculations.getSkillAbility(skill);
    final abilityScore = _getAbilityScore(player, ability);
    final isProficient = player.skillProficiencies?.contains(skill) ?? false;
    final proficiencyBonus =
        player.proficiencyBonus ??
        CharacterCalculations.calculateProficiencyBonus(player.level);

    return CharacterCalculations.calculateSkillModifier(
      abilityScore: abilityScore,
      proficiencyBonus: proficiencyBonus,
      isProficient: isProficient,
    );
  }

  /// Get passive perception
  int getPassivePerception(Player player) {
    final isProficient =
        player.skillProficiencies?.contains('Perception') ?? false;
    final proficiencyBonus =
        player.proficiencyBonus ??
        CharacterCalculations.calculateProficiencyBonus(player.level);

    return CharacterCalculations.calculatePassivePerception(
      wisdom: player.wis,
      proficiencyBonus: proficiencyBonus,
      isProficient: isProficient,
    );
  }

  /// Get initiative modifier
  int getInitiativeModifier(Player player) {
    return CharacterCalculations.calculateInitiativeModifier(player.dex);
  }

  /// Calculate maximum HP for level up (returns suggested HP increase)
  int calculateHpIncrease(Player player, int hitDie) {
    // Average HP increase: (hitDie / 2) + 1 + CON modifier
    final conModifier = CharacterCalculations.calculateAbilityModifier(
      player.con,
    );
    return ((hitDie / 2).floor() + 1 + conModifier).clamp(1, 999);
  }

  /// Perform a short rest (restore some HP and abilities)
  Future<Player> performShortRest(
    Player player,
    int hitDiceUsed,
    int hitDie,
  ) async {
    final conModifier = CharacterCalculations.calculateAbilityModifier(
      player.con,
    );
    final hpRestored =
        (hitDiceUsed * (hitDie ~/ 2 + 1)) + (hitDiceUsed * conModifier);

    final newCurrentHp = ((player.hpCurrent ?? 0) + hpRestored).clamp(
      0,
      player.hpMax ?? 0,
    );

    final updatedPlayer = Player(
      id: player.id,
      campaignId: player.campaignId,
      playerUid: player.playerUid,
      name: player.name,
      className: player.className,
      subclass: player.subclass,
      level: player.level,
      race: player.race,
      background: player.background,
      alignment: player.alignment,
      str: player.str,
      dex: player.dex,
      con: player.con,
      intl: player.intl,
      wis: player.wis,
      cha: player.cha,
      hpMax: player.hpMax,
      hpCurrent: newCurrentHp,
      hpTemp: 0, // Temp HP removed on rest
      ac: player.ac,
      proficiencyBonus: player.proficiencyBonus,
      speed: player.speed,
      savingThrowProficiencies: player.savingThrowProficiencies,
      skillProficiencies: player.skillProficiencies,
      languages: player.languages,
      equipment: player.equipment,
      features: player.features,
      spells: player.spells,
      notes: player.notes,
      bio: player.bio,
      ddbCharacterId: player.ddbCharacterId,
      lastDdbSync: player.lastDdbSync,
      createdAt: player.createdAt,
      updatedAt: DateTime.now(),
      rev: player.rev,
      deleted: player.deleted,
    );

    await _repository.update(updatedPlayer);
    return updatedPlayer;
  }

  /// Perform a long rest (restore all HP and abilities)
  Future<Player> performLongRest(Player player) async {
    final updatedPlayer = Player(
      id: player.id,
      campaignId: player.campaignId,
      playerUid: player.playerUid,
      name: player.name,
      className: player.className,
      subclass: player.subclass,
      level: player.level,
      race: player.race,
      background: player.background,
      alignment: player.alignment,
      str: player.str,
      dex: player.dex,
      con: player.con,
      intl: player.intl,
      wis: player.wis,
      cha: player.cha,
      hpMax: player.hpMax,
      hpCurrent: player.hpMax, // Restore to max
      hpTemp: 0, // Temp HP removed
      ac: player.ac,
      proficiencyBonus: player.proficiencyBonus,
      speed: player.speed,
      savingThrowProficiencies: player.savingThrowProficiencies,
      skillProficiencies: player.skillProficiencies,
      languages: player.languages,
      equipment: player.equipment,
      features: player.features,
      spells: player.spells,
      notes: player.notes,
      bio: player.bio,
      ddbCharacterId: player.ddbCharacterId,
      lastDdbSync: player.lastDdbSync,
      createdAt: player.createdAt,
      updatedAt: DateTime.now(),
      rev: player.rev,
      deleted: player.deleted,
    );

    await _repository.update(updatedPlayer);
    return updatedPlayer;
  }

  /// Helper to get ability score by name
  int _getAbilityScore(Player player, String ability) {
    switch (ability.toUpperCase()) {
      case 'STR':
        return player.str;
      case 'DEX':
        return player.dex;
      case 'CON':
        return player.con;
      case 'INT':
        return player.intl;
      case 'WIS':
        return player.wis;
      case 'CHA':
        return player.cha;
      default:
        return 10; // default fallback
    }
  }

  /// Get all skill modifiers for a player
  Map<String, int> getAllSkillModifiers(Player player) {
    final modifiers = <String, int>{};
    for (final skill in CharacterCalculations.standardSkills) {
      modifiers[skill] = getSkillModifier(player, skill);
    }
    return modifiers;
  }

  /// Get all saving throw modifiers for a player
  Map<String, int> getAllSavingThrowModifiers(Player player) {
    final modifiers = <String, int>{};
    for (final ability in CharacterCalculations.abilityScores) {
      modifiers[ability] = getSavingThrowModifier(player, ability);
    }
    return modifiers;
  }
}
