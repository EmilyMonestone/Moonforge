import 'package:moonforge/core/services/base_service.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

/// Service for scene operations and business logic
class SceneService extends BaseService {
  final SceneRepository _repository;

  @override
  String get serviceName => 'SceneService';

  SceneService(this._repository);

  /// Get scenes by adventure
  Future<List<Scene>> getScenesByAdventure(String adventureId) async {
    return execute(() async {
      final scenes = await _repository.getByAdventure(adventureId);
      scenes.sort((a, b) => a.order.compareTo(b.order));
      return scenes;
    }, operationName: 'getScenesByAdventure');
  }

  /// Get a single scene by ID
  Future<Scene?> getSceneById(String sceneId) async {
    return execute(() async {
      return await _repository.getById(sceneId);
    }, operationName: 'getSceneById');
  }

  /// Calculate scene statistics for an adventure
  Future<SceneStatistics> getSceneStatistics(String adventureId) async {
    return execute(() async {
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
    }, operationName: 'getSceneStatistics');
  }

  /// Reorder scenes within an adventure
  Future<void> reorderScenes(String adventureId, List<String> sceneIds) async {
    return execute(() async {
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

      logInfo('Reordered ${sceneIds.length} scenes in adventure $adventureId');
    }, operationName: 'reorderScenes');
  }

  /// Duplicate a scene
  Future<Scene> duplicateScene(Scene original, String newId) async {
    return execute(() async {
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

      logInfo('Duplicated scene ${original.id} to ${duplicate.id}');
      return duplicate;
    }, operationName: 'duplicateScene');
  }

  /// Get the next scene in order
  Future<Scene?> getNextScene(Scene currentScene) async {
    return execute(() async {
      final scenes = await getScenesByAdventure(currentScene.adventureId);
      final currentIndex = scenes.indexWhere((s) => s.id == currentScene.id);

      if (currentIndex >= 0 && currentIndex < scenes.length - 1) {
        return scenes[currentIndex + 1];
      }

      return null;
    }, operationName: 'getNextScene');
  }

  /// Get the previous scene in order
  Future<Scene?> getPreviousScene(Scene currentScene) async {
    return execute(() async {
      final scenes = await getScenesByAdventure(currentScene.adventureId);
      final currentIndex = scenes.indexWhere((s) => s.id == currentScene.id);

      if (currentIndex > 0) {
        return scenes[currentIndex - 1];
      }

      return null;
    }, operationName: 'getPreviousScene');
  }

  /// Calculate the next order number for a new scene
  Future<int> getNextOrder(String adventureId) async {
    return execute(() async {
      final scenes = await getScenesByAdventure(adventureId);
      if (scenes.isEmpty) return 1;

      final maxOrder = scenes
          .map((s) => s.order)
          .reduce((a, b) => a > b ? a : b);
      return maxOrder + 1;
    }, operationName: 'getNextOrder');
  }

  /// Search scenes by name or content
  Future<List<Scene>> searchScenes(String adventureId, String query) async {
    return execute(() async {
      final scenes = await getScenesByAdventure(adventureId);
      final lowerQuery = query.toLowerCase();

      return scenes.where((scene) {
        final nameMatch = scene.name.toLowerCase().contains(lowerQuery);
        final summaryMatch =
            scene.summary?.toLowerCase().contains(lowerQuery) ?? false;
        return nameMatch || summaryMatch;
      }).toList();
    }, operationName: 'searchScenes');
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
