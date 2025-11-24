import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';

class SessionLogPanel extends StatelessWidget {
  final QuillController controller;

  const SessionLogPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.article_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Text('Session Log', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        CustomQuillViewer(
          controller: controller,
          onMentionTap: (entityId, mentionType) async {
            EntityRouteData(entityId: entityId).push(context);
          },
        ),
      ],
    );
  }
}
