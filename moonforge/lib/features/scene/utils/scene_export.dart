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

  /// Extract read-aloud text from scene content
  static String? extractReadAloudText(Scene scene) {
    if (scene.content == null || scene.content!.isEmpty) return null;

    try {
      final ops = scene.content!['ops'] as List<dynamic>?;
      if (ops == null) return null;

      final buffer = StringBuffer();
      bool inReadAloud = false;

      for (final op in ops) {
        if (op is Map && op.containsKey('insert')) {
          final text = op['insert'];
          final attributes = op['attributes'] as Map<String, dynamic>?;

          // Look for italic text or blockquotes as read-aloud indicators
          if (attributes != null &&
              (attributes.containsKey('italic') ||
                  attributes.containsKey('blockquote'))) {
            if (text is String) {
              buffer.write(text);
              inReadAloud = true;
            }
          } else if (inReadAloud && text is String && text.trim().isEmpty) {
            // End of read-aloud section
            break;
          }
        }
      }

      final result = buffer.toString().trim();
      return result.isNotEmpty ? result : null;
    } catch (e) {
      return null;
    }
  }
}
