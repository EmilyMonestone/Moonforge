import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

// Prefix for hashtag links (for place | item | handout | journal)
const String prefixHashtag = "-moonforge-hashtag-entity-";

// Prefix for mention links (for NPC | group | monster)
const String prefixMention = "-moonforge-mention-entity-";

final defaultMentionStyles = DefaultStyles(
  link: const TextStyle().copyWith(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  ),
);

final mentionElementOptions = const QuillEditorElementOptions(
  orderedList: QuillEditorOrderedListElementOptions(),
  unorderedList: QuillEditorUnOrderedListElementOptions(),
  codeBlock: QuillEditorCodeBlockElementOptions(
    enableLineNumbers: true,
  ),
);
