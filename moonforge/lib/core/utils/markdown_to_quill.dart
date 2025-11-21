import 'package:dart_quill_delta/dart_quill_delta.dart' as quill;
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';

/// Converts markdown text to Quill delta format
Map<String, dynamic> markdownToQuillDelta(String markdown) {
  // Configure the markdown parser
  final mdDocument = md.Document(
    encodeHtml: false,
    extensionSet: md.ExtensionSet.gitHubFlavored,
  );

  // Create converter
  final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);

  // Convert markdown to delta
  final delta = mdToDelta.convert(markdown);

  // Return in the format expected by Quill Document.fromJson
  return {'ops': delta.toJson()};
}

/// Converts Quill delta to markdown text
String quillDeltaToMarkdown(Map<String, dynamic> deltaJson) {
  try {
    final deltaToMd = DeltaToMarkdown();

    // Extract ops list from delta JSON
    final ops = deltaJson['ops'] as List?;
    if (ops == null) return '';

    // Create Delta from JSON
    final delta = quill.Delta.fromJson(ops);

    // Convert to markdown
    return deltaToMd.convert(delta);
  } catch (e) {
    // If conversion fails, return empty string
    return '';
  }
}
