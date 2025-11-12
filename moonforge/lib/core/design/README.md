# Domain Visuals System

This directory contains the centralized visual identity system for domain types in Moonforge.

## Overview

The domain visuals system provides a single source of truth for icons and colors associated with specific domain types (campaigns, chapters, adventures, scenes, entities, etc.) throughout the Flutter application.

## Files

- **`domain_visuals.dart`**: Main implementation with `DomainVisuals` registry and extension methods

## Usage

### Basic Usage

```dart
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';

// Get the icon for a campaign
IconData campaignIcon = DomainType.campaign.icon;

// Create an Icon widget
Icon(DomainType.campaign.icon);

// Using the convenience method
DomainType.campaign.toIcon();

// With custom size and color
DomainType.campaign.toIcon(size: 24, color: Colors.blue);
```

### Access Visual Configuration

```dart
// Get full visual configuration
final visuals = DomainType.adventure.visuals;
print(visuals.icon);
print(visuals.color);
print(visuals.semanticLabel);

// Or use individual getters
IconData icon = DomainType.scene.icon;
Color? color = DomainType.scene.color;
String? label = DomainType.scene.semanticLabel;
```

### Working with Entity Kinds

Entity kinds from the database can be converted to domain types:

```dart
// Convert entity kind string to icon
IconData npcIcon = DomainVisuals.getEntityKindIcon('npc');
IconData placeIcon = DomainVisuals.getEntityKindIcon('place');

// Convert to DomainType enum first (for more control)
DomainType type = DomainVisuals.entityKindToDomainType('monster');
Icon(type.icon);
```

### Static Access

For cases where you need static access:

```dart
IconData icon = DomainVisuals.getIcon(DomainType.party);
Color? color = DomainVisuals.getColor(DomainType.party);
String? label = DomainVisuals.getSemanticLabel(DomainType.party);
```

## Adding New Domain Types

To add a new domain type:

1. Add the enum value to `DomainType` in `lib/core/models/domain_type.dart`
2. Add the visual configuration to the `_visuals` map in `domain_visuals.dart`
3. If it's an entity kind, update `entityKindToDomainType` method

Example:

```dart
// In domain_type.dart
enum DomainType {
  // ... existing types
  quest,  // Add new type
}

// In domain_visuals.dart
static const Map<DomainType, DomainVisualConfig> _visuals = {
  // ... existing configs
  DomainType.quest: DomainVisualConfig(
    icon: Icons.flag_outlined,
    color: Colors.amber,  // Optional
    semanticLabel: 'Quest',
  ),
};
```

## Available Domain Types

### Campaign Structure
- `campaign` - Top-level campaign container
- `chapter` - Major section within a campaign
- `adventure` - Specific quest or story arc
- `scene` - Specific encounter or moment

### Gameplay
- `session` - Playing session with notes
- `party` - Group of player characters
- `encounter` - Combat or challenge scenario
- `player` - Player character
- `combatant` - Encounter participant

### Content
- `mediaAsset` - Images, audio, etc.

### Entity Types
- `entityNpc` - Non-Player Character
- `entityMonster` - Monster
- `entityGroup` - Faction, organization
- `entityPlace` - Location, building
- `entityItem` - Weapon, artifact
- `entityHandout` - Document, letter
- `entityJournal` - Lore, notes
- `entityGeneric` - Unknown entity type

## Design Principles

1. **Type Safety**: Use enums instead of strings for compile-time checking
2. **Consistency**: One icon/color per domain type across the entire app
3. **Extensibility**: Easy to add new types without modifying existing code
4. **Accessibility**: Semantic labels for screen readers
5. **Performance**: Const values for zero runtime overhead
6. **Optional Colors**: Colors can be null to allow theme-based coloring

## Integration Examples

### In a List Tile

```dart
ListTile(
  leading: DomainType.campaign.toIcon(),
  title: Text(campaign.name),
  trailing: Icon(Icons.chevron_right),
)
```

### In a Card Header

```dart
Row(
  children: [
    Icon(DomainType.chapter.icon),
    SizedBox(width: 8),
    Text(chapter.name),
  ],
)
```

### With Theme Colors

```dart
Icon(
  DomainType.adventure.icon,
  color: Theme.of(context).colorScheme.primary,
)
```

### Dynamic Entity Icons

```dart
// For an entity with a 'kind' field
Widget buildEntityIcon(Entity entity) {
  final domainType = DomainVisuals.entityKindToDomainType(entity.kind);
  return Icon(domainType.icon);
}
```

## Benefits

- **No Magic Strings**: Type-safe access prevents typos
- **Easy Refactoring**: Change an icon in one place, updates everywhere
- **Consistent UX**: Same visual language throughout the app
- **Quick Discovery**: IDE autocomplete shows all available types
- **Low Maintenance**: Adding new types is straightforward
- **Zero Runtime Cost**: All values are compile-time constants
