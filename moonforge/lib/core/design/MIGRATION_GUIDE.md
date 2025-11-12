# Migration Guide: Adopting Domain Visuals System

This guide helps developers transition existing code to use the centralized domain visuals system.

## Quick Reference

### Before (Old Way)
```dart
Icon(Icons.book_outlined)  // Campaign icon
Icon(Icons.menu_book_outlined)  // Chapter icon
Icon(Icons.auto_stories_outlined)  // Adventure icon
Icon(Icons.theaters_outlined)  // Scene icon
Icon(Icons.face_outlined)  // NPC icon
```

### After (New Way)
```dart
Icon(DomainType.campaign.icon)
Icon(DomainType.chapter.icon)
Icon(DomainType.adventure.icon)
Icon(DomainType.scene.icon)
Icon(DomainType.entityNpc.icon)

// Or even simpler:
DomainType.campaign.toIcon()
```

## Step-by-Step Migration

### 1. Add Imports

Add these imports to files that will use domain visuals:

```dart
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';
```

### 2. Replace Icon References

#### For Campaign Icons

```dart
// Before
Icon(Icons.book_outlined)

// After
Icon(DomainType.campaign.icon)
// or
DomainType.campaign.toIcon()
```

#### For Chapter Icons

```dart
// Before
Icon(Icons.menu_book_outlined)

// After
Icon(DomainType.chapter.icon)
// or
DomainType.chapter.toIcon()
```

#### For Adventure Icons

```dart
// Before
Icon(Icons.auto_stories_outlined)

// After
Icon(DomainType.adventure.icon)
```

#### For Scene Icons

```dart
// Before
Icon(Icons.theaters_outlined)

// After
Icon(DomainType.scene.icon)
```

#### For Party/Group Icons

```dart
// Before
Icon(Icons.group_outlined)

// After  
Icon(DomainType.party.icon)
```

#### For Session Icons

```dart
// Before
Icon(Icons.event_note_outlined)  // or similar

// After
Icon(DomainType.session.icon)
```

#### For Encounter Icons

```dart
// Before
Icon(Icons.gavel_outlined)  // or similar

// After
Icon(DomainType.encounter.icon)
```

### 3. Migrate Entity Kind Icons

For entity-related icons that depend on the entity's `kind` field:

```dart
// Before
IconData getEntityIcon(String kind) {
  switch (kind) {
    case 'npc':
      return Icons.face_outlined;
    case 'monster':
      return Icons.bug_report_outlined;
    case 'place':
      return Icons.place_outlined;
    // ... more cases
    default:
      return Icons.note_outlined;
  }
}

// After
IconData getEntityIcon(String kind) {
  return DomainVisuals.getEntityKindIcon(kind);
}

// Or even simpler - use EntityFormatters helper
import 'package:moonforge/features/entities/utils/entity_formatters.dart';

IconData icon = EntityFormatters.getKindIcon(entity.kind);
```

### 4. Update StatChips and Similar Widgets

```dart
// Before
_StatChip(
  icon: Icons.book_outlined,
  label: '${campaign.entityIds.length} entities',
)

// After
_StatChip(
  icon: DomainType.entityGeneric.icon,
  label: '${campaign.entityIds.length} entities',
)
```

### 5. Handle Dynamic Icons with Colors

```dart
// Before
Icon(
  Icons.book_outlined,
  color: theme.colorScheme.primary,
  size: 24,
)

// After
DomainType.campaign.toIcon(
  color: theme.colorScheme.primary,
  size: 24,
)
```

## Common Patterns

### Pattern 1: List Tiles

```dart
// Before
ListTile(
  leading: Icon(Icons.book_outlined),
  title: Text(campaign.name),
)

// After
ListTile(
  leading: DomainType.campaign.toIcon(),
  title: Text(campaign.name),
)
```

### Pattern 2: Cards with Headers

```dart
// Before
Row(
  children: [
    Icon(Icons.menu_book_outlined),
    SizedBox(width: 8),
    Text('Chapter Title'),
  ],
)

// After
Row(
  children: [
    Icon(DomainType.chapter.icon),
    SizedBox(width: 8),
    Text('Chapter Title'),
  ],
)
```

### Pattern 3: Chips/Badges

```dart
// Before
Chip(
  avatar: Icon(Icons.theaters_outlined, size: 16),
  label: Text('5 scenes'),
)

// After
Chip(
  avatar: Icon(DomainType.scene.icon, size: 16),
  label: Text('5 scenes'),
)
```

### Pattern 4: Navigation Icons

```dart
// Before
IconData getNavigationIcon(String route) {
  if (route.contains('campaign')) return Icons.book_outlined;
  if (route.contains('chapter')) return Icons.menu_book_outlined;
  // ...
}

// After
IconData getNavigationIcon(String route) {
  if (route.contains('campaign')) return DomainType.campaign.icon;
  if (route.contains('chapter')) return DomainType.chapter.icon;
  // ...
}
```

## Files to Migrate

Priority files that could benefit from migration:

### High Priority
- ✅ `lib/features/campaign/widgets/campaign_card.dart` - **DONE**
- ✅ `lib/features/chapter/widgets/chapter_card.dart` - **DONE**
- ✅ `lib/features/chapter/widgets/chapter_stats_widget.dart` - **DONE**
- ✅ `lib/features/entities/utils/entity_formatters.dart` - **DONE**
- `lib/features/adventure/widgets/adventure_card.dart`
- `lib/features/scene/widgets/scene_card.dart` (if exists)
- `lib/features/entities/widgets/entity_card.dart` (if exists)

### Medium Priority
- `lib/core/repositories/menu_registry.dart` - Menu action icons
- `lib/features/*/views/*_screen.dart` - Screen-level icons
- Navigation rail/drawer icons
- Dashboard/home screen icons

### Low Priority
- One-off icons in dialogs
- Error/status icons
- Action button icons (edit, delete, etc.)

## Benefits of Migration

1. **Type Safety**: Compile-time checking prevents typos
2. **Consistency**: Icons automatically stay consistent
3. **Easy Changes**: Update one place to change everywhere
4. **Discoverability**: IDE autocomplete shows all types
5. **Accessibility**: Built-in semantic labels
6. **Future-Proof**: Easy to add custom icons/colors later

## Backward Compatibility

The old icon references (e.g., `Icons.book_outlined`) will continue to work. Migration is **optional but recommended** for:

- New code
- Code being actively modified
- Code with multiple icon references
- Code dealing with domain entities

No rush to migrate everything at once. Gradual adoption is perfectly fine!

## Need Help?

See the main README in `lib/core/design/README.md` for more examples and usage patterns.
