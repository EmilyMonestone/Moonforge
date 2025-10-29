# Session Planning

Sessions let you plan and log game sessions.

## Features

- Session info (for players before session)
- Session log (notes during/after session)
- Link to party
- Date/time scheduling

## Data Model

```dart
@freezed
class Session with _$Session {
  const factory Session({
    required String id,
    DateTime? datetime,
    Content? info,      // Player-visible info
    Content? log,       // DM/player notes
    String? partyId,
  }) = _Session;
}
```

## Usage

Create a session:

```dart
final session = Session(
  id: uuid.v4(),
  datetime: DateTime.now(),
  info: Content.fromText('Session 5: Into the Dungeon'),
  partyId: 'party-id',
);
```

## Related Documentation

- [Campaigns](campaigns.md)
- [Firebase Schema](../reference/firebase-schema.md)
