import 'package:flutter_quill/flutter_quill.dart';
import 'package:moonforge/core/models/ai/story_context.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

/// Helper service to build story context for AI generation
class StoryContextBuilder {
  /// Detect language via simple heuristic; falls back to English when uncertain
  String? _detectLanguage(String? text) {
    final normalized = text?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    const languagePatterns = {
      'German': {
        'der',
        'die',
        'das',
        'und',
        'ist',
        'ein',
        'eine',
        'zu',
        'auf',
        'mit',
      },
      'French': {
        'le',
        'la',
        'les',
        'et',
        'est',
        'un',
        'une',
        'de',
        'pour',
        'dans',
      },
      'Spanish': {'el', 'la', 'los', 'las', 'y', 'es', 'un', 'una', 'de', 'en'},
      'Italian': {'il', 'la', 'i', 'le', 'e', 'è', 'un', 'una', 'di', 'in'},
    };

    final words = normalized.toLowerCase().split(RegExp(r'\s+'));
    final matches = <String, int>{};
    for (final entry in languagePatterns.entries) {
      matches[entry.key] = words.take(100).where(entry.value.contains).length;
    }

    final bestMatch = matches.entries.reduce(
      (current, next) => next.value > current.value ? next : current,
    );

    return bestMatch.value >= 3 ? bestMatch.key : 'English';
  }

  final CampaignRepository _campaignRepo;
  final ChapterRepository _chapterRepo;
  final AdventureRepository _adventureRepo;
  final SceneRepository _sceneRepo;
  final EntityRepository _entityRepo;

  StoryContextBuilder({
    required CampaignRepository campaignRepo,
    required ChapterRepository chapterRepo,
    required AdventureRepository adventureRepo,
    required SceneRepository sceneRepo,
    required EntityRepository entityRepo,
  }) : _campaignRepo = campaignRepo,
       _chapterRepo = chapterRepo,
       _adventureRepo = adventureRepo,
       _sceneRepo = sceneRepo,
       _entityRepo = entityRepo;

  /// Build context for a campaign
  Future<StoryContext> buildForCampaign(String campaignId) async {
    final campaign = await _campaignRepo.getById(campaignId);
    if (campaign == null) {
      throw Exception('Campaign not found: $campaignId');
    }

    final entities = await _getEntitiesInfo(campaign.entityIds);
    final contentText = _extractQuillText(campaign.content);
    final language = _detectLanguage(contentText ?? campaign.description);

    return StoryContext(
      campaignName: campaign.name,
      campaignDescription: campaign.description,
      entities: entities,
      recentContent: contentText,
      language: language,
    );
  }

  /// Build context for a chapter
  Future<StoryContext> buildForChapter(String chapterId) async {
    final chapter = await _chapterRepo.getById(chapterId);
    if (chapter == null) {
      throw Exception('Chapter not found: $chapterId');
    }

    final campaign = await _campaignRepo.getById(chapter.campaignId);
    if (campaign == null) {
      throw Exception('Campaign not found: ${chapter.campaignId}');
    }

    final entities = await _getEntitiesInfo(
      [...campaign.entityIds, ...chapter.entityIds].toSet().toList(),
    );

    final contentText = _extractQuillText(chapter.content);
    final language = _detectLanguage(
      contentText ?? chapter.summary ?? campaign.description,
    );

    return StoryContext(
      campaignName: campaign.name,
      campaignDescription: campaign.description,
      chapterName: chapter.name,
      chapterSummary: chapter.summary,
      entities: entities,
      recentContent: contentText,
      language: language,
    );
  }

  /// Build context for an adventure
  Future<StoryContext> buildForAdventure(String adventureId) async {
    final adventure = await _adventureRepo.getById(adventureId);
    if (adventure == null) {
      throw Exception('Adventure not found: $adventureId');
    }

    final chapter = await _chapterRepo.getById(adventure.chapterId);
    if (chapter == null) {
      throw Exception('Chapter not found: ${adventure.chapterId}');
    }

    final campaign = await _campaignRepo.getById(chapter.campaignId);
    if (campaign == null) {
      throw Exception('Campaign not found: ${chapter.campaignId}');
    }

    final entities = await _getEntitiesInfo(
      [
        ...campaign.entityIds,
        ...chapter.entityIds,
        ...adventure.entityIds,
      ].toSet().toList(),
    );

    final contentText = _extractQuillText(adventure.content);
    final language = _detectLanguage(
      contentText ??
          adventure.summary ??
          chapter.summary ??
          campaign.description,
    );

    return StoryContext(
      campaignName: campaign.name,
      campaignDescription: campaign.description,
      chapterName: chapter.name,
      chapterSummary: chapter.summary,
      adventureName: adventure.name,
      adventureSummary: adventure.summary,
      entities: entities,
      recentContent: contentText,
      language: language,
    );
  }

