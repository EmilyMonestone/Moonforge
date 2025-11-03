# Scene Feature - Missing Implementations

## Overview

Scenes are the smallest narrative unit in Moonforge, contained within adventures. They represent specific locations, events, or encounters within an adventure's story.

## Current Implementation

### ✅ Implemented

**Views** (2 files)
- `scene_screen.dart` - Scene detail view
- `scene_edit_screen.dart` - Create/edit scene

**Utils** (1 file)
- `create_scene.dart` - Create new scene

**Routes**
- `SceneRoute` - `/campaign/chapter/:chapterId/adventure/:adventureId/scene/:sceneId`
- `SceneEditRoute` - `/campaign/chapter/:chapterId/adventure/:adventureId/scene/:sceneId/edit`

**Data Layer**
- `Scenes` table
- `SceneDao`
- `SceneRepository`

## ❌ Missing Components

### Controllers (0/1)

**Missing:**
- `scene_provider.dart`
  - Current scene state
  - Scene navigation (prev/next)
  - Scene completion tracking
  - Form state management

**Impact**: High - No state management

### Services (0/3)

**Missing:**
1. `scene_service.dart`
   - Scene operations
   - Scene flow management
   - Scene duration tracking
   - Scene statistics

2. `scene_navigation_service.dart`
   - Navigate between scenes in order
   - Track scene progression
   - Scene history

3. `scene_template_service.dart`
   - Common scene templates
   - Template application
   - Scene generation from templates

**Impact**: Medium

### Widgets (0/10+)

**Missing:**
1. `scene_card.dart` - Display scene in lists
2. `scene_list.dart` - List scenes in adventure
3. `scene_navigation_widget.dart` - Previous/next scene
4. `scene_completion_indicator.dart` - Scene done status
5. `scene_entity_list.dart` - Entities in scene
6. `scene_encounter_widget.dart` - Linked encounters
7. `scene_notes_widget.dart` - DM notes section
8. `scene_player_handout.dart` - Player-facing content
9. `scene_timeline_widget.dart` - Scene duration/pacing
10. `scene_reorder_widget.dart` - Drag-to-reorder scenes

**Impact**: Medium to High

### Utils (Missing: 4)

**Existing:**
- ✅ `create_scene.dart`

**Missing:**
1. `scene_validators.dart` - Validate scene data
2. `scene_ordering.dart` - Scene order utilities
3. `scene_templates.dart` - Scene template utilities
4. `scene_export.dart` - Export scene content

**Impact**: Low to Medium

### Views (Missing: 2)

**Missing:**
1. `scene_list_screen.dart` - Browse all scenes across adventures
2. `scene_templates_screen.dart` - Browse and apply templates

**Impact**: Medium

### Routes (Missing: 2)

**Missing:**
- `/campaign/scenes` - List all scenes globally
- `/scenes/templates` - Scene template library

**Impact**: Low to Medium

## 🚧 Incomplete Features

### Scene Screen Enhancements

**Partially Implemented:**
- Basic scene detail view exists
- Missing features:
  - Scene navigation (previous/next)
  - Linked encounters display
  - Entity list
  - Player handout section
  - Read aloud text formatting
  - Scene completion checkbox
  - Time/duration tracking
  - Scene-specific maps/images

### Scene Edit Screen Enhancements

**Missing:**
- Scene template selection
- Rich formatting for read-aloud text
- Encounter linking
- Entity quick-add
- Scene duration estimation
- Player visibility toggle (DM only vs shared)

### Scene Types/Templates

**Missing:**
- Combat scene template
- Social encounter template
- Exploration template
- Puzzle template
- Rest scene template
- Cutscene template
- Boss fight template

### Scene Features Not Implemented

1. **Scene Flow** - Track which scenes players have completed
2. **Scene Dependencies** - Scenes that unlock other scenes
3. **Branching** - Multiple possible next scenes
4. **Scene Rewards** - XP, loot, story rewards
5. **Scene Conditions** - Prerequisites for scene access
6. **Scene Media** - Associated maps, music, images
7. **Read Aloud Text** - Formatted player descriptions
8. **DM Notes** - Private scene notes
9. **Scene Duration** - Estimated/actual time
10. **Scene Difficulty** - Challenge rating

## Implementation Priority

### High Priority

1. **Scene Navigation Widget** - Essential for running scenes
2. **Scene Provider** - State management
3. **Scene Widgets Library** - UI components
4. **Scene Service** - Business logic

### Medium Priority

5. **Scene Templates** - Quick scene creation
6. **Scene Flow Tracking** - Completion status
7. **Read Aloud Formatting** - Better player content
8. **Scene List Screen** - Browse scenes

### Low Priority

9. **Branching Scenes** - Complex story flows
10. **Scene Dependencies** - Advanced features

## Integration Points

### Dependencies

- **Adventures** - Scenes belong to adventures
- **Entities** - Scenes have associated entities
- **Encounters** - Scenes may contain encounters
- **Media** - Scene maps and images
- **Sessions** - Scenes played during sessions

### Required Changes

1. **Router** - Add scene list route
2. **Menu Registry** - Scene-specific actions (already exists via `_sceneMenu`)
3. **Adventure View** - Display scene list

## Testing Needs

- Unit tests for scene service
- Unit tests for scene ordering
- Widget tests for scene components
- Integration tests for scene CRUD
- Test scene navigation

## Documentation Needs

- Feature README
- Scene template guide
- Scene flow documentation
- Best practices guide

## Next Steps

1. Create scene provider for state management
2. Build scene navigation widget
3. Implement scene service layer
4. Create scene widget library
5. Add scene flow tracking
6. Implement scene templates
7. Add read aloud text formatting
8. Create scene list screen
9. Add tests
10. Write documentation

---

**Status**: Partial Implementation (30% complete)
**Last Updated**: 2025-11-03
