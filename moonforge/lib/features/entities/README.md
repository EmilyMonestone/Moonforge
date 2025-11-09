# Entities Feature

This feature provides comprehensive entity management for campaigns including NPCs, monsters, places, items, organizations, and more.

## Overview

The Entities feature allows users to create, view, browse, filter, and manage campaign entities with rich metadata and relationships.

## Components

### Controllers

#### `entity_provider.dart`
State management for the current entity being viewed or edited.
- Load entity by ID
- Set/clear current entity
- Update current entity

#### `entity_list_controller.dart`
State management for entity browsing with filters and search.
- Load all entities
- Search entities by name or summary
- Filter by kind (NPC, monster, place, etc.)
- Filter by tags
- Sort by name, kind, created date, or updated date
- Get unique tags and kinds from entities

### Services

#### `entity_service.dart`
Business logic for entity operations.
- Create new entities with full metadata
- Update existing entities
- Delete entities (soft delete)
- Duplicate entities
- Move entities between origins
- Tag management (add/remove)
- Member management for groups/organizations

### Views

#### `entity_list_screen.dart`
Browse all entities in the campaign with advanced filtering.
- Search bar for quick filtering
- Kind filter dropdown
- Tag filter chips
- Entity cards with kind, summary, and tags
- Click to view entity details
- Create new entity button

#### `entity_screen.dart` (existing)
View entity details.

#### `entity_edit_screen.dart` (existing)
Create or edit an entity.

### Widgets

#### `entity_card.dart`
Reusable card widget for displaying entities in lists.
- Shows entity name, kind, summary
- Displays first 5 tags
- Customizable tap and long-press handlers
- Optional trailing widget

#### `entity_type_icon.dart`
Icon representation for entity kinds.
- Kind-specific icons (person, pets, groups, place, etc.)
- Color-coded by kind category
- Helper functions for getting icons, colors, and labels

### Utils

#### `entity_validators.dart`
Validation logic for entity data.
- Validate entity name (required, max 100 chars)
- Validate entity kind (must be valid type)
- Validate summary (max 500 chars)
- Validate tags (alphanumeric, max 50 chars)
- Validate place type
- Check required fields by kind

#### `entity_formatters.dart`
Formatting utilities for entity display.
- Format kind as human-readable label
- Format summary with ellipsis
- Format tags as comma-separated string
- Format dates (relative: "2h ago", "5d ago", etc.)
- Format coordinates
- Format place info with parent
- Format member counts

#### `entity_filters.dart`
Filter utilities for entity lists.
- Filter by kind, tag(s), search query, origin
- Filter by date ranges (created/updated after)
- Filter NPCs/monsters, places, items, groups
- Filter by presence of images or stat blocks
- Complex multi-criteria filtering

#### `entity_sorting.dart`
Sorting utilities for entity lists.
- Sort by name (asc/desc)
- Sort by kind (asc/desc)
- Sort by created/updated date (asc/desc)
- Sort by tag count (asc/desc)
- Generic sort function
- Multi-field sorting

### Routes

- `/campaign/entities` - Browse all entities (EntitiesListRoute)
- `/campaign/entity/:entityId` - View entity details (EntityRoute)
- `/campaign/entity/:entityId/edit` - Edit entity (EntityEditRoute)

### Menu Actions

- **Browse Entities** - Navigate to entity list screen from campaign menu
- **Create Entity** - Create new entity (existing, context-aware)

## Entity Types

The system supports the following entity kinds:

- **NPC** - Non-player characters
- **Monster** - Creatures from bestiary
- **Group** - Organizations, factions (with members)
- **Place** - Locations, buildings (with place type and parent)
- **Item** - Equipment, magic items
- **Handout** - Player handouts
- **Journal** - Journal entries

## Data Model

Entities are stored in the `Entities` table with the following fields:

- `id` - Unique identifier
- `kind` - Entity type (npc, monster, group, place, item, handout, journal)
- `name` - Entity name
- `originId` - Parent context (campaign/chapter/adventure/scene)
- `summary` - Short description
- `tags` - List of tags for categorization
- `statblock` - Stat block data for NPCs/monsters
- `placeType` - Type of place (for places)
- `parentPlaceId` - Parent location (for places)
- `coords` - Geographic coordinates
- `content` - Rich text content (Quill format)
- `images` - List of image references
- `members` - List of member IDs (for groups)
- `createdAt` - Creation timestamp
- `updatedAt` - Last update timestamp
- `rev` - Revision number for sync
- `deleted` - Soft delete flag

## Usage

### Creating an Entity

```dart
final service = EntityService(repository);
final entity = await service.createEntity(
  name: 'Aria the Merchant',
  kind: 'npc',
  originId: campaignId,
  summary: 'A friendly merchant in the town square',
  tags: ['merchant', 'ally', 'questgiver'],
);
```

### Browsing Entities

```dart
// Navigate to entity list
const EntitiesListRoute().go(context);

// Or from menu
// Click "Browse Entities" in campaign menu
```

### Filtering Entities

```dart
final controller = EntityListController(repository);
await controller.loadEntities();

// Search
controller.setSearchQuery('merchant');

// Filter by kind
controller.setKindFilter('npc');

// Filter by tags
controller.toggleTagFilter('ally');

// Clear filters
controller.clearFilters();
```

### Using Widgets

```dart
// Display entity card
EntityCard(
  entity: entity,
  onTap: () {
    EntityRoute(entityId: entity.id).push(context);
  },
);

// Show entity type icon
EntityTypeIcon(
  kind: entity.kind,
  size: 24,
);
```

## Localization

All user-facing strings are internationalized in:
- `lib/l10n/app_en.arb` - English
- `lib/l10n/app_de.arb` - German

New strings added:
- `search` - Search
- `filterByKind` - Filter by Kind
- `allKinds` - All Kinds
- `clearFilters` - Clear Filters
- `noEntitiesMatchingFilters` - No entities matching filters
- `browseEntities` - Browse Entities
- `browseAllEntities` - Browse all entities in the campaign

## Architecture

The entity feature follows the project's architectural patterns:

1. **Data Layer** - `EntityRepository` and `EntityDao` for database operations
2. **Service Layer** - `EntityService` for business logic
3. **Controller Layer** - `EntityProvider` and `EntityListController` for state management
4. **View Layer** - Screens and widgets for UI
5. **Utils Layer** - Validators, formatters, filters, and sorting utilities

## Testing

To test the entity feature:

1. Create a campaign
2. Navigate to `/campaign/entities` or click "Browse Entities" in the menu
3. Create entities of different kinds
4. Test search functionality
5. Test filtering by kind and tags
6. Test sorting options
7. Click on entities to view details
8. Edit and delete entities

## Future Enhancements

Potential improvements identified in `docs/missing/entities.md`:

- Entity relationship management
- Visual relationship graphs
- Entity templates by type
- Advanced search with full-text
- Import entities from external sources
- Type-specific forms (different UI for NPC vs Place vs Item)
- Stat block editor for D&D 5e format
- Organization chart visualization
- Location hierarchy visualization
- Image gallery for entities
- Export entities

## Related Documentation

- `docs/missing/entities.md` - Missing features analysis
- `docs/features/entities.md` - Entity feature overview
- Entity table schema in `lib/data/db/tables.dart`
- Entity DAO in `lib/data/db/daos/entity_dao.dart`
- Entity repository in `lib/data/repo/entity_repository.dart`
