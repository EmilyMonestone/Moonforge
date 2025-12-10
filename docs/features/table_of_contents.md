# Table of Contents Feature

## Overview

The Table of Contents (TOC) feature provides automatic navigation for long-form content pages in Moonforge. It adapts responsively to different screen sizes and platforms, showing as a persistent sidebar on wide layouts and a button-activated sheet on compact layouts.

## Key Features

- **Auto-scroll tracking**: Automatically highlights the section currently in view
- **Click navigation**: Click any TOC entry to smoothly scroll to that section
- **Responsive design**: Adapts to different screen sizes and form factors
- **Nested sections**: Supports hierarchical TOC structures with indentation
- **Icon support**: Optional icons for visual clarity
- **Cross-platform**: Works consistently across mobile, tablet, desktop, and web

## Architecture

### Core Components

1. **TocEntry** (`lib/core/models/toc_entry.dart`)
   - Model representing a single TOC entry
   - Contains: key, title, icon (optional), level

2. **TocController** (`lib/core/controllers/toc_controller.dart`)
   - Manages TOC state and scroll synchronization
   - Tracks active entry based on scroll position
   - Provides methods to scroll to entries

3. **TocProvider** (`lib/core/providers/toc_provider.dart`)
   - InheritedWidget for providing TOC controller to descendants
   - TocScope widget for wrapping page content

4. **TableOfContents** (`lib/core/widgets/table_of_contents.dart`)
   - Widget for displaying TOC sidebar (wide layouts)
   - TocButton widget for compact layouts

### Layout Integration

The TOC is integrated into all layout scaffolds:

- **Wide layouts** (desktop/mobile): TOC sidebar on the right side
  - `DesktopWideScaffold`
  - `MobileWideScaffold`

- **Compact layouts** (desktop/mobile): TOC button in app bar
  - `DesktopCompactScaffold`
  - `MobileCompactScaffold`

## Usage

### Basic Example

```dart
import 'package:flutter/material.dart';
import 'package:moonforge/core/models/toc_entry.dart';
import 'package:moonforge/core/providers/toc_provider.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  final _scrollController = ScrollController();
  late final List<TocEntry> _tocEntries;
  
  // Create keys for each section
  final _section1Key = GlobalKey();
  final _section2Key = GlobalKey();
  final _section3Key = GlobalKey();

  @override
  void initState() {
    super.initState();
    
    // Define TOC entries
    _tocEntries = [
      TocEntry(
        key: _section1Key,
        title: 'Introduction',
        icon: Icons.info_outline,
        level: 0,
      ),
      TocEntry(
        key: _section2Key,
        title: 'Details',
        icon: Icons.description,
        level: 0,
      ),
      TocEntry(
        key: _section3Key,
        title: 'Conclusion',
        icon: Icons.check_circle_outline,
        level: 0,
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            Container(key: _section1Key, child: _buildSection1()),
            Container(key: _section2Key, child: _buildSection2()),
            Container(key: _section3Key, child: _buildSection3()),
          ],
        ),
      ),
    );
  }

  Widget _buildSection1() { /* ... */ }
  Widget _buildSection2() { /* ... */ }
  Widget _buildSection3() { /* ... */ }
}
```

### Nested TOC Structure

```dart
_tocEntries = [
  TocEntry(
    key: _overviewKey,
    title: 'Overview',
    level: 0,
  ),
  TocEntry(
    key: _introKey,
    title: 'Introduction',
    level: 1,  // Indented
  ),
  TocEntry(
    key: _goalsKey,
    title: 'Goals',
    level: 1,  // Indented
  ),
  TocEntry(
    key: _detailsKey,
    title: 'Details',
    level: 0,
  ),
];
```

## How It Works

### Scroll Tracking

1. `TocScope` wraps the page content and creates a `TocController`
2. The controller listens to scroll events from the provided `ScrollController`
3. On scroll, it calculates which section is closest to the top of the viewport
4. The active entry is updated and the UI reflects the change

### Navigation

1. User clicks a TOC entry
2. `TocController.scrollToEntry()` is called
3. The method uses `Scrollable.ensureVisible()` to smoothly scroll to the section
4. The section key is used to find the widget's position

### Responsive Display

1. Layout scaffolds check for `TocProvider` in the widget tree
2. **Wide layouts**: If TOC exists, show `TableOfContents` sidebar
3. **Compact layouts**: If TOC exists, show `TocButton` in app bar
4. The button opens a `ModalBottomSheet` with TOC content

## Demo Page

See `lib/demo/toc_demo_view.dart` for a complete working example demonstrating all TOC features.

## Testing

Tests are located in:
- `test/core/models/toc_entry_test.dart` - Model tests
- `test/core/controllers/toc_controller_test.dart` - Controller tests
- `test/core/widgets/table_of_contents_test.dart` - Widget tests

Run tests with:
```bash
flutter test test/core/models/toc_entry_test.dart
flutter test test/core/controllers/toc_controller_test.dart
flutter test test/core/widgets/table_of_contents_test.dart
```

## Best Practices

1. **Use meaningful section titles**: Titles should clearly describe the content
2. **Keep hierarchy shallow**: Avoid deeply nested levels (0-2 is ideal)
3. **Add icons sparingly**: Use icons only when they add clarity
4. **Unique keys**: Each section must have a unique GlobalKey
5. **Single ScrollController**: Use one scroll controller per page

## Future Enhancements

Potential improvements for future versions:
- Sticky TOC header
- Collapsible nested sections
- TOC search/filter
- Keyboard navigation
- Smooth scroll with adjustable speed
- TOC position persistence (remember scroll position)
- Mini-map visualization for very long documents
