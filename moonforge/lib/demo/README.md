# Demo Pages

This directory contains demonstration pages that showcase various Moonforge features and components.

## Table of Contents Demo

**File**: `toc_demo_view.dart`

A comprehensive demonstration of the Table of Contents (TOC) feature, showing:

- How to create and configure TOC entries
- Auto-scroll tracking as you navigate the page
- Responsive behavior across different screen sizes
- Integration with the layout system
- Usage examples and code snippets

### Running the Demo

The demo can be viewed by navigating to the appropriate route in the app. The TOC will automatically appear:
- On wide layouts (tablet/desktop): as a sidebar on the right
- On compact layouts (mobile): accessible via a button in the app bar

### Code Structure

The demo illustrates the complete TOC implementation pattern:

1. **Setup**: Create GlobalKeys for each section
2. **Configuration**: Define TocEntry objects with titles and icons
3. **Integration**: Wrap content with TocScope
4. **Markup**: Attach keys to section containers

This serves as a reference implementation for developers adding TOC support to their own pages.

## Future Demos

This directory can be expanded with additional demo pages for other features:
- Rich text editor examples
- Media gallery demos
- Form validation showcases
- Animation demonstrations
- etc.
