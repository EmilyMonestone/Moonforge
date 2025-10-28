# Multi-Window Feature - User Experience Demo

## What Users Will See

### 1. Normal Navigation (Existing Behavior)
```
┌─────────────────────────────────────────┐
│  Campaign: Lost Mines of Phandelver     │
├─────────────────────────────────────────┤
│                                          │
│  Chapters                                │
│  ┌────────────────────────────────────┐ │
│  │ 1. Goblin Ambush             [>]  │ │ ← Left click
│  │ Summary: The adventure begins...   │ │
│  └────────────────────────────────────┘ │
│  ┌────────────────────────────────────┐ │
│  │ 2. Phandalin                  [>]  │ │
│  │ Summary: A frontier town...        │ │
│  └────────────────────────────────────┘ │
│                                          │
└─────────────────────────────────────────┘
                ↓ Left Click
┌─────────────────────────────────────────┐
│  Chapter: Goblin Ambush                 │
├─────────────────────────────────────────┤
│  (Navigates in same window)             │
└─────────────────────────────────────────┘
```

### 2. Context Menu (New Feature)
```
┌─────────────────────────────────────────┐
│  Campaign: Lost Mines of Phandelver     │
├─────────────────────────────────────────┤
│                                          │
│  Chapters                                │
│  ┌────────────────────────────────────┐ │
│  │ 1. Goblin Ambush             [>]  │ │ ← Right click
│  │ Summary: The adventure begins...   │ │
│  └───────────┬────────────────────────┘ │
│              │                           │
│  ┌───────────▼──────────────────────┐   │
│  │ 📂 Open in new window          │   │ ← Context menu appears
│  └────────────────────────────────────┘ │
│                                          │
└─────────────────────────────────────────┘
```

### 3. Web Platform - New Tab Opens
```
Browser Tab 1 (Original)         Browser Tab 2 (New)
┌──────────────────────┐         ┌──────────────────────┐
│ Campaign Screen      │         │ Chapter: Goblin      │
│                      │         │         Ambush       │
│ Chapters List        │         │                      │
│ • Goblin Ambush      │  →→→    │ Summary: The         │
│ • Phandalin          │         │ adventure begins...  │
│ • Redbrand           │         │                      │
│                      │         │ Adventures           │
└──────────────────────┘         │ • Cragmaw Hideout   │
    (User's view)                │ • Goblin Arrows     │
                                 └──────────────────────┘
                                     (Opens in new tab)
```

### 4. Desktop Platform - New Window Opens
```
Window 1 (Original)                    Window 2 (New)
┌───────────────────────────┐         ┌───────────────────────────┐
│ Moonforge                 │         │ Moonforge                 │
├───────────────────────────┤         ├───────────────────────────┤
│ Campaign Screen           │         │ Chapter: Goblin Ambush    │
│                           │         │                           │
│ Chapters                  │         │ Summary: The adventure    │
│ ┌────────────────┐        │  →→→    │ begins when the party...  │
│ │ Goblin Ambush  │        │         │                           │
│ └────────────────┘        │         │ Adventures                │
│ ┌────────────────┐        │         │ • Cragmaw Hideout        │
│ │ Phandalin      │        │         │ • Goblin Arrows          │
│ └────────────────┘        │         │                           │
└───────────────────────────┘         └───────────────────────────┘
  (Main window stays open)              (New window created)
```

## Interaction Flow

### Step-by-Step User Journey

1. **User browses campaign**
   ```
   User is viewing: Campaign Screen
   Sees: List of chapters
   ```

2. **User wants to reference a chapter while editing another**
   ```
   User thinks: "I need to see Chapter 1 while working on Chapter 2"
   Action: Right-clicks on "Chapter 1: Goblin Ambush"
   ```

3. **Context menu appears**
   ```
   Menu shows: "Open in new window" (or "In neuem Fenster öffnen" in German)
   User clicks: The menu option
   ```

4. **New window/tab opens**
   ```
   Web: New browser tab with Chapter 1
   Desktop: New application window with Chapter 1
   Original: Stays on Campaign Screen
   ```

5. **User can now work with both views**
   ```
   Window 1: Campaign overview
   Window 2: Chapter 1 details
   User can: Reference both simultaneously
   ```

## Use Cases

### 1. DM Preparation
```
Window 1: Session notes         Window 2: Entity details
Window 3: Scene description     Window 4: Initiative tracker
All windows: Independent but showing related content
```

### 2. Cross-Reference
```
Window 1: Current chapter       Window 2: NPC entity sheet
User: Checking NPC stats while planning encounters
```

### 3. Multi-Monitor Setup
```
Monitor 1: Campaign overview    Monitor 2: Detailed scene view
Monitor 3: Character sheets     Monitor 4: Maps/handouts
Each window: Draggable and resizable
```

## Platform Differences

### Web (Chrome/Firefox/Edge)
- Opens in **new tab** by default
- Browser determines if new tab or window based on user settings
- URL bar shows full path: `https://moonforge.app/campaign/chapter/xyz`
- Can be bookmarked independently
- Each tab shares authentication state via Firebase

### Desktop Windows
- Opens in **new native window**
- Window is resizable and movable
- Window appears at default size (1000x800) centered on screen
- Independent Flutter engine instance
- Windows can overlap and be arranged freely

### Desktop Linux
- Same behavior as Windows
- Native window using GTK/X11
- Respects Linux window manager behavior

### Not Supported (Hidden)
- macOS: Feature not shown (future enhancement)
- Android: Not applicable (mobile)
- iOS: Not applicable (mobile)

## Visual Examples

### Before (No Context Menu)
```
Right-click → Nothing happens (or browser default menu)
Only option: Left-click to navigate
```

### After (With Context Menu)
```
Right-click → Custom context menu appears
Options: 
  1. Left-click: Navigate in same window (existing)
  2. Right-click + "Open in new window": Open in new window (new!)
```

## Expected User Feedback

**Positive Indicators:**
- "This is so useful for cross-referencing!"
- "I can have multiple chapters open at once"
- "Perfect for multi-monitor setups"
- "Just like my browser tabs, but for campaign content"

**Things to Watch:**
- Do users discover the feature? (right-click is not always intuitive)
- Are there performance issues with many windows?
- Do users want keyboard shortcuts instead/in addition?

## Accessibility Notes

- **Keyboard users**: Currently no keyboard shortcut (future enhancement: Ctrl/Cmd+Click)
- **Screen readers**: Context menu is standard Material widget (should be accessible)
- **Touch devices**: No right-click gesture (acceptable - mobile not primary target)

## Future Enhancements Visible to Users

1. **"Open in new window" icon button** - Make feature more discoverable
2. **Keyboard shortcut** - Ctrl/Cmd+Click to open in new window
3. **Window badges** - Show which window has which content
4. **Remember preferences** - Window size/position per content type
5. **"Focus window"** - If already open, focus instead of creating duplicate

## Summary

This feature transforms Moonforge from a single-window app to a multi-window application, enabling:
- ✅ Better workflow for DMs with multiple monitors
- ✅ Easy cross-referencing of campaign content
- ✅ Flexible workspace organization
- ✅ Natural browsing patterns (like web tabs)
- ✅ No learning curve (right-click is familiar)

All while maintaining:
- ✅ Backward compatibility (existing usage unchanged)
- ✅ Performance (each window is independent)
- ✅ Security (isolated contexts)
- ✅ User control (windows can be closed anytime)
