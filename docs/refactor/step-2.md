# Step 2: File and Folder Organization Consistency

**Priority**: High  
**Effort**: M (3-5 days)  
**Branch**: `refactor/02-folder-organization`

## Goal

Ensure consistent folder structure and file naming across all features. This makes the codebase more navigable and helps developers quickly find related code. A consistent structure also reduces cognitive load when switching between features.

By the end of this step:
- All features follow the same organizational pattern
- Files are named consistently
- Empty or redundant directories are removed
- Related files are colocated appropriately

## Scope

**What's included:**
- All directories under `lib/features/`
- Core utilities in `lib/core/`
- File naming conventions

**What's excluded:**
- Generated files and build artifacts
- Platform-specific code (android/, ios/, etc.)
- Third-party packages

**Types of changes allowed:**
- Moving files between directories
- Renaming files for consistency
- Removing empty directories
- Updating import statements

## Instructions

### 1. Audit Current Structure

First, document the current structure of each feature:

```bash
cd moonforge/lib/features
for dir in */; do
  echo "=== $dir ==="
  find "$dir" -type d | sort
done
```

Identify inconsistencies:
- ✅ Features with all subdirectories (views, widgets, controllers, services, utils)
- ⚠️ Features missing standard directories
- ⚠️ Non-standard directory names
- ⚠️ Files in the wrong locations

### 2. Establish Standard Feature Structure

Each feature should follow this structure:

```
lib/features/<feature_name>/
├── controllers/          # State management (Providers, ViewModels)
├── services/            # Business logic, API calls
├── utils/               # Feature-specific helpers
├── views/               # Full screens/pages
├── widgets/             # Reusable UI components for this feature
└── README.md            # Optional: Feature documentation
```

**Notes:**
- Not every feature needs every directory (e.g., some may not need `utils/`)
- Create directories only when needed
- Remove empty directories

### 3. Standardize File Naming

Apply consistent naming conventions:

#### Views (Screens)
**Pattern**: `<feature>_<screen>_view.dart` or `<screen>_view.dart`

**Examples:**
```
login_view.dart
campaign_details_view.dart
encounter_list_view.dart
```

**Before:**
```
lib/features/campaign/views/CampaignScreen.dart
lib/features/campaign/views/campaign_page.dart
lib/features/campaign/views/details.dart
```

**After:**
```
lib/features/campaign/views/campaign_list_view.dart
lib/features/campaign/views/campaign_details_view.dart
```

#### Widgets
**Pattern**: `<descriptive_name>_widget.dart` or `<name>.dart`

**Examples:**
```
campaign_card.dart
entity_avatar.dart
hp_bar_widget.dart
```

#### Controllers
**Pattern**: `<feature>_controller.dart` or `<feature>_provider.dart`

**Examples:**
```
campaign_controller.dart
encounter_provider.dart
initiative_tracker_controller.dart
```

#### Services
**Pattern**: `<feature>_service.dart` or `<domain>_service.dart`

**Examples:**
```
campaign_service.dart
encounter_difficulty_service.dart
auth_service.dart
```

### 4. Reorganize Misplaced Files

Common issues to fix:

#### a) Widgets in views folder

**Before:**
```
lib/features/campaign/views/
  ├── campaign_list_view.dart
  ├── campaign_card.dart          ❌ Widget in views
  └── campaign_filter_dialog.dart ❌ Widget in views
```

**After:**
```
lib/features/campaign/views/
  └── campaign_list_view.dart

lib/features/campaign/widgets/
  ├── campaign_card.dart          ✅
  └── campaign_filter_dialog.dart ✅
```

#### b) Services with mixed responsibilities

**Before:**
```
lib/features/campaign/services/
  ├── campaign_service.dart        # API calls
  ├── campaign_helpers.dart        # Utility functions
  └── campaign_validator.dart      # Validation logic
```

**After:**
```
lib/features/campaign/services/
  └── campaign_service.dart        # API calls and business logic

lib/features/campaign/utils/
  ├── campaign_helpers.dart        # Utility functions
  └── campaign_validator.dart      # Validation logic
```

#### c) Controllers with unclear names

**Before:**
```
lib/features/campaign/controllers/
  ├── provider.dart               ❌ Too generic
  ├── campaign.dart               ❌ Missing suffix
  └── CampaignController.dart     ❌ Wrong case
```

**After:**
```
lib/features/campaign/controllers/
  └── campaign_provider.dart      ✅
```

### 5. Update Import Statements

After moving files, update all imports. Use your IDE's refactoring tools:

**VS Code**: Right-click file → "Rename" or use F2  
**Android Studio/IntelliJ**: Right-click → "Refactor" → "Move"  
**Manual**: Use find/replace with regex

