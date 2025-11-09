# Missing Features & Implementations

This directory documents missing or incomplete implementations across the Moonforge application. Each feature has its own detailed documentation file outlining missing components.

## Overview

Moonforge is a comprehensive campaign management tool for tabletop RPGs, built with Flutter. While the core architecture and many features are implemented, several components need
completion for a fully functional application.

IMPORTANT: A LOT OF CHANGES ARE DONE, THIS DOCUMENT IS OUTDATED.

## Status Legend

- ✅ **Implemented** - Feature is complete and functional
- 🚧 **Partial** - Feature exists but has missing components
- ❌ **Missing** - Feature is not implemented

## Feature Status Summary

| Feature        | Status     | Missing Components                    | Documentation                    |
|----------------|------------|---------------------------------------|----------------------------------|
| Adventure      | 🚧 Partial | List view, widgets                    | [adventure.md](./adventure.md)   |
| Authentication | 🚧 Partial | Controllers, services                 | [auth.md](./auth.md)             |
| Campaign       | 🚧 Partial | List view, widgets                    | [campaign.md](./campaign.md)     |
| Chapter        | 🚧 Partial | Controllers, widgets                  | [chapter.md](./chapter.md)       |
| Encounters     | 🚧 Partial | Full initiative UI, widgets           | [encounters.md](./encounters.md) |
| Entities       | 🚧 Partial | Controllers, widgets, services        | [entities.md](./entities.md)     |
| Home           | 🚧 Partial | Controllers, services                 | [home.md](./home.md)             |
| Parties        | 🚧 Partial | Controllers, services, widgets, utils | [parties.md](./parties.md)       |
| Scene          | 🚧 Partial | Controllers, services, widgets        | [scene.md](./scene.md)           |
| Session        | 🚧 Partial | Controllers, services, widgets, utils | [session.md](./session.md)       |
| Settings       | 🚧 Partial | Controllers, services, widgets, utils | [settings.md](./settings.md)     |

## Critical Missing Components

### Cross-Feature Gaps

1. **List/Browse Views**
    - No dedicated list views for browsing campaigns, adventures, chapters, etc.
    - Currently relies on home screen's recent sections
    - Need: Searchable, filterable list views for all major entities

2. **Controllers/State Management**
    - Only campaign has a controller (campaign_provider)
    - Most features lack state management
    - Need: Consistent state management across all features

3. **Feature-Specific Widgets**
    - Very few features have custom widgets
    - Reusable components are mostly in core/widgets
    - Need: Feature-specific widget libraries

4. **Services Layer**
    - Only encounters has services (difficulty, initiative)
    - Business logic often mixed with UI
    - Need: Service layer for each feature domain

5. **Utility Functions**
    - Inconsistent utility coverage across features
    - Some features have extensive utils, others have none
    - Need: Comprehensive utility functions for each feature

### Missing Routes

While routes are defined in the router, several navigation flows are incomplete:

- **Initiative Tracker**: Screen exists but not routed in app_router.dart
- **Media Assets**: Routes for media browsing/management
- **Combatants**: No dedicated route for combatant management outside encounters
- **Players (PC Sheets)**: No routes for player character sheet management despite Players table existing

### Missing UI Screens

1. **List/Browse Screens**
    - Campaign list screen
    - Adventure list screen (outside chapter context)
    - Entity browser/library
    - Encounter library
    - Session list/calendar
    - Media library/browser

2. **Detail Views**
    - Media asset detail screen
    - Player character sheet detail view
    - Combatant detail view

3. **Management Screens**
    - Bulk operations screens
    - Import/export screens
    - Backup/restore screens

### Data Layer Completeness

The data layer is comprehensive with:

- ✅ All tables defined in tables.dart
- ✅ DAOs for all major entities
- ✅ Repositories for all major entities
- ✅ Sync infrastructure (outbox, inbound listener)

However, some gaps exist:

- ❌ Combatants table exists but no combatant repository
- ❌ Players table exists but limited integration in UI
- ❌ MediaAssets table exists but no media management UI

## Architecture Gaps

### Missing Patterns

1. **Loading States**: Inconsistent loading state handling
2. **Error Boundaries**: Limited error handling in features
3. **Offline Indicators**: No visual feedback for sync status
4. **Validation**: Inconsistent form validation patterns
5. **Permissions**: Permission checking not consistently implemented

### Missing Infrastructure

1. **Testing**
    - Unit tests only for encounter services
    - No widget tests
    - No integration tests

2. **Documentation**
    - Most features lack README files
    - Only encounters has comprehensive documentation
    - API documentation sparse

3. **Accessibility**
    - No documented accessibility testing
    - Screen reader support unclear
    - Keyboard navigation incomplete

## Priority Recommendations

### High Priority (Core Functionality)

1. **Initiative Tracker Route & Full UI**
    - Screen exists but needs routing integration
    - Critical for encounter management

2. **Player Character Management**
    - Players table exists but no UI
    - Essential for party management

3. **List Views for Major Entities**
    - Users need to browse and search campaigns, entities, encounters
    - Current home screen "recent" sections insufficient

4. **State Management**
    - Add controllers/providers for all features
    - Consistent state pattern across app

### Medium Priority (Enhanced Functionality)

1. **Feature Widgets Libraries**
    - Reusable components for each feature
    - Consistent UI patterns

2. **Service Layers**
    - Business logic extraction from UI
    - Testable, reusable services

3. **Comprehensive Utils**
    - Helper functions for common operations
    - Consistent utility patterns

### Low Priority (Polish & Enhancement)

1. **Bulk Operations**
    - Multi-select and batch operations
    - Import/export functionality

2. **Advanced Features**
    - Templates and presets
    - Advanced search and filtering
    - Custom reports

## How to Use This Documentation

1. **For Contributors**: Each feature file lists specific missing components to implement
2. **For Project Planning**: Use status summary to prioritize development
3. **For Code Review**: Check if new features address documented gaps
4. **For Testing**: Missing components indicate areas needing test coverage

## Contributing

When implementing missing features:

1. Review the specific feature documentation
2. Follow existing patterns in similar features
3. Add tests for new functionality
4. Update this documentation when completing features
5. Maintain consistency with Material 3 Expressive design

## Related Documentation

- [Architecture Overview](../architecture/overview.md)
- [Feature Specifications](../features/)
- [Development Guide](../development/)
- [Firebase Schema](../reference/firebase-schema.md)

---

**Last Updated**: 2025-11-03
**Status**: Initial analysis complete
