import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

// TODO: Create EntityWithOrigin model class if not exists
class EntityWithOrigin {
  final Entity entity;
  final EntityOrigin? origin;

  EntityWithOrigin({required this.entity, this.origin});
}

class EntityOrigin {
  final String partType;
  final String partId;
  final String label;
  final String path;

  const EntityOrigin({
    required this.partType,
    required this.partId,
    required this.label,
    required this.path,
  });
}

/// Service to gather entities from parts and their children
class EntityGatherer {
  final CampaignRepository campaignRepo;
  final ChapterRepository chapterRepo;
  final AdventureRepository adventureRepo;
  final SceneRepository sceneRepo;
  final EncounterRepository encounterRepo;
  final EntityRepository entityRepo;

  EntityGatherer({
    required this.campaignRepo,
    required this.chapterRepo,
    required this.adventureRepo,
    required this.sceneRepo,
    required this.encounterRepo,
    required this.entityRepo,
  });

  /// Gather entities from a campaign and all its children
  Future<List<EntityWithOrigin>> gatherFromCampaign(String campaignId) async {
    final campaign = await campaignRepo.getById(campaignId);
    if (campaign == null) return [];

    final entitiesWithOrigin = <EntityWithOrigin>[];

    // Add entities directly from campaign via explicit references
    if (campaign.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(campaign.entityIds);
      entitiesWithOrigin.addAll(
        entities.map(
          (e) => EntityWithOrigin(
            entity: e,
            origin: EntityOrigin(
              partType: 'campaign',
              partId: campaignId,
              label: 'Campaign',
              path: '',
            ),
          ),
        ),
      );
    }

    // Gather from all chapters in this campaign
    final chapters = await chapterRepo.getByCampaign(campaignId);
    chapters.sort((a, b) => a.order.compareTo(b.order));

    for (var i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      final chapterEntities = await _gatherFromChapter(
        campaignId,
        chapter,
        i + 1,
      );
      entitiesWithOrigin.addAll(chapterEntities);
    }

    // Gather from all encounters with originId = campaignId
    final encounters = await encounterRepo.getByOrigin(campaignId);
    for (final encounter in encounters) {
      if (encounter.entityIds.isNotEmpty) {
        final entities = await _fetchEntities(encounter.entityIds);
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
    final chapters = await chapterRepo.getByCampaign(campaignId);
    chapters.sort((a, b) => a.order.compareTo(b.order));

    final chapterIndex = chapters.indexWhere((c) => c.id == chapterId);
    if (chapterIndex == -1) return [];

    return _gatherFromChapter(
      campaignId,
      chapters[chapterIndex],
      chapterIndex + 1,
    );
  }

  Future<List<EntityWithOrigin>> _gatherFromChapter(
    String campaignId,
    Chapter chapter,
    int chapterNumber,
  ) async {
    final entitiesWithOrigin = <EntityWithOrigin>[];

    // Add entities directly from chapter
    if (chapter.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(chapter.entityIds);
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
    final adventures = await adventureRepo.getByChapter(chapter.id);
    adventures.sort((a, b) => a.order.compareTo(b.order));

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
    final chapters = await chapterRepo.getByCampaign(campaignId);
    chapters.sort((a, b) => a.order.compareTo(b.order));

    final chapterIndex = chapters.indexWhere((c) => c.id == chapterId);
    if (chapterIndex == -1) return [];

    final adventures = await adventureRepo.getByChapter(chapterId);
    adventures.sort((a, b) => a.order.compareTo(b.order));

    final adventureIndex = adventures.indexWhere((a) => a.id == adventureId);
    if (adventureIndex == -1) return [];

    return _gatherFromAdventure(
      campaignId,
      chapterId,
      adventures[adventureIndex],
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
      final entities = await _fetchEntities(adventure.entityIds);
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
    final scenes = await sceneRepo.getByAdventure(adventure.id);
    scenes.sort((a, b) => a.order.compareTo(b.order));

    for (var i = 0; i < scenes.length; i++) {
      final scene = scenes[i];
      if (scene.entityIds.isNotEmpty) {
        final entities = await _fetchEntities(scene.entityIds);
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
    final chapters = await chapterRepo.getByCampaign(campaignId);
    chapters.sort((a, b) => a.order.compareTo(b.order));

    final chapterIndex = chapters.indexWhere((c) => c.id == chapterId);
    if (chapterIndex == -1) return [];

    final adventures = await adventureRepo.getByChapter(chapterId);
    adventures.sort((a, b) => a.order.compareTo(b.order));

    final adventureIndex = adventures.indexWhere((a) => a.id == adventureId);
    if (adventureIndex == -1) return [];

    final scenes = await sceneRepo.getByAdventure(adventureId);
    scenes.sort((a, b) => a.order.compareTo(b.order));

    final sceneIndex = scenes.indexWhere((s) => s.id == sceneId);
    if (sceneIndex == -1) return [];

    final scene = scenes[sceneIndex];
    final entitiesWithOrigin = <EntityWithOrigin>[];

    // Add entities directly from scene with proper origin
    if (scene.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(scene.entityIds);
      final chapterNumber = chapterIndex + 1;
      final adventureNumber = adventureIndex + 1;
      final sceneNumber = sceneIndex + 1;
      entitiesWithOrigin.addAll(
        entities.map(
          (e) => EntityWithOrigin(
            entity: e,
            origin: EntityOrigin(
              partType: 'scene',
              partId: scene.id,
              label: 'Scene $chapterNumber.$adventureNumber.$sceneNumber',
              path: '$chapterNumber.$adventureNumber.$sceneNumber',
            ),
          ),
        ),
      );
    }

    return entitiesWithOrigin;
  }

  /// Gather entities from an encounter
  Future<List<EntityWithOrigin>> gatherFromEncounter(
    String campaignId,
    String encounterId,
  ) async {
    final encounter = await encounterRepo.getById(encounterId);
    if (encounter == null) return [];

    final entitiesWithOrigin = <EntityWithOrigin>[];

    // Add entities directly from encounter with proper origin
    if (encounter.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(encounter.entityIds);
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

    return entitiesWithOrigin;
  }

  /// Fetch entities by IDs
  Future<List<Entity>> _fetchEntities(List<String> entityIds) async {
    try {
      final entities = <Entity>[];
      for (final entityId in entityIds) {
        final entity = await entityRepo.getById(entityId);
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
  List<EntityWithOrigin> _deduplicateEntities(List<EntityWithOrigin> entities) {
    int rank(EntityOrigin? o) {
      if (o == null) return 0; // direct assignment is the least specific here
      switch (o.partType) {
        case 'scene':
          return 5;
        case 'encounter':
          return 4;
        case 'adventure':
          return 3;
        case 'chapter':
          return 2;
        case 'campaign':
          return 1;
        default:
          return 1;
      }
    }

    final seenIds = <String, EntityWithOrigin>{};

    for (final entityWithOrigin in entities) {
      final id = entityWithOrigin.entity.id;
      final existing = seenIds[id];

      if (existing == null) {
        seenIds[id] = entityWithOrigin;
      } else {
        if (rank(entityWithOrigin.origin) > rank(existing.origin)) {
          seenIds[id] = entityWithOrigin;
        }
      }
    }

    return seenIds.values.toList();
  }
}
