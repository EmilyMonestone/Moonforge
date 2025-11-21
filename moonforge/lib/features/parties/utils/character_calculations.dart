/// D&D 5e character calculations and modifiers
class CharacterCalculations {
  /// Calculate ability modifier from ability score
  static int calculateAbilityModifier(int abilityScore) {
    return (abilityScore - 10) ~/ 2;
  }

  /// Calculate proficiency bonus from character level
  static int calculateProficiencyBonus(int level) {
    return ((level - 1) ~/ 4) + 2;
  }

  /// Calculate initiative modifier (based on Dexterity)
  static int calculateInitiativeModifier(int dexterity) {
    return calculateAbilityModifier(dexterity);
  }

  /// Calculate passive perception
  static int calculatePassivePerception({
    required int wisdom,
    required int proficiencyBonus,
    required bool isProficient,
  }) {
    final wisdomMod = calculateAbilityModifier(wisdom);
    final profBonus = isProficient ? proficiencyBonus : 0;
    return 10 + wisdomMod + profBonus;
  }

  /// Calculate skill modifier
  static int calculateSkillModifier({
    required int abilityScore,
    required int proficiencyBonus,
    required bool isProficient,
    bool hasExpertise = false,
  }) {
    final abilityMod = calculateAbilityModifier(abilityScore);

    if (hasExpertise) {
      return abilityMod + (proficiencyBonus * 2);
    } else if (isProficient) {
      return abilityMod + proficiencyBonus;
    } else {
      return abilityMod;
    }
  }

  /// Calculate saving throw modifier
  static int calculateSavingThrowModifier({
    required int abilityScore,
    required int proficiencyBonus,
    required bool isProficient,
  }) {
    final abilityMod = calculateAbilityModifier(abilityScore);
    final profBonus = isProficient ? proficiencyBonus : 0;
    return abilityMod + profBonus;
  }

  /// Format modifier with + or - sign
  static String formatModifier(int modifier) {
    if (modifier >= 0) {
      return '+$modifier';
    } else {
      return '$modifier';
    }
  }

  /// Calculate spell save DC
  static int calculateSpellSaveDC({
    required int spellcastingAbility,
    required int proficiencyBonus,
  }) {
    return 8 + proficiencyBonus + calculateAbilityModifier(spellcastingAbility);
  }

  /// Calculate spell attack bonus
  static int calculateSpellAttackBonus({
    required int spellcastingAbility,
    required int proficiencyBonus,
  }) {
    return proficiencyBonus + calculateAbilityModifier(spellcastingAbility);
  }

  /// Get ability name from abbreviation
  static String getAbilityName(String abbreviation) {
    switch (abbreviation.toUpperCase()) {
      case 'STR':
        return 'Strength';
      case 'DEX':
        return 'Dexterity';
      case 'CON':
        return 'Constitution';
      case 'INT':
        return 'Intelligence';
      case 'WIS':
        return 'Wisdom';
      case 'CHA':
        return 'Charisma';
      default:
        return abbreviation;
    }
  }

  /// Get skill's governing ability
  static String getSkillAbility(String skill) {
    switch (skill.toLowerCase()) {
      case 'athletics':
        return 'STR';
      case 'acrobatics':
      case 'sleight of hand':
      case 'stealth':
        return 'DEX';
      case 'arcana':
      case 'history':
      case 'investigation':
      case 'nature':
      case 'religion':
        return 'INT';
      case 'animal handling':
      case 'insight':
      case 'medicine':
      case 'perception':
      case 'survival':
        return 'WIS';
      case 'deception':
      case 'intimidation':
      case 'performance':
      case 'persuasion':
        return 'CHA';
      default:
        return 'STR'; // default fallback
    }
  }

  /// D&D 5e standard skills list
  static const List<String> standardSkills = [
    'Acrobatics',
    'Animal Handling',
    'Arcana',
    'Athletics',
    'Deception',
    'History',
    'Insight',
    'Intimidation',
    'Investigation',
    'Medicine',
    'Nature',
    'Perception',
    'Performance',
    'Persuasion',
    'Religion',
    'Sleight of Hand',
    'Stealth',
    'Survival',
  ];

  /// D&D 5e ability scores
  static const List<String> abilityScores = [
    'STR',
    'DEX',
    'CON',
    'INT',
    'WIS',
    'CHA',
  ];

  /// Calculate carrying capacity (in pounds)
  static int calculateCarryingCapacity(int strength) {
    return strength * 15;
  }

  /// Calculate encumbrance levels
  static Map<String, int> calculateEncumbrance(int strength) {
    final capacity = calculateCarryingCapacity(strength);
    return {
      'normal': capacity,
      'encumbered': (capacity * 2 / 3).round(),
      'heavily_encumbered': (capacity / 3).round(),
    };
  }
}
