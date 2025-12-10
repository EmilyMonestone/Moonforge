# Layout Widgets

This directory contains the platform-specific scaffold implementations for Moonforge's adaptive layout system.

## Current Architecture (Platform-Based)

### Active Widgets

These are the current, recommended widgets:

- **`mobile_compact_scaffold.dart`** - Phone layouts on Android/iOS/Fuchsia
- **`mobile_wide_scaffold.dart`** - Tablet layouts on Android/iOS/Fuchsia  
- **`desktop_compact_scaffold.dart`** - Narrow windows on Windows/macOS/Linux/Web
- **`desktop_wide_scaffold.dart`** - Normal/wide windows on Windows/macOS/Linux/Web

### Legacy Widgets (Deprecated)

These widgets are deprecated and kept for backward compatibility:

- **`adaptive_compact_scaffold.dart`** ❌ Deprecated - Use platform-specific variants
- **`adaptive_wide_scaffold.dart`** ❌ Deprecated - Use platform-specific variants

## Quick Reference

| Platform | Size | Widget |
|----------|------|--------|
| Mobile (Android/iOS/Fuchsia) | Compact (< 600px) | `MobileCompactScaffold` |
| Mobile (Android/iOS/Fuchsia) | Medium/Expanded (≥ 600px) | `MobileWideScaffold` |
| Desktop (Windows/macOS/Linux/Web) | Compact (< 600px) | `DesktopCompactScaffold` |
| Desktop (Windows/macOS/Linux/Web) | Medium/Expanded (≥ 600px) | `DesktopWideScaffold` |

## Documentation

For detailed documentation including visual diagrams and usage examples, see:

**[docs/architecture/layout-widgets.md](../../../docs/architecture/layout-widgets.md)**

## Key Differences

### Mobile vs Desktop

**Mobile scaffolds** prioritize:
- Touch-first interactions
- Bottom navigation on phones
- Modal bottom sheets for actions
- Larger touch targets

**Desktop scaffolds** prioritize:
- Mouse/keyboard interactions
- Persistent side navigation rails
- Enhanced navigation with metadata (user, sync, version)
- Denser UI elements

### Compact vs Wide

**Compact scaffolds**:
- Mobile: Bottom NavigationBar + optional overflow rail
- Desktop: Collapsed NavigationRail

**Wide scaffolds**:
- Mobile: Standard NavigationRail
- Desktop: Expandable NavigationRailM3E with trailing metadata

## Migration from Old Architecture

If you're maintaining code that uses the old `AdaptiveCompactScaffold` or `AdaptiveWideScaffold`:

1. Identify if your code needs platform-specific behavior
2. Replace with the appropriate mobile or desktop variant
3. Test on both target platforms
4. Refer to the migration guide in [docs/architecture/layout-widgets.md](../../../docs/architecture/layout-widgets.md)

## Testing

Tests for each widget are in `test/layout/`:
- `mobile_compact_scaffold_test.dart`
- `mobile_wide_scaffold_test.dart`
- `desktop_compact_scaffold_test.dart`
- `desktop_wide_scaffold_test.dart`
- `platform_detector_test.dart`
