# Step 4: Consolidate Theme and Style Utilities

**Priority**: Medium  
**Effort**: M (3-5 days)  
**Branch**: `refactor/04-theme-consolidation`

## Goal

Centralize all styling-related constants and utilities to ensure consistent visual design across the app. This eliminates magic numbers and hardcoded colors, making theme changes easier and maintaining visual consistency.

By the end of this step:
- All colors, spacing, and typography are defined in one place
- Magic numbers are replaced with named constants
- Theme extensions provide easy access to custom styles
- Visual consistency is improved across features

## Scope

**What's included:**
- Color definitions and constants
- Spacing and padding constants
- Custom theme extensions
- Typography utilities
- Border radius and shape utilities

**What's excluded:**
- Feature-specific styling that isn't reused
- Animation timings (handle in a separate step)
- Platform-specific styling

**Types of changes allowed:**
- Creating utility classes and extensions
- Replacing magic numbers with constants
- Adding theme extensions
- Updating widget usage to reference theme

## Instructions

### 1. Audit Current Theme Usage

Identify hardcoded values across the codebase:

```bash
cd moonforge/lib

# Find hardcoded colors
grep -r "Color(0x" . --include="*.dart" | grep -v ".g.dart" | wc -l
grep -r "Colors\." . --include="*.dart" | grep -v ".g.dart" | wc -l

# Find hardcoded spacing
grep -r "EdgeInsets.all([0-9]" . --include="*.dart" | wc -l
grep -r "SizedBox(height: [0-9]" . --include="*.dart" | wc -l

# Find hardcoded font sizes
grep -r "fontSize: [0-9]" . --include="*.dart" | wc -l
```

### 2. Create Spacing Constants

Define standard spacing values:

**lib/core/design/spacing.dart:**
```dart
/// Standard spacing constants used throughout the app.
///
/// Use these instead of magic numbers for consistent spacing.
abstract class AppSpacing {
  // Base unit (4px grid)
  static const double unit = 4.0;

  // Spacing scale
  static const double xs = unit;          // 4
  static const double sm = unit * 2;      // 8
  static const double md = unit * 3;      // 12
  static const double lg = unit * 4;      // 16
  static const double xl = unit * 6;      // 24
  static const double xxl = unit * 8;     // 32
  static const double xxxl = unit * 12;   // 48

  // Common padding presets
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // Horizontal padding
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // Vertical padding
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);

  // Screen padding (usually for page content)
  static const EdgeInsets screenPadding = EdgeInsets.all(lg);
  static const EdgeInsets screenPaddingHorizontal = horizontalLg;
}
```

**Before** (scattered magic numbers):
```dart
Padding(
  padding: const EdgeInsets.all(16),
  child: Column(
    children: [
      const SizedBox(height: 8),
      Text('Title'),
      const SizedBox(height: 16),
      Text('Body'),
    ],
  ),
);
```

**After** (using constants):
```dart
Padding(
  padding: AppSpacing.paddingLg,
  child: Column(
    children: [
      SizedBox(height: AppSpacing.sm),
      Text('Title'),
      SizedBox(height: AppSpacing.lg),
      Text('Body'),
    ],
  ),
);
```

### 3. Create Border Radius Constants

**lib/core/design/borders.dart:**
```dart
/// Standard border radius and shape constants.
abstract class AppBorders {
  // Border radius values
  static const double radiusNone = 0;
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusXl = 16;
  static const double radiusFull = 9999; // Pill shape

  // Common border radius presets
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );

  // Top-only radius (for dialogs, bottom sheets)
  static const BorderRadius borderRadiusTopMd = BorderRadius.only(
    topLeft: Radius.circular(radiusMd),
    topRight: Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusTopLg = BorderRadius.only(
    topLeft: Radius.circular(radiusLg),
    topRight: Radius.circular(radiusLg),
  );

  // Shapes
  static const RoundedRectangleBorder shapeSm = RoundedRectangleBorder(
    borderRadius: borderRadiusSm,
  );
  static const RoundedRectangleBorder shapeMd = RoundedRectangleBorder(
    borderRadius: borderRadiusMd,
  );
  static const RoundedRectangleBorder shapeLg = RoundedRectangleBorder(
    borderRadius: borderRadiusLg,
  );
}
```

### 4. Create Custom Theme Extensions

For styles not covered by Material theme:

