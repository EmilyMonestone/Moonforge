# Adventure Feature - Missing Implementations

## Overview

The Adventure feature manages individual adventure modules within chapters. Adventures are collections of scenes that form a cohesive story arc within a campaign chapter.

## Current Implementation

### ✅ Implemented

**Views** (2 files)
- `adventure_screen.dart` - Detail view for an adventure
- `adventure_edit_screen.dart` - Form for creating/editing adventures

**Utils** (1 file)
- `create_adventure.dart` - Utility for creating new adventures

**Routes**
- `AdventureRoute` - View adventure detail: `/campaign/chapter/:chapterId/adventure/:adventureId`
- `AdventureEditRoute` - Edit adventure: `/campaign/chapter/:chapterId/adventure/:adventureId/edit`

**Data Layer**
- `Adventures` table in tables.dart
- `AdventureDao` for database operations
- `AdventureRepository` for business logic

## ❌ Missing Components

### Controllers (0/1)

**Missing:**
- `adventure_provider.dart` or `adventure_controller.dart`
  - State management for adventures
  - Current adventure context
  - Navigation state
  - Form state management
  - Similar to existing `campaign_provider.dart`

**Impact**: High
- No centralized state management
- Difficult to share adventure context across widgets
- Form state not preserved during navigation

**Recommendation**: Create `AdventureProvider` extending `ChangeNotifier`
```dart
class AdventureProvider extends ChangeNotifier {
  Adventure? _currentAdventure;
  
  Adventure? get currentAdventure => _currentAdventure;
  
  void setCurrentAdventure(Adventure? adventure) {
    _currentAdventure = adventure;
    notifyListeners();
  }
  
  Future<void> updateAdventure(Adventure adventure) async {
    // Update logic
    notifyListeners();
  }
}
```

### Services (0/1)

**Missing:**
- `adventure_service.dart`
  - Adventure progression tracking
  - Scene orchestration within adventure
  - Adventure completion status
  - XP and reward calculations
  - Adventure statistics (scenes completed, time spent, etc.)

**Impact**: Medium
- Business logic mixed with UI code
- No centralized adventure management logic
- Difficult to test adventure-related operations

**Recommendation**: Extract business logic into service layer

### Widgets (0/5+)

**Missing:**

1. `adventure_card.dart`
   - Display adventure summary in lists
   - Shows name, progress, scene count
   - Click to navigate to adventure detail

2. `adventure_list.dart`
   - List all adventures in a chapter
   - Filter and sort capabilities
   - Quick actions (edit, delete, duplicate)

3. `adventure_progress_indicator.dart`
   - Visual progress through scenes
   - Completion percentage
   - Current scene indicator

4. `scene_list_in_adventure.dart`
   - List scenes within an adventure
   - Drag-to-reorder scenes
   - Scene status indicators

5. `adventure_stats_widget.dart`
   - Display adventure statistics
   - Scene count, entity count
   - Estimated play time
   - Encounter difficulty summary

**Impact**: Medium
- Code duplication in views
- Inconsistent UI patterns
- Harder to maintain and test

### Utils (Missing: 2+)

**Existing:**
- ✅ `create_adventure.dart`

**Missing:**

1. `adventure_navigation.dart`
   - Navigate between scenes in order
   - Jump to specific scene
   - Track adventure progress

2. `adventure_validation.dart`
   - Validate adventure data
   - Check for required fields
   - Ensure scenes are properly ordered

**Impact**: Low to Medium
- Validation logic scattered
- Navigation patterns inconsistent

### Views (Missing: 1+)

**Existing:**
- ✅ `adventure_screen.dart`
- ✅ `adventure_edit_screen.dart`

**Missing:**

1. `adventure_list_screen.dart`
   - Browse all adventures across chapters
   - Filter by chapter, status, tags
   - Search adventures by name/content
   - Bulk operations
   - Route: `/campaign/adventures` (not currently defined)

