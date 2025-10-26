# Quill Mention Feature Implementation Summary

## Overview
Implemented a comprehensive mention and hashtag feature for the Quill rich text editor in Moonforge, allowing users to reference entities within their campaign content.

## Features Implemented

### 1. Custom Quill Editor (`custom_quill_editor.dart`)
- **@ Mentions**: Type '@' to autocomplete NPC, group, and monster entities
- **# Hashtags**: Type '#' to autocomplete place, item, handout, and journal entities
- **Overlay UI**: Shows a dropdown with entity suggestions as you type
- **Keyboard Navigation**: Press Enter to select the first suggestion
- **RTL Support**: Automatic detection and support for right-to-left text
- **Integration**: Uses EntityMentionService to fetch entities from Firebase

### 2. Custom Quill Viewer (`custom_quill_viewer.dart`)
- **Clickable Links**: Mentions and hashtags become clickable links
- **Navigation**: Click on a mention to navigate to the entity details
- **Custom Handler**: `onMentionTap` callback for custom click behavior
- **Default Dialog**: Falls back to showing entity ID in a dialog if no handler provided

### 3. Entity Mention Service (`entity_mention_service.dart`)
- **Entity Search**: Search entities by kind and query string
- **Campaign Scoped**: Only searches entities within the current campaign
- **Filtering**: Supports filtering by multiple entity kinds
- **Limit Control**: Configurable result limit (default: 10)
- **Error Handling**: Graceful error handling with logging

### 4. Constants (`quill_mention_constants.dart`)
- **Prefixes**: Unique prefixes for hashtag and mention links
  - `prefixHashtag`: `-moonforge-hashtag-entity-`
  - `prefixMention`: `-moonforge-mention-entity-`
- **Styles**: Default Quill styles for mentions
- **Element Options**: Default Quill element options

## Integration

### Campaign Edit Screen
Updated `/moonforge/lib/features/campaign/views/campaign_edit_screen.dart`:
- Replaced `QuillEditor.basic` with `CustomQuillEditor`
- Added entity search functionality via `EntityMentionService`
- Mentions are now available when editing campaign content

### Campaign Screen (Viewer)
Updated `/moonforge/lib/features/campaign/views/campaign_screen.dart`:
- Replaced `QuillEditor` with `CustomQuillViewer`
- Added click handler to navigate to entity details
- Mentions are now clickable when viewing campaign content

## Usage Example

```dart
// Editor with mention support
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

// Viewer with clickable mentions
CustomQuillViewer(
  controller: _quillController,
  onMentionTap: (entityId, mentionType) async {
    EntityRoute(entityId: entityId).push(context);
  },
  padding: const EdgeInsets.all(16),
)
```

## Entity Types Supported

### @ Mentions (NPCs, Groups, Monsters)
- `npc`: Non-player characters
- `group`: Groups of entities
- `monster`: Monster entities

### # Hashtags (Places, Items, Handouts, Journals)
- `place`: Locations and places
- `item`: Items and equipment
- `handout`: Handouts and documents
- `journal`: Journal entries

## Data Format

Mentions are stored in Quill documents as links with special prefixes:
- Example mention: `@Gandalf` → Link: `-moonforge-mention-entity-{entityId}`
- Example hashtag: `#Rivendell` → Link: `-moonforge-hashtag-entity-{entityId}`

This allows the mention to be:
1. Rendered as formatted text in the editor
2. Stored as structured data (entity ID)
3. Clickable in the viewer to navigate to entity details

## Files Created

1. `/moonforge/lib/core/widgets/quill_mention/quill_mention.dart` - Main export file
2. `/moonforge/lib/core/widgets/quill_mention/quill_mention_constants.dart` - Constants
3. `/moonforge/lib/core/widgets/quill_mention/custom_quill_editor.dart` - Editor with mentions
4. `/moonforge/lib/core/widgets/quill_mention/custom_quill_viewer.dart` - Viewer with mentions
5. `/moonforge/lib/core/widgets/quill_mention/entity_mention_service.dart` - Entity search service
6. `/moonforge/lib/core/widgets/quill_mention/quill_mention_example.dart` - Example usage
7. `/moonforge/lib/core/widgets/quill_mention/README.md` - Feature documentation
8. `/moonforge/test/core/widgets/quill_mention/quill_mention_constants_test.dart` - Unit tests

## Files Modified

1. `/moonforge/lib/features/campaign/views/campaign_edit_screen.dart` - Integrated editor
2. `/moonforge/lib/features/campaign/views/campaign_screen.dart` - Integrated viewer

## Testing

Basic unit tests created for the constants file. The feature can be manually tested by:
1. Creating entities in a campaign
2. Editing campaign content
3. Typing '@' or '#' to see suggestions
4. Selecting entities and saving
5. Viewing the campaign content and clicking on mentions

## Future Enhancements

Potential improvements for future consideration:
- Add fuzzy search for better entity matching
- Support for custom entity icons in the suggestion dropdown
- Keyboard navigation (arrow keys) in the suggestion list
- Caching of entity search results
- Support for mentioning other types of content (sessions, chapters, etc.)
- Rich preview on hover over mentions
