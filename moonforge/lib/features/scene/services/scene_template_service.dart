import 'package:moonforge/data/db/app_db.dart';
import 'package:uuid/uuid.dart';

/// Service for managing scene templates
class SceneTemplateService {
  SceneTemplateService._();

  /// Get all available scene templates
  static List<SceneTemplate> getTemplates() {
    return [
      SceneTemplate(
        id: 'combat',
        name: 'Combat Scene',
        description: 'A scene focused on combat encounters',
        icon: 'swords',
        defaultSummary: 'A tense combat encounter',
        defaultContent: {
          'ops': [
            {'insert': 'Combat Scene\n', 'attributes': {'header': 1}},
            {'insert': '\n'},
            {'insert': 'Initiative Order\n', 'attributes': {'bold': true}},
            {'insert': '• \n• \n• \n\n'},
            {'insert': 'Tactics\n', 'attributes': {'bold': true}},
            {'insert': 'Describe enemy tactics and strategy here.\n\n'},
            {'insert': 'Terrain & Features\n', 'attributes': {'bold': true}},
            {'insert': 'Describe the battlefield and any special terrain features.\n\n'},
            {'insert': 'Treasure\n', 'attributes': {'bold': true}},
            {'insert': 'List any loot or rewards here.\n'},
          ],
        },
      ),
      SceneTemplate(
        id: 'social',
        name: 'Social Encounter',
        description: 'A scene for roleplay and social interaction',
        icon: 'chat',
        defaultSummary: 'A social encounter with NPCs',
        defaultContent: {
          'ops': [
            {'insert': 'Social Encounter\n', 'attributes': {'header': 1}},
            {'insert': '\n'},
            {'insert': 'NPCs Present\n', 'attributes': {'bold': true}},
            {'insert': '• \n• \n\n'},
            {'insert': 'Mood & Atmosphere\n', 'attributes': {'bold': true}},
            {'insert': 'Describe the social setting and atmosphere.\n\n'},
            {'insert': 'Key Topics\n', 'attributes': {'bold': true}},
            {'insert': '• \n• \n• \n\n'},
            {'insert': 'Possible Outcomes\n', 'attributes': {'bold': true}},
            {'insert': 'List potential outcomes based on player choices.\n'},
          ],
        },
      ),
      SceneTemplate(
        id: 'exploration',
        name: 'Exploration',
        description: 'A scene for exploring new locations',
        icon: 'map',
        defaultSummary: 'Exploring a new location',
        defaultContent: {
          'ops': [
            {'insert': 'Exploration Scene\n', 'attributes': {'header': 1}},
            {'insert': '\n'},
            {'insert': 'Location Description\n', 'attributes': {'bold': true}},
            {'insert': 'Describe what the players see, hear, and smell.\n\n'},
            {'insert': 'Points of Interest\n', 'attributes': {'bold': true}},
            {'insert': '• \n• \n• \n\n'},
            {'insert': 'Hidden Secrets\n', 'attributes': {'bold': true}},
            {'insert': 'What can be found with investigation?\n\n'},
            {'insert': 'Hazards & Challenges\n', 'attributes': {'bold': true}},
            {'insert': 'Any environmental challenges or traps?\n'},
          ],
        },
      ),
      SceneTemplate(
        id: 'puzzle',
        name: 'Puzzle',
        description: 'A scene featuring a puzzle or riddle',
        icon: 'puzzle',
        defaultSummary: 'A challenging puzzle',
        defaultContent: {
          'ops': [
            {'insert': 'Puzzle Scene\n', 'attributes': {'header': 1}},
            {'insert': '\n'},
            {'insert': 'Puzzle Description\n', 'attributes': {'bold': true}},
            {'insert': 'Describe the puzzle as the players encounter it.\n\n'},
            {'insert': 'Clues\n', 'attributes': {'bold': true}},
            {'insert': '• \n• \n• \n\n'},
            {'insert': 'Solution\n', 'attributes': {'bold': true}},
            {'insert': 'The solution to the puzzle.\n\n'},
            {'insert': 'Reward\n', 'attributes': {'bold': true}},
            {'insert': 'What happens when the puzzle is solved?\n'},
          ],
        },
      ),
      SceneTemplate(
        id: 'rest',
        name: 'Rest Scene',
        description: 'A safe place for the party to rest',
        icon: 'bed',
        defaultSummary: 'A place to rest and recover',
        defaultContent: {
          'ops': [
            {'insert': 'Rest Scene\n', 'attributes': {'header': 1}},
            {'insert': '\n'},
            {'insert': 'Location\n', 'attributes': {'bold': true}},
            {'insert': 'Describe where the party is resting.\n\n'},
            {'insert': 'Safety Level\n', 'attributes': {'bold': true}},
            {'insert': 'Is this a safe rest? Any chance of interruption?\n\n'},
            {'insert': 'Activities\n', 'attributes': {'bold': true}},
            {'insert': 'What can the party do during the rest?\n• Craft\n• Study\n• Keep watch\n\n'},
            {'insert': 'Time Passage\n', 'attributes': {'bold': true}},
            {'insert': 'How much time passes? Long rest or short rest?\n'},
          ],
        },
      ),
      SceneTemplate(
        id: 'cutscene',
        name: 'Cutscene',
        description: 'A narrative scene with limited player interaction',
        icon: 'movie',
        defaultSummary: 'An important story moment',
        defaultContent: {
          'ops': [
            {'insert': 'Cutscene\n', 'attributes': {'header': 1}},
            {'insert': '\n'},
            {'insert': 'Read Aloud\n', 'attributes': {'bold': true}},
            {'insert': 'Read this narrative text to the players:\n\n'},
            {'insert': '"', 'attributes': {'italic': true}},
            {'insert': 'Your dramatic narrative text here...', 'attributes': {'italic': true}},
            {'insert': '"\n\n', 'attributes': {'italic': true}},
            {'insert': 'Key Events\n', 'attributes': {'bold': true}},
            {'insert': '• \n• \n• \n\n'},
            {'insert': 'Aftermath\n', 'attributes': {'bold': true}},
            {'insert': 'What happens next?\n'},
          ],
        },
      ),
      SceneTemplate(
        id: 'boss',
        name: 'Boss Fight',
        description: 'An epic boss battle',
        icon: 'dragon',
        defaultSummary: 'A climactic boss battle',
        defaultContent: {
          'ops': [
            {'insert': 'Boss Fight\n', 'attributes': {'header': 1}},
            {'insert': '\n'},
            {'insert': 'Boss Introduction\n', 'attributes': {'bold': true}},
            {'insert': 'Describe the boss\'s dramatic entrance.\n\n'},
            {'insert': 'Boss Stats\n', 'attributes': {'bold': true}},
            {'insert': '• HP: \n• AC: \n• Special Abilities: \n\n'},
            {'insert': 'Phase Transitions\n', 'attributes': {'bold': true}},
            {'insert': 'What happens at different HP thresholds?\n\n'},
            {'insert': 'Legendary Actions\n', 'attributes': {'bold': true}},
            {'insert': '• \n• \n• \n\n'},
            {'insert': 'Victory Conditions\n', 'attributes': {'bold': true}},
            {'insert': 'What happens when the boss is defeated?\n'},
          ],
        },
      ),
    ];
  }

