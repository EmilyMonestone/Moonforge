import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/parties/utils/character_calculations.dart';

/// Validators for character data
class CharacterValidators {
  /// Validate character name
  static String? validateCharacterName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Character name is required';
    }
    if (name.length < 2) {
      return 'Character name must be at least 2 characters';
    }
    if (name.length > 100) {
      return 'Character name must be less than 100 characters';
    }
    return null;
  }

  /// Validate character class
  static String? validateClassName(String? className) {
    if (className == null || className.trim().isEmpty) {
      return 'Character class is required';
    }
    return null;
  }

  /// Validate character level
  static String? validateLevel(int? level) {
    if (level == null || level < 1) {
      return 'Character level must be at least 1';
    }
    if (level > 20) {
      return 'Character level cannot exceed 20';
    }
    return null;
  }

  /// Validate ability score
  static String? validateAbilityScore(int? score) {
    if (score == null || score < 1) {
      return 'Ability score must be at least 1';
    }
    if (score > 30) {
      return 'Ability score cannot exceed 30';
    }
    return null;
  }

  /// Validate HP values
  static String? validateHp(int? current, int? max) {
    if (max == null || max < 1) {
      return 'Max HP must be at least 1';
    }
    if (current == null || current < 0) {
      return 'Current HP cannot be negative';
    }
    if (current > max) {
      return 'Current HP cannot exceed max HP';
    }
    return null;
  }

  /// Validate AC
  static String? validateAc(int? ac) {
    if (ac == null || ac < 1) {
      return 'AC must be at least 1';
    }
    if (ac > 30) {
      return 'AC seems unusually high (max 30)';
    }
    return null;
  }

  /// Check if character is ready for play
  static List<String> validateCharacterReadiness(Player player) {
    final issues = <String>[];

    // Check basic info
    if (validateCharacterName(player.name) != null) {
      issues.add('Invalid character name');
    }
    if (validateClassName(player.className) != null) {
      issues.add('Invalid character class');
    }
    if (validateLevel(player.level) != null) {
      issues.add('Invalid character level');
    }

    // Check ability scores
    for (final ability in CharacterCalculations.abilityScores) {
      final score = _getAbilityScore(player, ability);
      if (validateAbilityScore(score) != null) {
        issues.add('Invalid $ability score');
      }
    }

    // Check HP
    if (validateHp(player.hpCurrent, player.hpMax) != null) {
      issues.add('Invalid HP values');
    }

    // Check AC
    if (validateAc(player.ac) != null) {
      issues.add('Invalid AC');
    }

    // Check proficiency bonus
    if (player.proficiencyBonus == null) {
      issues.add('Proficiency bonus not set');
    }

    return issues;
  }

  /// Helper to get ability score by name
  static int _getAbilityScore(Player player, String ability) {
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
        return 10;
    }
  }
}
