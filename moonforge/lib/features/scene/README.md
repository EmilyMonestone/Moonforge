# Scene Feature Documentation

## Overview

The Scene feature in Moonforge provides comprehensive tools for managing scenes within adventures. Scenes are the smallest narrative units, representing specific locations, events,
or encounters.

## Architecture

### Controllers

#### SceneProvider

- **Location**: `lib/features/scene/controllers/scene_provider.dart`
- **Purpose**: State management for scene navigation and completion tracking
- **Key Features**:
    - Current scene tracking
    - Previous/next scene navigation
    - Scene completion status
    - Scene history persistence

### Services

#### SceneService

- **Location**: `lib/features/scene/services/scene_service.dart`
- **Purpose**: Business logic for scene operations
- **Key Features**:
    - Scene CRUD operations
    - Scene statistics calculation
    - Scene reordering
    - Scene duplication
    - Scene search

#### SceneNavigationService

- **Location**: `lib/features/scene/services/scene_navigation_service.dart`
- **Purpose**: Scene navigation history and progression tracking
- **Key Features**:
    - Navigation history
    - Forward/back navigation
    - Progression tracking
    - Visit tracking

#### SceneTemplateService

- **Location**: `lib/features/scene/services/scene_template_service.dart`
- **Purpose**: Scene template management
- **Templates**:
    - Combat Scene
    - Social Encounter
    - Exploration
    - Puzzle
    - Rest Scene
    - Cutscene
    - Boss Fight

### Widgets

#### SceneCard

- **Location**: `lib/features/scene/widgets/scene_card.dart`
- **Purpose**: Display scene in list views
- **Features**: Order badge, summary display, action buttons

#### SceneList

- **Location**: `lib/features/scene/widgets/scene_list.dart`
- **Purpose**: List scenes for an adventure
- **Features**: StreamBuilder integration, empty state, error handling

#### SceneNavigationWidget

- **Location**: `lib/features/scene/widgets/scene_navigation_widget.dart`
- **Purpose**: Navigate between scenes
- **Features**: Previous/next buttons, progress indicator, scene counter

#### SceneCompletionIndicator

- **Location**: `lib/features/scene/widgets/scene_completion_indicator.dart`
- **Purpose**: Show and toggle scene completion status
- **Features**: Checkbox, completion label, visual feedback

#### SceneNotesWidget

- **Location**: `lib/features/scene/widgets/scene_notes_widget.dart`
- **Purpose**: Display DM-only notes
- **Features**: Private notes indicator, edit capability

#### ScenePlayerHandout

- **Location**: `lib/features/scene/widgets/scene_player_handout.dart`
- **Purpose**: Display read-aloud text
- **Features**: Formatted display, copy to clipboard

#### SceneReorderWidget

- **Location**: `lib/features/scene/widgets/scene_reorder_widget.dart`
- **Purpose**: Drag-to-reorder scenes
- **Features**: Reorderable list, order indicators

### Utilities

#### SceneValidators

- **Location**: `lib/features/scene/utils/scene_validators.dart`
- **Purpose**: Validate scene data
- **Functions**:
    - `validateName()` - Validate scene name
    - `validateSummary()` - Validate summary length
    - `validateOrder()` - Validate order number
    - `isNameUniqueInAdventure()` - Check name uniqueness
    - `suggestUniqueName()` - Generate unique name

#### SceneOrdering

- **Location**: `lib/features/scene/utils/scene_ordering.dart`
- **Purpose**: Scene ordering operations
- **Functions**:
    - `sortByOrder()` - Sort scenes
    - `getNextOrder()` - Get next order number
    - `moveScene()` - Move scene to new position
    - `reorderByIds()` - Reorder by ID list
    - `normalizeOrder()` - Ensure sequential ordering
    - `swapScenes()` - Swap two scenes

#### SceneTemplates

- **Location**: `lib/features/scene/utils/scene_templates.dart`
- **Purpose**: Template utilities
- **Functions**:
    - `getAllTemplates()` - Get all templates
    - `getTemplateById()` - Get specific template
    - `createFromTemplate()` - Create scene from template
    - `recommendTemplate()` - Suggest template based on content

#### SceneExport

- **Location**: `lib/features/scene/utils/scene_export.dart`
- **Purpose**: Export scene content
- **Functions**:
    - `toMarkdown()` - Export to Markdown
    - `toJson()` - Export to JSON
    - `toPlainText()` - Export to plain text
    - `exportMultipleScenesMarkdown()` - Batch export
    - `extractReadAloudText()` - Extract read-aloud sections

### Views

#### SceneView

- **Location**: `lib/features/scene/views/scene_view.dart`
- **Purpose**: View scene details
- **Features**:
    - Scene navigation
    - Completion tracking
    - Read-aloud text extraction
    - Entity mentions
    - Edit button

#### SceneEditView

- **Location**: `lib/features/scene/views/scene_edit_view.dart`
- **Purpose**: Create and edit scenes
- **Features**: Rich text editing, autosave, entity mentions