  /// Get a template by ID
  static SceneTemplate? getTemplateById(String id) {
    try {
      return getTemplates().firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Create a scene from a template
  static Scene createSceneFromTemplate({
    required SceneTemplate template,
    required String adventureId,
    required int order,
    String? customName,
  }) {
    final uuid = const Uuid();
    return Scene(
      id: uuid.v4(),
      adventureId: adventureId,
      name: customName ?? template.name,
      order: order,
      summary: template.defaultSummary,
      content: template.defaultContent,
      entityIds: const [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 0,
    );
  }

  /// Apply a template to an existing scene
  static Scene applyTemplateToScene({
    required Scene scene,
    required SceneTemplate template,
    bool overwriteName = false,
    bool overwriteSummary = false,
    bool overwriteContent = false,
  }) {
    return scene.copyWith(
      name: overwriteName ? template.name : scene.name,
      summary: overwriteSummary ? template.defaultSummary : scene.summary,
      content: overwriteContent ? template.defaultContent : scene.content,
      updatedAt: DateTime.now(),
      rev: scene.rev + 1,
    );
  }
}

/// Scene template data class
class SceneTemplate {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String defaultSummary;
  final Map<String, dynamic> defaultContent;

  const SceneTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.defaultSummary,
    required this.defaultContent,
  });
}
