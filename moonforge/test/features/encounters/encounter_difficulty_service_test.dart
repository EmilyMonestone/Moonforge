import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/features/encounters/services/encounter_difficulty_service.dart';

void main() {
  group('EncounterDifficultyService', () {
    group('calculatePartyThresholds', () {
      test('calculates correct thresholds for single level 3 character', () {
        final thresholds =
            EncounterDifficultyService.calculatePartyThresholds([3]);

        expect(thresholds['easy'], 75);
        expect(thresholds['medium'], 150);
        expect(thresholds['hard'], 225);
        expect(thresholds['deadly'], 400);
      });

      test('calculates correct thresholds for multiple characters', () {
        // Example from D&D rules: 3x level 3 + 1x level 2
        final thresholds =
            EncounterDifficultyService.calculatePartyThresholds([3, 3, 3, 2]);

        expect(thresholds['easy'], 275); // 75 + 75 + 75 + 50
        expect(thresholds['medium'], 550); // 150 + 150 + 150 + 100
        expect(thresholds['hard'], 825); // 225 + 225 + 225 + 150
        expect(thresholds['deadly'], 1400); // 400 + 400 + 400 + 200
      });

      test('handles empty party', () {
        final thresholds =
            EncounterDifficultyService.calculatePartyThresholds([]);

        expect(thresholds['easy'], 0);
        expect(thresholds['medium'], 0);
        expect(thresholds['hard'], 0);
        expect(thresholds['deadly'], 0);
      });

      test('handles level 1 characters', () {
        final thresholds =
            EncounterDifficultyService.calculatePartyThresholds([1, 1]);

        expect(thresholds['easy'], 50);
        expect(thresholds['medium'], 100);
        expect(thresholds['hard'], 150);
        expect(thresholds['deadly'], 200);
      });

      test('handles level 20 characters', () {
        final thresholds =
            EncounterDifficultyService.calculatePartyThresholds([20]);

        expect(thresholds['easy'], 2800);
        expect(thresholds['medium'], 5700);
        expect(thresholds['hard'], 8500);
        expect(thresholds['deadly'], 12700);
      });
    });

    group('getXpForCr', () {
      test('returns correct XP for common CRs', () {
        expect(EncounterDifficultyService.getXpForCr('0'), 10);
        expect(EncounterDifficultyService.getXpForCr('1/8'), 25);
        expect(EncounterDifficultyService.getXpForCr('1/4'), 50);
        expect(EncounterDifficultyService.getXpForCr('1/2'), 100);
        expect(EncounterDifficultyService.getXpForCr('1'), 200);
        expect(EncounterDifficultyService.getXpForCr('2'), 450);
        expect(EncounterDifficultyService.getXpForCr('5'), 1800);
        expect(EncounterDifficultyService.getXpForCr('10'), 5900);
        expect(EncounterDifficultyService.getXpForCr('20'), 25000);
      });

      test('returns 0 for unknown CR', () {
        expect(EncounterDifficultyService.getXpForCr('invalid'), 0);
      });
    });

    group('getEncounterMultiplier', () {
      test('returns correct multiplier for standard party (3-5)', () {
        expect(EncounterDifficultyService.getEncounterMultiplier(1, 4), 1.0);
        expect(EncounterDifficultyService.getEncounterMultiplier(2, 4), 1.5);
        expect(EncounterDifficultyService.getEncounterMultiplier(3, 4), 2.0);
        expect(EncounterDifficultyService.getEncounterMultiplier(6, 4), 2.0);
        expect(EncounterDifficultyService.getEncounterMultiplier(7, 4), 2.5);
        expect(EncounterDifficultyService.getEncounterMultiplier(10, 4), 2.5);
        expect(EncounterDifficultyService.getEncounterMultiplier(11, 4), 3.0);
        expect(EncounterDifficultyService.getEncounterMultiplier(14, 4), 3.0);
        expect(EncounterDifficultyService.getEncounterMultiplier(15, 4), 4.0);
      });

      test('adjusts multiplier for small party (< 3)', () {
        expect(EncounterDifficultyService.getEncounterMultiplier(1, 2), 1.5);
        expect(EncounterDifficultyService.getEncounterMultiplier(2, 2), 2.0);
        expect(EncounterDifficultyService.getEncounterMultiplier(3, 2), 2.5);
      });

      test('adjusts multiplier for large party (>= 6)', () {
        expect(EncounterDifficultyService.getEncounterMultiplier(1, 6), 0.5);
        expect(EncounterDifficultyService.getEncounterMultiplier(2, 6), 1.0);
        expect(EncounterDifficultyService.getEncounterMultiplier(3, 6), 1.5);
        expect(EncounterDifficultyService.getEncounterMultiplier(7, 6), 2.0);
      });
    });

    group('calculateAdjustedXp', () {
      test('calculates adjusted XP correctly', () {
        // Single monster worth 100 XP, party of 4
        expect(
          EncounterDifficultyService.calculateAdjustedXp([100], 4),
          100, // 100 * 1.0
        );

        // Two monsters worth 100 XP each, party of 4
        expect(
          EncounterDifficultyService.calculateAdjustedXp([100, 100], 4),
          300, // 200 * 1.5
        );

        // Four monsters worth 100 XP each, party of 4
        expect(
          EncounterDifficultyService.calculateAdjustedXp(
              [100, 100, 100, 100], 4),
          800, // 400 * 2.0
        );
      });

      test('handles empty monster list', () {
        expect(EncounterDifficultyService.calculateAdjustedXp([], 4), 0);
      });

      test('accounts for party size in adjustment', () {
        // Same encounter, different party sizes
        final monsters = [100, 100];

        // Small party (2 members)
        expect(
          EncounterDifficultyService.calculateAdjustedXp(monsters, 2),
          400, // 200 * 2.0 (adjusted multiplier)
        );

        // Standard party (4 members)
        expect(
          EncounterDifficultyService.calculateAdjustedXp(monsters, 4),
          300, // 200 * 1.5
        );

        // Large party (6 members)
        expect(
          EncounterDifficultyService.calculateAdjustedXp(monsters, 6),
          200, // 200 * 1.0 (adjusted multiplier)
        );
      });
    });

    group('classifyDifficulty', () {
      test('classifies difficulty correctly', () {
        final thresholds = {
          'easy': 275,
          'medium': 550,
          'hard': 825,
          'deadly': 1400,
        };

        expect(
          EncounterDifficultyService.classifyDifficulty(200, thresholds),
          'trivial',
        );
        expect(
          EncounterDifficultyService.classifyDifficulty(300, thresholds),
          'easy',
        );
        expect(
          EncounterDifficultyService.classifyDifficulty(600, thresholds),
          'medium',
        );
        expect(
          EncounterDifficultyService.classifyDifficulty(900, thresholds),
          'hard',
        );
        expect(
          EncounterDifficultyService.classifyDifficulty(1500, thresholds),
          'deadly',
        );
      });

      test('handles edge cases at boundaries', () {
        final thresholds = {
          'easy': 100,
          'medium': 200,
          'hard': 300,
          'deadly': 400,
        };

        expect(
          EncounterDifficultyService.classifyDifficulty(99, thresholds),
          'trivial',
        );
        expect(
          EncounterDifficultyService.classifyDifficulty(100, thresholds),
          'easy',
        );
        expect(
          EncounterDifficultyService.classifyDifficulty(199, thresholds),
          'easy',
        );
        expect(
          EncounterDifficultyService.classifyDifficulty(200, thresholds),
          'medium',
        );
      });
    });

    group('Integration: D&D Example', () {
      test('validates D&D rulebook example', () {
        // From the rulebook: 3x level 3, 1x level 2 party
        // Facing 1 bugbear (CR 1, 200 XP) + 3 hobgoblins (CR 1/2, 100 XP each)
        // Total: 200 + 300 = 500 XP
        // With 4 monsters, multiplier = 2.0
        // Adjusted XP = 500 * 2.0 = 1000 XP
        // Hard threshold = 825, Deadly threshold = 1400
        // Result: Hard encounter

        final partyLevels = [3, 3, 3, 2];
        final monsterXp = [200, 100, 100, 100];

        final thresholds =
            EncounterDifficultyService.calculatePartyThresholds(partyLevels);
        final adjustedXp = EncounterDifficultyService.calculateAdjustedXp(
          monsterXp,
          partyLevels.length,
        );
        final difficulty =
            EncounterDifficultyService.classifyDifficulty(
                adjustedXp, thresholds);

        expect(thresholds['easy'], 275);
        expect(thresholds['medium'], 550);
        expect(thresholds['hard'], 825);
        expect(thresholds['deadly'], 1400);
        expect(adjustedXp, 1000);
        expect(difficulty, 'hard');
      });

      test('validates easy encounter', () {
        // 4x level 5 characters vs 2x CR 1/2 monsters
        final partyLevels = [5, 5, 5, 5];
        final monsterXp = [100, 100];

        final thresholds =
            EncounterDifficultyService.calculatePartyThresholds(partyLevels);
        final adjustedXp = EncounterDifficultyService.calculateAdjustedXp(
          monsterXp,
          partyLevels.length,
        );
        final difficulty =
            EncounterDifficultyService.classifyDifficulty(
                adjustedXp, thresholds);

        expect(adjustedXp, 300); // 200 * 1.5
        expect(difficulty, 'trivial'); // Well below easy threshold of 1000
      });

      test('validates deadly encounter', () {
        // 4x level 1 characters vs 1x CR 2 monster
        final partyLevels = [1, 1, 1, 1];
        final monsterXp = [450];

        final thresholds =
            EncounterDifficultyService.calculatePartyThresholds(partyLevels);
        final adjustedXp = EncounterDifficultyService.calculateAdjustedXp(
          monsterXp,
          partyLevels.length,
        );
        final difficulty =
            EncounterDifficultyService.classifyDifficulty(
                adjustedXp, thresholds);

        expect(adjustedXp, 450); // 450 * 1.0
        expect(difficulty, 'deadly'); // Above deadly threshold of 400
      });
    });
  });
}