#### SceneListScreen

- **Location**: `lib/features/scene/views/scene_list_screen.dart`
- **Purpose**: Browse all scenes in campaign
- **Features**: Grouped by chapter/adventure, navigation

#### SceneTemplatesScreen

- **Location**: `lib/features/scene/views/scene_templates_screen.dart`
- **Purpose**: Browse scene templates
- **Features**: Template preview, categorization

## Usage

### Basic Scene Navigation

```dart
// Initialize provider
final sceneProvider = SceneProvider(sceneRepository);

// Set current scene
await
sceneProvider.setCurrentScene
(
scene);

// Navigate to next scene
final nextScene = await sceneProvider.navigateToNext();

// Navigate to previous scene
final previousScene = await sceneProvider.navigateToPrevious();

// Check navigation availability
final hasNext = sceneProvider.hasNext();
final hasPrevious = sceneProvider.hasPrevious();
```

### Using Scene Service

```dart

final sceneService = SceneService(sceneRepository);

// Get scenes for an adventure
final scenes = await
sceneService.getScenesByAdventure
(
adventureId);

// Get scene statistics
final stats = await sceneService.getSceneStatistics(adventureId);
print('Total scenes: ${stats.totalScenes}');
print('Completion: ${stats.completionPercentage}%');

// Reorder scenes
await sceneService.reorderScenes(adventureId, orderedSceneIds);

// Duplicate a scene
final duplicate = await sceneService.duplicateScene(originalScene, newId);
```

### Using Templates

```dart
// Get all templates
final templates = SceneTemplates.getAllTemplates();

// Get a specific template
final combatTemplate = SceneTemplates.getTemplateById('combat');

// Create scene from template
final scene = SceneTemplates.createFromTemplate(
  templateId: 'combat',
  adventureId: adventureId,
  order: 1,
  customName: 'Goblin Ambush',
);

// Get template recommendation
final recommendedTemplateId = SceneTemplates.recommendTemplate(existingScene);
```

### Exporting Scenes

```dart
// Export to Markdown
final markdown = SceneExport.toMarkdown(scene);

// Export to JSON
final json = SceneExport.toJson(scene);

// Export multiple scenes
final markdown = SceneExport.exportMultipleScenesMarkdown(
  scenes,
  adventureTitle: 'The Lost Mine',
);

// Extract read-aloud text
final readAloud = SceneExport.extractReadAloudText(scene);
```

### Validation

```dart
// Validate scene name
final nameError = SceneValidators.validateName('Scene Name');

// Validate entire scene
final errors = SceneValidators.validateScene(scene);if (
errors.isEmpty) {
// Scene is valid
}

// Check name uniqueness
final isUnique = SceneValidators.isNameUniqueInAdventure(
name,
adventureId,
existingScenes,
);

// Suggest unique name
final uniqueName = SceneValidators.suggestUniqueName(
'Scene Name',
adventureId,
existingScenes,
);
```

## Integration

### Provider Setup

Add SceneProvider to your app's provider hierarchy:

```dart
MultiProvider
(
providers: [
// ... other providers
ChangeNotifierProvider(
create: (context) => SceneProvider(
context.read<SceneRepository>(),
),
),
],
child: MyApp(
)
,
)
```

### Using Widgets

```dart
// Scene list
SceneList
(
adventureId: adventureId,
onSceneTap: (scene) {
// Navigate to scene
},
)

// Scene navigation
SceneNavigationWidget(
currentScene: currentScene,
onNavigate: (scene) {
// Handle navigation
},
)

// Completion indicator
SceneCompletionIndicator(
isCompleted: provider.isCompleted,
onToggle: () {
provider.toggleCompletion();
},
)
```

## Future Enhancements

### Planned Features

- Scene dependencies (prerequisites)
- Branching scenes (multiple outcomes)
- Scene rewards tracking
- Scene conditions
- Scene media (maps, music, images)
- Duration tracking
- Difficulty ratings

### Pending Improvements

- Enhanced template system
- Better read-aloud text detection
- Scene flow visualization
- Completion persistence
- Advanced navigation patterns

## Testing

Unit tests should cover:

- SceneService operations
- SceneNavigationService history
- Scene ordering utilities
- Scene validation
- Template operations
- Export functions

Widget tests should cover:

- SceneCard rendering
- SceneList with different states
- SceneNavigationWidget interactions
- Scene form validation

## Contributing

When adding new scene features:

1. Follow existing patterns
2. Add appropriate validation
3. Update documentation
4. Include tests
5. Consider template applicability

## See Also

- [Adventure Documentation](../adventure/README.md)
- [Chapter Documentation](../chapter/README.md)
- [Entity Documentation](../entities/README.md)
- [Database Schema](../../docs/firebase_schema.md)

## Examples

- Scene AI assistance snippet moved to `docs/examples/scene/ai_assistance_example.md` (was `EXAMPLE_AI_INTEGRATION.dart`)