**Impact**: Medium
- Users can only see adventures within chapter context
- No global adventure management
- Difficult to find adventures across chapters

### Routes (Missing: 1)

**Existing:**
- ✅ Adventure detail route (within chapter context)
- ✅ Adventure edit route

**Missing:**
- Adventure list route: `/campaign/adventures`
  - Browse all adventures in campaign
  - Independent of chapter context

**Impact**: Medium
- No way to browse adventures globally
- Must navigate through chapter hierarchy

## 🚧 Incomplete Features

### Adventure Screen Enhancements

**Partially Implemented:**
- Basic adventure detail view exists
- Missing features:
  - Progress tracking visualization
  - Scene navigation (previous/next)
  - Related encounters display
  - Associated entities list
  - Adventure notes/DM section
  - Print/export functionality

### Adventure Edit Screen Enhancements

**Partially Implemented:**
- Basic form for name, summary, content
- Missing features:
  - Scene reordering interface
  - Bulk scene operations
  - Adventure templates
  - Import/export adventures
  - Rich metadata (tags, categories, difficulty)

## Implementation Priority

### High Priority

1. **Adventure List Screen** - Essential for adventure management
2. **Adventure Widgets** - Improve code reuse and consistency
3. **Adventure Provider** - Better state management

### Medium Priority

4. **Adventure Service** - Extract business logic
5. **Scene List Widget** - Better scene management UI
6. **Adventure Utils** - Navigation and validation helpers

### Low Priority

7. **Advanced Statistics** - Analytics and reporting
8. **Templates** - Pre-built adventure structures

## Integration Points

### Dependencies

- **Chapter**: Adventures belong to chapters
- **Scenes**: Adventures contain multiple scenes
- **Entities**: Adventures can have associated NPCs, items, locations
- **Encounters**: Adventures may reference encounters
- **Campaign**: Adventures are part of campaign structure

### Required Changes in Other Components

1. **Router** (`app_router.dart`)
   - Add `AdventureListRoute` for global adventure browsing
   - Consider flat adventure access: `/campaign/adventure/:id`

2. **Menu Registry** (`menu_registry.dart`)
   - ✅ Already has `_adventureMenu` for adventure context
   - Add actions for adventure list view

3. **Chapter Views**
   - Integrate adventure list widget
   - Show adventure progress in chapter view

## Testing Needs

### Unit Tests (Missing)

- Adventure provider state management
- Adventure service business logic
- Adventure validation utilities
- Adventure navigation helpers

### Widget Tests (Missing)

- Adventure card rendering
- Adventure list interactions
- Adventure edit form validation
- Progress indicator display

### Integration Tests (Missing)

- Create adventure flow
- Navigate through scenes
- Edit and update adventure
- Delete adventure cascade

## Documentation Needs

1. **Feature README**
   - Create `moonforge/lib/features/adventure/README.md`
   - Document adventure structure and relationships
   - Usage examples for utilities

2. **API Documentation**
   - Document all public methods
   - Parameter descriptions
   - Return value specifications

3. **User Documentation**
   - How to create and manage adventures
   - Scene organization best practices
   - Adventure templates guide

## Related Files

### Core Files
- `moonforge/lib/data/db/tables.dart` - Adventures table definition
- `moonforge/lib/data/db/daos/adventure_dao.dart` - Database operations
- `moonforge/lib/data/repo/adventure_repository.dart` - Business logic

### Router
- `moonforge/lib/core/services/app_router.dart` - Route definitions

### Menu
- `moonforge/lib/core/repositories/menu_registry.dart` - Menu actions

## Next Steps

1. Create adventure provider for state management
2. Implement adventure list screen and route
3. Build reusable adventure widgets
4. Add adventure service for business logic
5. Enhance existing screens with missing features
6. Add comprehensive tests
7. Write feature documentation

---

**Status**: Partial Implementation (30% complete)
**Last Updated**: 2025-11-03
