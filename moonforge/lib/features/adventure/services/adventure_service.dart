import 'package:moonforge/core/services/base_service.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

/// Service for adventure-related business logic
class AdventureService extends BaseService {
  final AdventureRepository _adventureRepository;
  final SceneRepository _sceneRepository;

  @override
  String get serviceName => 'AdventureService';

  AdventureService(this._adventureRepository, this._sceneRepository);

  /// Get adventure statistics
  Future<AdventureStatistics> getStatistics(String adventureId) async {
    return execute(() async {
      final adventure = await _adventureRepository.getById(adventureId);
      if (adventure == null) {
        return AdventureStatistics(sceneCount: 0, entityCount: 0);
      }

      final scenes = await _sceneRepository.getByAdventure(adventureId);
      final sceneCount = scenes.length;
      final entityCount = adventure.entityIds.length;

      return AdventureStatistics(
        sceneCount: sceneCount,
        entityCount: entityCount,
      );
    }, operationName: 'getStatistics');
  }

  /// Get the next scene in order for navigation
  Future<Scene?> getNextScene(String adventureId, int currentOrder) async {
    return execute(() async {
      final scenes = await _sceneRepository.getByAdventure(adventureId);
      scenes.sort((a, b) => a.order.compareTo(b.order));

      for (final scene in scenes) {
        if (scene.order > currentOrder) {
          return scene;
        }
      }
      return null;
    }, operationName: 'getNextScene');
  }

  /// Get the previous scene in order for navigation
  Future<Scene?> getPreviousScene(String adventureId, int currentOrder) async {
    return execute(() async {
      final scenes = await _sceneRepository.getByAdventure(adventureId);
      scenes.sort((a, b) => b.order.compareTo(a.order));

      for (final scene in scenes) {
        if (scene.order < currentOrder) {
          return scene;
        }
      }
      return null;
    }, operationName: 'getPreviousScene');
  }
}

/// Data class for adventure statistics
class AdventureStatistics {
  final int sceneCount;
  final int entityCount;

  AdventureStatistics({required this.sceneCount, required this.entityCount});
}
