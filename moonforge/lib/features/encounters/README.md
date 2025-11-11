# Encounters Feature

This directory contains the implementation of the Encounter Builder and Initiative Tracker feature for Moonforge.

## Directory Structure

```
encounters/
├── controllers/
│   ├── encounter_provider.dart           # Encounter state management
│   └── initiative_tracker_controller.dart # Initiative tracker state
├── services/
│   ├── combatant_service.dart            # Combatant CRUD and HP management
│   ├── encounter_difficulty_service.dart # D&D 5e difficulty calculations
│   └── initiative_tracker_service.dart   # Initiative order and turn management
├── utils/
│   ├── create_encounter.dart             # Utility for creating new encounters
│   ├── create_encounter_in_adventure.dart
│   ├── create_encounter_in_chapter.dart
│   └── create_encounter_in_scene.dart
├── views/
│   ├── encounter_edit_screen.dart        # Encounter builder UI
│   ├── encounter_list_screen.dart        # Browse all encounters
│   ├── encounter_screen.dart             # View encounter details
│   └── initiative_tracker_screen.dart    # Initiative tracker UI
└── widgets/
    ├── add_combatant_dialog.dart         # Dialog to add combatants
    ├── combatant_card.dart               # Combatant display card
    ├── combatant_conditions_widget.dart  # Status effects display
    ├── combatant_hp_bar.dart             # HP bar widget
    ├── condition_selector.dart           # Condition picker dialog
    ├── damage_heal_dialog.dart           # Quick HP adjustment
    ├── encounter_card.dart               # Encounter list item
    ├── encounter_difficulty_badge.dart   # Difficulty indicator
    ├── encounter_list.dart               # Encounter list widget
    ├── initiative_order_list.dart        # Initiative order display
    └── round_counter.dart                # Round number display
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

### Combatant Service

Business logic for combatant operations:

- CRUD operations for combatants
- HP management (damage, healing, setting HP)
- Condition management (add, remove, clear)
- Initiative tracking
- Utility methods (duplicate combatants, check status)

### State Management

**EncounterProvider**: Manages encounter state

- Load encounters by origin (campaign, chapter, etc.)
- Current encounter tracking
- CRUD operations with automatic UI updates

**InitiativeTrackerController**: Manages combat state

- Roll initiative for all combatants
- Turn navigation (next/previous)
- HP and condition management during combat
- Combat log tracking
- Round counter
- Encounter completion detection

### Reusable Widgets

**Display Widgets:**

- `CombatantCard`: Full combatant display with HP bar, AC, conditions
- `CombatantHpBar`: Visual HP indicator with color coding
- `CombatantConditionsWidget`: Condition badges with icons
- `EncounterCard`: Encounter list item with preview
- `EncounterDifficultyBadge`: Visual difficulty indicator
- `RoundCounter`: Current round display

**List Widgets:**

- `EncounterList`: Browse encounters with empty state
- `InitiativeOrderList`: Combatant list sorted by initiative

**Dialog Widgets:**

- `AddCombatantDialog`: Add new combatant form
- `DamageHealDialog`: Quick HP adjustment
- `ConditionSelector`: Multi-select condition picker

## Usage

### Browsing Encounters

From the campaign menu, select "Browse Encounters" to view all encounters:

```dart
const EncountersListRouteData().go(context);
```

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

Using the CombatantService:

```dart
import 'package:moonforge/features/encounters/services/combatant_service.dart';

// Apply damage
final damaged = await combatantService.applyDamage(combatant, 10);

// Heal
final healed = await combatantService.heal(combatant, 5);

// Set HP directly
final updated = await combatantService.setHp(combatant, 20);

// Add condition
final poisoned = await combatantService.addCondition(combatant, 'poisoned');

// Remove condition
final cured = await combatantService.removeCondition(combatant, 'poisoned');

// Clear all conditions
final cleared = await combatantService.clearConditions(combatant);

// Check status
if (combatantService.isAlive(combatant)) {
  // Combatant has HP > 0
}

if (combatantService.isBloodied(combatant)) {
  // Combatant is below 50% HP
}
```

### Using the Initiative Tracker Controller

```dart
import 'package:moonforge/features/encounters/controllers/initiative_tracker_controller.dart';
import 'package:provider/provider.dart';

// Initialize controller with combatants
final controller = context.read<InitiativeTrackerController>();
controller.initialize(combatants);

// Roll initiative for all
controller.rollInitiativeForAll();

// Navigate turns
controller.nextTurn();
controller.previousTurn();

// Apply damage/healing
controller.applyDamage(combatantIndex, damageAmount);
controller.heal(combatantIndex, healingAmount);

// Manage conditions
controller.addCondition(combatantIndex, 'stunned');
controller.removeCondition(combatantIndex, 'stunned');

// Access state
final currentCombatant = controller.currentCombatant;
final round = controller.round;
final log = controller.combatLog;
final isOver = controller.isEncounterOver();
```

### Using Widgets

```dart
import 'package:moonforge/features/encounters/widgets/combatant_card.dart';
import 'package:moonforge/features/encounters/widgets/damage_heal_dialog.dart';

// Display a combatant
CombatantCard(
  combatant: combatant,
  isCurrentTurn: true,
  onTap: () => _showDetails(combatant),
  onDamage: () async {
    final damage = await showDamageDialog(
      context,
      combatantName: combatant.name,
      currentHp: combatant.currentHp,
      maxHp: combatant.maxHp,
    );
    if (damage != null) {
      controller.applyDamage(index, damage);
    }
  },
  onHeal: () async {
    final healing = await showHealDialog(
      context,
      combatantName: combatant.name,
      currentHp: combatant.currentHp,
      maxHp: combatant.maxHp,
    );
    if (healing != null) {
      controller.heal(index, healing);
    }
  },
);
```

## Code Generation

Routes and data models require code generation. After modifying:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## D&D 5e Reference

This implementation follows D&D 5e Basic Rules Chapter 13: Building Combat Encounters.

### XP Thresholds by Level

| Level | Easy  | Medium | Hard  | Deadly |
|-------|-------|--------|-------|--------|
| 1     | 25    | 50     | 75    | 100    |
| 2     | 50    | 100    | 150   | 200    |
| 3     | 75    | 150    | 225   | 400    |
| 5     | 250   | 500    | 750   | 1,100  |
| 10    | 600   | 1,200  | 1,900 | 2,800  |
| 20    | 2,800 | 5,700  | 8,500 | 12,700 |

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

**Current Status:** Phase 2 Complete (UI Components & State Management)

✅ Completed:

- Encounter difficulty calculation service
- Initiative tracker service
- Combatant data model and service
- Combatant repository for data operations
- State management (EncounterProvider, InitiativeTrackerController)
- Complete widget library (11 reusable widgets)
- Encounter list screen
- Routes for initiative tracker and encounter browsing
- Menu integration for "Browse Encounters"
- Basic UI scaffolding
- Localization (EN, DE)

🚧 In Progress:

- Complete encounter builder UI
- Monster/NPC selection interface
- Live difficulty calculation display

📋 Planned:

- Enhanced initiative tracker features (concentration, death saves, etc.)
- Encounter persistence during combat
- Combat log with history
- Preset encounter templates
- Random encounter generator
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