**lib/core/design/app_theme_extensions.dart:**
```dart
import 'package:flutter/material.dart';

/// Custom theme extension for app-specific styling.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color? surfaceContainerLow;
  final Color? surfaceContainerHigh;
  final Color? successColor;
  final Color? warningColor;
  final Color? infoColor;

  const AppThemeExtension({
    this.surfaceContainerLow,
    this.surfaceContainerHigh,
    this.successColor,
    this.warningColor,
    this.infoColor,
  });

  @override
  ThemeExtension<AppThemeExtension> copyWith({
    Color? surfaceContainerLow,
    Color? surfaceContainerHigh,
    Color? successColor,
    Color? warningColor,
    Color? infoColor,
  }) {
    return AppThemeExtension(
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      successColor: successColor ?? this.successColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
    );
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) {
      return this;
    }
    return AppThemeExtension(
      surfaceContainerLow: Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t),
      surfaceContainerHigh: Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t),
      successColor: Color.lerp(successColor, other.successColor, t),
      warningColor: Color.lerp(warningColor, other.warningColor, t),
      infoColor: Color.lerp(infoColor, other.infoColor, t),
    );
  }

  // Light theme defaults
  static AppThemeExtension light() {
    return AppThemeExtension(
      surfaceContainerLow: Colors.grey[100],
      surfaceContainerHigh: Colors.grey[200],
      successColor: Colors.green[600],
      warningColor: Colors.orange[600],
      infoColor: Colors.blue[600],
    );
  }

  // Dark theme defaults
  static AppThemeExtension dark() {
    return AppThemeExtension(
      surfaceContainerLow: Colors.grey[900],
      surfaceContainerHigh: Colors.grey[850],
      successColor: Colors.green[400],
      warningColor: Colors.orange[400],
      infoColor: Colors.blue[400],
    );
  }
}

// Extension for easy access
extension ThemeContextExtension on BuildContext {
  AppThemeExtension get appTheme {
    return Theme.of(this).extension<AppThemeExtension>() ??
        AppThemeExtension.light();
  }
}
```

**Update App widget to include extensions:**
```dart
// In lib/app.dart
ThemeData(
  colorScheme: lightDynamic ?? App._defaultLightColorScheme,
  useMaterial3: true,
  extensions: [
    AppThemeExtension.light(),
  ],
).colorScheme.toM3EThemeData(),
```

**Usage:**
```dart
Container(
  color: context.appTheme.surfaceContainerLow,
  child: Text('Content'),
);
```

### 5. Create Typography Utilities

**lib/core/design/typography.dart:**
```dart
import 'package:flutter/material.dart';

/// Typography utilities and text style helpers.
extension TextStyleExtensions on TextStyle {
  /// Makes text bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Makes text semi-bold
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Makes text italic
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// Applies a specific color
  TextStyle colored(Color color) => copyWith(color: color);

  /// Applies opacity
  TextStyle withOpacity(double opacity) => copyWith(
        color: color?.withOpacity(opacity),
      );
}

/// Convenient access to text styles
extension TextThemeContext on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Shortcuts for common styles
  TextStyle get displayLarge => textTheme.displayLarge!;
  TextStyle get displayMedium => textTheme.displayMedium!;
  TextStyle get displaySmall => textTheme.displaySmall!;

  TextStyle get headlineLarge => textTheme.headlineLarge!;
  TextStyle get headlineMedium => textTheme.headlineMedium!;
  TextStyle get headlineSmall => textTheme.headlineSmall!;

  TextStyle get titleLarge => textTheme.titleLarge!;
  TextStyle get titleMedium => textTheme.titleMedium!;
  TextStyle get titleSmall => textTheme.titleSmall!;

  TextStyle get bodyLarge => textTheme.bodyLarge!;
  TextStyle get bodyMedium => textTheme.bodyMedium!;
  TextStyle get bodySmall => textTheme.bodySmall!;

  TextStyle get labelLarge => textTheme.labelLarge!;
  TextStyle get labelMedium => textTheme.labelMedium!;
  TextStyle get labelSmall => textTheme.labelSmall!;
}
```

**Before:**
```dart
Text(
  'Title',
  style: Theme.of(context).textTheme.titleMedium?.copyWith(
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.primary,
  ),
);
```

**After:**
```dart
Text(
  'Title',
  style: context.titleMedium.bold.colored(context.theme.colorScheme.primary),
);
```

### 6. Create Color Utilities

**lib/core/design/colors.dart:**
```dart
import 'package:flutter/material.dart';

/// Semantic color names for common use cases.
abstract class AppColors {
  // Success states
  static const Color successLight = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF66BB6A);

  // Warning states
  static const Color warningLight = Color(0xFFFFA726);
  static const Color warningDark = Color(0xFFFFB74D);

  // Error states (defer to theme)
  // Use Theme.of(context).colorScheme.error instead

  // Info states
  static const Color infoLight = Color(0xFF2196F3);
  static const Color infoDark = Color(0xFF42A5F5);

  // Dividers and borders
  static const Color dividerLight = Color(0xFFE0E0E0);
  static const Color dividerDark = Color(0xFF424242);
}

/// Color utilities and extensions
extension ColorExtensions on Color {
  /// Lightens the color by a percentage (0.0 to 1.0)
  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// Darkens the color by a percentage (0.0 to 1.0)
  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}

/// Convenient color scheme access
extension ColorSchemeContext on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  // Primary colors
  Color get primary => colorScheme.primary;
  Color get onPrimary => colorScheme.onPrimary;
  Color get primaryContainer => colorScheme.primaryContainer;
  Color get onPrimaryContainer => colorScheme.onPrimaryContainer;

  // Secondary colors
  Color get secondary => colorScheme.secondary;
  Color get onSecondary => colorScheme.onSecondary;

  // Surface colors
  Color get surface => colorScheme.surface;
  Color get onSurface => colorScheme.onSurface;
  Color get surfaceVariant => colorScheme.surfaceVariant;

  // Error colors
  Color get error => colorScheme.error;
  Color get onError => colorScheme.onError;

  // Outline
  Color get outline => colorScheme.outline;
}
```

