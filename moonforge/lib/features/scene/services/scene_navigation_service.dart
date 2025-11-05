import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

/// Service for managing scene navigation and progression
class SceneNavigationService {
  final SceneRepository _repository;
  final List<String> _sceneHistory = [];
  int _currentHistoryIndex = -1;

  SceneNavigationService(this._repository);

  /// Get the scene history
  List<String> get history => List.unmodifiable(_sceneHistory);

  /// Get the current position in history
  int get currentHistoryIndex => _currentHistoryIndex;

  /// Navigate to a scene and add it to history
  Future<void> navigateToScene(String sceneId) async {
    try {
      // Remove any forward history if we're not at the end
      if (_currentHistoryIndex < _sceneHistory.length - 1) {
        _sceneHistory.removeRange(
          _currentHistoryIndex + 1,
          _sceneHistory.length,
        );
      }

      // Add the new scene to history
      _sceneHistory.add(sceneId);
      _currentHistoryIndex = _sceneHistory.length - 1;

      logger.i('Navigated to scene $sceneId (history index: $_currentHistoryIndex)');
    } catch (e) {
      logger.e('Error navigating to scene: $e');
      rethrow;
    }
  }

  /// Navigate back in history
  Future<String?> navigateBack() async {
    if (!canNavigateBack()) return null;

    _currentHistoryIndex--;
    final sceneId = _sceneHistory[_currentHistoryIndex];
    logger.i('Navigated back to scene $sceneId (history index: $_currentHistoryIndex)');
    return sceneId;
  }

  /// Navigate forward in history
  Future<String?> navigateForward() async {
    if (!canNavigateForward()) return null;

    _currentHistoryIndex++;
    final sceneId = _sceneHistory[_currentHistoryIndex];
    logger.i('Navigated forward to scene $sceneId (history index: $_currentHistoryIndex)');
    return sceneId;
  }

  /// Check if we can navigate back
  bool canNavigateBack() {
    return _currentHistoryIndex > 0;
  }

  /// Check if we can navigate forward
  bool canNavigateForward() {
    return _currentHistoryIndex < _sceneHistory.length - 1;
  }

  /// Clear the navigation history
  void clearHistory() {
    _sceneHistory.clear();
    _currentHistoryIndex = -1;
    logger.i('Cleared scene navigation history');
  }

  /// Get the current scene ID from history
  String? getCurrentSceneId() {
    if (_currentHistoryIndex >= 0 && _currentHistoryIndex < _sceneHistory.length) {
      return _sceneHistory[_currentHistoryIndex];
    }
    return null;
  }

  /// Track scene progression through an adventure
  Future<SceneProgression> getProgression(String adventureId) async {
    try {
      final scenes = await _repository.getByAdventure(adventureId);
      scenes.sort((a, b) => a.order.compareTo(b.order));

      // Find scenes that appear in history
      final visitedSceneIds = _sceneHistory.toSet();
      final visitedScenes = scenes.where(
        (s) => visitedSceneIds.contains(s.id),
      ).toList();

      // Calculate progression
      final totalScenes = scenes.length;
      final visitedCount = visitedScenes.length;
      final currentSceneId = getCurrentSceneId();
      
      Scene? currentScene;
      if (currentSceneId != null) {
        final sceneIndex = scenes.indexWhere((s) => s.id == currentSceneId);
        if (sceneIndex >= 0) {
          currentScene = scenes[sceneIndex];
        }
      }

      return SceneProgression(
        totalScenes: totalScenes,
        visitedScenes: visitedCount,
        currentScene: currentScene,
        scenes: scenes,
      );
    } catch (e) {
      logger.e('Error getting scene progression: $e');
      rethrow;
    }
  }

  /// Get the next unvisited scene in order
  Future<Scene?> getNextUnvisitedScene(String adventureId) async {
    try {
      final scenes = await _repository.getByAdventure(adventureId);
      scenes.sort((a, b) => a.order.compareTo(b.order));

      final visitedSceneIds = _sceneHistory.toSet();

      // Find the first unvisited scene
      for (final scene in scenes) {
        if (!visitedSceneIds.contains(scene.id)) {
          return scene;
        }
      }

      return null; // All scenes visited
    } catch (e) {
      logger.e('Error getting next unvisited scene: $e');
      rethrow;
    }
  }

  /// Check if a scene has been visited
  bool hasVisited(String sceneId) {
    return _sceneHistory.contains(sceneId);
  }

  /// Get visit count for a scene
  int getVisitCount(String sceneId) {
    return _sceneHistory.where((id) => id == sceneId).length;
  }
}

/// Scene progression data class
class SceneProgression {
  final int totalScenes;
  final int visitedScenes;
  final Scene? currentScene;
  final List<Scene> scenes;

  SceneProgression({
    required this.totalScenes,
    required this.visitedScenes,
    required this.currentScene,
    required this.scenes,
  });

  int get remainingScenes => totalScenes - visitedScenes;

  double get progressPercentage {
    if (totalScenes == 0) return 0.0;
    return (visitedScenes / totalScenes) * 100;
  }

  int? get currentSceneOrder => currentScene?.order;

  bool get isComplete => visitedScenes >= totalScenes;
}
