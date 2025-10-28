# Encounters Feature

This directory contains the implementation of the Encounter Builder and Initiative Tracker feature for Moonforge.

## Directory Structure

```
encounters/
├── models/
│   └── combatant.dart           # Combatant model (player, monster, NPC in an encounter)
├── services/
│   ├── encounter_difficulty_service.dart  # D&D 5e difficulty calculations
│   └── initiative_tracker_service.dart    # Initiative order and turn management
├── utils/
│   └── create_encounter.dart    # Utility for creating new encounters
└── views/
    ├── encounter_screen.dart    # View encounter details
    └── encounter_edit_screen.dart  # Encounter builder UI
```

## Features

### Encounter Difficulty Calculator

Implements D&D 5e encounter building rules:
- Calculates XP thresholds for parties (Easy, Medium, Hard, Deadly)
- Maps Challenge Rating to XP for monsters
- Applies encounter multipliers based on monster count
- Adjusts for party size (small <3, standard 3-5, large ≥6)
- Classifies encounter difficulty

### Initiative Tracker

Manages turn-based combat:
- Sorts combatants by initiative (with modifier tiebreakers)
- Tracks rounds and turn order
- Skips defeated combatants
- Detects encounter completion
- Tracks HP, AC, and conditions

### Combatant Model

Represents participants in combat:
- Support for players, monsters, and NPCs
- HP and AC tracking
- Initiative values and modifiers
- Conditions/status effects
- References to bestiary or campaign entities
- Ally/enemy designation

## Usage

### Creating an Encounter

From any campaign view, use the menu action "Create Encounter":

```dart
encounter_utils.createEncounter(context, campaign);
```

This creates a new encounter and navigates to the builder.

### Calculating Difficulty

```dart
import 'package:moonforge/features/encounters/services/encounter_difficulty_service.dart';

// Define party (list of levels)
final partyLevels = [3, 3, 3, 2];

// Calculate thresholds
final thresholds = EncounterDifficultyService.calculatePartyThresholds(partyLevels);
// Returns: {easy: 275, medium: 550, hard: 825, deadly: 1400}

// Define monsters (list of XP values)
final monsterXp = [200, 100, 100, 100]; // 1 Bugbear + 3 Hobgoblins

// Calculate adjusted XP
final adjustedXp = EncounterDifficultyService.calculateAdjustedXp(
  monsterXp,
  partyLevels.length,
);
// Returns: 1000 (500 base XP × 2.0 multiplier for 4 monsters)

// Classify difficulty
final difficulty = EncounterDifficultyService.classifyDifficulty(adjustedXp, thresholds);
// Returns: 'hard'
```

### Managing Initiative

```dart
import 'package:moonforge/features/encounters/models/combatant.dart';
import 'package:moonforge/features/encounters/services/initiative_tracker_service.dart';

// Create combatants
final combatants = [
  Combatant(
    id: '1',
    name: 'Fighter',
    type: CombatantType.player,
    initiative: 15,
    currentHp: 25,
    maxHp: 25,
  ),
  Combatant(
    id: '2',
    name: 'Goblin',
    type: CombatantType.monster,
    initiative: 12,
    currentHp: 7,
    maxHp: 7,
  ),
];

// Sort by initiative
final sorted = InitiativeTrackerService.sortByInitiative(combatants);

// Navigate turns
var currentIndex = 0;
currentIndex = InitiativeTrackerService.getNextCombatantIndex(sorted, currentIndex);

// Check if round is complete
if (InitiativeTrackerService.isNewRound(previousIndex, currentIndex)) {
  roundNumber++;
}

// Check if encounter is over
if (InitiativeTrackerService.isEncounterOver(sorted)) {
  final winner = InitiativeTrackerService.getWinner(sorted);
  // winner is 'allies' or 'enemies'
}
```

### Working with Combatants

```dart
// Apply damage
final damaged = combatant.applyDamage(10);

// Heal
final healed = combatant.heal(5);

// Add condition
final poisoned = combatant.addCondition('poisoned');

// Remove condition
final cured = combatant.removeCondition('poisoned');

// Check status
if (combatant.isAlive) {
  // Combatant has HP > 0
}

if (combatant.isEnemy) {
  // Combatant is not an ally
}
```

## Testing

Run the test suite:

```bash
flutter test test/features/encounters/
```

This runs:
- `encounter_difficulty_service_test.dart` - 31 tests for difficulty calculations
- `initiative_tracker_service_test.dart` - 22 tests for initiative management

All tests validate against D&D 5e rules with examples from the rulebook.

## Code Generation

The Combatant model requires code generation. After modifying the model:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## D&D 5e Reference

This implementation follows D&D 5e Basic Rules Chapter 13: Building Combat Encounters.

### XP Thresholds by Level

| Level | Easy | Medium | Hard | Deadly |
|-------|------|--------|------|--------|
| 1     | 25   | 50     | 75   | 100    |
| 2     | 50   | 100    | 150  | 200    |
| 3     | 75   | 150    | 225  | 400    |
| 5     | 250  | 500    | 750  | 1,100  |
| 10    | 600  | 1,200  | 1,900| 2,800  |
| 20    | 2,800| 5,700  | 8,500|12,700  |

(See `EncounterDifficultyService` for the complete table)

### Encounter Multipliers

| Monsters | Standard Party | Small (<3) | Large (≥6) |
|----------|----------------|------------|------------|
| 1        | ×1.0           | ×1.5       | ×0.5       |
| 2        | ×1.5           | ×2.0       | ×1.0       |
| 3-6      | ×2.0           | ×2.5       | ×1.5       |
| 7-10     | ×2.5           | ×3.0       | ×2.0       |
| 11-14    | ×3.0           | ×4.0       | ×2.5       |
| 15+      | ×4.0           | ×5.0       | ×3.0       |

## Status

**Current Status:** Phase 1 Complete (Core Services & Tests)

✅ Completed:
- Encounter difficulty calculation service
- Initiative tracker service
- Combatant data model
- Comprehensive unit tests (53 tests)
- Basic UI scaffolding
- Menu integration
- Localization (EN, DE)

🚧 In Progress:
- Complete encounter builder UI
- Monster/NPC selection interface
- Live difficulty calculation display

📋 Planned:
- Full initiative tracker UI
- HP and condition management
- Encounter persistence
- Combat log
- Preset templates

## Contributing

When working on this feature:

1. Follow D&D 5e rules precisely
2. Add tests for new calculation logic
3. Keep UI consistent with Material 3 Expressive design
4. Internationalize all user-facing strings
5. Document complex algorithms

## See Also

- [Complete Implementation Documentation](../../docs/encounter_builder_implementation.md)
- [Firebase Schema](../../docs/firebase_schema.md) - Encounter data structure
- [D&D 5e Basic Rules](https://www.dndbeyond.com/sources/basic-rules)
- [Kobold Plus Club](https://koboldplus.club/) - Inspiration for UX
