# Encounter Builder Feature - Development Checklist

Use this checklist to track progress on the Encounter Builder and Initiative Tracker feature.

## ✅ Completed (Phase 1)

### Core Services
- [x] EncounterDifficultyService with full D&D 5e rules
  - [x] XP threshold tables (levels 1-20)
  - [x] CR to XP mapping (CR 0-30)
  - [x] Encounter multipliers
  - [x] Party size adjustments
  - [x] Difficulty classification
- [x] InitiativeTrackerService
  - [x] Initiative sorting
  - [x] Turn navigation
  - [x] Round detection
  - [x] Combat state tracking
  - [x] Win condition detection

### Data Models
- [x] Combatant model (Freezed)
  - [x] Player/Monster/NPC types
  - [x] HP tracking
  - [x] Initiative values
  - [x] Condition management
  - [x] Extension methods (damage, heal, conditions)

### Testing
- [x] 31 tests for EncounterDifficultyService
- [x] 22 tests for InitiativeTrackerService
- [x] D&D rulebook example validation
- [x] Edge case coverage

### Integration
- [x] Menu action "Create Encounter"
- [x] create_encounter utility
- [x] Router configuration
- [x] Navigation between screens

### Localization
- [x] 50+ strings in English
- [x] 50+ strings in German

### Documentation
- [x] Implementation guide (10k+ words)
- [x] Feature README with examples
- [x] Summary document
- [x] Development checklist (this file)

## 🚧 In Progress (Phase 2)

### Encounter Builder UI
- [ ] Party selection dropdown
  - [ ] Fetch existing parties
  - [ ] Display party composition
  - [ ] Show party size
- [ ] Custom player group builder
  - [ ] Add player form
  - [ ] Level input
  - [ ] Remove player
  - [ ] Validation
- [ ] XP threshold display
  - [ ] Calculate from party
  - [ ] Show all four thresholds
  - [ ] Update in real-time
- [ ] Monster/NPC browser
  - [ ] Integrate BestiaryProvider
  - [ ] Query campaign entities
  - [ ] Search functionality
  - [ ] Filter by CR
  - [ ] Display CR and XP
- [ ] Combatant management
  - [ ] Add combatant button
  - [ ] Combatant card widget
  - [ ] Edit inline
  - [ ] Remove combatant
  - [ ] Set quantity
  - [ ] Drag to reorder
- [ ] Live difficulty indicator
  - [ ] Calculate adjusted XP
  - [ ] Show base vs adjusted
  - [ ] Color-coded display
  - [ ] Update on changes
- [ ] Save encounter
  - [ ] Validate form
  - [ ] Call repository
  - [ ] Show success/error
  - [ ] Navigate back

## 📋 Not Started (Phase 3+)

### Initiative Tracker UI
- [ ] Create initiative_tracker_screen.dart
- [ ] Roll initiative UI
  - [ ] Roll all button
  - [ ] Roll individually
  - [ ] Manual input
  - [ ] Auto-sort
- [ ] Tracker display
  - [ ] Ordered combatant list
  - [ ] Current turn highlight
  - [ ] Round counter
  - [ ] Next/Previous buttons
- [ ] HP management
  - [ ] Damage button/dialog
  - [ ] Heal button/dialog
  - [ ] Current/Max display
  - [ ] Dead state visual
- [ ] Condition management
  - [ ] Add condition dropdown
  - [ ] Condition chips/badges
  - [ ] Remove condition
  - [ ] Condition descriptions
- [ ] Combat actions
  - [ ] Add combatant mid-encounter
  - [ ] Remove combatant
  - [ ] Skip turn
- [ ] Combat log
  - [ ] Log entries
  - [ ] Scrollable history
  - [ ] Export log
- [ ] Encounter end
  - [ ] Detect completion
  - [ ] Show winner
  - [ ] Display summary
  - [ ] Save to notes option

### Persistence
- [ ] Enhance Encounter model
  - [ ] Add difficulty field
  - [ ] Add party reference
  - [ ] Add structured combatants
  - [ ] Add scene/adventure link
- [ ] Repository updates
  - [ ] Save with combatants
  - [ ] Load with combatants
  - [ ] Update combatants
  - [ ] Delete encounter
- [ ] State persistence
  - [ ] Save tracker state
  - [ ] Resume encounter
  - [ ] Auto-save

### Advanced Features
- [ ] Encounter presets
  - [ ] Save as template
  - [ ] Load template
  - [ ] Preset library
- [ ] Wave/multipart support
  - [ ] Group combatants
  - [ ] Wave selector
  - [ ] Combined difficulty
- [ ] Balancing hints
  - [ ] Suggest monsters
  - [ ] Budget builder
  - [ ] Warnings
- [ ] Dice integration
  - [ ] Visual roller
  - [ ] Initiative rolls
  - [ ] Damage rolls

### Testing & Polish
- [ ] Widget tests
  - [ ] Encounter builder widgets
  - [ ] Initiative tracker widgets
  - [ ] Form validation
- [ ] Integration tests
  - [ ] Full encounter flow
  - [ ] Save and load
  - [ ] Initiative tracking
- [ ] Manual testing
  - [ ] Various party sizes
  - [ ] Different difficulty levels
  - [ ] Edge cases
- [ ] UI screenshots
  - [ ] Encounter builder
  - [ ] Initiative tracker
  - [ ] Monster browser
- [ ] Performance testing
  - [ ] Large bestiaries
  - [ ] Many combatants
  - [ ] Long encounters

### Mobile Optimization
- [ ] Responsive layouts
- [ ] Touch gestures
- [ ] Mobile-specific controls
- [ ] Tablet layouts

### Multiplayer (Future)
- [ ] Real-time sync
- [ ] Player visibility controls
- [ ] DM vs Player views
- [ ] Remote session support

## Quick Start for Developers

1. **Generate code first:**
   ```bash
   cd moonforge
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Run tests:**
   ```bash
   flutter test test/features/encounters/
   ```

3. **Read documentation:**
   - Start with: `moonforge/lib/features/encounters/README.md`
   - Then: `docs/encounter_builder_implementation.md`
   - Finally: `ENCOUNTER_BUILDER_SUMMARY.md`

4. **Pick a task from Phase 2 "In Progress" section above**

5. **Follow the pattern:**
   - Write tests first (if adding logic)
   - Keep changes minimal
   - Update localization strings
   - Document complex code
   - Test manually

## Progress Tracking

**Overall Progress: ~30%**

- Phase 1 (Core): ████████████████████ 100% ✅
- Phase 2 (Builder UI): ████░░░░░░░░░░░░░░░░ 20% 🚧
- Phase 3 (Tracker): ░░░░░░░░░░░░░░░░░░░░ 0% 📋
- Phase 4 (Persistence): ░░░░░░░░░░░░░░░░░░░░ 0% 📋
- Phase 5 (Advanced): ░░░░░░░░░░░░░░░░░░░░ 0% 📋

**Estimated Hours Remaining: ~42-56 hours**

## Notes

- All core business logic is complete and tested
- Focus on UI implementation next
- Database schema already supports encounters
- Bestiary integration is ready to use
- Follow Material 3 Expressive design language
- All strings must be internationalized

## Questions?

See `ENCOUNTER_BUILDER_SUMMARY.md` for detailed information about what's done and what's next.
