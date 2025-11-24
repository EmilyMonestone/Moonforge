import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';

class DmNotesPanel extends StatelessWidget {
  final QuillController controller;

  const DmNotesPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.admin_panel_settings_outlined,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'DM Notes (Private)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
