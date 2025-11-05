# Code Generation Required

The adventure feature implementation has added new routes that require code generation.

## What needs to be done

Run the following command from the `moonforge/` directory:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Or use the convenience script:

```bash
cd moonforge
../scripts/generate_code.sh
```

## What this generates

This will regenerate `lib/core/services/app_router.g.dart` to include the new `AdventureListRoute` that was added to support browsing all adventures in a campaign at `/campaign/adventures`.

## New Components Added

### Controllers
- `adventure_provider.dart` - State management for current adventure context

### Widgets  
- `adventure_card.dart` - Card widget for displaying adventure summaries
- `adventure_list.dart` - List widget for displaying multiple adventures

### Views
- `adventure_list_screen.dart` - Screen for browsing all adventures in a campaign

### Services
- `adventure_service.dart` - Business logic for adventure operations (progress tracking, statistics, scene navigation)

### Utils
- `adventure_navigation.dart` - Helper functions for navigating between scenes
- `adventure_validation.dart` - Validation utilities for adventure data

### Routes
- `AdventureListRoute` - New route at `/campaign/adventures` for the adventure list screen

### Localization
- Added `filterByChapter` and `allChapters` strings to `app_en.arb` and `app_de.arb`
