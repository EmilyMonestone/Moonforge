# Campaign Feature - Missing Implementations

## Overview

The Campaign feature is the core organizational unit of Moonforge, representing a complete tabletop RPG campaign. Campaigns contain chapters, adventures, scenes, entities, parties, and sessions.

## Current Implementation

### ✅ Implemented

**Views** (2 files)
- `campaign_screen.dart` - Campaign detail/dashboard view
- `campaign_edit_screen.dart` - Form for creating/editing campaigns

**Controllers** (1 file)
- `campaign_provider.dart` - State management for current campaign

**Utils** (1 file)
- `create_campaign.dart` - Utility for creating new campaigns

**Routes**
- `CampaignRoute` - View campaign: `/campaign`
- `CampaignEditRoute` - Edit campaign: `/campaign/edit`

**Data Layer**
- `Campaigns` table in tables.dart
- `CampaignDao` for database operations
- `CampaignRepository` for business logic

## ❌ Missing Components

### Controllers (Partial: 1/2)

**Existing:**
- ✅ `campaign_provider.dart` - Basic campaign state management

**Missing Enhancements:**
- Campaign selection history
- Campaign switching logic
- Multi-campaign state management
- Campaign archival state
- Campaign sharing state
- Unsaved changes tracking

**Missing:**
- `campaign_list_controller.dart`
  - Manage list of all campaigns
  - Filter and search state
  - Sort preferences
  - Bulk selection
  - Campaign comparison state

**Impact**: Medium
- Cannot manage multiple campaigns efficiently
- No list view state management
- Limited campaign organization features

### Services (0/3)

**Missing:**

1. `campaign_service.dart`
   - Campaign lifecycle management
   - Campaign duplication
   - Campaign archival/restoration
   - Campaign export/import
   - Campaign statistics calculation
   - Template management

2. `campaign_sharing_service.dart`
   - Share campaign with other users
   - Permission management
   - Collaborative features
   - Member invitation
   - Access control

3. `campaign_analytics_service.dart`
   - Session count and frequency
   - Total play time
   - Entity counts by type
   - Encounter statistics
   - Progress tracking
   - Player engagement metrics

**Impact**: Medium to High
- Business logic mixed with UI
- No campaign-level operations
- Missing collaboration features
- No analytics/insights

### Widgets (0/12+)

**Missing:**

1. `campaign_card.dart`
   - Display campaign in list view
   - Show thumbnail, name, description
   - Quick stats (chapters, sessions, etc.)
   - Last played date
   - Click to navigate

2. `campaign_list.dart`
   - List all user's campaigns
   - Grid/list view toggle
   - Filter by status (active/archived)
   - Sort options
   - Search functionality

3. `campaign_stats_dashboard.dart`
   - Overview statistics widget
   - Entity counts
   - Session history
   - Recent activity
   - Progress indicators

4. `campaign_timeline.dart`
   - Visual campaign timeline
   - Session markers
   - Chapter/adventure milestones
   - Current position indicator

5. `campaign_chapter_list.dart`
   - List chapters in campaign
   - Reorder chapters
   - Progress indicators
   - Quick actions

6. `campaign_entity_browser.dart`
   - Browse all entities in campaign
   - Filter by type (NPC, location, item, etc.)
   - Search entities
   - Quick link to entity details

7. `campaign_member_list.dart`
   - Show campaign members (owner + members)
   - Permission indicators
   - Member management actions
   - Invitation status

8. `campaign_recent_activity.dart`
   - Recent changes feed
   - Who made changes
   - What was modified
   - Timestamp

9. `campaign_quick_actions.dart`
   - Common action buttons
   - New chapter, new session
   - Quick navigation
   - Start session

10. `campaign_header.dart`
    - Campaign title and description
    - Edit button
    - Share button
    - Settings menu

11. `campaign_sidebar.dart`
    - Navigation within campaign
    - Chapter list
    - Entity categories
    - Session list

12. `campaign_settings_panel.dart`
    - Campaign preferences
    - Default values
    - Rules settings
    - Privacy settings

**Impact**: High
- Campaign screen is monolithic
- Code duplication
- Inconsistent UI patterns
- Poor maintainability

### Utils (Missing: 5+)

**Existing:**
- ✅ `create_campaign.dart`

**Missing:**

1. `campaign_navigation.dart`
   - Navigate through campaign structure
   - Breadcrumb helpers
   - Deep linking within campaign
   - Back navigation tracking

2. `campaign_validation.dart`
   - Validate campaign data
   - Check required fields
   - Name uniqueness
   - Member UID validation

3. `campaign_export.dart`
   - Export campaign to JSON
   - Export to PDF
   - Export selected content
   - Include/exclude options

4. `campaign_import.dart`
   - Import from JSON
   - Import from other formats
   - Merge campaigns
   - Conflict resolution

5. `campaign_templates.dart`
   - Pre-built campaign structures
   - Template selection
   - Apply template to campaign
   - Custom template creation

6. `campaign_search.dart`
   - Search within campaign content
   - Full-text search
   - Filter search results
   - Search history

**Impact**: Medium
- Missing essential utilities
- Operations are manual/difficult
- No template system

### Views (Missing: 3+)

**Existing:**
- ✅ `campaign_screen.dart`
- ✅ `campaign_edit_screen.dart`

**Missing:**

1. `campaign_list_screen.dart`
   - Browse all campaigns
   - Create new campaign
   - Archive/delete campaigns
   - Quick campaign switching
   - Route: `/campaigns` (not currently defined)

