import 'package:moonforge/data/db/app_db.dart';

/// Utilities for scene ordering operations
class SceneOrdering {
  SceneOrdering._();

  /// Sort scenes by order
  static List<Scene> sortByOrder(List<Scene> scenes) {
    final sorted = List<Scene>.from(scenes);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  /// Get the next available order number
  static int getNextOrder(List<Scene> scenes) {
    if (scenes.isEmpty) return 1;

    final maxOrder = scenes.map((s) => s.order).reduce(
      (max, order) => order > max ? order : max,
    );
    return maxOrder + 1;
  }

  /// Move a scene to a new position
  static List<Scene> moveScene(
    List<Scene> scenes,
    String sceneId,
    int newOrder,
  ) {
    final sorted = sortByOrder(scenes);
    final sceneIndex = sorted.indexWhere((s) => s.id == sceneId);

    if (sceneIndex == -1) return scenes;

    final scene = sorted[sceneIndex];
    final oldOrder = scene.order;

    if (oldOrder == newOrder) return scenes;

    final updatedScenes = <Scene>[];

    for (final s in sorted) {
      if (s.id == sceneId) {
        // Update the moved scene
        updatedScenes.add(s.copyWith(order: newOrder));
      } else if (oldOrder < newOrder) {
        // Moving down: shift scenes between old and new position up
        if (s.order > oldOrder && s.order <= newOrder) {
          updatedScenes.add(s.copyWith(order: s.order - 1));
        } else {
          updatedScenes.add(s);
        }
      } else {
        // Moving up: shift scenes between new and old position down
        if (s.order >= newOrder && s.order < oldOrder) {
          updatedScenes.add(s.copyWith(order: s.order + 1));
        } else {
          updatedScenes.add(s);
        }
      }
    }

    return sortByOrder(updatedScenes);
  }

  /// Reorder scenes based on new order list
  static List<Scene> reorderByIds(List<Scene> scenes, List<String> orderedIds) {
    final sceneMap = {for (var s in scenes) s.id: s};
    final reordered = <Scene>[];

    for (var i = 0; i < orderedIds.length; i++) {
      final id = orderedIds[i];
      final scene = sceneMap[id];

      if (scene != null) {
        reordered.add(scene.copyWith(order: i + 1));
      }
    }

    return reordered;
  }

  /// Normalize scene order (ensure sequential 1, 2, 3...)
  static List<Scene> normalizeOrder(List<Scene> scenes) {
    final sorted = sortByOrder(scenes);
    final normalized = <Scene>[];

    for (var i = 0; i < sorted.length; i++) {
      final expectedOrder = i + 1;
      final scene = sorted[i];

      if (scene.order != expectedOrder) {
        normalized.add(scene.copyWith(order: expectedOrder));
      } else {
        normalized.add(scene);
      }
    }

    return normalized;
  }

  /// Insert a scene at a specific position
  static List<Scene> insertAt(List<Scene> scenes, Scene newScene, int position) {
    final sorted = sortByOrder(scenes);
    final updated = <Scene>[];

    for (final scene in sorted) {
      if (scene.order >= position) {
        updated.add(scene.copyWith(order: scene.order + 1));
      } else {
        updated.add(scene);
      }
    }

    updated.add(newScene.copyWith(order: position));
    return sortByOrder(updated);
  }

  /// Remove a scene and adjust orders
  static List<Scene> removeScene(List<Scene> scenes, String sceneId) {
    final sorted = sortByOrder(scenes);
    final scene = sorted.firstWhere(
      (s) => s.id == sceneId,
      orElse: () => sorted.first,
    );
    final removedOrder = scene.order;

    final updated = <Scene>[];

    for (final s in sorted) {
      if (s.id == sceneId) {
        continue; // Skip the removed scene
      } else if (s.order > removedOrder) {
        updated.add(s.copyWith(order: s.order - 1));
      } else {
        updated.add(s);
      }
    }

    return updated;
  }

  /// Swap two scenes
  static List<Scene> swapScenes(
    List<Scene> scenes,
    String sceneId1,
    String sceneId2,
  ) {
    final scene1 = scenes.firstWhere((s) => s.id == sceneId1);
    final scene2 = scenes.firstWhere((s) => s.id == sceneId2);

    final order1 = scene1.order;
    final order2 = scene2.order;

    return scenes.map((s) {
      if (s.id == sceneId1) {
        return s.copyWith(order: order2);
      } else if (s.id == sceneId2) {
        return s.copyWith(order: order1);
      }
      return s;
    }).toList();
  }
}
