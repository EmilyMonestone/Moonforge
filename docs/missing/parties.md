# Parties Feature - Missing Implementations

## Overview

The Parties feature manages player character groups (parties), individual player characters (members), and their associated sessions.

## Current Implementation

### ✅ Implemented

**Views** (4 files)

- `party_screen.dart` - Party detail view
- `party_edit_screen.dart` - Create/edit party
- `member_screen.dart` - Player character detail
- `member_edit_screen.dart` - Create/edit player character

**Routes**

- `PartyRootRoute` - `/party`
- `PartyRoute` - `/party/:partyId`
- `PartyEditRoute` - `/party/:partyId/edit`
- `MemberRoute` - `/party/:partyId/member/:memberId`
- `MemberEditRoute` - `/party/:partyId/member/:memberId/edit`

**Data Layer**

- `Parties` table
- `Players` table (comprehensive PC schema)
- `PartyDao`
- `PlayerDao`
- `PartyRepository`
- `PlayerRepository`

## ❌ Missing Components

### Controllers (0/2)

**Missing:**

1. `party_provider.dart`
    - Current party state
    - Party switching
    - Party member management
    - Session tracking

2. `player_provider.dart`
    - Current player character state
    - Character sheet state
    - HP/resource tracking
    - Level up state

**Impact**: High - No state management for parties or players

### Services (0/6)

**Missing:**

1. `party_service.dart`
    - Party operations
    - Member management
    - Party statistics
    - Session management

2. `player_character_service.dart`
    - Character creation
    - Level up calculations
    - Ability score management
    - HP calculations

3. `character_sheet_service.dart`
    - Character sheet display logic
    - Stat calculations (modifiers, bonuses)
    - Proficiency calculations
    - Spell slot tracking

4. `dndbeyond_sync_service.dart`
    - D&D Beyond integration
    - Import character from D&D Beyond
    - Sync character updates
    - Handle ddbCharacterId field

5. `party_balancing_service.dart`
    - Party composition analysis
    - Level balancing
    - Role coverage (tank, healer, etc.)

6. `session_scheduling_service.dart`
    - Schedule party sessions
    - Send notifications
    - Track attendance

**Impact**: High - Complex business logic needed

### Widgets (0/20+)

**Missing:**

**Party Widgets:**

1. `party_card.dart` - Display party in lists
2. `party_list.dart` - Browse parties
3. `party_member_list.dart` - List members in party
4. `party_composition_widget.dart` - Visual party composition
5. `party_stats_widget.dart` - Party statistics
6. `add_member_to_party_dialog.dart` - Add existing PC to party

**Player Character Widgets:**

7. `character_sheet_widget.dart` - Full character sheet display
8. `character_card.dart` - Character card in lists
9. `ability_scores_widget.dart` - Ability scores display
10. `skill_list_widget.dart` - Skills with modifiers
11. `saving_throws_widget.dart` - Saving throws display
12. `hp_tracker_widget.dart` - HP management
13. `spell_list_widget.dart` - Spells display
14. `equipment_list_widget.dart` - Equipment/inventory
15. `features_list_widget.dart` - Class features
16. `proficiencies_widget.dart` - All proficiencies
17. `character_header.dart` - Name, class, level, race
18. `level_up_dialog.dart` - Level up interface
19. `short_rest_dialog.dart` - Short rest mechanics
20. `long_rest_dialog.dart` - Long rest mechanics
21. `death_save_tracker.dart` - Death saving throws
22. `inspiration_tracker.dart` - Inspiration points

**Impact**: Critical - Player character sheets are core functionality

### Utils (0/8)

**Missing:**

1. `party_validators.dart` - Validate party data
2. `character_validators.dart` - Validate character data
3. `character_calculations.dart` - Stat calculations, modifiers
   4.`character_formatters.dart` - Display formatting
   5.`rest_mechanics.dart` - Rest and recovery
   6.`character_export.dart` - Export character sheets
   7.`character_import.dart` - Import from D&D Beyond, etc.

**Impact**: High - Complex D&D 5e rules

### Views (Missing: 3+)

**Missing:**

