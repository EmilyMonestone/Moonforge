import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';

/// A widget for drag-to-reorder scenes
class SceneReorderWidget extends StatefulWidget {
  const SceneReorderWidget({
    super.key,
    required this.scenes,
    required this.onReorder,
  });

  final List<Scene> scenes;
  final void Function(List<Scene> reorderedScenes) onReorder;

  @override
  State<SceneReorderWidget> createState() => _SceneReorderWidgetState();
}

class _SceneReorderWidgetState extends State<SceneReorderWidget> {
  late List<Scene> _scenes;

  @override
  void initState() {
    super.initState();
    _scenes = List.from(widget.scenes);
    _scenes.sort((a, b) => a.order.compareTo(b.order));
  }

  @override
  void didUpdateWidget(SceneReorderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scenes != oldWidget.scenes) {
      _scenes = List.from(widget.scenes);
      _scenes.sort((a, b) => a.order.compareTo(b.order));
    }
  }

  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      // Adjust newIndex if moving down
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      // Remove and insert the item
      final scene = _scenes.removeAt(oldIndex);
      _scenes.insert(newIndex, scene);

      // Notify parent of the reorder
      widget.onReorder(_scenes);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_scenes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No scenes to reorder',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return ReorderableListView.builder(
      itemCount: _scenes.length,
      onReorder: _handleReorder,
      buildDefaultDragHandles: true,
      itemBuilder: (context, index) {
        final scene = _scenes[index];
        return Card(
          key: ValueKey(scene.id),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(
              scene.name,
              style: theme.textTheme.titleSmall,
            ),
            subtitle: scene.summary != null && scene.summary!.isNotEmpty
                ? Text(
                    scene.summary!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  )
                : null,
            trailing: ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            ),
          ),
        );
      },
    );
  }
}
