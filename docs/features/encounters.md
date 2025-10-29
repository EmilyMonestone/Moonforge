# Encounter Builder

The encounter builder helps create and run D&D 5e combat encounters.

## Features

- Create encounter presets
- Add combatants from entities or bestiary
- Initiative tracker
- HP and condition tracking
- Difficulty calculation (XP budgets, party size adjustments)
- Turn management

## Encounter Model

```dart
@freezed
class Encounter with _$Encounter {
  const factory Encounter({
    required String id,
    required String name,
    @Default(false) bool preset,
    String? notes,
    @Default([]) List<Combatant> combatants,
  }) = _Encounter;
}
```

## Combatant Model

```dart
@freezed
class Combatant with _$Combatant {
  const factory Combatant({
    required String id,
    required String name,
    required int initiative,
    required HP hp,
    required int ac,
    @Default([]) List<String> conditions,
    CombatantSource? source,
  }) = _Combatant;
}
```

## Difficulty Calculation

Uses D&D 5e encounter building rules:
- XP thresholds by character level
- Encounter multipliers by monster count
- Party size adjustments

## Initiative Tracker

Features:
- Sort by initiative (with modifier tiebreaker)
- Next/previous turn
- Skip dead combatants
- Round tracking
- Win condition detection

## Related Documentation

- [Entities](entities.md)
- [Bestiary](bestiary.md)
