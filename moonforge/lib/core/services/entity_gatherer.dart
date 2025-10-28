import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/models/data/adventure.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/core/models/data/chapter.dart';
import 'package:moonforge/core/models/data/encounter.dart';
import 'package:moonforge/core/models/data/entity.dart';
import 'package:moonforge/core/models/data/scene.dart';
import 'package:moonforge/core/models/entity_with_origin.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Service to gather entities from parts and their children
class EntityGatherer {
  final Odm odm = Odm.instance;

  /// Gather entities from a campaign and all its children
  Future<List<EntityWithOrigin>> gatherFromCampaign(
    String campaignId,
  ) async {
    final campaign = await odm.campaigns.doc(campaignId).get();
    if (campaign == null) return [];

    final entitiesWithOrigin = <EntityWithOrigin>[];

    // Add entities directly from campaign
    if (campaign.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(campaignId, campaign.entityIds);
      entitiesWithOrigin.addAll(
        entities.map((e) => EntityWithOrigin(entity: e)),
      );
    }

    // Gather from all chapters
    final chapters = await odm.campaigns
        .doc(campaignId)
        .chapters
        .orderBy((o) => (o.order(),))
        .get();

    for (var i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      final chapterEntities = await _gatherFromChapter(
        campaignId,
        chapter,
        i + 1,
      );
      entitiesWithOrigin.addAll(chapterEntities);
    }

    // Gather from all encounters
    final encounters = await odm.campaigns.doc(campaignId).encounters.get();
    for (final encounter in encounters) {
      if (encounter.entityIds.isNotEmpty) {
        final entities = await _fetchEntities(campaignId, encounter.entityIds);
        entitiesWithOrigin.addAll(
          entities.map(
            (e) => EntityWithOrigin(
              entity: e,
              origin: EntityOrigin(
                partType: 'encounter',
                partId: encounter.id,
                label: 'Encounter: ${encounter.name}',
                path: encounter.name,
              ),
            ),
          ),
        );
      }
    }

    return _deduplicateEntities(entitiesWithOrigin);
  }

  /// Gather entities from a chapter and all its children
  Future<List<EntityWithOrigin>> gatherFromChapter(
    String campaignId,
    String chapterId,
  ) async {
    final chapters = await odm.campaigns
        .doc(campaignId)
        .chapters
        .orderBy((o) => (o.order(),))
        .get();

    final chapterIndex =
        chapters.indexWhere((c) => c.id == chapterId);
    if (chapterIndex == -1) return [];

    final chapter = chapters[chapterIndex];
    return _gatherFromChapter(campaignId, chapter, chapterIndex + 1);
  }

  Future<List<EntityWithOrigin>> _gatherFromChapter(
    String campaignId,
    Chapter chapter,
    int chapterNumber,
  ) async {
    final entitiesWithOrigin = <EntityWithOrigin>[];

    // Add entities directly from chapter
    if (chapter.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(campaignId, chapter.entityIds);
      entitiesWithOrigin.addAll(
        entities.map(
          (e) => EntityWithOrigin(
            entity: e,
            origin: EntityOrigin(
              partType: 'chapter',
              partId: chapter.id,
              label: 'Chapter $chapterNumber',
              path: '$chapterNumber',
            ),
          ),
        ),
      );
    }

    // Gather from all adventures in this chapter
    final adventures = await odm.campaigns
        .doc(campaignId)
        .chapters
        .doc(chapter.id)
        .adventures
        .orderBy((o) => (o.order(),))
        .get();

    for (var i = 0; i < adventures.length; i++) {
      final adventure = adventures[i];
      final adventureEntities = await _gatherFromAdventure(
        campaignId,
        chapter.id,
        adventure,
        chapterNumber,
        i + 1,
      );
      entitiesWithOrigin.addAll(adventureEntities);
    }

    return entitiesWithOrigin;
  }

  /// Gather entities from an adventure and all its children
  Future<List<EntityWithOrigin>> gatherFromAdventure(
    String campaignId,
    String chapterId,
    String adventureId,
  ) async {
    final chapters = await odm.campaigns
        .doc(campaignId)
        .chapters
        .orderBy((o) => (o.order(),))
        .get();

    final chapterIndex =
        chapters.indexWhere((c) => c.id == chapterId);
    if (chapterIndex == -1) return [];

    final chapter = chapters[chapterIndex];
    final adventures = await odm.campaigns
        .doc(campaignId)
        .chapters
        .doc(chapterId)
        .adventures
        .orderBy((o) => (o.order(),))
        .get();

    final adventureIndex =
        adventures.indexWhere((a) => a.id == adventureId);
    if (adventureIndex == -1) return [];

    final adventure = adventures[adventureIndex];
    return _gatherFromAdventure(
      campaignId,
      chapterId,
      adventure,
      chapterIndex + 1,
      adventureIndex + 1,
    );
  }

