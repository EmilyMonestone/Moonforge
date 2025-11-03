# Entities Feature - Missing Implementations

## Overview

Entities represent NPCs, locations, items, organizations, and other campaign elements. They are the building blocks of campaign content with rich metadata and relationships.

## Current Implementation

### ✅ Implemented

**Views** (2 files)
- `entity_screen.dart` - Entity detail view
- `entity_edit_screen.dart` - Create/edit entity

**Utils** (5 files)
- `create_entity.dart`
- `create_entity_in_chapter.dart`
- `create_entity_in_adventure.dart`
- `create_entity_in_scene.dart`
- `create_entity_in_encounter.dart`

**Routes**
- `EntityRoute` - `/campaign/entity/:entityId`
- `EntityEditRoute` - `/campaign/entity/:entityId/edit`

**Data Layer**
- `Entities` table (comprehensive schema)
- `EntityDao`
- `EntityRepository`

**Core Widgets**
- `entities_widget.dart` - Display entity list
- `entity_widgets_wrappers.dart` - Entity UI helpers

## ❌ Missing Components

### Controllers (0/2)

**Missing:**
1. `entity_provider.dart` - Current entity state management
2. `entity_list_controller.dart` - Entity browser state, filters, search

**Impact**: High - No centralized entity state

### Services (0/4)

**Missing:**
1. `entity_service.dart` - Entity operations, relationships
2. `entity_search_service.dart` - Full-text search, filtering
3. `entity_relationship_service.dart` - Manage entity connections
4. `entity_import_service.dart` - Import from various sources

**Impact**: High - Complex entity logic in UI code

### Widgets (Partial: 2/15+)

**Existing:**
- ✅ `entities_widget.dart` (in core/widgets)
- ✅ `entity_widgets_wrappers.dart` (in core/widgets)

**Missing:**
1. `entity_card.dart` - Entity display in lists
2. `entity_list.dart` - Comprehensive entity list
3. `entity_type_icon.dart` - Visual entity type indicator
4. `entity_tag_chips.dart` - Tag display and management
5. `entity_stat_block.dart` - Display creature/NPC stats
6. `entity_relationship_graph.dart` - Visual entity connections
7. `entity_location_map.dart` - Location hierarchy visualization
8. `entity_organization_chart.dart` - Organization structure
9. `entity_quick_view.dart` - Hover preview card
10. `entity_filter_panel.dart` - Advanced filtering UI
11. `entity_search_bar.dart` - Entity search widget
12. `entity_image_gallery.dart` - Entity images display
13. `entity_notes_widget.dart` - Entity notes section
14. `entity_references_list.dart` - Where entity is used
15. `entity_creation_wizard.dart` - Step-by-step entity creation

**Impact**: High - Entity UI is complex and needs componentization

### Utils (Missing: 5+)

**Existing:**
- ✅ Multiple create_entity utilities

**Missing:**
1. `entity_validators.dart` - Validate entity data
2. `entity_formatters.dart` - Format entity display
3. `entity_filters.dart` - Filter logic
4. `entity_sorting.dart` - Sort utilities
5. `entity_export.dart` - Export entities
6. `entity_templates.dart` - Entity templates by type

**Impact**: Medium

### Views (Missing: 4+)

**Missing:**
1. `entity_list_screen.dart` - Browse all entities
2. `entity_library_screen.dart` - Organized entity browser by type
3. `entity_relationship_screen.dart` - Visual relationship management
4. `entity_import_screen.dart` - Import entities from sources

**Impact**: High - No way to browse entities comprehensively

### Routes (Missing: 3)

**Missing:**
- `/campaign/entities` - Browse all entities
- `/campaign/entities/library` - Entity library organized by type
- `/campaign/entities/relationships` - Relationship visualization

**Impact**: High

## 🚧 Incomplete Features

### Entity Types Not Fully Supported

The Entities table has a `kind` field, but UI may not fully support all types:
- ✅ NPC/Creature - Likely supported
- ❓ Location - Partial support (placeType field exists)
- ❓ Item - Unknown support level
- ❓ Organization - Has members field but UI unclear
- ❓ Event - Not clear if supported
- ❓ Faction - Related to organization

### Entity Features Missing

1. **Stat Blocks** - statblock field exists but display may be incomplete
2. **Location Hierarchy** - parentPlaceId exists but no visualization
3. **Organization Members** - members field exists but no management UI
4. **Entity Images** - images field exists but gallery UI missing
5. **Entity Relationships** - No explicit relationship management
6. **Entity Templates** - No template system
7. **Entity Tags** - tags field exists but tag management UI minimal
8. **Entity Search** - No advanced search UI
9. **Entity Linking** - Mentions in quill content but needs enhancement

### Entity Screen Enhancements

**Missing:**
- Tabbed interface (Overview, Stats, Relationships, History)
- Image gallery
- Related entities section
- Usage locations (where entity appears)
- Edit history
- Export options
- Print-friendly view

### Entity Edit Screen Enhancements

**Missing:**
- Type-specific forms (different for NPC vs Location vs Item)
- Stat block editor (D&D 5e format)
- Image upload and management
- Tag selector with autocomplete
- Relationship builder
- Template selection
- Import from SRD/bestiary

## Implementation Priority

### High Priority

1. **Entity List Screen & Route** - Essential for entity management
2. **Entity Widgets Library** - Componentize UI
3. **Entity Provider** - State management
4. **Entity Service** - Business logic layer

### Medium Priority

5. **Entity Type-Specific UI** - Different forms/displays per type
6. **Entity Relationship Management** - Connect entities
7. **Entity Search & Filter** - Advanced browsing
8. **Entity Templates** - Quick entity creation

### Low Priority

9. **Entity Import** - Import from external sources
10. **Relationship Visualization** - Graph view
11. **Organization Charts** - Hierarchy visualization

## Integration Points

### Dependencies

- **Campaigns** - Entities belong to campaigns
- **Chapters/Adventures/Scenes** - Entity context
- **Encounters** - Entities in combatants
- **Quill Mentions** - Entity linking in content
- **Bestiary Service** - Import creature stats
- **Media** - Entity images

### Required Changes

1. **Router** - Add entity list and library routes
2. **Menu Registry** - Enhanced entity actions
3. **Quill Editor** - Better entity mention integration
4. **Search** - Global entity search

## Testing Needs

- Unit tests for entity service
- Widget tests for entity components
- Integration tests for entity CRUD
- Relationship management tests
- Search functionality tests

## Documentation

**Existing:**
- ✅ `docs/features/entities.md` - Feature overview

**Missing:**
- Feature README in lib/features/entities/
- Entity type specifications
- Relationship model documentation
- API documentation

## Next Steps

1. Create entity list screen and routes
2. Build entity provider for state management
3. Implement entity service layer
4. Create entity widget library
5. Add type-specific entity forms
6. Implement entity relationship management
7. Add advanced search and filtering
8. Build entity templates system
9. Add comprehensive tests
10. Write feature documentation

---

**Status**: Partial Implementation (30% complete)
**Last Updated**: 2025-11-03