Example search and replace:
```bash
# Find old import
import 'package:moonforge/features/campaign/views/campaign_card.dart';

# Replace with new import
import 'package:moonforge/features/campaign/widgets/campaign_card.dart';
```

### 6. Standardize Export Files (Optional)

For features with many files, consider adding barrel exports:

**lib/features/campaign/campaign.dart:**
```dart
/// Campaign feature exports
library campaign;

// Views
export 'views/campaign_list_view.dart';
export 'views/campaign_details_view.dart';

// Widgets
export 'widgets/campaign_card.dart';
export 'widgets/campaign_filter_dialog.dart';

// Controllers
export 'controllers/campaign_provider.dart';

// Services
export 'services/campaign_service.dart';
```

**Usage:**
```dart
// Before: Multiple imports
import 'package:moonforge/features/campaign/views/campaign_list_view.dart';
import 'package:moonforge/features/campaign/widgets/campaign_card.dart';

// After: Single import
import 'package:moonforge/features/campaign/campaign.dart';
```

**Caution**: Only use barrel exports if they simplify imports. Don't export everything blindly.

### 7. Clean Up Empty Directories

Remove directories that are empty or contain only generated files:

```bash
# Find empty directories
find lib/features -type d -empty

# Remove them
find lib/features -type d -empty -delete
```

### 8. Update Documentation

If features have README files, update them to reflect new structure:

**lib/features/campaign/README.md:**
```markdown
# Campaign Feature

Manages D&D campaigns including creation, editing, and organization.

## Structure

- `views/` - Campaign list and detail screens
- `widgets/` - Reusable campaign UI components
- `controllers/` - Campaign state management
- `services/` - Campaign business logic and API
- `utils/` - Campaign-specific utilities

## Key Files

- `campaign_list_view.dart` - Main campaign list screen
- `campaign_provider.dart` - Campaign state management
- `campaign_service.dart` - Campaign data operations
```

## Safety & Verification

### Potential Pitfalls

1. **Broken imports**: Moving files breaks imports. Use IDE refactoring tools or careful find/replace.
2. **Generated file imports**: Don't move generated files; regenerate them after moving source files.
3. **Circular dependencies**: Reorganizing may expose circular dependencies. Document them.
4. **Test file paths**: Update test imports to match new structure.

### Verification Checklist

After each batch of moves:

- [ ] `flutter analyze` passes with no new errors
- [ ] All imports resolve correctly (no red squiggles in IDE)
- [ ] `flutter test` passes completely
- [ ] App builds successfully
- [ ] File names follow conventions
- [ ] No empty directories remain

### Testing Strategy

1. **Build test**: Ensure project compiles
   ```bash
   flutter build --debug
   ```

2. **Run tests**: All existing tests should pass
   ```bash
   flutter test
   ```

3. **Import check**: Search for old paths
   ```bash
   grep -r "old/path" lib/ test/
   ```

4. **Manual testing**: Navigate through all major features

## Git Workflow Tip

**Branch naming**: `refactor/02-folder-organization`

**Commit strategy**: Make incremental commits per feature or change type

```bash
git commit -m "refactor(campaign): reorganize folder structure"
git commit -m "refactor(encounters): rename view files for consistency"
git commit -m "refactor: update imports after file moves"
```

**PR description template**:
```markdown
## Refactor Step 2: File and Folder Organization Consistency

### Changes
- Standardized feature folder structure across all features
- Renamed X files for consistency
- Moved Y widgets from views/ to widgets/
- Removed Z empty directories

### Structure Changes
**Before:**
- Mixed conventions across features
- Inconsistent file naming

**After:**
- All features follow standard structure
- Consistent naming: `*_view.dart`, `*_widget.dart`, etc.

### Verification
- [x] All imports updated and working
- [x] `flutter analyze` passes
- [x] `flutter test` passes
- [x] App builds and runs
- [x] No functional changes
```

## Impact Assessment

**Risk level**: Low-Medium  
**Files affected**: Potentially 50-100 files (moves and import updates)  
**Breaking changes**: None (internal reorganization only)  
**Migration needed**: None

## Next Step

Once this step is complete and merged, proceed to [Step 3: Extract Common Widget Patterns](step-3.md).

## Common Questions

**Q: Should I rename everything at once or do it incrementally?**  
A: Start with one feature to validate the approach, then apply to others. This reduces risk.

**Q: What if a file doesn't fit the standard structure?**  
A: Document the exception and the reason. Not everything needs to be forced into the pattern.

**Q: Should tests follow the same structure as source files?**  
A: Yes, mirror the structure in `test/` to make tests easy to find:
```
lib/features/campaign/views/campaign_list_view.dart
test/features/campaign/views/campaign_list_view_test.dart
```

**Q: What about the `core/` directory?**  
A: Apply similar consistency to `core/`, but recognize it serves a different purpose (shared utilities, not features).
