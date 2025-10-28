# Quill Mention Feature

This module provides mention and hashtag support for the Quill editor in Moonforge.

## Features

- **@ Mentions**: Autocomplete for NPC, group, and monster entities
- **# Hashtags**: Autocomplete for place, item, handout, and journal entities
- **Clickable Links**: View entity details by clicking on mentions in the viewer
- **RTL Support**: Automatic detection and support for right-to-left text

## Usage

### Basic Editor with Mentions

```dart
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/data/firebase/models/entity.dart';

// In your widget state:
final _quillController = QuillController.basic();
final _editorKey = GlobalKey();
String? _campaignId; // Set this to your current campaign ID

// In your build method:
CustomQuillEditor(
  controller: _quillController,
  keyForPosition: _editorKey,
  onSearchEntities: (kind, query) async {
    // Fetch entities from the database
    return await EntityMentionService.searchEntities(
      campaignId: _campaignId!,
      kinds: kind,
      query: query,
      limit: 10,
    );
  },
  padding: const EdgeInsets.all(16),
  maxHeight: 400,
)
```

### Viewer with Clickable Mentions

```dart
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/services/app_router.dart';

CustomQuillViewer(
  controller: _quillController,
  onMentionTap: (entityId, mentionType) async {
    // Navigate to entity details
    EntityRoute(entityId: entityId).push(context);
  },
  padding: const EdgeInsets.all(16),
)
```

## Entity Types

### @ Mentions

- **npc**: Non-player characters
- **group**: Groups of entities
- **monster**: Monster entities

### # Hashtags

- **place**: Locations and places
- **item**: Items and equipment
- **handout**: Handouts and documents
- **journal**: Journal entries

## Implementation Details

### Data Format

Mentions and hashtags are stored as Quill links with special prefixes:

- Mentions: `-moonforge-mention-entity-{entityId}`
- Hashtags: `-moonforge-hashtag-entity-{entityId}`

### Keyboard Shortcuts

- **Enter**: Insert the first suggestion from the list
- **Alt+Enter**: Insert a newline without submitting
- **Space/Newline**: Close the suggestion overlay

## Example Integration

See `campaign_edit_screen.dart` for a complete example of integrating the mention feature into an existing Quill editor setup.

## Testing

To test the mention feature:

1. Create some entities in your campaign (NPCs, places, items, etc.)
2. Open a screen with the CustomQuillEditor
3. Type '@' to see NPC/group/monster suggestions
4. Type '#' to see place/item/handout/journal suggestions
5. Select an entity from the list or press Enter
6. The entity name will be inserted as a clickable link
7. In the viewer, click the link to navigate to the entity details
