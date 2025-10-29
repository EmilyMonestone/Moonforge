import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention_constants.dart';

/// Custom Quill viewer with mention click handling.
///
/// Handles clicks on:
/// - '@' mentions (NPC, group, monster)
/// - '#' hashtags (place, item, handout, journal)
class CustomQuillViewer extends StatelessWidget {
  final QuillController controller;
  final Future<void> Function(String entityId, String mentionType)?
  onMentionTap;
  final EdgeInsets? padding;
  final double? maxHeight;
  final double? minHeight;

  const CustomQuillViewer({
    super.key,
    required this.controller,
    this.onMentionTap,
    this.padding,
    this.maxHeight,
    this.minHeight,
  });

  @override
  Widget build(BuildContext context) {
    controller.readOnly = true;
    return QuillEditor.basic(
      controller: controller,
      config: QuillEditorConfig(
        padding: padding ?? EdgeInsets.zero,
        maxHeight: maxHeight,
        minHeight: minHeight,
        showCursor: false,
        customStyles: defaultMentionStyles,
        onLaunchUrl: (string) async {
          await _handleLinkTap(context, string);
        },
      ),
    );
  }

  Future<void> _handleLinkTap(BuildContext context, String url) async {
    try {
      // Check if it's a mention or hashtag
      if (url.contains(prefixMention) || url.contains(prefixHashtag)) {
        String entityId = url
            .replaceAll("https://", "")
            .replaceAll("http://", "");

        if (entityId.startsWith(prefixMention)) {
          entityId = entityId.replaceAll(prefixMention, "");
          if (onMentionTap != null) {
            await onMentionTap!(entityId, 'mention');
          } else {
            _showDefaultDialog(context, 'Mention Clicked', entityId);
          }
          return;
        }

        if (entityId.startsWith(prefixHashtag)) {
          entityId = entityId.replaceAll(prefixHashtag, "");
          if (onMentionTap != null) {
            await onMentionTap!(entityId, 'hashtag');
          } else {
            _showDefaultDialog(context, 'Hashtag Clicked', entityId);
          }
          return;
        }
      }

      // For regular URLs, could open in browser
      // For now, just log
      logger.i('URL clicked: $url');
    } catch (e) {
      logger.e('Error handling link tap: $e');
    }
  }

  void _showDefaultDialog(BuildContext context, String title, String entityId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(
          'Entity ID: $entityId',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
