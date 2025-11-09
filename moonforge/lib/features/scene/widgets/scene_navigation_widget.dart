import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/scene/controllers/scene_provider.dart';
import 'package:provider/provider.dart';

/// A widget for navigating between scenes (previous/next)
class SceneNavigationWidget extends StatelessWidget {
  const SceneNavigationWidget({
    super.key,
    required this.currentScene,
    this.onNavigate,
  });

  final Scene currentScene;
  final void Function(Scene scene)? onNavigate;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SceneProvider>();
    final theme = Theme.of(context);

    final hasPrevious = provider.hasPrevious();
    final hasNext = provider.hasNext();
    final currentIndex = provider.getCurrentSceneIndex();
    final totalScenes = provider.scenesInAdventure.length;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Previous button
            IconButton.filled(
              onPressed: hasPrevious
                  ? () async {
                      final previousScene = await provider.navigateToPrevious();
                      if (previousScene != null && onNavigate != null) {
                        onNavigate!(previousScene);
                      }
                    }
                  : null,
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Previous scene',
            ),

            const SizedBox(width: 16),

            // Scene position indicator
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentScene.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Scene ${currentIndex + 1} of $totalScenes',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  LinearProgressIndicator(
                    value: totalScenes > 0 ? (currentIndex + 1) / totalScenes : 0,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Next button
            IconButton.filled(
              onPressed: hasNext
                  ? () async {
                      final nextScene = await provider.navigateToNext();
                      if (nextScene != null && onNavigate != null) {
                        onNavigate!(nextScene);
                      }
                    }
                  : null,
              icon: const Icon(Icons.arrow_forward),
              tooltip: 'Next scene',
            ),
          ],
        ),
      ),
    );
  }
}
