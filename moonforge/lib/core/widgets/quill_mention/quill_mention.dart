/// Custom Quill editor and viewer with mention support for Moonforge entities.
///
/// Provides:
/// - [CustomQuillEditor]: Editor with '@' and '#' mention autocomplete
/// - [CustomQuillViewer]: Viewer with clickable mention links
/// - [EntityMentionService]: Service for fetching entities
/// - [prefixHashtag] and [prefixMention]: Constants for link prefixes
library;

export 'custom_quill_editor.dart';
export 'custom_quill_viewer.dart';
export 'quill_mention_constants.dart';
export 'entity_mention_service.dart';
