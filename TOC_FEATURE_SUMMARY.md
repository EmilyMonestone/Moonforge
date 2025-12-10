# Table of Contents Feature - Implementation Summary

## Overview

This PR introduces a responsive Table of Contents (TOC) feature that provides automatic navigation for long-form content pages. The feature adapts to different screen sizes and platforms, ensuring a consistent user experience across all devices.

## Implementation Details

### Core Architecture

The TOC feature is built on three main components:

1. **Model Layer** (`TocEntry`)
   - Immutable model representing TOC entries
   - Supports hierarchical structures via `level` property
   - Optional icon support for visual clarity

2. **Controller Layer** (`TocController`)
   - Manages TOC state using ChangeNotifier pattern
   - Implements auto-scroll tracking algorithm
   - Provides smooth navigation to sections

3. **Provider Layer** (`TocProvider` / `TocScope`)
   - Uses InheritedWidget pattern for state propagation
   - Automatically sets up scroll listeners
   - Manages controller lifecycle

### User Interface

#### Wide Layouts (Tablet/Desktop)
- **Persistent Sidebar**: TOC displays as a 240px sidebar on the right side
- **Visual Feedback**: Active section highlighted with primary color
- **Smooth Scrolling**: Clicking entries triggers smooth scroll animation

#### Compact Layouts (Mobile)
- **Topbar Button**: TOC accessible via icon button in app bar
- **Bottom Sheet**: Draggable modal sheet for TOC navigation
- **Touch-Optimized**: List tiles optimized for touch interaction

### Layout Integration

Modified scaffolds to support TOC:

| Scaffold | Layout | TOC Display |
|----------|--------|-------------|
| `DesktopWideScaffold` | Wide | Right sidebar |
| `MobileWideScaffold` | Wide | Right sidebar |
| `DesktopCompactScaffold` | Compact | App bar button → sheet |
| `MobileCompactScaffold` | Compact | App bar button → sheet |

### Auto-Scroll Tracking Algorithm

The TOC automatically tracks scroll position using the following approach:

1. Listen to scroll events via `ScrollController`
2. On scroll, iterate through all TOC entries
3. Calculate distance from each section to viewport top
4. Select the section closest to the top
5. Update active state and notify listeners

This provides real-time visual feedback as users navigate content.

## Files Changed

### New Files Created

**Core Components:**
- `moonforge/lib/core/models/toc_entry.dart` - TOC entry model
- `moonforge/lib/core/controllers/toc_controller.dart` - State management
- `moonforge/lib/core/providers/toc_provider.dart` - Provider/scope widgets
- `moonforge/lib/core/widgets/table_of_contents.dart` - UI components
- `moonforge/lib/core/widgets/toc_section.dart` - Helper utilities

**Demo & Documentation:**
- `moonforge/lib/demo/toc_demo_view.dart` - Comprehensive demo page
- `moonforge/lib/demo/README.md` - Demo directory documentation
- `docs/features/table_of_contents.md` - Feature documentation

**Tests:**
- `moonforge/test/core/models/toc_entry_test.dart` - Model tests
- `moonforge/test/core/controllers/toc_controller_test.dart` - Controller tests
- `moonforge/test/core/widgets/table_of_contents_test.dart` - Widget tests

### Modified Files

**Layout Scaffolds:**
- `moonforge/lib/layout/widgets/desktop_wide_scaffold.dart`
- `moonforge/lib/layout/widgets/mobile_wide_scaffold.dart`
- `moonforge/lib/layout/widgets/desktop_compact_scaffold.dart`
- `moonforge/lib/layout/widgets/mobile_compact_scaffold.dart`

## Usage Example

```dart
class MyPageView extends StatefulWidget {
  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  final _scrollController = ScrollController();
  final _section1Key = GlobalKey();
  final _section2Key = GlobalKey();
  
  late final List<TocEntry> _tocEntries;

  @override
  void initState() {
    super.initState();
    _tocEntries = [
      TocEntry(key: _section1Key, title: 'Introduction', icon: Icons.info),
      TocEntry(key: _section2Key, title: 'Details', icon: Icons.description),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return TocScope(
      scrollController: _scrollController,
      entries: _tocEntries,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(key: _section1Key, child: IntroductionSection()),
            Container(key: _section2Key, child: DetailsSection()),
          ],
        ),
      ),
    );
  }
}
```

## Testing

All components have comprehensive test coverage:

- **Model Tests**: Verify TocEntry creation, equality, and hashing
- **Controller Tests**: Validate state management and scroll tracking
- **Widget Tests**: Ensure proper rendering and interaction

Run tests with:
```bash
flutter test test/core/models/toc_entry_test.dart
flutter test test/core/controllers/toc_controller_test.dart
flutter test test/core/widgets/table_of_contents_test.dart
```

## Code Quality

✅ **Code Review**: All issues addressed
✅ **Security Scan**: No vulnerabilities detected (CodeQL)
✅ **Test Coverage**: Unit and widget tests included
✅ **Documentation**: Comprehensive docs and examples provided

## Benefits

1. **Improved Navigation**: Users can quickly jump to specific sections
2. **Context Awareness**: Always know which section you're viewing
3. **Responsive Design**: Works seamlessly across all platforms
4. **Developer Friendly**: Simple API, easy to integrate
5. **Performance**: Efficient scroll tracking with minimal overhead

## Platform Support

Tested and verified on:
- ✅ Desktop (Windows, macOS, Linux)
- ✅ Web
- ✅ Mobile (Android, iOS)
- ✅ All form factors (compact, medium, expanded)

## Future Enhancements

Potential improvements for future iterations:
- Collapsible nested sections
- Search/filter functionality
- Keyboard navigation support
- Mini-map visualization
- Sticky TOC header option
- Customizable styling/theming

## Migration Guide

For existing pages wanting to add TOC support:

1. Add a `ScrollController` to your page
2. Create `GlobalKey` instances for each section
3. Define `TocEntry` list with keys and titles
4. Wrap content with `TocScope`
5. Attach keys to section containers

See `toc_demo_view.dart` for a complete example.

## Conclusion

The Table of Contents feature provides a professional, user-friendly navigation system that enhances the overall user experience in Moonforge. It follows Flutter best practices, integrates seamlessly with the existing architecture, and works consistently across all platforms.
