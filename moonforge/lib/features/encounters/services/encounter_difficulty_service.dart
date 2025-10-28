import 'package:moonforge/core/models/data/player.dart';

/// Service for calculating D&D 5e encounter difficulty
/// Based on D&D 5e Basic Rules Chapter 13: Building Combat Encounters
class EncounterDifficultyService {
  EncounterDifficultyService._();

  /// XP thresholds by character level for each difficulty
  /// Indexed by level (1-20)
  static const Map<int, Map<String, int>> _xpThresholdsByLevel = {
    1: {'easy': 25, 'medium': 50, 'hard': 75, 'deadly': 100},
    2: {'easy': 50, 'medium': 100, 'hard': 150, 'deadly': 200},
    3: {'easy': 75, 'medium': 150, 'hard': 225, 'deadly': 400},
    4: {'easy': 125, 'medium': 250, 'hard': 375, 'deadly': 500},
    5: {'easy': 250, 'medium': 500, 'hard': 750, 'deadly': 1100},
    6: {'easy': 300, 'medium': 600, 'hard': 900, 'deadly': 1400},
    7: {'easy': 350, 'medium': 750, 'hard': 1100, 'deadly': 1700},
    8: {'easy': 450, 'medium': 900, 'hard': 1400, 'deadly': 2100},
    9: {'easy': 550, 'medium': 1100, 'hard': 1600, 'deadly': 2400},
    10: {'easy': 600, 'medium': 1200, 'hard': 1900, 'deadly': 2800},
    11: {'easy': 800, 'medium': 1600, 'hard': 2400, 'deadly': 3600},
    12: {'easy': 1000, 'medium': 2000, 'hard': 3000, 'deadly': 4500},
    13: {'easy': 1100, 'medium': 2200, 'hard': 3400, 'deadly': 5100},
    14: {'easy': 1250, 'medium': 2500, 'hard': 3800, 'deadly': 5700},
    15: {'easy': 1400, 'medium': 2800, 'hard': 4300, 'deadly': 6400},
    16: {'easy': 1600, 'medium': 3200, 'hard': 4800, 'deadly': 7200},
    17: {'easy': 2000, 'medium': 3900, 'hard': 5900, 'deadly': 8800},
    18: {'easy': 2100, 'medium': 4200, 'hard': 6300, 'deadly': 9500},
    19: {'easy': 2400, 'medium': 4900, 'hard': 7300, 'deadly': 10900},
    20: {'easy': 2800, 'medium': 5700, 'hard': 8500, 'deadly': 12700},
  };

  /// Challenge Rating to XP mapping
  static const Map<String, int> _crToXp = {
    '0': 10,
    '1/8': 25,
    '1/4': 50,
    '1/2': 100,
    '1': 200,
    '2': 450,
    '3': 700,
    '4': 1100,
    '5': 1800,
    '6': 2300,
    '7': 2900,
    '8': 3900,
    '9': 5000,
    '10': 5900,
    '11': 7200,
    '12': 8400,
    '13': 10000,
    '14': 11500,
    '15': 13000,
    '16': 15000,
    '17': 18000,
    '18': 20000,
    '19': 22000,
    '20': 25000,
    '21': 33000,
    '22': 41000,
    '23': 50000,
    '24': 62000,
    '25': 75000,
    '26': 90000,
    '27': 105000,
    '28': 120000,
    '29': 135000,
    '30': 155000,
  };

  /// Calculate party XP thresholds for each difficulty level
  /// Returns a map with keys: easy, medium, hard, deadly
  static Map<String, int> calculatePartyThresholds(List<int> playerLevels) {
    final totals = {'easy': 0, 'medium': 0, 'hard': 0, 'deadly': 0};

    for (final level in playerLevels) {
      final thresholds = _xpThresholdsByLevel[level];
      if (thresholds != null) {
        totals['easy'] = totals['easy']! + thresholds['easy']!;
        totals['medium'] = totals['medium']! + thresholds['medium']!;
        totals['hard'] = totals['hard']! + thresholds['hard']!;
        totals['deadly'] = totals['deadly']! + thresholds['deadly']!;
      }
    }

    return totals;
  }

  /// Calculate party XP thresholds from Player objects
  static Map<String, int> calculatePartyThresholdsFromPlayers(
      List<Player> players) {
    return calculatePartyThresholds(players.map((p) => p.level).toList());
  }

  /// Get XP value for a given Challenge Rating
  static int getXpForCr(String cr) {
    return _crToXp[cr] ?? 0;
  }

  /// Calculate the encounter multiplier based on number of monsters
  /// Accounts for party size adjustments
  static double getEncounterMultiplier(int monsterCount, int partySize) {
    // Base multiplier by monster count
    double baseMultiplier;
    if (monsterCount == 1) {
      baseMultiplier = 1.0;
    } else if (monsterCount == 2) {
      baseMultiplier = 1.5;
    } else if (monsterCount <= 6) {
      baseMultiplier = 2.0;
    } else if (monsterCount <= 10) {
      baseMultiplier = 2.5;
    } else if (monsterCount <= 14) {
      baseMultiplier = 3.0;
    } else {
      baseMultiplier = 4.0;
    }

    // Adjust for party size
    if (partySize < 3) {
      // Use next higher multiplier for small parties
      if (monsterCount == 1) {
        baseMultiplier = 1.5;
      } else if (monsterCount == 2) {
        baseMultiplier = 2.0;
      } else if (monsterCount <= 6) {
        baseMultiplier = 2.5;
      } else if (monsterCount <= 10) {
        baseMultiplier = 3.0;
      } else if (monsterCount <= 14) {
        baseMultiplier = 4.0;
      } else {
        baseMultiplier = 5.0;
      }
    } else if (partySize >= 6) {
      // Use next lower multiplier for large parties
      if (monsterCount == 1) {
        baseMultiplier = 0.5;
      } else if (monsterCount == 2) {
        baseMultiplier = 1.0;
      } else if (monsterCount <= 6) {
        baseMultiplier = 1.5;
      } else if (monsterCount <= 10) {
        baseMultiplier = 2.0;
      } else if (monsterCount <= 14) {
        baseMultiplier = 2.5;
      } else {
        baseMultiplier = 3.0;
      }
    }

    return baseMultiplier;
  }

  /// Calculate adjusted XP for monsters in an encounter
  static int calculateAdjustedXp(List<int> monsterXpValues, int partySize) {
    if (monsterXpValues.isEmpty) return 0;

    final baseXp = monsterXpValues.reduce((a, b) => a + b);
    final multiplier =
        getEncounterMultiplier(monsterXpValues.length, partySize);

    return (baseXp * multiplier).round();
  }

  /// Classify encounter difficulty based on adjusted XP and party thresholds
  /// Returns: 'trivial', 'easy', 'medium', 'hard', or 'deadly'
  static String classifyDifficulty(
      int adjustedXp, Map<String, int> partyThresholds) {
    if (adjustedXp < partyThresholds['easy']!) {
      return 'trivial';
    } else if (adjustedXp < partyThresholds['medium']!) {
      return 'easy';
    } else if (adjustedXp < partyThresholds['hard']!) {
      return 'medium';
    } else if (adjustedXp < partyThresholds['deadly']!) {
      return 'hard';
    } else {
      return 'deadly';
    }
  }

  /// Get all available CR values
  static List<String> getAvailableCRs() {
    return _crToXp.keys.toList();
  }

  /// Get XP thresholds for a specific character level
  static Map<String, int>? getThresholdsForLevel(int level) {
    return _xpThresholdsByLevel[level];
  }
}
