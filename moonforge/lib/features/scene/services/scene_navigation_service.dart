import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:moonforge/core/services/base_service.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

/// Service for managing scene navigation and progression
class SceneNavigationService extends BaseService {
  final SceneRepository _repository;
  final AdventureRepository _adventureRepository;
  final List<String> _sceneHistory = [];
  int _currentHistoryIndex = -1;
  final _stateController = StreamController<SceneNavState>.broadcast();

  @override
  String get serviceName => 'SceneNavigationService';

  SceneNavigationService({
    required SceneRepository sceneRepository,
    required AdventureRepository adventureRepository,
  }) : _repository = sceneRepository,
       _adventureRepository = adventureRepository;

  /// Get the scene history
  List<String> get history => List.unmodifiable(_sceneHistory);

  /// Get the current position in history
  int get currentHistoryIndex => _currentHistoryIndex;

  /// Navigate to a scene and add it to history
  Future<void> navigateToScene(String sceneId) async {
    return execute(() async {
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
      await _emitState();

      logInfo(
        'Navigated to scene $sceneId (history index: $_currentHistoryIndex)',
      );
    }, operationName: 'navigateToScene');
  }

  /// Navigate back in history
  Future<String?> navigateBack() async {
    if (!canNavigateBack()) return null;

    _currentHistoryIndex--;
    final sceneId = _sceneHistory[_currentHistoryIndex];
    await _emitState();
    logInfo(
      'Navigated back to scene $sceneId (history index: $_currentHistoryIndex)',
    );
    return sceneId;
  }

  /// Navigate forward in history
  Future<String?> navigateForward() async {
    if (!canNavigateForward()) return null;

    _currentHistoryIndex++;
    final sceneId = _sceneHistory[_currentHistoryIndex];
    await _emitState();
    logInfo(
      'Navigated forward to scene $sceneId (history index: $_currentHistoryIndex)',
    );
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
    _emitState();
    logInfo('Cleared scene navigation history');
  }

  /// Get the current scene ID from history
  String? getCurrentSceneId() {
    if (_currentHistoryIndex >= 0 &&
        _currentHistoryIndex < _sceneHistory.length) {
      return _sceneHistory[_currentHistoryIndex];
    }
    return null;
  }

  /// Track scene progression through an adventure
  Future<SceneProgression> getProgression(String adventureId) async {
    return execute(() async {
      final scenes = await _repository.getByAdventure(adventureId);
      scenes.sort((a, b) => a.order.compareTo(b.order));

      // Find scenes that appear in history
      final visitedSceneIds = _sceneHistory.toSet();
      final visitedScenes = scenes
          .where((s) => visitedSceneIds.contains(s.id))
          .toList();

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
    }, operationName: 'getProgression');
  }

  /// Get the next unvisited scene in order
  Future<Scene?> getNextUnvisitedScene(String adventureId) async {
    return execute(() async {
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
    }, operationName: 'getNextUnvisitedScene');
  }

  /// Check if a scene has been visited
  bool hasVisited(String sceneId) {
    return _sceneHistory.contains(sceneId);
  }

  /// Get visit count for a scene
  int getVisitCount(String sceneId) {
    return _sceneHistory.where((id) => id == sceneId).length;
  }

  Stream<SceneNavState> get stateStream => _stateController.stream;

  Future<void> _emitState() async {
    final currentId = getCurrentSceneId();
    if (currentId == null) {
      _stateController.add(SceneNavState.empty());
      return;
    }
    final currentScene = await _repository.getById(currentId);
    if (currentScene == null) {
      _stateController.add(SceneNavState.empty());
      return;
    }
    final scenes = await _repository.getByAdventure(currentScene.adventureId);
    scenes.sort((a, b) => a.order.compareTo(b.order));
    final index = scenes.indexWhere((s) => s.id == currentScene.id);
    _stateController.add(
      SceneNavState(
        currentName: currentScene.name,
        position: index >= 0 ? index + 1 : 1,
        total: scenes.length,
        hasPrevious: index > 0,
        hasNext: index < scenes.length - 1,
        adventureId: currentScene.adventureId,
      ),
    );
  }

  Future<void> goToPrevious(BuildContext context) async {
    final state = await stateStream.first;
    if (!state.hasPrevious) return;
    final scenes = await _repository.getByAdventure(state.adventureId);
    scenes.sort((a, b) => a.order.compareTo(b.order));
    final prevScene = scenes[state.position - 2];
    await navigateToScene(prevScene.id);
    if (context.mounted) {
      final adventure = await _adventureRepository.getById(
        prevScene.adventureId,
      );
      if (adventure != null) {
        SceneRouteData(
          chapterId: adventure.chapterId,
          adventureId: prevScene.adventureId,
          sceneId: prevScene.id,
        ).go(context);
      }
    }
  }

  Future<void> goToNext(BuildContext context) async {
    final state = await stateStream.first;
    if (!state.hasNext) return;
    final scenes = await _repository.getByAdventure(state.adventureId);
    scenes.sort((a, b) => a.order.compareTo(b.order));
    final nextScene = scenes[state.position];
    await navigateToScene(nextScene.id);
    if (context.mounted) {
      final adventure = await _adventureRepository.getById(
        nextScene.adventureId,
      );
      if (adventure != null) {
        SceneRouteData(
          chapterId: adventure.chapterId,
          adventureId: nextScene.adventureId,
          sceneId: nextScene.id,
        ).go(context);
      }
    }
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

class SceneNavState {
  SceneNavState({
    required this.currentName,
    required this.position,
    required this.total,
    required this.hasPrevious,
    required this.hasNext,
    required this.adventureId,
  });

  factory SceneNavState.empty() => SceneNavState(
    currentName: '',
    position: 0,
    total: 0,
    hasPrevious: false,
    hasNext: false,
    adventureId: '',
  );

  final String currentName;
  final int position;
  final int total;
  final bool hasPrevious;
  final bool hasNext;
  final String adventureId;
}
