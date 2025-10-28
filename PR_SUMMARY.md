# PR Summary: Add Reusable Entities Widget and Entity Fields

## Overview
This PR implements a comprehensive entities feature for Moonforge that allows users to associate entities (NPCs, monsters, groups, places, items, etc.) with campaigns, chapters, adventures, scenes, and encounters. It includes a reusable widget that displays all entities in grouped tables with origin badges showing hierarchical relationships.

## What's Included

### ✅ Model Changes
- Added `entityIds: List<String>` field to Campaign, Chapter, Adventure, Scene, and Encounter models
- Created EntityWithOrigin and EntityOrigin models for tracking entity sources

### ✅ Business Logic
- EntityGatherer service that recursively collects entities from a part and all its children
- Deduplication logic to avoid showing duplicate entities
- Origin tracking with hierarchical paths (e.g., "Scene 1.3.2")

### ✅ UI Components
- EntitiesWidget: Reusable widget that displays entities in three grouped tables
  - NPCs, Monsters & Groups
  - Places
  - Items & Others
- Colored kind chips and clickable entity names
- Origin badges for entities from child parts
- Wrapper widgets for each screen type

### ✅ Integration
- Added entities widget to all relevant screens:
  - Campaign screen (shows all entities in entire campaign)
  - Chapter screen (chapter + all adventures/scenes)
  - Adventure screen (adventure + all scenes)
  - Scene screen (scene entities only)
  - Encounter screen (encounter entities only)

### ✅ Localization
- Added English and German translations for new UI strings

### ✅ Documentation
- Comprehensive feature documentation (`docs/entities_feature.md`)
- Quick start guide (`ENTITIES_README.md`)
- Implementation summary (`IMPLEMENTATION_SUMMARY.md`)
- Code generation script (`scripts/generate_code.sh`)

## Files Changed
- **19 files changed**
- **~1,256 lines added**
- **0 lines removed** (only additions, no breaking changes)

## Before Running
⚠️ **IMPORTANT**: You must run code generation before the app will compile:

```bash
cd moonforge
./scripts/generate_code.sh
```

This generates the necessary `.freezed.dart` and `.g.dart` files.

## Testing Checklist
After code generation, test:
- [ ] App compiles without errors
- [ ] Navigate to campaign screen - entities widget appears
- [ ] Navigate to chapter screen - entities widget appears with proper origin badges
- [ ] Navigate to adventure screen - entities widget appears
- [ ] Navigate to scene screen - entities widget appears
- [ ] Navigate to encounter screen - entities widget appears
- [ ] Click entity name - navigates to entity detail page
- [ ] Verify empty state shows "No entities yet" message
- [ ] Verify entity grouping (NPCs/Monsters, Places, Items)
- [ ] Verify origin badges show correct hierarchical paths

## Architecture Highlights

### Clean Separation of Concerns
- Models: Data structure
- Services: Business logic (EntityGatherer)
- Widgets: UI presentation (EntitiesWidget)
- Wrappers: Screen-specific integration

### Type Safety
- Uses Firestore ODM for type-safe database access
- Freezed models for immutability
- Strong typing throughout

### Reusability
- Single EntitiesWidget used across all screens
- Wrapper widgets adapt the widget to each screen's context
- EntityGatherer service can be used anywhere

### Performance
- Lazy loading with FutureBuilder
- Deduplication to avoid redundant data
- Efficient Firestore queries

## Future Enhancements
Potential improvements (not included in this PR):
- Add/remove entities from parts via UI
- Click origin badge to navigate to source
- Filter/search entities by name or kind
- Sort by name, kind, or origin
- Pagination for large entity lists
- Entity thumbnails or icons
- Bulk entity assignment
- Entity relationship graph visualization

## Migration Notes
- No database migrations required (entityIds stored as regular Firestore array)
- Existing campaigns will have empty entityIds arrays by default
- No breaking changes to existing functionality
- Feature can be used immediately after code generation

## Related Issues
Closes #[issue-number] (if applicable)

## Screenshots
(Will be added after manual testing with Flutter running)

---

**Ready for Review**: ✅  
**Ready for Testing**: ⚠️ (after code generation)  
**Documentation**: ✅ Complete  
**Breaking Changes**: ❌ None
