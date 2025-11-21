import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

/// Service for scene operations and business logic
class SceneService {
  final SceneRepository _repository;

  SceneService(this._repository);

  /// Get scenes by adventure
  Future<List<Scene>> getScenesByAdventure(String adventureId) async {
    try {
      final scenes = await _repository.getByAdventure(adventureId);
      scenes.sort((a, b) => a.order.compareTo(b.order));
      return scenes;
    } catch (e) {
      logger.e('Error getting scenes by adventure: $e');
      rethrow;
    }
  }

  /// Get a single scene by ID
  Future<Scene?> getSceneById(String sceneId) async {
    try {
      return await _repository.getById(sceneId);
    } catch (e) {
      logger.e('Error getting scene by ID: $e');
      rethrow;
    }
  }

  /// Calculate scene statistics for an adventure
  Future<SceneStatistics> getSceneStatistics(String adventureId) async {
    try {
      final scenes = await getScenesByAdventure(adventureId);

      final totalScenes = scenes.length;
      final completedScenes = 0; // TODO: Implement completion tracking
      final totalDuration = Duration.zero; // TODO: Implement duration tracking

      return SceneStatistics(
        totalScenes: totalScenes,
        completedScenes: completedScenes,
        remainingScenes: totalScenes - completedScenes,
        estimatedDuration: totalDuration,
      );
    } catch (e) {
      logger.e('Error calculating scene statistics: $e');
      rethrow;
    }
  }

  /// Reorder scenes within an adventure
  Future<void> reorderScenes(String adventureId, List<String> sceneIds) async {
    try {
      final scenes = await _repository.getByAdventure(adventureId);

      // Create a map of scene ID to scene
      final sceneMap = {for (var s in scenes) s.id: s};

      // Update order for each scene
      for (var i = 0; i < sceneIds.length; i++) {
        final sceneId = sceneIds[i];
        final scene = sceneMap[sceneId];

        if (scene != null && scene.order != i + 1) {
          final updatedScene = scene.copyWith(order: i + 1, rev: scene.rev + 1);
          await _repository.update(updatedScene);
        }
      }

      logger.i('Reordered ${sceneIds.length} scenes in adventure $adventureId');
    } catch (e) {
      logger.e('Error reordering scenes: $e');
      rethrow;
    }
  }

  /// Duplicate a scene
  Future<Scene> duplicateScene(Scene original, String newId) async {
    try {
      final duplicate = Scene(
        id: newId,
        adventureId: original.adventureId,
        name: '${original.name} (Copy)',
        order: original.order + 1,
        summary: original.summary,
        content: original.content,
        entityIds: original.entityIds,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 0,
      );

      await _repository.create(duplicate);

      // Adjust order of subsequent scenes
      final scenes = await getScenesByAdventure(original.adventureId);
      final scenesToUpdate = scenes.where(
        (s) => s.order > original.order && s.id != duplicate.id,
      );

      for (final scene in scenesToUpdate) {
        final updated = scene.copyWith(
          order: scene.order + 1,
          rev: scene.rev + 1,
        );
        await _repository.update(updated);
      }

      logger.i('Duplicated scene ${original.id} to ${duplicate.id}');
      return duplicate;
    } catch (e) {
      logger.e('Error duplicating scene: $e');
      rethrow;
    }
  }

  /// Get the next scene in order
  Future<Scene?> getNextScene(Scene currentScene) async {
    try {
      final scenes = await getScenesByAdventure(currentScene.adventureId);
      final currentIndex = scenes.indexWhere((s) => s.id == currentScene.id);

      if (currentIndex >= 0 && currentIndex < scenes.length - 1) {
        return scenes[currentIndex + 1];
      }

      return null;
    } catch (e) {
      logger.e('Error getting next scene: $e');
      rethrow;
    }
  }

  /// Get the previous scene in order
  Future<Scene?> getPreviousScene(Scene currentScene) async {
    try {
      final scenes = await getScenesByAdventure(currentScene.adventureId);
      final currentIndex = scenes.indexWhere((s) => s.id == currentScene.id);

      if (currentIndex > 0) {
        return scenes[currentIndex - 1];
      }

      return null;
    } catch (e) {
      logger.e('Error getting previous scene: $e');
      rethrow;
    }
  }

  /// Calculate the next order number for a new scene
  Future<int> getNextOrder(String adventureId) async {
    try {
      final scenes = await getScenesByAdventure(adventureId);
      if (scenes.isEmpty) return 1;

      final maxOrder = scenes
          .map((s) => s.order)
          .reduce((a, b) => a > b ? a : b);
      return maxOrder + 1;
    } catch (e) {
      logger.e('Error getting next order: $e');
      rethrow;
    }
  }

  /// Search scenes by name or content
  Future<List<Scene>> searchScenes(String adventureId, String query) async {
    try {
      final scenes = await getScenesByAdventure(adventureId);
      final lowerQuery = query.toLowerCase();

      return scenes.where((scene) {
        final nameMatch = scene.name.toLowerCase().contains(lowerQuery);
        final summaryMatch =
            scene.summary?.toLowerCase().contains(lowerQuery) ?? false;
        return nameMatch || summaryMatch;
      }).toList();
    } catch (e) {
      logger.e('Error searching scenes: $e');
      rethrow;
    }
  }
}

/// Scene statistics data class
class SceneStatistics {
  final int totalScenes;
  final int completedScenes;
  final int remainingScenes;
  final Duration estimatedDuration;

  SceneStatistics({
    required this.totalScenes,
    required this.completedScenes,
    required this.remainingScenes,
    required this.estimatedDuration,
  });

  double get completionPercentage {
    if (totalScenes == 0) return 0.0;
    return (completedScenes / totalScenes) * 100;
  }
}
