import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

/// Utility functions for adventure navigation
class AdventureNavigation {
  /// Navigate to the next scene in an adventure
  static Future<void> goToNextScene(
    BuildContext context,
    String chapterId,
    String adventureId,
    int currentOrder,
    SceneRepository sceneRepository,
  ) async {
    final scenes = await sceneRepository.getByAdventure(adventureId);
    scenes.sort((a, b) => a.order.compareTo(b.order));

    Scene? nextScene;
    for (final scene in scenes) {
      if (scene.order > currentOrder) {
        nextScene = scene;
        break;
      }
    }

    if (nextScene != null && context.mounted) {
      SceneRoute(
        chapterId: chapterId,
        adventureId: adventureId,
        sceneId: nextScene.id,
      ).go(context);
    }
  }

  /// Navigate to the previous scene in an adventure
  static Future<void> goToPreviousScene(
    BuildContext context,
    String chapterId,
    String adventureId,
    int currentOrder,
    SceneRepository sceneRepository,
  ) async {
    final scenes = await sceneRepository.getByAdventure(adventureId);
    scenes.sort((a, b) => b.order.compareTo(a.order));

    Scene? previousScene;
    for (final scene in scenes) {
      if (scene.order < currentOrder) {
        previousScene = scene;
        break;
      }
    }

    if (previousScene != null && context.mounted) {
      SceneRoute(
        chapterId: chapterId,
        adventureId: adventureId,
        sceneId: previousScene.id,
      ).go(context);
    }
  }

  /// Navigate to a specific scene by order
  static Future<void> goToSceneByOrder(
    BuildContext context,
    String chapterId,
    String adventureId,
    int order,
    SceneRepository sceneRepository,
  ) async {
    final scenes = await sceneRepository.getByAdventure(adventureId);
    final scene = scenes.where((s) => s.order == order).firstOrNull;

    if (scene != null && context.mounted) {
      SceneRoute(
        chapterId: chapterId,
        adventureId: adventureId,
        sceneId: scene.id,
      ).go(context);
    }
  }

  /// Check if there is a next scene
  static Future<bool> hasNextScene(
    String adventureId,
    int currentOrder,
    SceneRepository sceneRepository,
  ) async {
    final scenes = await sceneRepository.getByAdventure(adventureId);
    return scenes.any((s) => s.order > currentOrder);
  }

  /// Check if there is a previous scene
  static Future<bool> hasPreviousScene(
    String adventureId,
    int currentOrder,
    SceneRepository sceneRepository,
  ) async {
    final scenes = await sceneRepository.getByAdventure(adventureId);
    return scenes.any((s) => s.order < currentOrder);
  }
}
