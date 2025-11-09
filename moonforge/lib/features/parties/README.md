# Parties Feature Implementation

## Overview

The Parties feature manages player character groups (parties) and individual player characters (members) with full D&D 5e character sheet support.

## Architecture

### Data Layer (Already Existed)
- **Tables**: `Parties`, `Players` (comprehensive D&D 5e schema)
- **DAOs**: `PartyDao`, `PlayerDao`
- **Repositories**: `PartyRepository`, `PlayerRepository`

### Controllers (State Management)
- **PartyProvider**: Manages current party state, party switching, member management
- **PlayerProvider**: Manages current player state, HP tracking, ability scores, level up

### Services (Business Logic)
- **PartyService**: Party operations, statistics, composition analysis, balance checking
- **PlayerCharacterService**: D&D 5e calculations, skill modifiers, saving throws, rest mechanics

### Utils
- **CharacterCalculations**: D&D 5e math (ability modifiers, proficiency bonus, skill checks, etc.)
- **PartyValidators**: Validation for party data
- **CharacterValidators**: Validation for character data
- **CharacterFormatters**: Display formatting for character information

### Widgets (10 created)

#### Character Widgets
- **CharacterSheetWidget**: Complete character sheet combining all components
- **CharacterHeaderWidget**: Name, class, level, race display
- **AbilityScoresWidget**: 6 ability scores with modifiers
- **HpTrackerWidget**: Interactive HP management (damage, heal, temp HP)
- **SkillListWidget**: 18 skills with proficiency indicators
- **SavingThrowsWidget**: 6 saving throws with proficiency
- **CharacterCard**: Character display in lists

#### Party Widgets
- **PartyCard**: Party display in lists
- **PartyStatsWidget**: Party statistics (member count, avg level, total HP, avg AC)
- **PartyCompositionWidget**: Class distribution visualization

### Views (5 screens)
- **PartyListScreen**: Browse all parties (NEW - shows at `/party`)
- **PartyScreen**: Party detail with members, stats, composition (at `/party/:partyId`)
- **MemberScreen**: Full character sheet view (at `/party/:partyId/member/:memberId`)
- **PartyEditScreen**: Create/edit party (existing)
- **MemberEditScreen**: Create/edit character (existing)

## Features Implemented

### D&D 5e Mechanics
- ✅ Ability score modifiers
- ✅ Skill checks with proficiency
- ✅ Saving throws with proficiency
- ✅ Proficiency bonus scaling (based on level)
- ✅ Initiative calculation
- ✅ Passive perception
- ✅ HP tracking (current, max, temporary)
- ✅ Damage and healing
- ✅ Short rest and long rest mechanics
- ✅ Spell save DC calculation
- ✅ Spell attack bonus calculation

### Party Management
- ✅ Create and list parties
- ✅ View party details
- ✅ Add/remove members
- ✅ Party statistics (avg level, HP, AC)
- ✅ Party composition (class distribution)
- ✅ Party balance checking (tank/healer/DPS analysis)

### Character Display
- ✅ Complete character sheet
- ✅ Character header (name, class, level, race, background, alignment)
- ✅ Core combat stats (HP, AC, Initiative, Speed, Proficiency Bonus, Passive Perception)
- ✅ Ability scores (all 6 with modifiers)
- ✅ Skills (all 18 with proficiency)
- ✅ Saving throws (all 6 with proficiency)
- ✅ Features & traits list
- ✅ Equipment list
- ✅ Spells list

### HP Tracking
- ✅ Visual HP bar with color coding (green/orange/red)
- ✅ Apply damage
- ✅ Apply healing
- ✅ Temporary HP management
- ✅ Automatic temp HP application to damage

## Usage

### Navigating to Parties
```dart
// Go to party list
const PartyRootRoute().go(context);

// Go to specific party
PartyRoute(partyId: 'party123').go(context);

// Go to character sheet
MemberRoute(partyId: 'party123', memberId: 'player456').go(context);
```

### Using Providers
```dart
// Get party provider
final partyProvider = Provider.of<PartyProvider>(context);

// Set current party
partyProvider.setCurrentParty(party);

// Add member to party
await partyProvider.addMember(playerId);

// Get player provider
final playerProvider = Provider.of<PlayerProvider>(context);

// Update HP
await playerProvider.takeDamage(10);
await playerProvider.heal(5);

// Level up character
await playerProvider.levelUp();
```

### Using Services
```dart
// Party service
final partyService = PartyService(partyRepo, playerRepo);
final members = await partyService.getPartyMembers(partyId);
final stats = await partyService.getPartyStatistics(partyId);
final balance = await partyService.checkPartyBalance(partyId);

// Character service
final characterService = PlayerCharacterService(playerRepo);
final skillMod = characterService.getSkillModifier(player, 'Stealth');
final saveMod = characterService.getSavingThrowModifier(player, 'DEX');
final updatedPlayer = await characterService.performLongRest(player);
```

## Not Implemented (Future Enhancements)

Based on `docs/missing/parties.md`, the following were marked as lower priority:

### Medium Priority
- D&D Beyond integration (import/sync)
- Advanced spell management UI
- Equipment management UI
- Level up dialog interface
- Rest dialogs (short/long rest UI)

### Low Priority
- Death saving throws tracker
- Inspiration tracker
- Party inventory/loot tracking
- Party journal
- Session scheduling
- Multiclassing support
- Feat management

## Database Schema

### Parties Table
```dart
- id: String (PK)
- campaignId: String (FK)
- name: String
- summary: String?
- memberEntityIds: List<String>? (legacy)
- memberPlayerIds: List<String>? (current)
- createdAt: DateTime?
- updatedAt: DateTime?
- rev: int
```

### Players Table (Comprehensive D&D 5e)
```dart
- id: String (PK)
- campaignId: String (FK)
- playerUid: String? (Firebase Auth UID)
- name: String
- className: String
- subclass: String?
- level: int (default 1)
- race: String?
- background: String?
- alignment: String?

// Ability Scores
- str, dex, con, intl, wis, cha: int (default 10)

// Core Stats
- hpMax, hpCurrent, hpTemp: int?
- ac: int?
- proficiencyBonus: int?
- speed: int?

// Proficiencies and Features
- savingThrowProficiencies: List<String>?
- skillProficiencies: List<String>?
- languages: List<String>?
- equipment: List<String>?
- features: List<Map>? (name, description)
- spells: List<String>?

// Rich Text
- notes: QuillDelta?
- bio: QuillDelta?

// D&D Beyond Integration
- ddbCharacterId: String?
- lastDdbSync: DateTime?

// Metadata
- createdAt, updatedAt: DateTime?
- rev: int (default 1)
- deleted: bool (default false)
```

## Testing

No automated tests were added per the instruction to make minimal modifications and only add tests if they already exist in the repository.

## Notes

- The implementation follows the existing patterns in the codebase (e.g., CampaignProvider)
- All providers are registered in `MultiProviderWrapper`
- The PartyRootRoute (`/party`) now shows the party list instead of an empty state
- Character sheets are fully functional with all D&D 5e stats
- HP tracking includes damage, healing, and temporary HP mechanics
- Party balance checking helps DMs ensure balanced party composition