  /// Build context for a scene
  Future<StoryContext> buildForScene(String sceneId) async {
    final scene = await _sceneRepo.getById(sceneId);
    if (scene == null) {
      throw Exception('Scene not found: $sceneId');
    }

    final adventure = await _adventureRepo.getById(scene.adventureId);
    if (adventure == null) {
      throw Exception('Adventure not found: ${scene.adventureId}');
    }

    final chapter = await _chapterRepo.getById(adventure.chapterId);
    if (chapter == null) {
      throw Exception('Chapter not found: ${adventure.chapterId}');
    }

    final campaign = await _campaignRepo.getById(chapter.campaignId);
    if (campaign == null) {
      throw Exception('Campaign not found: ${chapter.campaignId}');
    }

    // Get all related entities
    final entities = await _getEntitiesInfo(
      [
        ...campaign.entityIds,
        ...chapter.entityIds,
        ...adventure.entityIds,
        ...scene.entityIds,
      ].toSet().toList(),
    );

    // Get recent scenes for context
    final recentScenes = await _sceneRepo.getByAdventure(scene.adventureId);
    final recentContent = _buildRecentScenesContent(recentScenes, scene.id);

    // Detect language from scene content or fallback to campaign content
    final sceneText = _extractQuillText(scene.content);
    final language = _detectLanguage(sceneText ?? recentContent);

    return StoryContext(
      campaignName: campaign.name,
      campaignDescription: campaign.description,
      chapterName: chapter.name,
      chapterSummary: chapter.summary,
      adventureName: adventure.name,
      adventureSummary: adventure.summary,
      sceneName: scene.name,
      sceneSummary: scene.summary,
      entities: entities,
      recentContent: recentContent,
      language: language,
    );
  }

  /// Get entity information for the context
  Future<List<EntityInfo>> _getEntitiesInfo(List<String> entityIds) async {
    if (entityIds.isEmpty) return [];

    final entities = <EntityInfo>[];
    for (final id in entityIds) {
      final entity = await _entityRepo.getById(id);
      if (entity != null && !entity.deleted) {
        entities.add(
          EntityInfo(
            id: entity.id,
            name: entity.name,
            kind: entity.kind,
            summary: entity.summary,
            tags: entity.tags ?? [],
          ),
        );
      }
    }
    return entities;
  }

  /// Extract plain text from Quill delta JSON
  String? _extractQuillText(Map<String, dynamic>? delta) {
    if (delta == null) return null;

    try {
      final ops = delta['ops'];
      if (ops is List) {
        final document = Document.fromJson(
          List<Map<String, dynamic>>.from(ops),
        );
        return document.toPlainText();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Build recent scenes content for context
  String _buildRecentScenesContent(List<Scene> scenes, String currentSceneId) {
    // Sort by order
    scenes.sort((a, b) => a.order.compareTo(b.order));

    // Get scenes before the current one
    final currentIndex = scenes.indexWhere((s) => s.id == currentSceneId);
    if (currentIndex <= 0) return '';

    // Take up to 3 previous scenes
    final startIndex = (currentIndex - 3).clamp(0, scenes.length);
    final recentScenes = scenes.sublist(startIndex, currentIndex);

    if (recentScenes.isEmpty) {
      return '';
    }

    final buffer = StringBuffer();
    for (final scene in recentScenes) {
      buffer.writeln('Scene: ${scene.name}');
      if (scene.summary != null && scene.summary!.isNotEmpty) {
        buffer.writeln(scene.summary);
      }
      final content = _extractQuillText(scene.content);
      if (content != null && content.isNotEmpty) {
        final truncated = content.length > 500
            ? '${content.substring(0, 500)}...'
            : content;
        buffer.writeln(truncated);
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}
