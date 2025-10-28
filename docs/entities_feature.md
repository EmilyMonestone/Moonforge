# Entities Feature Implementation

This document describes the entities feature implementation for Moonforge.

## Overview

The entities feature adds the ability to associate entities (NPCs, monsters, groups, places, items, etc.) with campaigns, chapters, adventures, scenes, and encounters. It includes a reusable widget that displays all entities related to a specific part, including entities from child parts.

## Features

### Model Changes

Added `entityIds` field (List<String>) to the following models:
- Campaign
- Chapter
- Adventure
- Scene
- Encounter

This field stores the IDs of entities directly related to each part.

### Entity Gathering

The `EntityGatherer` service (`lib/core/services/entity_gatherer.dart`) recursively gathers entities from:
- The current part (direct entities)
- All child parts (with origin tracking)

For example:
- Campaign: entities from campaign + all chapters + all adventures + all scenes + all encounters
- Chapter: entities from chapter + all adventures under it + all scenes under those adventures
- Adventure: entities from adventure + all scenes under it
- Scene: entities from scene only
- Encounter: entities from encounter only

### Entity Display

The `EntitiesWidget` (`lib/core/widgets/entities_widget.dart`) displays entities grouped into three tables:

1. **NPCs, Monsters & Groups**: For kind = 'npc', 'monster', or 'group'
2. **Places**: For kind = 'place'
3. **Items & Others**: For kind = 'item', 'handout', 'journal', or any other kind

Each entity shows:
- Name (clickable link to entity detail)
- Kind (displayed as a colored chip)
- Origin (badge showing where the entity comes from, e.g., "Scene 1.3.2" or "Adventure 2.1")

### Origin Badges

Entities that come from child parts display an origin badge with:
- Label: Human-readable description (e.g., "Scene 1.3.2", "Adventure 2.1")
- Path: Hierarchical position based on order fields

The numbering follows the structure:
- Chapter: "1", "2", "3", etc.
- Adventure: "1.1", "1.2", "2.1", etc. (chapter.adventure)
- Scene: "1.1.1", "1.2.3", etc. (chapter.adventure.scene)

## Setup Instructions

### 1. Generate Freezed/JSON Code

Before running the app, you must generate the necessary code files:

```bash
cd moonforge
dart run build_runner build --delete-conflicting-outputs
```

This will:
- Generate `entity_with_origin.freezed.dart` and `entity_with_origin.g.dart`
- Update existing `.freezed.dart` and `.g.dart` files to include the new `entityIds` field

### 2. Localization

The following localization strings have been added:
- `entities`: "Entities" / "Entitäten"
- `noEntitiesYet`: "No entities yet" / "Noch keine Entitäten"

Run `flutter pub get` to regenerate localization files if needed.

## Usage

### Viewing Entities

The entities widget is automatically displayed on:
- Campaign screen (shows all entities in the entire campaign)
- Chapter screen (shows entities from chapter and all adventures/scenes under it)
- Adventure screen (shows entities from adventure and all scenes under it)
- Scene screen (shows entities from scene only)
- Encounter screen (shows entities from encounter only)

### Adding Entities to Parts

To add entities to a part, you need to:

1. Update the part's `entityIds` list with entity IDs
2. Save the part document to Firestore

Example (updating a scene):

```dart
final scene = await odm.campaigns
    .doc(campaignId)
    .chapters
    .doc(chapterId)
    .adventures
    .doc(adventureId)
    .scenes
    .doc(sceneId)
    .get();

if (scene != null) {
  final updatedScene = scene.copyWith(
    entityIds: [...scene.entityIds, newEntityId],
  );
  
  await odm.campaigns
      .doc(campaignId)
      .chapters
      .doc(chapterId)
      .adventures
      .doc(adventureId)
      .scenes
      .doc(sceneId)
      .set(updatedScene);
}
```

## Architecture

### Key Files

**Models:**
- `lib/core/models/entity_with_origin.dart`: EntityWithOrigin and EntityOrigin models
- `lib/core/models/data/campaign.dart`: Campaign model with entityIds
- `lib/core/models/data/chapter.dart`: Chapter model with entityIds
- `lib/core/models/data/adventure.dart`: Adventure model with entityIds
- `lib/core/models/data/scene.dart`: Scene model with entityIds
- `lib/core/models/data/encounter.dart`: Encounter model with entityIds

**Services:**
- `lib/core/services/entity_gatherer.dart`: EntityGatherer service for gathering entities

**Widgets:**
- `lib/core/widgets/entities_widget.dart`: EntitiesWidget for displaying entities
- `lib/core/widgets/entity_widgets_wrappers.dart`: Wrapper widgets for each screen type

**Screen Integration:**
- `lib/features/campaign/views/campaign_screen.dart`
- `lib/features/chapter/views/chapter_screen.dart`
- `lib/features/adventure/views/adventure_screen.dart`
- `lib/features/scene/views/scene_screen_impl.dart`
- `lib/features/encounters/views/encounter_screen.dart`

### Data Flow

1. Screen renders and requests entities via wrapper widget
2. Wrapper widget calls EntityGatherer service
3. EntityGatherer:
   - Fetches direct entities for the current part
   - Recursively fetches entities from all child parts
   - Attaches origin information to entities from child parts
   - Deduplicates entities (keeping most specific origin)
4. EntitiesWidget receives entities and groups them by kind
5. Tables are rendered with clickable entity names and origin badges

## Future Enhancements

Possible improvements:
- Add/remove entities directly from the widget UI
- Click origin badge to navigate to the source part
- Filter/search entities by name or kind
- Sort entities by name, kind, or origin
- Pagination for large entity lists
- Show entity summaries or images in the table
- Bulk operations (assign multiple entities at once)
- Entity relationship visualization (graph view)
