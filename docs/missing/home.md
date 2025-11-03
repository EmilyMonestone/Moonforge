# Home Feature - Missing Implementations

## Overview

The Home feature provides the main landing page/dashboard, showing recent items and quick access to campaigns, parties, and sessions.

## Current Implementation

### ✅ Implemented

**Views** (2 files)
- `home_screen.dart` - Main dashboard
- `unknown_path_screen.dart` - 404 page

**Widgets** (4 files)
- `card_list.dart` - Generic card list widget
- `placeholders.dart` - Empty state placeholders
- `section_header.dart` - Section headers
- `recent_section.dart` - Recent items display

**Routes**
- `HomeRoute` - `/`

## ❌ Missing Components

### Controllers (0/1)

**Missing:**
- `home_controller.dart` or `dashboard_controller.dart`
  - Dashboard layout preferences
  - Widget visibility toggles
  - Refresh state
  - Filter preferences
  - Quick action state

**Impact**: Medium - Dashboard state not managed

### Services (0/2)

**Missing:**
1. `dashboard_service.dart`
   - Aggregate recent activity
   - Calculate statistics
   - Fetch quick links
   - User preferences

2. `quick_actions_service.dart`
   - Frequently used actions
   - Context-aware suggestions
   - Action history

**Impact**: Medium - Logic in UI component

### Widgets (Partial: 4/10+)

**Existing:**
- ✅ `card_list.dart`
- ✅ `placeholders.dart`
- ✅ `section_header.dart`
- ✅ `recent_section.dart`

**Missing:**
1. `dashboard_widget_base.dart` - Base class for dashboard widgets
2. `stats_overview_widget.dart` - Campaign statistics summary
3. `quick_actions_widget.dart` - Common action buttons
4. `notifications_widget.dart` - In-app notifications
5. `campaign_selector_widget.dart` - Quick campaign switcher
6. `upcoming_sessions_widget.dart` - Session calendar preview
7. `activity_feed_widget.dart` - Recent changes feed
8. `favorites_widget.dart` - Pinned/favorite items
9. `search_widget.dart` - Global search from home
10. `onboarding_widget.dart` - First-time user guidance

**Impact**: Medium - Home screen could be more informative

### Utils (0/3)

**Missing:**
1. `dashboard_layout.dart` - Dashboard layout management
2. `dashboard_preferences.dart` - User preferences storage
3. `quick_access.dart` - Recent and favorite items tracking

**Impact**: Low to Medium

### Views (Missing: 2)

**Missing:**
1. `dashboard_settings_screen.dart`
   - Customize dashboard
   - Widget visibility
   - Layout preferences
   - Route: `/settings/dashboard`

2. `search_results_screen.dart`
   - Global search results
   - Filter by type
   - Route: `/search?q=...`

**Impact**: Medium

### Routes (Missing: 2)

**Missing:**
- `/search` - Global search
- `/settings/dashboard` - Dashboard customization

**Impact**: Medium

## 🚧 Incomplete Features

### Home Screen Enhancements

**Partially Implemented:**
- Recent campaigns, sessions, parties displayed
- Missing features:
  - Statistics overview (total campaigns, entities, sessions)
  - Quick actions toolbar
  - Notifications/alerts
  - Activity feed (recent edits across all campaigns)
  - Upcoming sessions calendar
  - Favorites/pinned items
  - Customizable widget layout
  - Empty state for new users
  - Onboarding flow

### Recent Sections Limitations

**Current:**
- Shows 5 most recent items
- Basic title and subtitle

**Missing:**
- Configurable item count
- Additional metadata (last modified by, size, etc.)
- Item actions (archive, favorite, etc.)
- Load more functionality
- Refresh button
- Skeleton loading states

### Navigation

**Missing:**
- Breadcrumb navigation
- Global search
- Command palette integration
- Quick campaign switcher

## Implementation Priority

### High Priority

1. **Dashboard Statistics** - Overview of user's content
2. **Quick Actions Widget** - Common operations
3. **Global Search** - Find anything quickly
4. **Upcoming Sessions** - Session reminders

### Medium Priority

5. **Activity Feed** - Recent changes tracking
6. **Dashboard Customization** - User preferences
7. **Notifications** - In-app alerts
8. **Favorites System** - Pin important items

### Low Priority

9. **Onboarding** - New user experience
10. **Advanced Dashboard Layouts** - Customizable widgets

## Integration Points

### Dependencies

- **All Features** - Home aggregates from all features
- **Auth** - User-specific content
- **Settings** - Dashboard preferences
- **Notifications** - Alert display

### Required Changes

1. **Router** - Add search and dashboard settings routes
2. **Command Palette** - Integration with home
3. **All Features** - Provide recent activity data

## Testing Needs

- Widget tests for all home widgets
- Integration tests for dashboard data loading
- Test empty states
- Test error handling

## Documentation Needs

- Feature README
- Dashboard customization guide
- Widget documentation

## Next Steps

1. Add statistics overview widget
2. Implement quick actions widget
3. Create global search functionality
4. Add upcoming sessions widget
5. Implement activity feed
6. Add dashboard customization
7. Create onboarding flow
8. Add tests
9. Write documentation

---

**Status**: Partial Implementation (40% complete)
**Last Updated**: 2025-11-03
