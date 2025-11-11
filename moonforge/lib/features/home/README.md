# Home Feature

## Overview

The Home feature provides the main landing page/dashboard for Moonforge, displaying key statistics, quick actions, and recent activity to help users navigate and manage their D&D
campaigns.

## Structure

```
lib/features/home/
├── controllers/
│   └── home_controller.dart       # Dashboard state management
├── services/
│   ├── dashboard_service.dart     # Data aggregation service
│   └── quick_actions_service.dart # Quick actions management
├── views/
│   ├── home_screen.dart          # Main dashboard screen
│   └── unknown_path_screen.dart  # 404 page
└── widgets/
    ├── card_list.dart                  # Generic card list
    ├── placeholders.dart               # Loading/error/empty states
    ├── quick_actions_widget.dart       # Quick action buttons
    ├── recent_section.dart             # Recent items section
    ├── section_header.dart             # Section headers
    ├── stats_overview_widget.dart      # Statistics cards
    └── upcoming_sessions_widget.dart   # Upcoming sessions list
```

## Features

### Dashboard Statistics

Displays key metrics at a glance:

- Total Campaigns
- Total Sessions
- Total Parties
- Total Entities
- Upcoming Sessions

### Quick Actions

Provides fast access to common operations:

- Create New Campaign
- View Campaigns
- View Parties
- Access Settings

### Upcoming Sessions

Shows the next scheduled game sessions with date and time.

### Recent Items

Lists recently modified:

- Campaigns
- Sessions
- Parties

## Components

### Controllers

#### HomeController

Manages dashboard state and preferences:

- Widget visibility toggles
- Refresh state
- Preferences persistence
- Last refresh timestamp

**Usage:**

```dart
final controller = HomeController();
controller.setWidgetVisibility('stats', true);
bool isVisible = controller.isWidgetVisible('stats');
await controller.refresh();
```

### Services

#### DashboardService

Aggregates data from multiple repositories:

- Fetches statistics
- Queries upcoming sessions
- Tracks recent activity
- User-scoped data filtering

**Usage:**

```dart
final service = DashboardService(
  campaignRepo: campaignRepository,
  sessionRepo: sessionRepository,
  partyRepo: partyRepository,
  entityRepo: entityRepository,
);
final stats = await service.fetchStats(userId);
final upcomingSessions = await service.fetchUpcomingSessions();
```

#### QuickActionsService

Provides quick action buttons:

- Default actions (campaigns, parties, settings)
- Extensible for context-aware actions
- Icon and tooltip support

**Usage:**

```dart
final service = QuickActionsService();
final actions = service.getDefaultActions();
```

### Widgets

#### StatsOverviewWidget

Displays statistics in card format with icons and numbers.

#### QuickActionsWidget

Shows interactive buttons for common operations.

#### UpcomingSessionsWidget

Lists upcoming game sessions with formatted dates.

#### RecentSection<T>

Generic widget for displaying recent items of any type.

## Data Flow

1. **HomeScreen** loads user data
2. **DashboardService** aggregates statistics from repositories
3. **Widgets** display data with loading/error states
4. **HomeController** manages UI state and preferences

## Internationalization

All user-facing strings are internationalized:

- `dashboardStats` - Dashboard statistics title
- `quickActions` - Quick actions title
- `upcomingSessions` - Upcoming sessions title
- `totalCampaigns` - Total campaigns label
- `totalSessions` - Total sessions label
- `totalParties` - Total parties label
- `totalEntities` - Total entities label
- `noUpcomingSessions` - Empty state message
- `newCampaign` - New campaign button
- `newSession` - New session button
- `newParty` - New party button

Supported languages:

- English (`app_en.arb`)
- German (`app_de.arb`)

## Routing

The home screen is accessible at the root path (`/`):

```dart
const HomeRouteData().go(context);
```

Quick actions navigate to:

- `CampaignEditRouteData()` - Create new campaign
- `CampaignRouteData()` - View campaigns
- `PartyRootRouteData()` - View parties
- `SettingsRouteData()` - App settings

## Dependencies

### Internal

- `data/repo/*_repository.dart` - Data access layer
- `core/services/persistence_service.dart` - Preferences storage
- `core/utils/logger.dart` - Logging
- `core/widgets/surface_container.dart` - Container widget
- `features/campaign/controllers/campaign_provider.dart` - Campaign state

### External

- `firebase_auth` - User authentication
- `provider` - State management
- `drift` - Database queries
- `intl` - Date/time formatting

## Error Handling

All widgets include proper error handling:

- Loading states with `LoadingPlaceholder`
- Error states with `ErrorPlaceholder`
- Empty states with `EmptyPlaceholder` or custom messages
- Error logging with `logger.e()`

## Future Enhancements

### Planned Features (from specification)

1. **Global Search** - Find campaigns, sessions, entities across the app
2. **Activity Feed** - Recent changes and updates
3. **Favorites/Pinned Items** - Quick access to frequently used items
4. **Notifications** - In-app alerts and reminders
5. **Dashboard Customization** - User-configurable widget layout
6. **Onboarding** - First-time user guidance
7. **Campaign Selector** - Quick campaign switcher
8. **Search Widget** - Global search from home

### Technical TODOs

- [ ] Implement session detail navigation
- [ ] Implement party detail navigation
- [ ] Add widget tests
- [ ] Add dashboard settings screen
- [ ] Add search functionality and route
- [ ] Implement context menus for recent items
- [ ] Add refresh pull-to-refresh gesture
- [ ] Implement activity feed

## Testing

Currently, no tests exist for the home feature. Recommended tests:

### Widget Tests

- `home_screen_test.dart` - Test dashboard rendering
- `stats_overview_widget_test.dart` - Test statistics display
- `quick_actions_widget_test.dart` - Test action buttons
- `upcoming_sessions_widget_test.dart` - Test session list
- `recent_section_test.dart` - Test recent items

### Unit Tests

- `dashboard_service_test.dart` - Test data aggregation
- `quick_actions_service_test.dart` - Test action configuration
- `home_controller_test.dart` - Test state management

## Contributing

When adding new features to the Home feature:

1. Follow existing patterns (services for logic, widgets for UI)
2. Add internationalization strings to both `.arb` files
3. Include loading, error, and empty states
4. Add error logging with `logger`
5. Document new components in this README
6. Add tests for new functionality
7. Update the specification tracking in `docs/missing/home.md`

## Related Documentation

- [Project Structure](../../README.md)
- [Home Feature Specification](../../../docs/missing/home.md)
- [Copilot Instructions](../../../.github/copilot-instructions.md)
