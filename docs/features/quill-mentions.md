# Quill Mention Feature

The mention feature allows users to reference entities (@NPCs, #places, etc.) within rich text content throughout the app.

## Overview

Moonforge's rich text editor (Flutter Quill) includes custom mention and hashtag functionality for referencing campaign entities inline.

## Features

- **@ Mentions**: Reference NPCs, groups, and monsters
- **# Hashtags**: Reference places, items, handouts, and journals
- **Autocomplete**: Dropdown suggestions as you type
- **Clickable Links**: Navigate to entities by clicking mentions
- **Keyboard Navigation**: Press Enter to select first suggestion
- **Campaign Scoped**: Only shows entities from current campaign

## Entity Types

### @ Mentions
- NPCs (`npc`)
- Monsters (`monster`)
- Groups/Parties (`group`)

### # Hashtags
- Places (`place`)
- Items (`item`)
- Handouts (`handout`)
- Journals (`journal`)

## Usage

### In Editor

```dart
import 'package:moonforge/core/widgets/quill_mention/custom_quill_editor.dart';

CustomQuillEditor(
  controller: _quillController,
  keyForPosition: _editorKey,
  onSearchEntities: (kind, query) async {
    return await EntityMentionService.searchEntities(
      campaignId: campaignId,
      kinds: kind,
      query: query,
      limit: 10,
    );
  },
  padding: const EdgeInsets.all(16),
)
```

**User Experience:**
1. Type `@` or `#`
2. Start typing entity name
3. Dropdown shows matching entities
4. Click or press Enter to insert mention

### In Viewer

```dart
import 'package:moonforge/core/widgets/quill_mention/custom_quill_viewer.dart';

CustomQuillViewer(
  controller: _quillController,
  onMentionTap: (entityId, mentionType) async {
    // Navigate to entity
    EntityRoute(entityId: entityId).push(context);
  },
  padding: const EdgeInsets.all(16),
)
```

**User Experience:**
- Mentions appear as styled links in text
- Click mention to navigate to entity details
- Falls back to dialog if no tap handler provided

## Implementation Details

### Core Components

**CustomQuillEditor** (`lib/core/widgets/quill_mention/custom_quill_editor.dart`)
- Wraps QuillEditor with mention autocomplete overlay
- Detects `@` and `#` triggers
- Shows dropdown with entity suggestions
- Inserts mention on selection

**CustomQuillViewer** (`lib/core/widgets/quill_mention/custom_quill_viewer.dart`)
- Wraps QuillEditor in read-only mode
- Makes mentions clickable
- Handles navigation on tap

**EntityMentionService** (`lib/core/widgets/quill_mention/entity_mention_service.dart`)
- Searches entities in Firestore
- Filters by kind and query string
- Campaign-scoped queries
- Configurable result limit

**Constants** (`lib/core/widgets/quill_mention/quill_mention_constants.dart`)
- Link prefixes: `-moonforge-mention-entity-` and `-moonforge-hashtag-entity-`
- Default styles for mentions

### Data Format

Mentions are stored in Quill Delta format:

```json
{
  "insert": "@EntityName",
  "attributes": {
    "link": "-moonforge-mention-entity-{entityId}"
  }
}
```

Hashtags use `-moonforge-hashtag-entity-` prefix instead.

## Where It's Used

Currently integrated in:
- **Campaign edit screen** - Mention entities in campaign description
- **Campaign view screen** - Clickable mentions in campaign description

**Can be added to:**
- Chapter/Adventure/Scene editors
- Session notes
- Entity descriptions
- Any rich text field

## Adding to New Screens

### 1. For Editing

Replace `QuillEditor.basic` with `CustomQuillEditor`:

```dart
CustomQuillEditor(
  controller: _controller,
  keyForPosition: _editorKey,
  onSearchEntities: (kind, query) async {
    return await EntityMentionService.searchEntities(
      campaignId: ref.read(currentCampaignIdProvider)!,
      kinds: kind,
      query: query,
    );
  },
)
```

### 2. For Viewing

Replace `QuillEditor` with `CustomQuillViewer`:

```dart
CustomQuillViewer(
  controller: _controller,
  onMentionTap: (entityId, mentionType) async {
    EntityRoute(entityId: entityId).push(context);
  },
)
```

## Technical Details

### Entity Search

```dart
static Future<List<Entity>> searchEntities({
  required String campaignId,
  required List<String> kinds,
  String query = '',
  int limit = 10,
}) async {
  // Query Firestore for entities matching:
  // - campaignId
  // - kind in kinds list
  // - name contains query (case-insensitive)
  // - not deleted
  // - limit results
}
```

### Mention Detection

Editor listens for:
- `@` character → triggers NPC/monster/group search
- `#` character → triggers place/item/handout/journal search
- Text after trigger → filters results

### Link Handling

Viewer checks link attributes:
- Starts with `-moonforge-mention-entity-` → mention
- Starts with `-moonforge-hashtag-entity-` → hashtag
- Extracts entity ID from link
- Calls `onMentionTap` callback

## Localization

Mention feature uses standard Quill toolbar. Add custom strings in `lib/l10n/app_*.arb` if needed.

## RTL Support

Automatic right-to-left text direction support included.

## Best Practices

1. **Always provide `onSearchEntities`** - Required for autocomplete
2. **Always provide `onMentionTap`** - For proper navigation
3. **Scope to campaign** - Only show relevant entities
4. **Limit results** - Keep dropdown manageable (10-20 items)
5. **Validate entity IDs** - Ensure entity exists before navigating

## Limitations

- Only searches by name (not tags or other fields)
- Case-insensitive search only
- No fuzzy matching
- Requires campaign ID

## Troubleshooting

### Autocomplete not showing

- Check `onSearchEntities` callback is provided
- Verify campaign ID is valid
- Check entities exist in campaign
- Look for console errors

### Mentions not clickable

- Ensure using `CustomQuillViewer` not `QuillEditor`
- Verify `onMentionTap` callback is provided
- Check link prefix format

### Wrong entities showing

- Verify campaign ID is correct
- Check entity `kind` filter
- Confirm entities are not marked as deleted

## Related Documentation

- [Campaigns](campaigns.md) - Campaign management
- [Entities](entities.md) - Entity management
- [Architecture Overview](../architecture/overview.md) - Rich text editing

## External Resources

- [flutter_quill](https://pub.dev/packages/flutter_quill) - Rich text editor
- [Quill Delta Format](https://quilljs.com/docs/delta/) - Document format