  Future<List<EntityWithOrigin>> _gatherFromAdventure(
    String campaignId,
    String chapterId,
    Adventure adventure,
    int chapterNumber,
    int adventureNumber,
  ) async {
    final entitiesWithOrigin = <EntityWithOrigin>[];

    // Add entities directly from adventure
    if (adventure.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(campaignId, adventure.entityIds);
      entitiesWithOrigin.addAll(
        entities.map(
          (e) => EntityWithOrigin(
            entity: e,
            origin: EntityOrigin(
              partType: 'adventure',
              partId: adventure.id,
              label: 'Adventure $chapterNumber.$adventureNumber',
              path: '$chapterNumber.$adventureNumber',
            ),
          ),
        ),
      );
    }

    // Gather from all scenes in this adventure
    final scenes = await odm.campaigns
        .doc(campaignId)
        .chapters
        .doc(chapterId)
        .adventures
        .doc(adventure.id)
        .scenes
        .orderBy((o) => (o.order(),))
        .get();

    for (var i = 0; i < scenes.length; i++) {
      final scene = scenes[i];
      if (scene.entityIds.isNotEmpty) {
        final entities = await _fetchEntities(campaignId, scene.entityIds);
        entitiesWithOrigin.addAll(
          entities.map(
            (e) => EntityWithOrigin(
              entity: e,
              origin: EntityOrigin(
                partType: 'scene',
                partId: scene.id,
                label: 'Scene $chapterNumber.$adventureNumber.${i + 1}',
                path: '$chapterNumber.$adventureNumber.${i + 1}',
              ),
            ),
          ),
        );
      }
    }

    return entitiesWithOrigin;
  }

  /// Gather entities from a scene
  Future<List<EntityWithOrigin>> gatherFromScene(
    String campaignId,
    String chapterId,
    String adventureId,
    String sceneId,
  ) async {
    final chapters = await odm.campaigns
        .doc(campaignId)
        .chapters
        .orderBy((o) => (o.order(),))
        .get();

    final chapterIndex =
        chapters.indexWhere((c) => c.id == chapterId);
    if (chapterIndex == -1) return [];

    final adventures = await odm.campaigns
        .doc(campaignId)
        .chapters
        .doc(chapterId)
        .adventures
        .orderBy((o) => (o.order(),))
        .get();

    final adventureIndex =
        adventures.indexWhere((a) => a.id == adventureId);
    if (adventureIndex == -1) return [];

    final scenes = await odm.campaigns
        .doc(campaignId)
        .chapters
        .doc(chapterId)
        .adventures
        .doc(adventureId)
        .scenes
        .orderBy((o) => (o.order(),))
        .get();

    final sceneIndex = scenes.indexWhere((s) => s.id == sceneId);
    if (sceneIndex == -1) return [];

    final scene = scenes[sceneIndex];
    final entitiesWithOrigin = <EntityWithOrigin>[];

    // Add entities directly from scene
    if (scene.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(campaignId, scene.entityIds);
      entitiesWithOrigin.addAll(
        entities.map((e) => EntityWithOrigin(entity: e)),
      );
    }

    return entitiesWithOrigin;
  }

  /// Gather entities from an encounter
  Future<List<EntityWithOrigin>> gatherFromEncounter(
    String campaignId,
    String encounterId,
  ) async {
    final encounter =
        await odm.campaigns.doc(campaignId).encounters.doc(encounterId).get();
    if (encounter == null) return [];

    final entitiesWithOrigin = <EntityWithOrigin>[];

    // Add entities directly from encounter
    if (encounter.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(campaignId, encounter.entityIds);
      entitiesWithOrigin.addAll(
        entities.map((e) => EntityWithOrigin(entity: e)),
      );
    }

    return entitiesWithOrigin;
  }

  /// Fetch entities by IDs from a campaign
  Future<List<Entity>> _fetchEntities(
    String campaignId,
    List<String> entityIds,
  ) async {
    try {
      final entities = <Entity>[];
      for (final entityId in entityIds) {
        final entity =
            await odm.campaigns.doc(campaignId).entities.doc(entityId).get();
        if (entity != null && !entity.deleted) {
          entities.add(entity);
        }
      }
      return entities;
    } catch (e) {
      logger.e('Error fetching entities: $e');
      return [];
    }
  }

  /// Deduplicate entities by ID, keeping the one with the most specific origin
  List<EntityWithOrigin> _deduplicateEntities(
    List<EntityWithOrigin> entities,
  ) {
    final seenIds = <String, EntityWithOrigin>{};

    for (final entityWithOrigin in entities) {
      final id = entityWithOrigin.entity.id;
      final existing = seenIds[id];

      if (existing == null) {
        seenIds[id] = entityWithOrigin;
      } else {
        // Keep the entity with no origin (direct) or most specific origin
        if (entityWithOrigin.origin == null) {
          seenIds[id] = entityWithOrigin;
        } else if (existing.origin != null) {
          // Keep the one with longer path (more specific)
          final newPathDepth =
              entityWithOrigin.origin!.path.split('.').length;
          final existingPathDepth = existing.origin!.path.split('.').length;
          if (newPathDepth > existingPathDepth) {
            seenIds[id] = entityWithOrigin;
          }
        }
      }
    }

    return seenIds.values.toList();
  }
}
