# Campaign Management

Campaigns are the top-level containers for all content in Moonforge.

## Overview

A campaign contains:
- Chapters → Adventures → Scenes (story hierarchy)
- Entities (NPCs, monsters, places, items)
- Encounters (combat scenarios)
- Sessions (game sessions)
- Media assets (images, audio, video)

## Campaign Structure

```
Campaign
├── Chapters
│   └── Adventures
│       └── Scenes
├── Entities
├── Encounters
├── Sessions
├── Media
└── Parties
```

## Rich Text Editing

Campaign descriptions use Flutter Quill with:
- **@Mentions**: Reference NPCs, monsters, groups (see [Quill Mentions](quill-mentions.md))
- **#Hashtags**: Reference places, items, handouts
- **Media embeds**: Images, videos
- **Formatting**: Bold, italic, lists, headers

## Data Model

```dart
@freezed
class Campaign with _$Campaign {
  const factory Campaign({
    required String id,
    required String name,
    String? description,
    required Content content, // Rich text
    @Default([]) List<String> memberUids,
    String? ownerUid,
    @Default(1) int rev,
  }) = _Campaign;
}
```

## Usage

### Creating a Campaign

```dart
final campaign = Campaign(
  id: uuid.v4(),
  name: 'The Wild Beyond',
  content: Content.empty(),
  ownerUid: currentUser.uid,
  memberUids: [currentUser.uid],
);

await campaignRepository.upsert(campaign);
```

### Watching Campaigns

```dart
final campaignsProvider = StreamProvider<List<Campaign>>((ref) {
  final repo = ref.watch(campaignRepositoryProvider);
  return repo.watchAll();
});
```

## Related Documentation

- [Quill Mentions](quill-mentions.md)
- [Entities](entities.md)
- [Firebase Schema](../reference/firebase-schema.md)
