# Entity Management

Entities are reusable objects within campaigns: NPCs, monsters, places, items, etc.

## Entity Types

- **NPC**: Non-player characters
- **Monster**: Creatures from bestiary
- **Group**: Organizations, factions
- **Place**: Locations, buildings
- **Item**: Equipment, magic items
- **Handout**: Player handouts
- **Journal**: Journal entries

## Data Model

```dart
@freezed
class Entity with _$Entity {
  const factory Entity({
    required String id,
    required String kind,
    required String name,
    String? summary,
    @Default([]) List<String> tags,
    Content? content,
    Map<String, dynamic>? statblock,
  }) = _Entity;
}
```

## Statblocks

For monsters and NPCs:

```dart
statblock: {
  'source': 'srd',  // or 'custom'
  'srdRef': 'MM:Goblin',
  'data': {/* monster stats */}
}
```

## Usage

### Creating Entity

```dart
final entity = Entity(
  id: uuid.v4(),
  kind: 'npc',
  name: 'Aria the Merchant',
  tags: ['merchant', 'ally'],
);
```

### Linking to Bestiary

See [Bestiary](bestiary.md) for monster data integration.

## Related Documentation

- [Bestiary](bestiary.md)
- [Campaigns](campaigns.md)
- [Firebase Schema](../reference/firebase-schema.md)
