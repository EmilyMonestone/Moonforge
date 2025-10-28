# Multi-Window Feature - Visual Guide

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     User Interface Layer                     │
│                                                               │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │  Chapter     │    │  Adventure   │    │    Scene     │  │
│  │   Screen     │    │   Screen     │    │   Screen     │  │
│  └──────┬───────┘    └──────┬───────┘    └──────┬───────┘  │
│         │                   │                    │           │
│         └───────────────────┴────────────────────┘           │
│                             │                                │
│                    ┌────────▼────────┐                       │
│                    │    CardList     │                       │
│                    │   (Enhanced)    │                       │
│                    └────────┬────────┘                       │
│                             │                                │
│          ┌──────────────────┴──────────────────┐            │
│          │                                      │            │
│    ┌─────▼──────┐                      ┌───────▼────────┐   │
│    │  onTap()   │                      │ Right-Click    │   │
│    │  Navigate  │                      │ Context Menu   │   │
│    │  Same Tab  │                      └───────┬────────┘   │
│    └────────────┘                              │            │
│                                         ┌──────▼───────┐    │
│                                         │LinkContext   │    │
│                                         │    Menu      │    │
│                                         └──────┬───────┘    │
└────────────────────────────────────────────────┼────────────┘
                                                 │
                                    ┌────────────▼───────────┐
                                    │  MultiWindowService    │
                                    │   (Platform Router)    │
                                    └────────────┬───────────┘
                                                 │
                         ┌───────────────────────┴──────────────────────┐
                         │                                               │
                    ┌────▼─────┐                                  ┌─────▼──────┐
                    │   Web    │                                  │  Desktop   │
                    │ Platform │                                  │ (Win/Lin)  │
                    └────┬─────┘                                  └─────┬──────┘
                         │                                              │
                  ┌──────▼───────┐                              ┌───────▼────────┐
                  │ url_launcher │                              │desktop_multi   │
                  │              │                              │    _window     │
                  └──────┬───────┘                              └───────┬────────┘
                         │                                              │
                  ┌──────▼───────┐                              ┌───────▼────────┐
                  │  New Browser │                              │  New Window    │
                  │     Tab      │                              │   Process      │
                  │              │                              │                │
                  │  Same URL +  │                              │  Moonforge     │
                  │  New Route   │                              │  + Route Arg   │
                  └──────────────┘                              └────────────────┘
```

## User Flow

### Normal Navigation (Left Click)
```
User clicks → CardList.onTap() → GoRouter.go() → Same window navigation
```

### Multi-Window Navigation (Right Click)
```
User right-clicks
    ↓
Context menu appears: "Open in new window"
    ↓
User selects option
    ↓
LinkContextMenu calls MultiWindowService.openRouteInNewWindow()
    ↓
Platform detection:
    ├─ Web → url_launcher opens new tab with full URL
    └─ Desktop → desktop_multi_window creates new window process
        ↓
    New window/tab starts
        ↓
    main.dart receives route argument
        ↓
    GoRouter navigates to the route
        ↓
    Content displayed in new window
```

## State Flow

```
┌──────────────────────────────────────────────────────────┐
│                    Main Window                            │
│  ┌────────────────────────────────────────────────┐      │
│  │  Firebase Auth State (shared via Firebase)    │      │
│  │  Campaign Provider (local to window)          │      │
│  │  Router State (local to window)               │      │
│  └────────────────────────────────────────────────┘      │
└──────────────────────────────────────────────────────────┘
                          │
                          │ (Independent)
                          ▼
┌──────────────────────────────────────────────────────────┐
│                    New Window                             │
│  ┌────────────────────────────────────────────────┐      │
│  │  Firebase Auth State (shared via Firebase)    │      │
│  │  Campaign Provider (fresh instance)           │      │
│  │  Router State (navigated to specific route)   │      │
│  └────────────────────────────────────────────────┘      │
└──────────────────────────────────────────────────────────┘
```

## Security Model

### Web
```
window.open(url, '_blank')
    ↓
Browser creates new tab/window
    ↓
No window.opener reference (security)
    ↓
Independent browsing context
```

### Desktop
```
DesktopMultiWindow.createWindow(route)
    ↓
New OS process spawned
    ↓
Independent Flutter engine instance
    ↓
Isolated memory space
```

## Example Integration

### Before (Simple List)
```dart
CardList<Chapter>(
  items: chapters,
  titleOf: (c) => c.name,
  onTap: (c) => ChapterRoute(chapterId: c.id).go(context),
)
```

### After (With Multi-Window Support)
```dart
CardList<Chapter>(
  items: chapters,
  titleOf: (c) => c.name,
  onTap: (c) => ChapterRoute(chapterId: c.id).go(context),
  enableContextMenu: true,  // ← Enable feature
  routeOf: (c) => ChapterRoute(chapterId: c.id).location,  // ← Provide route
)
```

## Platform Support Matrix

| Platform | Multi-Window | Implementation | Deep Linking |
|----------|-------------|----------------|--------------|
| Web | ✅ Yes | url_launcher → new tab | Full URL with route |
| Windows | ✅ Yes | desktop_multi_window → new window | Process argument |
| Linux | ✅ Yes | desktop_multi_window → new window | Process argument |
| macOS | ❌ No | Not implemented | N/A |
| Android | ❌ No | Not applicable | N/A |
| iOS | ❌ No | Not applicable | N/A |

## Performance Considerations

- **Memory**: Each window has its own Flutter engine and app state
- **Firebase**: Shared auth state, but independent Firestore connections
- **CPU**: Multiple windows = multiple processes on desktop
- **Network**: Each window makes its own Firebase queries

## Future Enhancements

1. **Window Management**
   - Track open windows
   - Prevent duplicate windows for same route
   - Focus existing window instead of creating new one

2. **State Synchronization**
   - Use Firebase real-time listeners
   - Sync state between windows automatically

3. **Window Preferences**
   - Remember size/position per route type
   - Save/restore window layout

4. **macOS Support**
   - Investigate native macOS multi-window APIs
   - Add platform-specific implementation
