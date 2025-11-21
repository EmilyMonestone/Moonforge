import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/features/scene/services/scene_template_service.dart';
import 'package:moonforge/features/scene/utils/scene_templates.dart';

/// Screen for browsing and applying scene templates
class SceneTemplatesView extends StatelessWidget {
  const SceneTemplatesView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SceneTemplates.getAllTemplates();
    final templatesByCategory = SceneTemplates.getTemplatesByCategory();

    return SurfaceContainer(
      title: Text('Scene Templates', style: theme.textTheme.displaySmall),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Choose a template to quickly create a scene with pre-filled content.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...templatesByCategory.entries.map((entry) {
            final category = entry.key;
            final categoryTemplates = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    category,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...categoryTemplates.map((template) {
                  return _TemplateCard(template: template);
                }),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template});

  final SceneTemplate template;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayIcon = SceneTemplates.getDisplayIcon(template.icon);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          _showTemplatePreview(context);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    displayIcon,
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Template info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      template.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Action button
              IconButton(
                icon: const Icon(Icons.visibility_outlined),
                onPressed: () => _showTemplatePreview(context),
                tooltip: 'Preview template',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTemplatePreview(BuildContext context) {
    final theme = Theme.of(context);
    final displayIcon = SceneTemplates.getDisplayIcon(template.icon);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(displayIcon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(template.name, style: theme.textTheme.titleLarge),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                template.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Default Summary:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(template.defaultSummary, style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              Text(
                'Template Content Preview:',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _extractPreviewText(template.defaultContent),
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              // Note: Template application requires navigation context
              // which should be implemented when adding routes to app_router.dart
              // User can create a scene from template via the scene creation flow
            },
            icon: const Icon(Icons.add),
            label: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _extractPreviewText(Map<String, dynamic> content) {
    try {
      final ops = content['ops'] as List<dynamic>?;
      if (ops == null) return 'No content preview available';

      final buffer = StringBuffer();
      for (final op in ops) {
        if (op is Map && op.containsKey('insert')) {
          final text = op['insert'];
          if (text is String) {
            buffer.write(text);
          }
        }
      }

      final preview = buffer.toString().trim();
      if (preview.length > 300) {
        return '${preview.substring(0, 300)}...';
      }
      return preview;
    } catch (e) {
      return 'Content preview not available';
    }
  }
}
