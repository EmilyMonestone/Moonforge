import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/features/encounters/models/combatant.dart';
import 'package:moonforge/features/encounters/services/initiative_tracker_service.dart';

void main() {
  group('InitiativeTrackerService', () {
    group('sortByInitiative', () {
      test('sorts combatants by initiative descending', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'Fighter',
            type: CombatantType.player,
            initiative: 15,
          ),
          const Combatant(
            id: '2',
            name: 'Wizard',
            type: CombatantType.player,
            initiative: 20,
          ),
          const Combatant(
            id: '3',
            name: 'Goblin',
            type: CombatantType.monster,
            initiative: 10,
          ),
        ];

        final sorted = InitiativeTrackerService.sortByInitiative(combatants);

        expect(sorted[0].name, 'Wizard');
        expect(sorted[0].order, 0);
        expect(sorted[1].name, 'Fighter');
        expect(sorted[1].order, 1);
        expect(sorted[2].name, 'Goblin');
        expect(sorted[2].order, 2);
      });

      test('uses initiative modifier to break ties', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'Fighter',
            type: CombatantType.player,
            initiative: 15,
            initiativeModifier: 2,
          ),
          const Combatant(
            id: '2',
            name: 'Wizard',
            type: CombatantType.player,
            initiative: 15,
            initiativeModifier: 4,
          ),
          const Combatant(
            id: '3',
            name: 'Rogue',
            type: CombatantType.player,
            initiative: 15,
            initiativeModifier: 3,
          ),
        ];

        final sorted = InitiativeTrackerService.sortByInitiative(combatants);

        expect(sorted[0].name, 'Wizard'); // Highest modifier
        expect(sorted[1].name, 'Rogue');
        expect(sorted[2].name, 'Fighter'); // Lowest modifier
      });
    });

    group('getNextCombatantIndex', () {
      test('returns next index in sequence', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'A',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'B',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '3',
            name: 'C',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
        ];

        expect(
          InitiativeTrackerService.getNextCombatantIndex(combatants, 0),
          1,
        );
        expect(
          InitiativeTrackerService.getNextCombatantIndex(combatants, 1),
          2,
        );
      });

      test('wraps to beginning after last combatant', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'A',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'B',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
        ];

        expect(
          InitiativeTrackerService.getNextCombatantIndex(combatants, 1),
          0,
        );
      });

      test('skips dead combatants', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'A',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'B (dead)',
            type: CombatantType.player,
            currentHp: 0,
            maxHp: 10,
          ),
          const Combatant(
            id: '3',
            name: 'C',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
        ];

        expect(
          InitiativeTrackerService.getNextCombatantIndex(combatants, 0),
          2, // Skips dead combatant at index 1
        );
      });
    });

    group('getPreviousCombatantIndex', () {
      test('returns previous index in sequence', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'A',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'B',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '3',
            name: 'C',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
        ];

        expect(
          InitiativeTrackerService.getPreviousCombatantIndex(combatants, 2),
          1,
        );
        expect(
          InitiativeTrackerService.getPreviousCombatantIndex(combatants, 1),
          0,
        );
      });

      test('wraps to end from first combatant', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'A',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'B',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
        ];

        expect(
          InitiativeTrackerService.getPreviousCombatantIndex(combatants, 0),
          1,
        );
      });
    });

    group('isNewRound', () {
      test('detects new round when wrapping', () {
        expect(InitiativeTrackerService.isNewRound(2, 0), true);
        expect(InitiativeTrackerService.isNewRound(1, 0), true);
      });

      test('does not detect new round when advancing', () {
        expect(InitiativeTrackerService.isNewRound(0, 1), false);
        expect(InitiativeTrackerService.isNewRound(1, 2), false);
      });
    });

    group('getAliveCount', () {
      test('counts alive combatants correctly', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'A',
            type: CombatantType.player,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'B',
            type: CombatantType.player,
            currentHp: 0,
            maxHp: 10,
          ),
          const Combatant(
            id: '3',
            name: 'C',
            type: CombatantType.player,
            currentHp: 5,
            maxHp: 10,
          ),
        ];

        expect(InitiativeTrackerService.getAliveCount(combatants), 2);
      });
    });

    group('getAliveAlliesCount and getAliveEnemiesCount', () {
      test('counts allies and enemies separately', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'Fighter',
            type: CombatantType.player,
            isAlly: true,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'Wizard',
            type: CombatantType.player,
            isAlly: true,
            currentHp: 0,
            maxHp: 10,
          ),
          const Combatant(
            id: '3',
            name: 'Goblin 1',
            type: CombatantType.monster,
            isAlly: false,
            currentHp: 5,
            maxHp: 10,
          ),
          const Combatant(
            id: '4',
            name: 'Goblin 2',
            type: CombatantType.monster,
            isAlly: false,
            currentHp: 7,
            maxHp: 10,
          ),
        ];

        expect(InitiativeTrackerService.getAliveAlliesCount(combatants), 1);
        expect(InitiativeTrackerService.getAliveEnemiesCount(combatants), 2);
      });
    });

    group('isEncounterOver', () {
      test('returns true when all enemies defeated', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'Fighter',
            type: CombatantType.player,
            isAlly: true,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'Goblin',
            type: CombatantType.monster,
            isAlly: false,
            currentHp: 0,
            maxHp: 10,
          ),
        ];

        expect(InitiativeTrackerService.isEncounterOver(combatants), true);
      });

      test('returns true when all allies defeated', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'Fighter',
            type: CombatantType.player,
            isAlly: true,
            currentHp: 0,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'Goblin',
            type: CombatantType.monster,
            isAlly: false,
            currentHp: 5,
            maxHp: 10,
          ),
        ];

        expect(InitiativeTrackerService.isEncounterOver(combatants), true);
      });

      test('returns false when both sides have alive combatants', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'Fighter',
            type: CombatantType.player,
            isAlly: true,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'Goblin',
            type: CombatantType.monster,
            isAlly: false,
            currentHp: 5,
            maxHp: 10,
          ),
        ];

        expect(InitiativeTrackerService.isEncounterOver(combatants), false);
      });
    });

    group('getWinner', () {
      test('returns allies when enemies defeated', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'Fighter',
            type: CombatantType.player,
            isAlly: true,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'Goblin',
            type: CombatantType.monster,
            isAlly: false,
            currentHp: 0,
            maxHp: 10,
          ),
        ];

        expect(InitiativeTrackerService.getWinner(combatants), 'allies');
      });

      test('returns enemies when allies defeated', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'Fighter',
            type: CombatantType.player,
            isAlly: true,
            currentHp: 0,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'Goblin',
            type: CombatantType.monster,
            isAlly: false,
            currentHp: 5,
            maxHp: 10,
          ),
        ];

        expect(InitiativeTrackerService.getWinner(combatants), 'enemies');
      });

      test('returns null when encounter not over', () {
        final combatants = [
          const Combatant(
            id: '1',
            name: 'Fighter',
            type: CombatantType.player,
            isAlly: true,
            currentHp: 10,
            maxHp: 10,
          ),
          const Combatant(
            id: '2',
            name: 'Goblin',
            type: CombatantType.monster,
            isAlly: false,
            currentHp: 5,
            maxHp: 10,
          ),
        ];

        expect(InitiativeTrackerService.getWinner(combatants), null);
      });
    });
  });
}
