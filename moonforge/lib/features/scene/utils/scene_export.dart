import 'dart:convert';

import 'package:moonforge/data/db/app_db.dart';

/// Utilities for exporting scene content
class SceneExport {
  SceneExport._();

  /// Export a scene to markdown format
  static String toMarkdown(Scene scene) {
    final buffer = StringBuffer();

    // Title
    buffer.writeln('# ${scene.name}');
    buffer.writeln();

    // Order
    buffer.writeln('**Scene Order:** ${scene.order}');
    buffer.writeln();

    // Summary
    if (scene.summary != null && scene.summary!.isNotEmpty) {
      buffer.writeln('## Summary');
      buffer.writeln(scene.summary);
      buffer.writeln();
    }

    // Content
    if (scene.content != null && scene.content!.isNotEmpty) {
      buffer.writeln('## Content');
      buffer.writeln();

      // Try to extract plain text from Quill delta
      try {
        final ops = scene.content!['ops'] as List<dynamic>?;
        if (ops != null) {
          for (final op in ops) {
            if (op is Map && op.containsKey('insert')) {
              final text = op['insert'];
              if (text is String) {
                buffer.write(text);
              }
            }
          }
        }
      } catch (e) {
        buffer.writeln('_Content not available_');
      }
      buffer.writeln();
    }

    // Metadata
    buffer.writeln('---');
    buffer.writeln();
    buffer.writeln('**Adventure ID:** ${scene.adventureId}');
    buffer.writeln('**Scene ID:** ${scene.id}');
    if (scene.createdAt != null) {
      buffer.writeln('**Created:** ${scene.createdAt}');
    }
    if (scene.updatedAt != null) {
      buffer.writeln('**Updated:** ${scene.updatedAt}');
    }

    return buffer.toString();
  }

  /// Export a scene to JSON format
  static String toJson(Scene scene) {
    final map = {
      'id': scene.id,
      'adventureId': scene.adventureId,
      'name': scene.name,
      'order': scene.order,
      'summary': scene.summary,
      'content': scene.content,
      'entityIds': scene.entityIds,
      'createdAt': scene.createdAt?.toIso8601String(),
      'updatedAt': scene.updatedAt?.toIso8601String(),
      'rev': scene.rev,
    };

    return const JsonEncoder.withIndent('  ').convert(map);
  }

  /// Export a scene to plain text format
  static String toPlainText(Scene scene) {
    final buffer = StringBuffer();

    buffer.writeln(scene.name);
    buffer.writeln('=' * scene.name.length);
    buffer.writeln();

    if (scene.summary != null && scene.summary!.isNotEmpty) {
      buffer.writeln(scene.summary);
      buffer.writeln();
    }

    // Extract plain text from content
    if (scene.content != null && scene.content!.isNotEmpty) {
      try {
        final ops = scene.content!['ops'] as List<dynamic>?;
        if (ops != null) {
          for (final op in ops) {
            if (op is Map && op.containsKey('insert')) {
              final text = op['insert'];
              if (text is String) {
                buffer.write(text);
              }
            }
          }
        }
      } catch (e) {
        buffer.writeln('Content not available');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// Export multiple scenes to markdown
  static String exportMultipleScenesMarkdown(
    List<Scene> scenes, {
    String? adventureTitle,
  }) {
    final buffer = StringBuffer();

    if (adventureTitle != null) {
      buffer.writeln('# $adventureTitle');
      buffer.writeln();
    }

    buffer.writeln('## Scenes');
    buffer.writeln();

    final sortedScenes = List<Scene>.from(scenes);
    sortedScenes.sort((a, b) => a.order.compareTo(b.order));

    for (final scene in sortedScenes) {
      buffer.writeln('---');
      buffer.writeln();
      buffer.writeln(toMarkdown(scene));
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// Export scenes to JSON array
  static String exportMultipleScenesJson(List<Scene> scenes) {
    final sortedScenes = List<Scene>.from(scenes);
    sortedScenes.sort((a, b) => a.order.compareTo(b.order));

    final list = sortedScenes.map((scene) {
      return {
        'id': scene.id,
        'adventureId': scene.adventureId,
        'name': scene.name,
        'order': scene.order,
        'summary': scene.summary,
        'content': scene.content,
        'entityIds': scene.entityIds,
        'createdAt': scene.createdAt?.toIso8601String(),
        'updatedAt': scene.updatedAt?.toIso8601String(),
        'rev': scene.rev,
      };
    }).toList();

    return const JsonEncoder.withIndent('  ').convert(list);
  }

  /// Extract read-aloud texts from scene content.
  ///
  /// Returns a list of strings, one per detected quote block. Detection follows
  /// Quill Delta semantics: block-level quote is represented by an op with
  /// `insert: "\n"` and attributes containing either `blockquote: true` or
  /// `quote: true`. Consecutive quoted lines are merged into a single string.
  static List<String> extractReadAloudText(Scene scene) {
    if (scene.content == null || scene.content!.isEmpty) return const [];

    try {
      final ops = scene.content!['ops'] as List<dynamic>?;
      if (ops == null) return const [];

      final results = <String>[];
      final currentLine = StringBuffer();
      StringBuffer? currentQuoteBlock; // Accumulates consecutive quote lines
      bool inQuote = false;

      for (final op in ops) {
        if (op is! Map || !op.containsKey('insert')) continue;

        final insert = op['insert'];
        final attributes = (op['attributes'] as Map?)?.cast<String, dynamic>();

        // Case 1: explicit line-break op (Quill's usual for block attributes)
        if (insert is String && insert == '\n') {
          final isQuote =
              attributes != null &&
              (attributes['blockquote'] == true || attributes['quote'] == true);

          final lineText = currentLine.toString();
          if (isQuote) {
            // Start or continue a quote block
            currentQuoteBlock ??= StringBuffer();
            if (currentQuoteBlock.isNotEmpty) currentQuoteBlock.write('\n');
            currentQuoteBlock.write(lineText);
            inQuote = true;
          } else {
            // Finish any open quote block before moving on
            if (inQuote && currentQuoteBlock != null) {
              final text = currentQuoteBlock.toString().trim();
              if (text.isNotEmpty) results.add(text);
            }
            currentQuoteBlock = null;
            inQuote = false;
          }

          // Reset for next line
          currentLine.clear();
          continue;
        }

        // Case 2: regular text segment (may contain raw newlines, be defensive)
        if (insert is String) {
          final text = insert.replaceAll('\r\n', '\n');
          // If text contains newlines, split and simulate line-break handling
          if (text.contains('\n')) {
            final parts = text.split('\n');
            for (var i = 0; i < parts.length; i++) {
              currentLine.write(parts[i]);
              if (i < parts.length - 1) {
                // We hit a newline without explicit block attributes.
                // Treat as a normal (non-quote) line break.
                if (inQuote && currentQuoteBlock != null) {
                  final blockText = currentQuoteBlock.toString().trim();
                  if (blockText.isNotEmpty) results.add(blockText);
                }
                currentQuoteBlock = null;
                inQuote = false;
                currentLine.clear();
              }
            }
          } else {
            currentLine.write(text);
          }
        }
        // Non-string inserts (embeds) are ignored for read-aloud extraction
      }

      // Flush any trailing quote block (if content didn't end with a newline op)
      if (inQuote && currentQuoteBlock != null) {
        final text = currentQuoteBlock.toString().trim();
        if (text.isNotEmpty) results.add(text);
      }

      return results;
    } catch (e) {
      return const [];
    }
  }
}
