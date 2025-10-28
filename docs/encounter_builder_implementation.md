# Encounter Builder & Initiative Tracker Implementation

## Overview

This document describes the implementation of the Encounter Builder and Initiative Tracker feature for Moonforge, following the D&D 5e encounter building rules from the Basic Rules Chapter 13.

## Architecture

### Core Services

#### 1. EncounterDifficultyService (`lib/features/encounters/services/encounter_difficulty_service.dart`)

The core service implementing D&D 5e encounter difficulty calculations.

**Key Methods:**

- `calculatePartyThresholds(List<int> playerLevels)` - Calculates XP thresholds (Easy, Medium, Hard, Deadly) for a party
- `getXpForCr(String cr)` - Converts Challenge Rating to XP value
- `getEncounterMultiplier(int monsterCount, int partySize)` - Applies encounter multipliers based on number of monsters and party size
- `calculateAdjustedXp(List<int> monsterXpValues, int partySize)` - Calculates the adjusted XP for an encounter
- `classifyDifficulty(int adjustedXp, Map<String, int> partyThresholds)` - Classifies encounter difficulty (Trivial, Easy, Medium, Hard, Deadly)

**Data Tables:**

- XP Thresholds by Level (1-20) for each difficulty tier
- CR to XP mapping (CR 0 to CR 30)
- Encounter multipliers based on monster count

**Party Size Adjustments:**
- Small parties (<3 members): Use next higher multiplier
- Standard parties (3-5 members): Use base multiplier
- Large parties (≥6 members): Use next lower multiplier

#### 2. InitiativeTrackerService (`lib/features/encounters/services/initiative_tracker_service.dart`)

Manages initiative order and turn-based combat flow.

**Key Methods:**

- `sortByInitiative(List<Combatant>)` - Sorts combatants by initiative roll (ties broken by modifier)
- `getNextCombatantIndex()` / `getPreviousCombatantIndex()` - Navigate turn order, skipping dead combatants
- `isNewRound()` - Detects when initiative wraps to start a new round
- `getAliveCount()` / `getAliveAlliesCount()` / `getAliveEnemiesCount()` - Combat state queries
- `isEncounterOver()` - Checks if all allies or all enemies are defeated
- `getWinner()` - Returns winning side when encounter ends

### Data Models

#### Combatant (`lib/features/encounters/models/combatant.dart`)

Represents a participant in an encounter (player, monster, or NPC).

**Fields:**
- Basic info: `id`, `name`, `type` (player/monster/npc), `isAlly`
- Combat stats: `currentHp`, `maxHp`, `armorClass`
- Initiative: `initiative` (rolled value), `initiativeModifier`
- Source: `entityId` (campaign entity), `bestiaryName` (from bestiary), `cr`, `xp`
- State: `conditions`, `notes`, `order` (position in initiative)

**Extension Methods:**
- `isAlive` - Check if combatant has HP > 0
- `isEnemy` - Check if combatant is not an ally
- `applyDamage(int)` - Apply damage and clamp HP
- `heal(int)` - Restore HP (clamped to max)
- `addCondition(String)` / `removeCondition(String)` - Manage status effects

## D&D 5e Rules Implementation

### Encounter Difficulty Calculation

The implementation follows the official D&D 5e rules:

1. **Determine XP Thresholds**: Sum per-character thresholds based on level
2. **Calculate Monster XP**: Sum the base XP of all monsters
3. **Apply Multiplier**: Adjust monster XP based on count and party size
4. **Compare**: Classify difficulty by comparing adjusted XP to thresholds

**Example** (from D&D rulebook):
- Party: 3× level 3, 1× level 2
- Monsters: 1× Bugbear (CR 1, 200 XP) + 3× Hobgoblins (CR 1/2, 100 XP each)
- Base XP: 200 + 300 = 500
- Adjusted XP: 500 × 2.0 (4 monsters) = 1000
- Thresholds: Easy 275, Medium 550, Hard 825, Deadly 1400
- Result: **Hard** encounter (1000 falls between Hard and Deadly)

### Encounter Multipliers

| Number of Monsters | Base Multiplier | Small Party (<3) | Large Party (≥6) |
|-------------------|-----------------|------------------|------------------|
| 1                 | 1.0             | 1.5              | 0.5              |
| 2                 | 1.5             | 2.0              | 1.0              |
| 3-6               | 2.0             | 2.5              | 1.5              |
| 7-10              | 2.5             | 3.0              | 2.0              |
| 11-14             | 3.0             | 4.0              | 2.5              |
| 15+               | 4.0             | 5.0              | 3.0              |

## UI Components

### Encounter Builder Screen (`lib/features/encounters/views/encounter_edit_screen.dart`)

The main screen for creating and editing encounters.

**Current Implementation:**
- Basic layout with name field
- Party selection placeholder
- Difficulty display placeholders
- Combatant list placeholder
- Save button

**Planned Features:**
- Party selection dropdown (existing parties or custom group)
- Live XP budget calculation display
- Monster browser (from Bestiary and campaign entities)
- Drag-and-drop combatant ordering
- Wave/group management for multi-part encounters
- Preset templates for quick encounter creation

