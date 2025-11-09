import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/scene/services/scene_template_service.dart';

/// Utilities for working with scene templates
class SceneTemplates {
  SceneTemplates._();

  /// Get all available templates
  static List<SceneTemplate> getAllTemplates() {
    return SceneTemplateService.getTemplates();
  }

  /// Get a template by ID
  static SceneTemplate? getTemplateById(String id) {
    return SceneTemplateService.getTemplateById(id);
  }

  /// Get template categories
  static Map<String, List<SceneTemplate>> getTemplatesByCategory() {
    return {
      'Combat': [
        _getTemplate('combat')!,
        _getTemplate('boss')!,
      ],
      'Social': [
        _getTemplate('social')!,
      ],
      'Exploration': [
        _getTemplate('exploration')!,
        _getTemplate('puzzle')!,
      ],
      'Other': [
        _getTemplate('rest')!,
        _getTemplate('cutscene')!,
      ],
    };
  }

  static SceneTemplate? _getTemplate(String id) {
    return SceneTemplateService.getTemplateById(id);
  }

  /// Create a scene from a template
  static Scene createFromTemplate({
    required String templateId,
    required String adventureId,
    required int order,
    String? customName,
  }) {
    final template = getTemplateById(templateId);
    if (template == null) {
      throw ArgumentError('Template not found: $templateId');
    }

    return SceneTemplateService.createSceneFromTemplate(
      template: template,
      adventureId: adventureId,
      order: order,
      customName: customName,
    );
  }

  /// Get template icons mapping
  static Map<String, String> getTemplateIcons() {
    return {
      'swords': '⚔️',
      'chat': '💬',
      'map': '🗺️',
      'puzzle': '🧩',
      'bed': '🛏️',
      'movie': '🎬',
      'dragon': '🐉',
    };
  }

  /// Get a display icon for a template
  static String getDisplayIcon(String iconKey) {
    return getTemplateIcons()[iconKey] ?? '📝';
  }

  /// Search templates by name or description
  static List<SceneTemplate> searchTemplates(String query) {
    if (query.isEmpty) return getAllTemplates();

    final lowerQuery = query.toLowerCase();
    return getAllTemplates().where((template) {
      return template.name.toLowerCase().contains(lowerQuery) ||
          template.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Get recommended template based on scene content
  static String? recommendTemplate(Scene scene) {
    final content = scene.content?.toString().toLowerCase() ?? '';
    final name = scene.name.toLowerCase();
    final summary = scene.summary?.toLowerCase() ?? '';

    final combinedText = '$name $summary $content';

    // Simple keyword matching for recommendations
    if (combinedText.contains('combat') ||
        combinedText.contains('fight') ||
        combinedText.contains('battle')) {
      return 'combat';
    }

    if (combinedText.contains('boss') ||
        combinedText.contains('legendary') ||
        combinedText.contains('final battle')) {
      return 'boss';
    }

    if (combinedText.contains('talk') ||
        combinedText.contains('conversation') ||
        combinedText.contains('negotiate') ||
        combinedText.contains('persuade')) {
      return 'social';
    }

    if (combinedText.contains('explore') ||
        combinedText.contains('investigate') ||
        combinedText.contains('search')) {
      return 'exploration';
    }

    if (combinedText.contains('puzzle') ||
        combinedText.contains('riddle') ||
        combinedText.contains('mystery')) {
      return 'puzzle';
    }

    if (combinedText.contains('rest') ||
        combinedText.contains('camp') ||
        combinedText.contains('sleep')) {
      return 'rest';
    }

    if (combinedText.contains('cutscene') ||
        combinedText.contains('narrative') ||
        combinedText.contains('story')) {
      return 'cutscene';
    }

    return null;
  }
}