2. `campaign_settings_screen.dart`
   - Campaign-specific settings
   - Rules and preferences
   - Privacy and sharing
   - Backup and export
   - Danger zone (archive/delete)
   - Route: `/campaign/settings`

3. `campaign_analytics_screen.dart`
   - Detailed campaign statistics
   - Session analytics
   - Entity distribution
   - Player engagement
   - Timeline visualization
   - Route: `/campaign/analytics`

4. `campaign_members_screen.dart`
   - Manage campaign members
   - Invite new members
   - Set permissions
   - View member activity
   - Route: `/campaign/members`

**Impact**: High
- Cannot browse all campaigns
- No campaign settings UI
- Missing member management
- No analytics dashboard

### Routes (Missing: 4)

**Existing:**
- ✅ Campaign detail route: `/campaign`
- ✅ Campaign edit route: `/campaign/edit`

**Missing:**
- `/campaigns` - List all campaigns
- `/campaign/settings` - Campaign settings
- `/campaign/analytics` - Campaign analytics
- `/campaign/members` - Member management

**Impact**: High
- Cannot browse campaigns
- No access to settings/analytics

## 🚧 Incomplete Features

### Campaign Screen Enhancements

**Partially Implemented:**
- Basic campaign detail view exists
- Missing features:
  - Comprehensive dashboard with widgets
  - Quick actions panel
  - Recent activity feed
  - Statistics overview
  - Chapter navigation sidebar
  - Entity browser
  - Session calendar
  - Member list

### Campaign Edit Screen Enhancements

**Partially Implemented:**
- Basic form exists (name, description, content)
- Missing features:
  - Rich media support (cover image)
  - Tag management
  - Template selection
  - Import/export options
  - Member invitation
  - Privacy settings
  - Advanced metadata

### Campaign Provider Enhancements

**Partially Implemented:**
- Basic current campaign state
- Missing features:
  - Campaign list management
  - Recent campaigns list
  - Campaign switching history
  - Dirty state tracking
  - Auto-save functionality
  - Sync status

## Implementation Priority

### High Priority

1. **Campaign List Screen & Route** - Essential for multi-campaign management
2. **Campaign Dashboard Widgets** - Better overview and navigation
3. **Campaign Service Layer** - Extract business logic
4. **Campaign Member Management** - Collaboration features

### Medium Priority

5. **Campaign Settings Screen** - Configuration options
6. **Campaign Import/Export** - Data portability
7. **Campaign Templates** - Faster campaign creation
8. **Campaign Search** - Find content within campaign

### Low Priority

9. **Campaign Analytics** - Insights and statistics
10. **Campaign Timeline** - Visual progress tracking
11. **Activity Feed** - Recent changes log

## Integration Points

### Dependencies

- **Chapters**: Campaigns contain chapters
- **Entities**: Campaign-level entities
- **Parties**: Parties belong to campaigns
- **Sessions**: Sessions are part of campaigns
- **Players**: Players are tied to campaigns
- **Firebase Auth**: User ownership and permissions

### Required Changes in Other Components

1. **Router** (`app_router.dart`)
   - Add `CampaignsListRoute` for browsing campaigns
   - Add `CampaignSettingsRoute`
   - Add `CampaignAnalyticsRoute`
   - Add `CampaignMembersRoute`

2. **Menu Registry** (`menu_registry.dart`)
   - ✅ Already has `_campaignMenu`
   - Enhance with settings, analytics actions

3. **Home Screen**
   - Link to full campaign list
   - Improve recent campaigns section

4. **App Scaffold**
   - Campaign switcher in toolbar
   - Current campaign indicator

## Testing Needs

### Unit Tests (Missing)

- Campaign provider state management
- Campaign service operations
- Campaign validation
- Import/export functionality
- Template application

### Widget Tests (Missing)

- Campaign card rendering
- Campaign list interactions
- Campaign edit form
- Dashboard widgets
- Member management UI

### Integration Tests (Missing)

- Create and edit campaign flow
- Campaign switching
- Member invitation and management
- Import/export cycle
- Multi-user collaboration

## Documentation Needs

1. **Feature README**
   - Enhance existing campaign documentation
   - Document campaign structure
   - Usage patterns and best practices

2. **User Guide**
   - Campaign creation guide
   - Organization strategies
   - Collaboration setup
   - Import/export workflows

3. **API Documentation**
   - Campaign service methods
   - Provider state management
   - Repository operations

## Related Files

### Core Files
- `moonforge/lib/data/db/tables.dart` - Campaigns table
- `moonforge/lib/data/db/daos/campaign_dao.dart` - Database operations
- `moonforge/lib/data/repo/campaign_repository.dart` - Business logic
- `moonforge/lib/features/campaign/controllers/campaign_provider.dart` - State management

### Router
- `moonforge/lib/core/services/app_router.dart` - Route definitions

### Menu
- `moonforge/lib/core/repositories/menu_registry.dart` - Menu actions

### Existing Documentation
- `docs/features/campaigns.md` - Campaign feature overview

## Next Steps

1. Create campaign list screen and route
2. Build campaign dashboard widgets
3. Implement campaign service layer
4. Add campaign settings screen
5. Enhance campaign provider with list management
6. Build member management UI
7. Add import/export functionality
8. Implement campaign templates
9. Add comprehensive tests
10. Update feature documentation

---

**Status**: Partial Implementation (40% complete)
**Last Updated**: 2025-11-03
