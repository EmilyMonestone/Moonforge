# Step 1: Code Formatting and Linting Cleanup

**Priority**: High  
**Effort**: S (1-2 days)  
**Branch**: `refactor/01-formatting-linting`

## Goal

Establish a clean baseline by ensuring all code is consistently formatted and passes static analysis. This creates a solid foundation for subsequent refactoring steps and prevents formatting noise in future diffs.

This step ensures that:
- All Dart code follows consistent formatting rules
- No lint warnings or errors are present
- Code adheres to Dart and Flutter best practices

## Scope

**What's included:**
- All Dart files in `lib/` (excluding generated files)
- All Dart files in `test/`
- Updating `analysis_options.yaml` if needed

**What's excluded:**
- Generated files (`*.g.dart`, `*.gr.dart`)
- Third-party code
- Platform-specific native code

## Instructions

### 1. Run Code Formatting

Format all Dart code using the standard formatter:

```bash
cd moonforge
dart format .
```

This will automatically fix:
- Indentation inconsistencies
- Line length issues (default 80 characters)
- Spacing around operators
- Trailing commas on multi-line lists

### 2. Review Formatting Changes

Before committing, review the changes:

```bash
git diff
```

Look for:
- ✅ Consistent indentation
- ✅ Proper line breaks
- ⚠️ Unexpected changes (rare, but investigate if found)

### 3. Run Static Analysis

Check for lint warnings and errors:

```bash
flutter analyze
```

### 4. Fix Lint Issues

Address any warnings or errors reported by the analyzer. Common issues and fixes:

#### a) Unused imports

**Before:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart'; // Redundant, already in material.dart
import 'package:moonforge/core/models/entity.dart'; // Not used
```

**After:**
```dart
import 'package:flutter/material.dart';
```

#### b) Prefer const constructors

**Before:**
```dart
return Padding(
  padding: EdgeInsets.all(16.0),
  child: Text('Hello'),
);
```

**After:**
```dart
return Padding(
  padding: const EdgeInsets.all(16.0),
  child: const Text('Hello'),
);
```

#### c) Avoid unnecessary null checks

**Before:**
```dart
if (user != null) {
  print(user.name);
}
```

**After (if user is already non-nullable):**
```dart
print(user.name);
```

#### d) Use collection literals

**Before:**
```dart
final list = List<String>();
final map = Map<String, int>();
```

**After:**
```dart
final list = <String>[];
final map = <String, int>{};
```

### 5. Consider Additional Lints (Optional)

Review `analysis_options.yaml` and consider enabling additional helpful lints:

```yaml
linter:
  rules:
    # Existing rules
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    prefer_final_fields: true
    avoid_print: true
    prefer_single_quotes: true
    sort_pub_dependencies: true
    unnecessary_brace_in_string_interps: true
    use_key_in_widget_constructors: true
```

**Note**: Only add rules that won't require extensive changes. The goal is baseline cleanup, not a major rewrite.

### 6. Verify No Behavior Changes

Run the full test suite:

```bash
flutter test
```

All tests should pass. If any fail, investigate whether:
- The test itself has formatting issues (fix them)
- The test is flaky (document and skip for now)
- The formatting broke something (very rare, revert and investigate)

### 7. Manual Smoke Test

Run the app and verify basic functionality:

```bash
flutter run
```

Test:
- ✅ App launches successfully
- ✅ Navigation works
- ✅ Key features are accessible

## Safety & Verification

### Potential Pitfalls

1. **String formatting changes**: Dart format may change multi-line strings. Review carefully.
2. **Generated files**: Don't format or fix lints in `*.g.dart` files (they'll be overwritten).
3. **Large diffs**: If formatting creates huge diffs, consider formatting incrementally by directory.

### Verification Checklist

Before committing:

- [ ] `dart format .` shows "Formatted 0 files"
- [ ] `flutter analyze` shows no issues
- [ ] `flutter test` passes completely
- [ ] `git diff` shows only formatting changes (no logic changes)
- [ ] App builds and runs successfully

### Testing

Since this step only affects formatting:

1. **Existing tests**: All existing tests should pass unchanged
2. **Manual testing**: Quick smoke test of major features
3. **No new tests needed**: Formatting doesn't require test changes

## Git Workflow Tip

**Branch naming**: `refactor/01-formatting-linting`

**Commit message examples**:
```
refactor: apply dart format to all source files

refactor: fix lint warnings in feature modules

refactor: enable additional lint rules in analysis_options.yaml
```

**PR description template**:
```markdown
## Refactor Step 1: Code Formatting and Linting Cleanup

### Changes
- Applied `dart format` to all Dart files
- Fixed X lint warnings
- Enabled Y additional lint rules

### Verification
- [x] `flutter analyze` passes with no warnings
- [x] `flutter test` passes (X tests)
- [x] App builds and runs successfully
- [x] No logic changes, only formatting

### Review Notes
This PR contains only automated formatting and lint fixes. No functional changes.
```

## Impact Assessment

**Risk level**: Very Low  
**Files affected**: Potentially all `.dart` files  
**Breaking changes**: None  
**Migration needed**: None

## Next Step

Once this step is complete and merged, proceed to [Step 2: File and Folder Organization Consistency](step-2.md).

## Common Questions

**Q: Should I fix all lint warnings, even in old code?**  
A: Yes, but focus on quick fixes. If a warning requires significant refactoring, document it and address in a later step.

**Q: What if formatting breaks a carefully formatted table or alignment?**  
A: Use `// dart format off` and `// dart format on` comments to preserve specific formatting:

```dart
// dart format off
final matrix = [
  [1, 0, 0],
  [0, 1, 0],
  [0, 0, 1],
];
// dart format on
```

**Q: Should I format test files differently?**  
A: No, use the same formatting rules for consistency.
