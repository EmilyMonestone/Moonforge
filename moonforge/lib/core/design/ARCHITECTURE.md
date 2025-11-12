# Domain Visuals System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        Application Code                              │
│  (Widgets, Screens, Components throughout the app)                  │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Uses
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                   DomainType Extension Methods                       │
│                                                                      │
│  • DomainType.campaign.icon          → IconData                     │
│  • DomainType.chapter.toIcon()       → Widget                       │
│  • DomainType.scene.color            → Color?                       │
│  • DomainType.adventure.visuals      → DomainVisualConfig           │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Extends
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                          DomainType Enum                             │
│                                                                      │
│  • campaign              • session           • entityNpc             │
│  • chapter               • party             • entityMonster         │
│  • adventure             • encounter         • entityPlace           │
│  • scene                 • player            • entityItem            │
│  • ... (18 types total)                                             │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Mapped by
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      DomainVisuals Registry                          │
│                                                                      │
│  Static Methods:                                                    │
│  • getConfig(type)           → DomainVisualConfig                   │
│  • getIcon(type)             → IconData                             │
│  • getColor(type)            → Color?                               │
│  • entityKindToDomainType()  → DomainType                           │
│  • getEntityKindIcon(kind)   → IconData                             │
│                                                                      │
│  Internal Map:                                                      │
│  Map<DomainType, DomainVisualConfig> _visuals                       │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ Contains
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      DomainVisualConfig                              │
│                                                                      │
│  Properties:                                                        │
│  • IconData icon              (required)                            │
│  • Color? color               (optional)                            │
│  • String? semanticLabel      (optional)                            │
└─────────────────────────────────────────────────────────────────────┘
```

## Usage Flow Diagrams

### Direct Usage Pattern
```
Widget
  └─> Icon(DomainType.campaign.icon)
        └─> DomainType enum
              └─> Extension method: icon
                    └─> DomainVisuals.getIcon()
                          └─> _visuals map lookup
                                └─> Returns: Icons.book_outlined
```

### Entity Kind Pattern
```
Entity (kind: "npc")
  └─> DomainVisuals.getEntityKindIcon("npc")
        └─> entityKindToDomainType("npc")
              └─> Returns: DomainType.entityNpc
                    └─> getIcon(DomainType.entityNpc)
                          └─> Returns: Icons.face_outlined
```

### Helper Method Pattern
```
Entity
  └─> EntityFormatters.getKindIcon(entity.kind)
        └─> DomainVisuals.getEntityKindIcon(kind)
              └─> [follows Entity Kind Pattern above]
```

## Data Flow

```
Compile Time:
┌──────────────────┐
│  Domain Types    │  → Enum values defined
│  Visual Configs  │  → Const map created
└──────────────────┘

Runtime:
┌──────────────────┐
│  Widget Build    │
└──────────────────┘
         ↓
┌──────────────────┐
│  Access Pattern  │  → DomainType.campaign.icon
└──────────────────┘
         ↓
┌──────────────────┐
│  Extension Call  │  → Extension getter invoked
└──────────────────┘
         ↓
┌──────────────────┐
│  Map Lookup      │  → _visuals[DomainType.campaign]
└──────────────────┘
         ↓
┌──────────────────┐
│  Return Icon     │  → Icons.book_outlined
└──────────────────┘
```

## Integration Points

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Moonforge App                                │
└─────────────────────────────────────────────────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ▼                           ▼                           ▼
┌───────────────┐           ┌───────────────┐         ┌───────────────┐
│   Campaigns   │           │   Chapters    │         │   Adventures  │
│   Feature     │           │   Feature     │         │   Feature     │
└───────────────┘           └───────────────┘         └───────────────┘
        │                           │                           │
        └───────────────────────────┼───────────────────────────┘
                                    │
                                    │ All import and use:
                                    ▼
                    ┌──────────────────────────────┐
                    │   DomainVisuals System       │
                    │   • domain_type.dart         │
                    │   • domain_visuals.dart      │
                    └──────────────────────────────┘
                                    │
                                    │ Provides consistent:
                                    ▼
                    ┌──────────────────────────────┐
                    │   Icons & Colors             │
                    │   for all domain types       │
                    └──────────────────────────────┘
```

## File Dependencies

```
domain_visuals.dart
  ├─> Imports: flutter/material.dart
  └─> Imports: domain_type.dart

domain_type.dart
  └─> No imports (pure enum)

domain_visuals_example.dart (example)
  ├─> Imports: flutter/material.dart
  ├─> Imports: domain_visuals.dart
  └─> Imports: domain_type.dart

campaign_card.dart (usage example)
  ├─> Imports: flutter/material.dart
  ├─> Imports: domain_visuals.dart
  ├─> Imports: domain_type.dart
  └─> Imports: app_db.dart

entity_formatters.dart (helper)
  ├─> Imports: flutter/material.dart
  ├─> Imports: domain_visuals.dart
  └─> Imports: app_db.dart
```

## Type Hierarchy

```
Object
  └─> Enum
        └─> DomainType
              ├─> campaign
              ├─> chapter
              ├─> adventure
              ├─> scene
              ├─> session
              ├─> party
              ├─> encounter
              ├─> player
              ├─> combatant
              ├─> mediaAsset
              ├─> entityNpc
              ├─> entityMonster
              ├─> entityGroup
              ├─> entityPlace
              ├─> entityItem
              ├─> entityHandout
              ├─> entityJournal
              └─> entityGeneric
```

## Extension Architecture

```
extension DomainTypeVisuals on DomainType
  ├─> get visuals: DomainVisualConfig
  ├─> get icon: IconData
  ├─> get color: Color?
  ├─> get semanticLabel: String?
  └─> toIcon({size, color}): Widget
```

## Registry Pattern

```
DomainVisuals (static class)
  ├─> Private: _visuals: Map<DomainType, DomainVisualConfig>
  ├─> Public: getConfig(type)
  ├─> Public: getIcon(type)
  ├─> Public: getColor(type)
  ├─> Public: getSemanticLabel(type)
  ├─> Public: entityKindToDomainType(kind)
  ├─> Public: getEntityKindIcon(kind)
  └─> Public: getEntityKindColor(kind)
```

## Access Patterns Comparison

```
┌─────────────────────────┬──────────────────────────────────────┐
│  Access Pattern         │  Use Case                             │
├─────────────────────────┼──────────────────────────────────────┤
│ type.icon               │ Quick, inline icon access            │
│ type.toIcon()           │ Direct widget creation               │
│ type.visuals            │ Access full config                   │
│ DomainVisuals.getIcon() │ Static context / utility functions   │
│ EntityFormatters...     │ Entity-specific convenience          │
└─────────────────────────┴──────────────────────────────────────┘
```
