import 'package:flutter/material.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

/// Provider for managing scene state and navigation
class SceneProvider with ChangeNotifier {
  static const String _currentSceneKey = 'current_scene_id';
  final PersistenceService _persistence = PersistenceService();
  final SceneRepository _sceneRepository;

  Scene? _currentScene;
  List<Scene> _scenesInAdventure = [];
  bool _isCompleted = false;

  Scene? get currentScene => _currentScene;
  List<Scene> get scenesInAdventure => _scenesInAdventure;
  bool get isCompleted => _isCompleted;

  SceneProvider(this._sceneRepository) {
    _loadPersistedSceneId();
  }

  /// Load the persisted scene ID on initialization
  void _loadPersistedSceneId() {
    try {
      final sceneId = _persistence.read<String>(_currentSceneKey);
      if (sceneId != null) {
        logger.i('Loaded persisted scene ID: $sceneId');
      }
    } catch (e) {
      logger.e('Failed to load persisted scene ID: $e');
    }
  }

  /// Get the persisted scene ID
  String? getPersistedSceneId() {
    return _persistence.read<String>(_currentSceneKey);
  }

  /// Set the current scene
  Future<void> setCurrentScene(Scene? scene) async {
    _currentScene = scene;

    // Persist the scene ID
    if (scene != null) {
      _persistence.write(_currentSceneKey, scene.id);
      logger.i('Persisted scene ID: ${scene.id}');

      // Load scenes in the same adventure for navigation
      await _loadScenesInAdventure(scene.adventureId);

      // Check completion status
      _isCompleted = _checkSceneCompletion(scene);
    } else {
      _persistence.remove(_currentSceneKey);
      _scenesInAdventure = [];
      _isCompleted = false;
      logger.i('Removed persisted scene ID');
    }

    notifyListeners();
  }

  /// Load all scenes in the current adventure
  Future<void> _loadScenesInAdventure(String adventureId) async {
    try {
      _scenesInAdventure = await _sceneRepository.getByAdventure(adventureId);
      _scenesInAdventure.sort((a, b) => a.order.compareTo(b.order));
    } catch (e) {
      logger.e('Failed to load scenes in adventure: $e');
      _scenesInAdventure = [];
    }
  }

  /// Navigate to the previous scene in order
  Future<Scene?> navigateToPrevious() async {
    if (_currentScene == null || _scenesInAdventure.isEmpty) return null;

    final currentIndex = _scenesInAdventure.indexWhere(
      (s) => s.id == _currentScene!.id,
    );

    if (currentIndex > 0) {
      final previousScene = _scenesInAdventure[currentIndex - 1];
      await setCurrentScene(previousScene);
      return previousScene;
    }

    return null; // No previous scene
  }

  /// Navigate to the next scene in order
  Future<Scene?> navigateToNext() async {
    if (_currentScene == null || _scenesInAdventure.isEmpty) return null;

    final currentIndex = _scenesInAdventure.indexWhere(
      (s) => s.id == _currentScene!.id,
    );

    if (currentIndex >= 0 && currentIndex < _scenesInAdventure.length - 1) {
      final nextScene = _scenesInAdventure[currentIndex + 1];
      await setCurrentScene(nextScene);
      return nextScene;
    }

    return null; // No next scene
  }

  /// Check if there is a previous scene
  bool hasPrevious() {
    if (_currentScene == null || _scenesInAdventure.isEmpty) return false;

    final currentIndex = _scenesInAdventure.indexWhere(
      (s) => s.id == _currentScene!.id,
    );

    return currentIndex > 0;
  }

  /// Check if there is a next scene
  bool hasNext() {
    if (_currentScene == null || _scenesInAdventure.isEmpty) return false;

    final currentIndex = _scenesInAdventure.indexWhere(
      (s) => s.id == _currentScene!.id,
    );

    return currentIndex >= 0 && currentIndex < _scenesInAdventure.length - 1;
  }

  /// Get the current scene's position in the adventure
  int getCurrentSceneIndex() {
    if (_currentScene == null || _scenesInAdventure.isEmpty) return -1;

    return _scenesInAdventure.indexWhere((s) => s.id == _currentScene!.id);
  }

  /// Toggle scene completion status
  void toggleCompletion() {
    _isCompleted = !_isCompleted;
    notifyListeners();
  }

  /// Mark scene as completed
  void markCompleted() {
    _isCompleted = true;
    notifyListeners();
  }

  /// Mark scene as incomplete
  void markIncomplete() {
    _isCompleted = false;
    notifyListeners();
  }

  /// Check if a scene is completed (placeholder logic)
  bool _checkSceneCompletion(Scene scene) {
    // TODO: Implement actual completion tracking
    // This could check a completion status field or external tracking
    return false;
  }

  /// Clear the persisted scene
  void clearPersistedScene() {
    _persistence.remove(_currentSceneKey);
    _currentScene = null;
    _scenesInAdventure = [];
    _isCompleted = false;
    notifyListeners();
  }

  /// Reload scenes in the current adventure
  Future<void> reloadScenes() async {
    if (_currentScene != null) {
      await _loadScenesInAdventure(_currentScene!.adventureId);
      notifyListeners();
    }
  }
}
