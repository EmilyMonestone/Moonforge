# Step 3: Extract Common Widget Patterns

**Priority**: High  
**Effort**: M (3-5 days)  
**Branch**: `refactor/03-common-widgets`

## Goal

Identify and extract repeated UI patterns into reusable widgets. This reduces code duplication, ensures consistency across the app, and makes UI updates easier by providing a
single source of truth for common patterns.

By the end of this step:

- Common UI patterns are extracted into reusable widgets
- Duplicate code is eliminated across features
- Styling is more consistent
- Changes to common patterns require updates in only one place

## Scope

**What's included:**

- Repeated UI patterns across features
- Common layouts and containers
- Frequently used button styles
- Repeated card layouts
- Common form inputs

**What's excluded:**

- Feature-specific widgets (keep those in feature folders)
- Complex widgets that aren't truly reusable
- Generated UI code

**Types of changes allowed:**

- Creating new reusable widgets in `lib/core/widgets/`
- Replacing duplicated code with widget calls
- Adding theme extensions for styling

## Instructions

### 1. Identify Duplication

Search for repeated patterns across features:

```bash
# Find similar widget structures
cd moonforge/lib/features

# Look for repeated patterns
grep -r "Card(" . | wc -l
grep -r "Container(" . | wc -l
grep -r "ElevatedButton" . | wc -l
grep -r "TextFormField" . | wc -l
```

Common duplication patterns to look for:

- Similar card layouts
- Repeated button styles
- Common dialog structures
- Repeated empty state messages
- Similar loading indicators
- Repeated error displays

### 2. Extract Common Button Widgets

Moonforge already uses M3E buttons, but you may find custom styling patterns worth extracting.

#### Example: Primary Action Button

**Before** (duplicated across features):

```dart
// In campaign_list_view.dart
ElevatedButton
(
style: ElevatedButton.styleFrom(
backgroundColor: Theme.of(context).colorScheme.primary,
foregroundColor: Theme.of(context).colorScheme.onPrimary,
padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
),
onPressed: onCreateCampaign,
child: const Text('Create Campaign'),
);

// In encounter_list_view.dart (same pattern)
ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Theme.of(context).colorScheme.primary,
foregroundColor: Theme.of(context).colorScheme.onPrimary,
padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
),
onPressed: onCreateEncounter,
child: const Text('Create Encounter'),
);
```

**After** (reusable widget):

```dart
// lib/core/widgets/action_button.dart
class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .primary,
        foregroundColor: Theme
            .of(context)
            .colorScheme
            .onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: onPressed,
      child: Text(label),
    );

    if (icon != null) {
      return ElevatedButton.icon(
        style: button.style,
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
    }

    return button;
  }
}

// Usage in features
ActionButton
(
label: 'Create Campaign',
onPressed: onCreateCampaign,
);

ActionButton(
label: 'Create Encounter',
icon: Icons.add,
onPressed: onCreateEncounter,
);
```

### 3. Extract Common Card Layouts

Many features likely use similar card layouts for list items.

#### Example: Content Card

**Before** (duplicated):

```dart
// In multiple features
Card
(
margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: Theme.of(context).textTheme.titleMedium,
),
const SizedBox(height: 8),
Text(
description,
style: Theme.of(context).textTheme.bodyMedium,
),
],
)
,
)
,
);
```

**After**:

```dart
// lib/core/widgets/content_card.dart
class ContentCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const ContentCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin,
      child: Padding(
        padding: padding!,
        child: child,
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: card,
      );
    }

    return card;
  }
}

// Usage
ContentCard
(
onTap: () => navigateToCampaign(campaign),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(title, style: context.theme.textTheme.titleMedium),
const SizedBox(height: 8),
Text(description, style: context.theme.textTheme.bodyMedium),
]
,
)
,
);
```

### 4. Extract Empty State Widgets

**Before** (duplicated across features):

```dart
Center
(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(Icons.inbox, size: 64, color: Colors.grey),
const SizedBox(height: 16),
Text(
'No campaigns yet',
style: Theme.of(context).textTheme.titleMedium,
),
const SizedBox(height: 8),
Text(
'Create your first campaign to get started',
style: Theme.of(context).textTheme.bodyMedium,
),
const SizedBox(height: 24),
ElevatedButton(
onPressed: onCreateCampaign,
child: const Text('Create Campaign'),
)
,
]
,
)
,
);
```

**After**:

```dart
// lib/core/widgets/empty_state.dart
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme
                  .of(context)
                  .colorScheme
                  .outline,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Usage
EmptyState
(
icon: Icons.campaign,
title: 'No campaigns yet',
message: 'Create your first campaign to get started',
actionLabel: 'Create Campaign
'
,
onAction
:
onCreateCampaign
,
);
```

### 5. Extract Loading State Widgets

**Before** (duplicated):

```dart
if (isLoading) {
return const Center(
child: CircularProgressIndicator(),
);
}
```

**After**:

```dart
// lib/core/widgets/loading_indicator.dart
class LoadingIndicator extends StatelessWidget {
  final String? message;

  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

// For inline loading (e.g., in buttons)
class InlineLoadingIndicator extends StatelessWidget {
  final double size;

  const InlineLoadingIndicator({super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme
              .of(context)
              .colorScheme
              .onPrimary,
        ),
      ),
    );
  }
}

// Usage
if (
isLoading) {
return const LoadingIndicator(message: 'Loading campaigns...');
}

// In button
ElevatedButton(
onPressed: isLoading ? null : onSave,
child: isLoading
? const InlineLoadingIndicator()
    : const Text
(
'
Save
'
)
,
);
```

### 6. Extract Error Display Widgets

**Before**:

