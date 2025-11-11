import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/quill_mention/quill_mention.dart';
import 'package:moonforge/core/widgets/quill_toolbar.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:provider/provider.dart';

/// Example screen demonstrating the Quill mention feature.
///
/// This example shows:
/// - How to set up the CustomQuillEditor with mention support
/// - How to integrate entity search
/// - How to set up the CustomQuillViewer with click handling
/// - How to navigate to entity details when mentions are clicked
class QuillMentionExampleScreen extends StatefulWidget {
  const QuillMentionExampleScreen({super.key, required this.campaignId});

  final String campaignId;

  @override
  State<QuillMentionExampleScreen> createState() =>
      _QuillMentionExampleScreenState();
}

class _QuillMentionExampleScreenState extends State<QuillMentionExampleScreen> {
  final GlobalKey _editorKey = GlobalKey();
  final QuillController _editorController = QuillController.basic();
  final QuillController _viewerController = QuillController.basic();

  @override
  void dispose() {
    _editorController.dispose();
    _viewerController.dispose();
    super.dispose();
  }

  void _copyToViewer() {
    setState(() {
      _viewerController.document = _editorController.document;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Quill Mention Feature Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How to use:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInstructionItem(
                      'Type "@" to mention NPCs, groups, or monsters',
                    ),
                    _buildInstructionItem(
                      'Type "#" to reference places, items, handouts, or journals',
                    ),
                    _buildInstructionItem(
                      'Select an entity from the dropdown or press Enter',
                    ),
                    _buildInstructionItem(
                      'Click "Copy to Viewer" to see the result',
                    ),
                    _buildInstructionItem(
                      'Click on mentions in the viewer to navigate to entity details',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Editor Section
            Text(
              'Editor',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: QuillCustomToolbar(controller: _editorController),
            ),
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
              child: CustomQuillEditor(
                controller: _editorController,
                keyForPosition: _editorKey,
                onSearchEntities: (kind, query) async {
                  // Fetch entities from the database via repository-backed service
                  final entityRepo = context.read<EntityRepository>();
                  final service = EntityMentionService(
                    entityRepository: entityRepo,
                  );
                  return await service.searchEntities(
                    campaignId: widget.campaignId,
                    kinds: kind,
                    query: query,
                    limit: 10,
                  );
                },
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),

            // Copy button
            Center(
              child: ElevatedButton.icon(
                onPressed: _copyToViewer,
                icon: const Icon(Icons.refresh),
                label: const Text('Copy to Viewer'),
              ),
            ),
            const SizedBox(height: 24),

            // Viewer Section
            Text(
              'Viewer (click on mentions to navigate)',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              constraints: const BoxConstraints(minHeight: 200),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomQuillViewer(
                controller: _viewerController,
                onMentionTap: (entityId, mentionType) async {
                  // Navigate to entity details
                  EntityRouteData(entityId: entityId).push(context);
                },
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
