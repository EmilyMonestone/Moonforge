import 'package:moonforge/data/db/app_db.dart';

/// Validators for scene data
class SceneValidators {
  SceneValidators._();

  /// Validate scene name
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Scene name is required';
    }
    if (value.trim().length < 2) {
      return 'Scene name must be at least 2 characters';
    }
    if (value.trim().length > 200) {
      return 'Scene name must be less than 200 characters';
    }
    return null;
  }

  /// Validate scene summary
  static String? validateSummary(String? value) {
    if (value == null) return null; // Summary is optional

    if (value.trim().length > 500) {
      return 'Summary must be less than 500 characters';
    }
    return null;
  }

  /// Validate scene order
  static String? validateOrder(int? value) {
    if (value == null || value < 1) {
      return 'Order must be a positive number';
    }
    return null;
  }

  /// Validate complete scene
  static Map<String, String> validateScene(Scene scene) {
    final errors = <String, String>{};

    final nameError = validateName(scene.name);
    if (nameError != null) {
      errors['name'] = nameError;
    }

    final summaryError = validateSummary(scene.summary);
    if (summaryError != null) {
      errors['summary'] = summaryError;
    }

    final orderError = validateOrder(scene.order);
    if (orderError != null) {
      errors['order'] = orderError;
    }

    return errors;
  }

  /// Check if scene is valid
  static bool isValid(Scene scene) {
    return validateScene(scene).isEmpty;
  }

  /// Validate scene name for uniqueness within adventure
  static bool isNameUniqueInAdventure(
    String name,
    String adventureId,
    List<Scene> existingScenes, {
    String? excludeSceneId,
  }) {
    final normalizedName = name.trim().toLowerCase();

    for (final scene in existingScenes) {
      if (scene.adventureId == adventureId &&
          scene.id != excludeSceneId &&
          scene.name.trim().toLowerCase() == normalizedName) {
        return false;
      }
    }

    return true;
  }

  /// Suggest a unique name by appending a number
  static String suggestUniqueName(
    String baseName,
    String adventureId,
    List<Scene> existingScenes,
  ) {
    String candidateName = baseName;
    int counter = 1;

    while (!isNameUniqueInAdventure(
      candidateName,
      adventureId,
      existingScenes,
    )) {
      counter++;
      candidateName = '$baseName ($counter)';
    }

    return candidateName;
  }
}
