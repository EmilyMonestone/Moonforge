# Reviewer Checklist: Entities Feature PR

## Pre-Review Setup
Before reviewing the code, ensure you can build and run:

```bash
cd moonforge
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Code Review Checklist

### Model Changes
- [ ] Review `entityIds` field additions in all 5 models (Campaign, Chapter, Adventure, Scene, Encounter)
- [ ] Verify field is defined as `@Default([]) List<String> entityIds`
- [ ] Check that existing fields are not modified
- [ ] Verify models still use freezed and firestore_odm annotations correctly

### New Models
- [ ] Review `entity_with_origin.dart` structure
- [ ] Verify EntityWithOrigin wraps Entity with optional EntityOrigin
- [ ] Verify EntityOrigin contains partType, partId, label, and path
- [ ] Check freezed and json_serializable annotations

### Business Logic (EntityGatherer)
- [ ] Review service structure and methods
- [ ] Verify recursive gathering logic for each part type
- [ ] Check origin tracking and path computation (e.g., "1.3.2")
- [ ] Review deduplication logic (keeps most specific origin)
- [ ] Verify error handling for missing parts or entities
- [ ] Check that deleted entities are filtered out
- [ ] Verify ODM.instance is accessed properly in each method

### UI Widget (EntitiesWidget)
- [ ] Review widget structure and state management
- [ ] Verify entity grouping logic (NPCs/Monsters/Groups, Places, Items/Others)
- [ ] Check empty state handling ("No entities yet")
- [ ] Review table layout and column structure
- [ ] Verify entity name is clickable and navigates correctly
- [ ] Check kind chip implementation and colors
- [ ] Review origin badge implementation
- [ ] Verify responsive design considerations

### Wrapper Widgets
- [ ] Review each wrapper widget (Campaign, Chapter, Adventure, Scene, Encounter)
- [ ] Verify proper parameter passing (campaignId, chapterId, etc.)
- [ ] Check FutureBuilder usage and error handling
- [ ] Verify loading states are handled

### Screen Integration
- [ ] Review integration in campaign_screen.dart
- [ ] Review integration in chapter_screen.dart
- [ ] Review integration in adventure_screen.dart
- [ ] Review integration in scene_screen_impl.dart
- [ ] Review integration in encounter_screen.dart
- [ ] Verify imports are correct
- [ ] Check that widgets are added in appropriate locations (usually in WrapLayout)

### Localization
- [ ] Review new strings in app_en.arb
- [ ] Review new strings in app_de.arb
- [ ] Verify translations are accurate
- [ ] Check that all UI strings are localized

### Documentation
- [ ] Review `docs/entities_feature.md` for completeness
- [ ] Review `ENTITIES_README.md` for clarity
- [ ] Review `IMPLEMENTATION_SUMMARY.md` for accuracy
- [ ] Review `PR_SUMMARY.md` for completeness
- [ ] Verify `scripts/generate_code.sh` works correctly

## Functional Testing Checklist

### Basic Functionality
- [ ] App compiles successfully after code generation
- [ ] No runtime errors when navigating to screens
- [ ] Entities widget appears on all relevant screens

### Campaign Screen
- [ ] Navigate to a campaign with no entities - verify "No entities yet" message
- [ ] Navigate to a campaign with entities - verify they display
- [ ] Verify entities from chapters, adventures, and scenes show origin badges
- [ ] Verify entities from encounters show origin badges
- [ ] Click entity name - navigates to entity detail page

### Chapter Screen
- [ ] Navigate to a chapter with no entities - verify "No entities yet" message
- [ ] Navigate to a chapter with entities - verify they display
- [ ] Verify entities from adventures and scenes show origin badges
- [ ] Verify entities directly on chapter show no badge

### Adventure Screen
- [ ] Navigate to an adventure with no entities - verify "No entities yet" message
- [ ] Navigate to an adventure with entities - verify they display
- [ ] Verify entities from scenes show origin badges
- [ ] Verify entities directly on adventure show no badge

### Scene Screen
- [ ] Navigate to a scene with no entities - verify "No entities yet" message
- [ ] Navigate to a scene with entities - verify they display
- [ ] Verify all entities show no badge (all are direct)

### Encounter Screen
- [ ] Navigate to an encounter with no entities - verify "No entities yet" message
- [ ] Navigate to an encounter with entities - verify they display
- [ ] Verify all entities show no badge (all are direct)

### Entity Grouping
- [ ] Verify NPCs, Monsters, and Groups appear in first table
- [ ] Verify Places appear in second table
- [ ] Verify Items, Handouts, Journals, and Others appear in third table
- [ ] Verify empty groups are not shown

### Origin Badges
- [ ] Verify chapter origin shows as "Chapter X"
- [ ] Verify adventure origin shows as "Adventure X.Y"
- [ ] Verify scene origin shows as "Scene X.Y.Z"
- [ ] Verify encounter origin shows as "Encounter: [name]"
- [ ] Verify badges have correct styling

### Kind Chips
- [ ] Verify NPC shows blue chip
- [ ] Verify Monster shows red chip
- [ ] Verify Group shows purple chip
- [ ] Verify Place shows green chip
- [ ] Verify Item shows orange chip
- [ ] Verify Handout shows amber chip
- [ ] Verify Journal shows teal chip

## Performance Testing
- [ ] Test with campaign with many entities (100+)
- [ ] Test with deep hierarchy (many chapters/adventures/scenes)
- [ ] Verify no noticeable lag when navigating between screens
- [ ] Check that deduplication works correctly (no duplicate entities shown)

## Edge Cases
- [ ] Entity with no kind field
- [ ] Entity with unknown kind
- [ ] Entity referenced but deleted (deleted=true)
- [ ] Entity ID in entityIds but entity doesn't exist
- [ ] Part with order=0 (should show as position 1 in path)
- [ ] Multiple entities with same ID in different parts

## Code Quality
- [ ] No unnecessary code duplication
- [ ] Proper error handling throughout
- [ ] Consistent code style with rest of project
- [ ] Proper use of const constructors
- [ ] No unnecessary rebuilds
- [ ] Proper disposal of resources

## Documentation Quality
- [ ] All documentation is clear and accurate
- [ ] Code comments explain complex logic
- [ ] README files are helpful for users
- [ ] Examples are correct and runnable

## Security Considerations
- [ ] No hardcoded credentials or sensitive data
- [ ] Proper access control (ODM handles Firestore security rules)
- [ ] No SQL injection risks (using ODM, not raw queries)
- [ ] Input validation where needed

## Accessibility
- [ ] Tables have proper semantic structure
- [ ] Clickable elements have proper tap targets
- [ ] Color is not the only indicator (chips have text too)
- [ ] Screen readers can navigate the widget

## Final Checks
- [ ] All commits have meaningful messages
- [ ] No debug code or console.log statements
- [ ] No commented-out code
- [ ] No TODO comments left unresolved
- [ ] Branch is up to date with base branch
- [ ] All tests pass (if applicable)
- [ ] No merge conflicts

## Approval Criteria
- [ ] All code review items addressed
- [ ] Functional testing complete and passing
- [ ] Documentation reviewed and approved
- [ ] No blocking issues identified
- [ ] Performance is acceptable
- [ ] Ready to merge

---

**Reviewer Notes:**

(Add any additional notes, concerns, or feedback here)
