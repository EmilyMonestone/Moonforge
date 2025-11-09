# Session Feature

The Session feature provides comprehensive session management for tabletop RPG campaigns, including scheduling, tracking, sharing, and export capabilities.

## Overview

Sessions represent game sessions where the party plays through campaign content. The feature supports:
- Session creation and editing
- Session scheduling with calendar view
- Session timer for tracking duration
- Public sharing with tokens
- Session notes (DM-only and shared logs)
- Session statistics and analytics
- Export functionality

## Architecture

### Controllers
- **SessionProvider**: Manages current session state and timer
- **SessionListController**: Manages session list state, filtering, and sorting

### Services
- **SessionService**: Core session lifecycle management and statistics
- **SessionTimerService**: Real-time session duration tracking
- **SessionSharingService**: Share token management and permissions
- **SessionCalendarService**: Scheduling and calendar operations
- **SessionExportService**: Export sessions in various formats (JSON, CSV, Markdown)

### Views
- **SessionScreen**: Display individual session details
- **SessionEditScreen**: Create/edit session information
- **SessionListScreen**: Browse all sessions with search and filters
- **SessionCalendarScreen**: Calendar view of scheduled sessions
- **SessionPublicShareScreen**: Public view for players (no auth required)

### Widgets
- **SessionCard**: Display session in lists
- **SessionList**: List of sessions with customization
- **SessionTimerWidget**: Running timer with controls
- **SessionCalendarWidget**: Interactive calendar display
- **UpcomingSessionWidget**: Next session preview
- **SessionStatsWidget**: Session statistics display
- **SessionSummaryWidget**: Session recap/summary

### Utils
- **SessionValidators**: Data validation utilities
- **SessionFormatters**: Date and duration formatting

## Routes

- `/party/:partyId/sessions` - Session list
- `/party/:partyId/session/:sessionId` - Session detail
- `/party/:partyId/session/:sessionId/edit` - Edit session
- `/share/session/:token` - Public share (no auth)

## Usage

### Creating a Session

```dart
final session = Session(
  id: generateId(),
  datetime: DateTime.now(),
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  rev: 0,
);
await sessionRepository.create(session);
```

### Managing Session State

```dart
// Get the session provider
final sessionProvider = context.read<SessionProvider>();

// Set current session
sessionProvider.setCurrentSession(session);

// Start timer
sessionProvider.startSession();

// Pause timer
sessionProvider.pauseSession();

// End session
sessionProvider.endSession();
```

### Enabling Sharing

```dart
final sharingService = SessionSharingService(repository);
final token = await sharingService.enableSharing(
  session,
  expiresAt: DateTime.now().add(Duration(days: 7)),
);
```

### Exporting Sessions

```dart
// Export as JSON
final json = SessionExportService.exportAsJson(session);

// Export as Markdown
final markdown = SessionExportService.exportAsMarkdown(session);

// Export multiple as CSV
final csv = SessionExportService.exportAsCSV(sessions);
```

## Features

### Session Timer
Track session duration in real-time with start, pause, resume, and stop controls.

### Calendar View
View and schedule sessions in a calendar format with month navigation.

### Public Sharing
Share session logs with players via secure tokens with optional expiration.

### Statistics
Track total sessions, average duration, and other metrics.

### Export
Export session data in JSON, CSV, Markdown, or plain text formats.

## Database Schema

The `Sessions` table includes:
- `id`: Unique identifier
- `datetime`: Scheduled date/time
- `info`: DM-only notes (Quill delta)
- `log`: Shared player log (Quill delta)
- `shareToken`: Token for public sharing
- `shareEnabled`: Whether sharing is enabled
- `shareExpiresAt`: Optional share expiration
- `createdAt`, `updatedAt`: Timestamps
- `rev`: Revision number

## Integration

Sessions integrate with:
- **Parties**: Sessions are linked to specific parties
- **Campaigns**: Session content relates to campaign material
- **Encounters**: Track encounters during sessions
- **Entities**: Reference NPCs and locations used

## Future Enhancements

Potential additions outlined in `docs/missing/session.md`:
- Session planning screen
- Session recap screen with enhanced summary
- Attendance tracking
- XP and rewards tracking
- Encounter linking during session
- Session templates
- Reminders and notifications
- Advanced analytics

## Testing

Currently, testing infrastructure is being established. Future tests will cover:
- Unit tests for services
- Widget tests for UI components
- Integration tests for CRUD operations
- Share token generation and validation

## Documentation

- Feature overview: `docs/features/sessions.md`
- Missing implementations: `docs/missing/session.md`
- This README: `lib/features/session/README.md`
