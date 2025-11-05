# Encounters Feature - Missing Implementations

## Overview

The Encounters feature manages combat encounters, initiative tracking, and encounter building for D&D 5e campaigns.

## Current Implementation

### ✅ Implemented

**Views** (3 files)
- `encounter_screen.dart` - View encounter details
- `encounter_edit_screen.dart` - Encounter builder
- `initiative_tracker_screen.dart` - Initiative tracker UI

**Services** (2 files)
- `encounter_difficulty_service.dart` - D&D 5e difficulty calculations
- `initiative_tracker_service.dart` - Initiative management

**Utils** (4 files)
- `create_encounter.dart`
- `create_encounter_in_scene.dart`
- `create_encounter_in_adventure.dart`
- `create_encounter_in_chapter.dart`

**Routes**
- `EncounterRoute` - `/campaign/encounter/:encounterId`
- `EncounterEditRoute` - `/campaign/encounter/:encounterId/edit`

**Data Layer**
- `Encounters` table
- `Combatants` table
- `EncounterDao`
- `CombatantDao` (exists but no repository)

**Documentation**
- ✅ Comprehensive README with examples

## ❌ Missing Components

### Controllers (0/2)

**Missing:**
1. `encounter_provider.dart` - Encounter state management
2. `initiative_tracker_controller.dart` - Initiative state, turn tracking

**Impact**: High - Initiative tracker screen handles all state internally

### Services (Partial: 2/3)

**Existing:**
- ✅ `encounter_difficulty_service.dart`
- ✅ `initiative_tracker_service.dart`

**Missing:**
1. `combatant_service.dart` - Combatant CRUD operations, HP management, conditions

**Impact**: Medium - Some logic in UI components

### Widgets (0/15+)

**Missing:**
1. `encounter_card.dart` - Display in lists
2. `encounter_list.dart` - Browse encounters
3. `encounter_difficulty_badge.dart` - Visual difficulty indicator
4. `combatant_card.dart` - Display combatant in initiative tracker
5. `combatant_hp_bar.dart` - Visual HP indicator
6. `combatant_conditions_widget.dart` - Status effects display
7. `initiative_order_list.dart` - Initiative tracker list widget
8. `add_combatant_dialog.dart` - Add combatant to encounter
9. `monster_selector.dart` - Select from bestiary
10. `encounter_xp_calculator.dart` - Live XP calculation display
11. `encounter_rewards_widget.dart` - Loot and rewards
12. `round_counter.dart` - Current round display
13. `turn_indicator.dart` - Current turn highlight
14. `condition_selector.dart` - Apply conditions to combatant
15. `damage_heal_dialog.dart` - Quick HP adjustment

**Impact**: High - Initiative tracker needs significant UI componentization

### Repositories (0/1)

**Missing:**
- `combatant_repository.dart` - Combatant data operations

**Impact**: Medium - DAO exists but no repository layer

### Views (Missing: 2+)

**Missing:**
1. `encounter_list_screen.dart` - Browse all encounters
2. `encounter_templates_screen.dart` - Pre-built encounters

**Impact**: Medium

### Routes (Missing: 2)

**Missing:**
- `/campaign/encounters` - List all encounters
- Initiative tracker not properly routed (screen exists but accessed via dialog)

**Impact**: Medium to High - Initiative tracker should be a route

## 🚧 Incomplete Features

### Initiative Tracker Enhancements

**Partially Implemented:**
- Basic initiative tracking exists
- Missing:
  - Persistent state across sessions
  - Combat log
  - Undo/redo actions
  - Save encounter state mid-combat
  - Resume paused encounters
  - Damage history
  - Death saves tracking
  - Concentration tracking
  - Temporary HP
  - Legendary actions/reactions
  - Lair actions

### Encounter Builder Enhancements

**Missing:**
- Live difficulty calculation display
- Monster stat block preview
- Terrain/environment settings
- Encounter maps integration
- Random encounter generator
- Encounter scaling (adjust CR)
- Encounter notes
- Rewards calculator

### Combatant Features

**Missing:**
- Detailed stat blocks
- Special abilities
- Spell slot tracking
- Resource management
- Custom combatant types

## Implementation Priority

### High Priority

1. **Initiative Tracker Route** - Make it a proper screen, not a dialog
2. **Encounter Widgets** - Componentize initiative tracker UI
3. **Combatant Repository** - Complete data layer
4. **Encounter Provider** - State management

### Medium Priority

5. **Combat Log** - Track combat actions
6. **Encounter List Screen** - Browse encounters
7. **Enhanced Combatant Features** - Conditions, resources
8. **Save/Resume Encounters** - Persistent combat state

### Low Priority

9. **Encounter Templates** - Pre-built encounters
10. **Random Generator** - Random encounter creation
11. **Advanced Features** - Legendary actions, lair actions

## Integration Points

### Dependencies

- **Bestiary Service** - Monster selection
- **Entities** - Link NPCs to combatants
- **Players** - PC stats for encounters
- **Scenes/Adventures** - Encounter context

### Required Changes

1. **Router** - Add initiative tracker route, encounters list route
2. **Menu Registry** - Enhance encounter actions
3. **Bestiary Integration** - Connect to bestiary service

## Testing Status

**Existing:**
- ✅ 53 unit tests for services
- ❌ No widget tests
- ❌ No integration tests

**Needed:**
- Widget tests for initiative tracker
- Integration tests for combat flow
- Combatant CRUD tests

## Related Documentation

- ✅ `moonforge/lib/features/encounters/README.md` - Excellent documentation exists
- ✅ `docs/features/encounters.md` - Feature overview

## Next Steps

1. Convert initiative tracker to routed screen
2. Create encounter provider for state management
3. Build encounter and combatant widgets
4. Implement combatant repository
5. Add combat log functionality
6. Create encounter list screen
7. Enhance initiative tracker with missing features
8. Add widget and integration tests

---

**Status**: Partial Implementation (55% complete)
**Last Updated**: 2025-11-03
