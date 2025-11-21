import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/features/scene/widgets/scene_card.dart';
import 'package:provider/provider.dart';

/// A widget that displays a list of scenes for an adventure
class SceneList extends StatefulWidget {
  const SceneList({
    super.key,
    required this.adventureId,
    this.onSceneTap,
    this.onSceneEdit,
    this.onSceneDelete,
    this.emptyMessage = 'No scenes yet',
    this.showOrder = true,
  });

  final String adventureId;
  final void Function(Scene scene)? onSceneTap;
  final void Function(Scene scene)? onSceneEdit;
  final void Function(Scene scene)? onSceneDelete;
  final String emptyMessage;
  final bool showOrder;

  @override
  State<SceneList> createState() => _SceneListState();
}

class _SceneListState extends State<SceneList> {
  @override
  Widget build(BuildContext context) {
    final sceneRepo = context.watch<SceneRepository>();

    return StreamBuilder<List<Scene>>(
      stream: sceneRepo.watchByAdventure(widget.adventureId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading scenes',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${snapshot.error}',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final scenes = snapshot.data ?? [];

        if (scenes.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.movie_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.emptyMessage,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: scenes.length,
          itemBuilder: (context, index) {
            final scene = scenes[index];
            return SceneCard(
              scene: scene,
              showOrder: widget.showOrder,
              onTap: widget.onSceneTap != null
                  ? () => widget.onSceneTap!(scene)
                  : null,
              onEdit: widget.onSceneEdit != null
                  ? () => widget.onSceneEdit!(scene)
                  : null,
              onDelete: widget.onSceneDelete != null
                  ? () => widget.onSceneDelete!(scene)
                  : null,
            );
          },
        );
      },
    );
  }
}