### 7. Replace Magic Numbers Throughout Codebase

Systematically replace hardcoded values:

**Pattern 1: Spacing**
```bash
# Search for: EdgeInsets.all(16)
# Replace with: AppSpacing.paddingLg

# Search for: SizedBox(height: 8)
# Replace with: SizedBox(height: AppSpacing.sm)
```

**Pattern 2: Colors**
```bash
# Search for: Colors.red
# Replace with: context.colorScheme.error (or AppColors.warningLight if appropriate)
```

**Pattern 3: Border radius**
```bash
# Search for: BorderRadius.circular(12)
# Replace with: AppBorders.borderRadiusLg
```

### 8. Create Design System Export

**lib/core/design/design_system.dart:**
```dart
/// Moonforge Design System
///
/// Central export for all design tokens and utilities.
library design_system;

export 'borders.dart';
export 'colors.dart';
export 'spacing.dart';
export 'typography.dart';
export 'app_theme_extensions.dart';
```

**Usage in features:**
```dart
import 'package:moonforge/core/design/design_system.dart';

// Now you have access to all design tokens
Container(
  padding: AppSpacing.paddingLg,
  decoration: BoxDecoration(
    color: context.surface,
    borderRadius: AppBorders.borderRadiusLg,
  ),
  child: Text(
    'Content',
    style: context.bodyMedium,
  ),
);
```

### 9. Document Design System

Create documentation for the design system:

**lib/core/design/README.md:**
```markdown
# Moonforge Design System

Centralized design tokens and utilities for consistent styling.

## Usage

Import the design system:

\`\`\`dart
import 'package:moonforge/core/design/design_system.dart';
\`\`\`

## Spacing

Use `AppSpacing` for all spacing needs:

- `AppSpacing.xs` - 4px
- `AppSpacing.sm` - 8px
- `AppSpacing.md` - 12px
- `AppSpacing.lg` - 16px (default)
- `AppSpacing.xl` - 24px
- `AppSpacing.xxl` - 32px
- `AppSpacing.xxxl` - 48px

Presets:
- `AppSpacing.paddingLg` - EdgeInsets.all(16)
- `AppSpacing.horizontalLg` - EdgeInsets.symmetric(horizontal: 16)
- `AppSpacing.screenPadding` - Default screen padding

## Colors

Use theme colors via extensions:

\`\`\`dart
context.primary
context.surface
context.error
\`\`\`

For semantic colors not in Material:
- `AppColors.successLight` / `AppColors.successDark`
- `AppColors.warningLight` / `AppColors.warningDark`

## Typography

Access text styles via context:

\`\`\`dart
context.titleMedium
context.bodyLarge
\`\`\`

Style modifiers:
\`\`\`dart
context.titleMedium.bold
context.bodySmall.italic.colored(context.primary)
\`\`\`

## Borders

Use `AppBorders` for border radius:

- `AppBorders.borderRadiusSm` - 4px
- `AppBorders.borderRadiusMd` - 8px
- `AppBorders.borderRadiusLg` - 12px (default)
- `AppBorders.borderRadiusXl` - 16px
\`\`\`
```

## Safety & Verification

### Potential Pitfalls

1. **Theme access in build methods**: Ensure `context` is available
2. **Const constructors**: Some constants may prevent const constructor usage
3. **Performance**: Excessive theme lookups can impact performance (cache when needed)
4. **Breaking existing styling**: Test visual appearance carefully

### Verification Checklist

- [ ] All magic numbers replaced with constants
- [ ] Theme extensions properly registered
- [ ] `flutter analyze` passes
- [ ] `flutter test` passes
- [ ] Visual regression testing completed
- [ ] Documentation updated

### Testing Strategy

1. **Visual testing**: Compare screenshots before/after
2. **Theme switching**: Test light/dark theme transitions
3. **Responsive testing**: Verify spacing on different screen sizes

## Git Workflow Tip

**Branch naming**: `refactor/04-theme-consolidation`

**Commit strategy**:
```bash
git commit -m "refactor: create design system constants"
git commit -m "refactor: add theme extensions"
git commit -m "refactor: replace spacing magic numbers"
git commit -m "refactor: replace color magic numbers"
git commit -m "refactor: document design system"
```

## Impact Assessment

**Risk level**: Low  
**Files affected**: 50-100 files  
**Breaking changes**: None  
**Migration needed**: None

## Next Step

Once this step is complete and merged, proceed to [Step 5: Standardize Async State Management](step-5.md).
