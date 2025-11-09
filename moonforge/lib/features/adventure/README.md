# Adventure Feature

The Adventure feature manages individual adventure modules within chapters. Adventures are collections of scenes that form a cohesive story arc within a campaign chapter.

## Structure

### Controllers
- **adventure_provider.dart** - State management for adventures
  - Manages current adventure context
  - Persists selected adventure ID across sessions
  - Similar to `CampaignProvider`

### Views
- **adventure_screen.dart** - Detail view for an adventure
  - Displays adventure name, summary, and content
  - Shows list of scenes
  - Shows associated entities
- **adventure_edit_screen.dart** - Form for creating/editing adventures
- **adventure_list_screen.dart** - Browse all adventures across chapters
  - Filter by chapter
  - Search adventures by name/content
  - Navigate to adventure detail

### Widgets
- **adventure_card.dart** - Display adventure summary in lists
  - Shows name, scene count, and last updated date
  - Click to navigate to adventure detail
  - Context menu support for opening in new window
- **adventure_list.dart** - List all adventures
  - Uses AdventureCard for each item
  - Shows empty state when no adventures exist

### Services
- **adventure_service.dart** - Business logic for adventures
  - Calculate progress based on completed scenes
  - Get adventure statistics (scene count, entity count, estimated play time)
  - Navigate between scenes (next/previous)

### Utils
- **create_adventure.dart** - Utility for creating new adventures
- **adventure_navigation.dart** - Helper functions for scene navigation
  - Navigate to next/previous scene
  - Check if next/previous scene exists
  - Jump to specific scene by order
- **adventure_validation.dart** - Validation utilities
  - Validate adventure data
  - Check required fields
  - Validate name length and order

## Routes

- `/campaign/chapter/:chapterId/adventure/:adventureId` - Adventure detail view
- `/campaign/chapter/:chapterId/adventure/:adventureId/edit` - Edit adventure
- `/campaign/adventures` - Browse all adventures in campaign (NEW)

## Data Layer

### Database
- **Adventures** table in `tables.dart`
- **AdventureDao** for database operations
- **AdventureRepository** for business logic

### Model
```dart
class Adventure {
  final String id;
  final String chapterId;
  final String name;
  final int order;
  final String? summary;
  final Map<String, dynamic>? content;
  final List<String> entityIds;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int rev;
}
```

## Usage Examples

### Creating an Adventure
```dart
import 'package:moonforge/features/adventure/utils/create_adventure.dart';

// From a button or menu action
await createAdventure(context, campaign);
```

### Navigating to Adventure Detail
```dart
import 'package:moonforge/core/services/app_router.dart';

AdventureRoute(
  chapterId: chapterId,
  adventureId: adventureId,
).go(context);
```

### Using Adventure Provider
```dart
import 'package:moonforge/features/adventure/controllers/adventure_provider.dart';

// Get current adventure
final provider = context.watch<AdventureProvider>();
final currentAdventure = provider.currentAdventure;

// Set current adventure
provider.setCurrentAdventure(adventure);
```

### Validating Adventure Data
```dart
import 'package:moonforge/features/adventure/utils/adventure_validation.dart';

final result = AdventureValidation.validate(adventure);
if (!result.isValid) {
  print(result.message);
}
```

### Calculating Progress
```dart
import 'package:moonforge/features/adventure/services/adventure_service.dart';

final service = AdventureService(adventureRepo, sceneRepo);
final progress = await service.calculateProgress(adventureId);
print('${progress.completedScenes} of ${progress.totalScenes} scenes completed');
print('${(progress.percentage * 100).toStringAsFixed(1)}% complete');
```

## Integration Points

### Dependencies
- **Chapter**: Adventures belong to chapters
- **Scenes**: Adventures contain multiple scenes
- **Entities**: Adventures can have associated NPCs, items, locations
- **Encounters**: Adventures may reference encounters
- **Campaign**: Adventures are part of campaign structure

### Menu Actions
The adventure context menu is defined in `menu_registry.dart` and includes:
- Edit adventure
- Delete adventure
- Create scene
- View scenes

## Localization

The following localization keys are used:
- `adventures` - Section title
- `adventure` - Singular label
- `noAdventuresYet` - Empty state message
- `createAdventure` - Create button label
- `filterByChapter` - Filter dropdown label
- `allChapters` - Filter option for all chapters
- `edit`, `delete`, `save`, `cancel` - Common actions

## Future Enhancements

See `docs/missing/adventure.md` for a complete list of potential enhancements:
- Progress tracking visualization
- Scene reordering interface
- Adventure templates
- Bulk operations
- Print/export functionality
- More sophisticated completion tracking
- XP and reward calculations
