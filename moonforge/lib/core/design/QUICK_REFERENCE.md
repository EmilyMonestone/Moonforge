# Domain Visuals Quick Reference Card

## Import Statements
```dart
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';
```

## Quick Access Patterns

### Get Icon (IconData)
```dart
DomainType.campaign.icon                    // Extension method
DomainVisuals.getIcon(DomainType.campaign)  // Static method
```

### Create Icon Widget
```dart
Icon(DomainType.campaign.icon)              // Manual creation
DomainType.campaign.toIcon()                // Extension method
DomainType.campaign.toIcon(size: 24, color: Colors.blue)  // With params
```

### Get Color (Color?)
```dart
DomainType.campaign.color                   // Extension method
DomainVisuals.getColor(DomainType.campaign) // Static method
```

### Get Full Config
```dart
DomainType.campaign.visuals                 // Returns DomainVisualConfig
```

### Entity Kind Conversion
```dart
DomainVisuals.getEntityKindIcon('npc')      // String → IconData
DomainVisuals.entityKindToDomainType('npc') // String → DomainType
EntityFormatters.getKindIcon(entity.kind)   // Helper method
```

## All Domain Types

| Type | Icon | Description |
|------|------|-------------|
| `DomainType.campaign` | 📖 book_outlined | Top-level campaign |
| `DomainType.chapter` | 📘 menu_book_outlined | Chapter in campaign |
| `DomainType.adventure` | 📚 auto_stories_outlined | Adventure/quest |
| `DomainType.scene` | 🎭 theaters_outlined | Scene/encounter moment |
| `DomainType.session` | 📅 event_note_outlined | Gaming session |
| `DomainType.party` | 👥 group_outlined | Party of PCs |
| `DomainType.encounter` | ⚖️ gavel_outlined | Combat encounter |
| `DomainType.player` | 👤 person_outlined | Player character |
| `DomainType.combatant` | 🛡️ shield_outlined | Combatant in encounter |
| `DomainType.mediaAsset` | 🖼️ image_outlined | Media file |
| `DomainType.entityNpc` | 😊 face_outlined | NPC entity |
| `DomainType.entityMonster` | 🐛 bug_report_outlined | Monster entity |
| `DomainType.entityGroup` | 👥👥 groups_outlined | Group/faction entity |
| `DomainType.entityPlace` | 📍 place_outlined | Place/location entity |
| `DomainType.entityItem` | 📦 inventory_2_outlined | Item entity |
| `DomainType.entityHandout` | 📄 description_outlined | Handout entity |
| `DomainType.entityJournal` | 📖 book_outlined | Journal entry entity |
| `DomainType.entityGeneric` | 📝 note_outlined | Generic/unknown entity |

## Common UI Patterns

### ListTile
```dart
ListTile(
  leading: DomainType.chapter.toIcon(),
  title: Text('Chapter 1'),
  trailing: Icon(Icons.chevron_right),
)
```

### Card Header
```dart
Row(
  children: [
    Icon(DomainType.adventure.icon, color: theme.colorScheme.primary),
    SizedBox(width: 8),
    Text('Adventure Title', style: theme.textTheme.titleLarge),
  ],
)
```

### Chip/Badge
```dart
Chip(
  avatar: Icon(DomainType.scene.icon, size: 16),
  label: Text('5 scenes'),
)
```

### IconButton
```dart
IconButton(
  icon: DomainType.campaign.toIcon(),
  onPressed: () => navigateToCampaign(),
)
```

### Card Leading
```dart
Card(
  child: ListTile(
    leading: CircleAvatar(
      child: Icon(DomainType.encounter.icon),
    ),
    title: Text('Boss Battle'),
  ),
)
```

## Entity Kind Strings

| Kind String | DomainType | Icon |
|-------------|------------|------|
| `'npc'` | `entityNpc` | face_outlined |
| `'monster'` | `entityMonster` | bug_report_outlined |
| `'group'` | `entityGroup` | groups_outlined |
| `'place'` | `entityPlace` | place_outlined |
| `'item'` | `entityItem` | inventory_2_outlined |
| `'handout'` | `entityHandout` | description_outlined |
| `'journal'` | `entityJournal` | book_outlined |
| `'unknown'` | `entityGeneric` | note_outlined |

## Property Access

```dart
final config = DomainType.campaign.visuals;

config.icon            // IconData
config.color           // Color? (optional)
config.semanticLabel   // String? (for accessibility)
```

## Helper Methods in EntityFormatters

```dart
// For entities with a 'kind' field
final icon = EntityFormatters.getKindIcon(entity.kind);
final color = EntityFormatters.getKindColor(entity.kind);
```

## Migration Pattern

```dart
// Before
Icon(Icons.book_outlined)
Icon(Icons.menu_book_outlined)
Icon(Icons.auto_stories_outlined)

// After
Icon(DomainType.campaign.icon)
Icon(DomainType.chapter.icon)
Icon(DomainType.adventure.icon)
```

## Adding New Domain Types

1. Add to `DomainType` enum in `domain_type.dart`:
   ```dart
   enum DomainType {
     // ... existing types
     myNewType,
   }
   ```

2. Add to `_visuals` map in `domain_visuals.dart`:
   ```dart
   DomainType.myNewType: DomainVisualConfig(
     icon: Icons.my_icon_outlined,
     color: Colors.blue,  // Optional
     semanticLabel: 'My New Type',
   ),
   ```

3. Done! Available everywhere automatically.

## Documentation Links

- **Full Guide:** `lib/core/design/README.md`
- **Migration:** `lib/core/design/MIGRATION_GUIDE.md`
- **Architecture:** `lib/core/design/ARCHITECTURE.md`
- **Summary:** `lib/core/design/IMPLEMENTATION_SUMMARY.md`
- **Example Widget:** `lib/core/widgets/domain_visuals_example.dart`
- **Tests:** `test/core/design/domain_visuals_test.dart`

## Notes

- All values are compile-time constants (zero runtime cost)
- Type-safe: enum prevents typos
- Consistent: one icon per domain type
- Extensible: easy to add new types
- Accessible: semantic labels included
- Optional colors: can be null for theme-based coloring

---
**Version:** 1.0 | **Updated:** 2025-11-12