### Encounter View Screen (`lib/features/encounters/views/encounter_screen.dart`)

Display screen for viewing an encounter and starting the initiative tracker.

**Current Implementation:**
- Basic header with encounter name
- Edit button (navigates to builder)
- Start encounter button (placeholder)

**Planned Features:**
- Display full encounter details
- Show calculated difficulty
- List all combatants with their stats
- Initiative tracker mode toggle

### Initiative Tracker (Planned)

A dedicated UI for running encounters in real-time.

**Planned Features:**
- Ordered list of combatants by initiative
- Current turn indicator
- Round counter
- HP and condition tracking
- Quick actions (damage, heal, add condition)
- Next/Previous turn buttons
- Combat log
- End encounter confirmation

## Menu Integration

The "Create Encounter" action has been added to the menu registry:
- Available in Campaign view
- Available in Adventure view
- Icon: shield_outlined
- Creates new encounter and navigates to builder

## Testing

### Unit Tests

**EncounterDifficultyService Tests** (`test/features/encounters/encounter_difficulty_service_test.dart`)
- 31 test cases covering:
  - Party threshold calculations (single/multiple characters, edge cases)
  - CR to XP mapping (common CRs, unknown CR)
  - Encounter multipliers (standard/small/large parties)
  - Adjusted XP calculations
  - Difficulty classification
  - Integration tests with D&D rulebook examples

**InitiativeTrackerService Tests** (`test/features/encounters/initiative_tracker_service_test.dart`)
- 22 test cases covering:
  - Initiative sorting (by value, by modifier for ties)
  - Turn navigation (next/previous, wrapping, skipping dead)
  - Round detection
  - Alive counts (total, allies, enemies)
  - Encounter completion detection
  - Winner determination

### Test Coverage

All core business logic has comprehensive unit test coverage:
- XP calculations validated against D&D rulebook examples
- Party size adjustments verified for all scenarios
- Initiative tracker edge cases (empty lists, all dead, ties) covered
- Total: 53 unit tests with 100% pass rate

## Localization

All user-facing strings are internationalized in English and German:

**Key Strings:**
- `createEncounter` - "Create Encounter" / "Begegnung erstellen"
- `encounterBuilder` - "Encounter Builder" / "Begegnungsbauer"
- `initiativeTracker` - "Initiative Tracker" / "Initiativ-Tracker"
- `encounterDifficulty` - "Encounter Difficulty" / "Begegnungsschwierigkeit"
- Difficulty levels: `trivial`, `easy`, `medium`, `hard`, `deadly`
- Combat terms: `initiative`, `hitPoints`, `armorClass`, `conditions`
- Actions: `rollInitiative`, `addCombatant`, `startEncounter`, `endEncounter`

See `lib/l10n/app_en.arb` and `lib/l10n/app_de.arb` for the complete list.

## Setup and Code Generation

### Required Code Generation

The Combatant model uses Freezed and JSON serialization annotations. After cloning, run:

```bash
cd moonforge
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- `combatant.freezed.dart` - Freezed immutable class boilerplate
- `combatant.g.dart` - JSON serialization methods

### Dependencies

All required packages are already in `pubspec.yaml`:
- `freezed_annotation` - For immutable models
- `json_annotation` - For JSON serialization
- `uuid` - For generating encounter IDs

## Future Enhancements

### Phase 1 Enhancements (Short-term)
1. Complete party selection UI with dropdown
2. Implement monster browser with search/filter
3. Wire up live XP calculation and difficulty display
4. Add combatant cards with inline editing
5. Implement encounter persistence to database

### Phase 2 Enhancements (Medium-term)
1. Full initiative tracker UI
2. HP and condition management
3. Combat log with history
4. Dice roller integration
5. Preset encounter templates

### Phase 3 Enhancements (Long-term)
1. Multi-part encounter support (waves)
2. Dynamic difficulty adjustment suggestions
3. Encounter balancing hints and warnings
4. Import/export encounters
5. Integration with session notes
6. Mobile-optimized initiative tracker
7. Real-time sync for multi-user sessions

## References

- **D&D 5e Basic Rules Chapter 13**: Building Combat Encounters
- **XP Thresholds**: Table in D&D Basic Rules (levels 1-20)
- **Challenge Ratings**: Monster Manual, Dungeon Master's Guide
- **Kobold Plus Club**: https://koboldplus.club/ (inspiration for UI/UX)

## Contributing

When extending this feature:

1. **Follow D&D Rules**: All calculations should match official rules exactly
2. **Test Thoroughly**: Add unit tests for new calculation logic
3. **Internationalize**: Add strings to both `app_en.arb` and `app_de.arb`
4. **Maintain Minimal Changes**: Keep changes surgical and focused
5. **Document**: Update this file when adding major features

## Questions and Issues

For questions about the implementation or to report issues, please refer to:
- The unit tests for examples of usage
- The D&D 5e Basic Rules for rule clarifications
- The issue tracker for known issues and feature requests