```dart
if (error != null) {
return Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(Icons.error_outline, size: 64, color: Colors.red),
const SizedBox(height: 16),
Text(
'Something went wrong',
style: Theme.of(context).textTheme.titleMedium,
),
const SizedBox(height: 8),
Text(error.toString()),
const SizedBox(height: 24),
ElevatedButton(
onPressed: onRetry,
child: const Text('Retry'),
),
],
),
);
}
```

**After**:

```dart
// lib/core/widgets/error_display.dart
class ErrorDisplay extends StatelessWidget {
  final String title;
  final String? message;
  final VoidCallback? onRetry;

  const ErrorDisplay({
    super.key,
    this.title = 'Something went wrong',
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme
                  .of(context)
                  .colorScheme
                  .error,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Usage
if (
state.hasError) {
return ErrorDisplay(
title: 'Failed to load campaigns',
message: state.error?.toString(),
onRetry: () => provider.loadCampaigns(),
);
}
```

### 7. Extract Common Form Fields

**Before** (duplicated TextFormField styling):

```dart
TextFormField
(
decoration: InputDecoration(
labelText: 'Campaign Name',
border: OutlineInputBorder(),
filled: true,
),
validator: (value) {
if (value == null || value.isEmpty) {
return 'Please enter a name';
}
return null;
},
);
```

**After**:

```dart
// lib/core/widgets/app_text_field.dart
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool isRequired;
  final int? maxLines;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.isRequired = false,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        filled: true,
      ),
      validator: validator ??
          (isRequired
              ? (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          }
              : null),
    );
  }
}

// Usage
AppTextField
(
label: 'Campaign Name',
controller: nameController,
isRequired: true,
);

AppTextField(
label: 'Description',
hint: 'Enter a description...',
maxLines:
3
,
controller
:
descriptionController
,
);
```

### 8. Update Features to Use New Widgets

Systematically replace duplicated code across features:

1. Start with one feature as a proof of concept
2. Replace all instances in that feature
3. Test thoroughly
4. Apply to remaining features

Use IDE search/replace to find instances:

```
Search for: "Center.*Column.*mainAxisAlignment.*center.*Icon.*size: 64"
```

### 9. Document Widget Usage

Add documentation to each new widget:

```dart
/// A reusable card widget that provides consistent styling across the app.
///
/// Use this for list items, content containers, and other card-based layouts.
///
/// Example:
/// ```dart
/// ContentCard(
///   onTap: () => navigate(),
///   child: Text('Content'),
/// );
/// ```
class ContentCard extends StatelessWidget {
  // ...
}
```

## Implementation Summary

- Added reusable `SectionHeader`, `ActionButton` enhancements, and strengthened existing `EmptyState`, `ErrorDisplay`, and `LoadingIndicator` widgets under `lib/core/widgets/`.
- Updated campaign, chapter, adventure, entity, and encounter features to consume the shared widgets so repeated button/header/empty-state code is gone.
- Localized new encounter dialogs and empty states by filling both `app_en.arb` and `app_de.arb`.
- Left truly feature-specific widgets (complex editors, Quill integrations) untouched per scope guardrails.

## Verification

- `flutter gen-l10n`
- `flutter analyze`
- `flutter test`
- Manual UI smoke test for campaign list, chapter list, and encounter list (desktop build)

## Safety & Verification

### Potential Pitfalls

1. **Over-abstraction**: Don't force every widget into a reusable pattern. If it's only used once or twice, leave it.
2. **Loss of flexibility**: Ensure reusable widgets still allow customization for special cases.
3. **Breaking existing behavior**: Test thoroughly that replaced widgets behave identically.
4. **Import issues**: Update imports when adding new widgets to core.

### Verification Checklist

- [ ] New widgets are in `lib/core/widgets/`
- [ ] Old duplicated code is replaced
- [ ] All widgets have proper documentation
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] Visual regression test (compare screenshots)
- [ ] App builds and runs

### Testing Strategy

1. **Widget tests**: Add tests for new reusable widgets
2. **Visual testing**: Compare before/after screenshots
3. **Interaction testing**: Ensure buttons, taps, etc. work
4. **Edge cases**: Test with empty states, errors, loading

Example widget test:

```dart
testWidgets
('EmptyState displays correctly
'
, (tester) async {
await tester.pumpWidget(
MaterialApp(
home: EmptyState(
icon: Icons.inbox,
title: 'No items',
message: 'Add an item to get started',
actionLabel: 'Add Item',
onAction: () {},
),
),
);

expect(find.text('No items'), findsOneWidget);
expect(find.text('Add an item to get started'), findsOneWidget);
expect(find.text('Add Item'), findsOneWidget);
expect(find.byIcon(Icons.inbox), findsOneWidget);
});
```

## Git Workflow Tip

**Commit strategy**:

```bash
git commit -m "refactor: extract EmptyState widget"
git commit -m "refactor: extract LoadingIndicator widget"
git commit -m "refactor: extract ErrorDisplay widget"
git commit -m "refactor: replace empty states in campaign feature"
git commit -m "refactor: replace empty states in encounter feature"
```

## Impact Assessment

**Risk level**: Low-Medium  
**Files affected**: 20-50 files  
**Breaking changes**: None  
**Migration needed**: None

## Next Step

Once this step is complete and merged, proceed to [Step 4: Consolidate Theme and Style Utilities](step-4.md).

## Common Questions

**Q: Should I extract a widget used only twice?**  
A: Use the "rule of three": extract when used 3+ times. For 2 uses, consider whether more are likely.

**Q: What if features need slightly different styling?**  
A: Add optional parameters for customization or use theme extensions.

**Q: Should I add tests for all new widgets?**  
A: Yes, especially for complex widgets with logic. Simple presentational widgets can have minimal tests.
