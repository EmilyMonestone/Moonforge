import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

/// Service for adventure-related business logic
class AdventureService {
  final AdventureRepository _adventureRepository;
  final SceneRepository _sceneRepository;

  AdventureService(this._adventureRepository, this._sceneRepository);

  /// Calculate adventure progress based on completed scenes
  Future<AdventureProgress> calculateProgress(String adventureId) async {
    final adventure = await _adventureRepository.getById(adventureId);
    if (adventure == null) {
      return AdventureProgress(
        totalScenes: 0,
        completedScenes: 0,
        percentage: 0.0,
      );
    }

    final scenes = await _sceneRepository.getByAdventure(adventureId);
    final totalScenes = scenes.length;

    // For now, consider a scene "completed" if it has been updated
    // This can be extended with more sophisticated completion tracking
    final completedScenes = scenes.where((s) => s.updatedAt != null).length;

    final percentage = totalScenes > 0 ? (completedScenes / totalScenes) : 0.0;

    return AdventureProgress(
      totalScenes: totalScenes,
      completedScenes: completedScenes,
      percentage: percentage,
    );
  }

  /// Get adventure statistics
  Future<AdventureStatistics> getStatistics(String adventureId) async {
    final adventure = await _adventureRepository.getById(adventureId);
    if (adventure == null) {
      return AdventureStatistics(
        sceneCount: 0,
        entityCount: 0,
        estimatedPlayTimeMinutes: 0,
      );
    }

    final scenes = await _sceneRepository.getByAdventure(adventureId);
    final sceneCount = scenes.length;
    final entityCount = adventure.entityIds.length;

    // Estimate play time: ~30 minutes per scene
    final estimatedPlayTimeMinutes = sceneCount * 30;

    return AdventureStatistics(
      sceneCount: sceneCount,
      entityCount: entityCount,
      estimatedPlayTimeMinutes: estimatedPlayTimeMinutes,
    );
  }

  /// Get the next scene in order for navigation
  Future<Scene?> getNextScene(String adventureId, int currentOrder) async {
    final scenes = await _sceneRepository.getByAdventure(adventureId);
    scenes.sort((a, b) => a.order.compareTo(b.order));

    for (final scene in scenes) {
      if (scene.order > currentOrder) {
        return scene;
      }
    }
    return null;
  }

  /// Get the previous scene in order for navigation
  Future<Scene?> getPreviousScene(String adventureId, int currentOrder) async {
    final scenes = await _sceneRepository.getByAdventure(adventureId);
    scenes.sort((a, b) => b.order.compareTo(a.order));

    for (final scene in scenes) {
      if (scene.order < currentOrder) {
        return scene;
      }
    }
    return null;
  }
}

/// Data class for adventure progress
class AdventureProgress {
  final int totalScenes;
  final int completedScenes;
  final double percentage;

  AdventureProgress({
    required this.totalScenes,
    required this.completedScenes,
    required this.percentage,
  });
}

/// Data class for adventure statistics
class AdventureStatistics {
  final int sceneCount;
  final int entityCount;
  final int estimatedPlayTimeMinutes;

  AdventureStatistics({
    required this.sceneCount,
    required this.entityCount,
    required this.estimatedPlayTimeMinutes,
  });
}