1. `party_list_screen.dart` - Browse all parties
2. `character_sheet_screen.dart` - Full-page character sheet view
3. `party_session_list_screen.dart` - Session history for party

**Impact**: High - Core views missing

### Routes (Missing: 3)

**Missing:**

- `/parties` - List all parties
- `/party/:partyId/character/:characterId` - Full character sheet (separate from member context)
- `/party/:partyId/sessions` - Party session history

**Impact**: High

## 🚧 Incomplete Features

### Players Table Integration

**Status:** Table exists with comprehensive schema but UI integration is minimal

The `Players` table has:

- ✅ All D&D 5e core stats (ability scores, HP, AC, etc.)
- ✅ Skills, saving throws, proficiencies
- ✅ Equipment, features, spells
- ✅ Rich text fields (notes, bio)
- ✅ D&D Beyond integration fields (ddbCharacterId, lastDdbSync)

**Missing UI:**

- Character sheet display
- Ability score management
- Skill proficiency selection
- Spell management
- Equipment management
- Level up interface
- HP tracking
- Resource management
- D&D Beyond sync UI

### Party Screen Enhancements

**Missing:**

- Party composition overview
- Average party level
- Session schedule
- Party inventory
- Shared notes
- Party relationships/dynamics

### Member Screen (Player Character)

**Current:** Basic view exists
**Missing:**

- Full character sheet layout
- Tabbed interface (Stats, Spells, Equipment, Bio)
- Interactive stat blocks
- Dice roll integration
- HP and resource tracking
- Condition tracking
- Print character sheet

### D&D Beyond Integration

**Status:** Fields exist but no implementation

**Missing:**

- Import character from D&D Beyond API
- Sync character updates
- Show last sync time
- Handle sync conflicts
- Link/unlink D&D Beyond account

### Party Features

**Missing:**

- Party loot tracking
- Shared party resources
- Party journal
- Party achievements
- Party reputation
- Faction standings

## Implementation Priority

### Critical (Core D&D 5e Functionality)

1. **Character Sheet Widget & Screen** - Essential for RPG app
2. **Player Character Service** - D&D 5e calculations
3. **HP Tracker Widget** - Combat essential
4. **Ability Scores & Skills Display** - Core stats

### High Priority

5. **Party Provider & Service** - State management
6. **Character Calculations Utils** - Modifiers, bonuses
7. **Party List Screen** - Browse parties
8. **Character Sheet Layout** - Full sheet view

### Medium Priority

9. **Spell & Equipment Management** - Feature completeness
10. **Level Up System** - Character progression
11. **Rest Mechanics** - D&D rules
12. **D&D Beyond Integration** - Import/sync

### Low Priority

13. **Party Inventory** - Shared resources
14. **Party Journal** - Collaborative notes
15. **Advanced Character Features** - Multiclassing, feats

## Integration Points

### Dependencies

- **Campaigns** - Parties belong to campaigns
- **Sessions** - Party session management
- **Encounters** - PC stats in combat
- **D&D Beyond Service** - Character import
- **Dice Roller** - Ability checks, attacks

### Required Changes

1. **Router** - Add party list and character sheet routes
2. **Encounters** - Link PCs to combatants
3. **Sessions** - Link sessions to parties
4. **Menu Registry** - Party and character actions

## Testing Needs

- Unit tests for character calculations
- Unit tests for D&D 5e mechanics
- Widget tests for character sheet
- Integration tests for D&D Beyond sync
- Test character import/export

## Documentation

**Existing:**

- Players table schema documented

**Missing:**

- Feature README
- D&D 5e rules implementation guide
- Character sheet documentation
- D&D Beyond integration guide

## Next Steps

1. **CRITICAL**: Implement character sheet display
2. Create player character service with D&D 5e calculations
3. Build character sheet widgets
4. Implement party provider and service
5. Add HP and resource tracking
6. Create party list screen
7. Implement D&D Beyond integration
8. Add level up system
9. Build rest mechanics
10. Add comprehensive tests
11. Write documentation

---

**Status**: Partial Implementation (20% complete - Data layer ready, UI minimal)
**Last Updated**: 2025-11-03
**Priority**: CRITICAL - Core RPG functionality missing
