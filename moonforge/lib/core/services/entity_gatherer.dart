import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
/// Service to gather entities from parts and their children
class EntityGatherer {
  /// Gather entities from a campaign and all its children
  Future<List<EntityWithOrigin>> gatherFromCampaign(String campaignId) async {
    final odm = Odm.instance;
    final campaign = await odm.campaigns.doc(campaignId).get();
    if (campaign == null) return [];
    final entitiesWithOrigin = <EntityWithOrigin>[];
    // Add entities directly from campaign via explicit references
    if (campaign.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(campaignId, campaign.entityIds);
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
    // Fallback/supplement: Also include all entities from the campaign's entities subcollection
    // This covers legacy/Imported data where entityIds were not populated.
    try {
      final allDirectEntities = await odm.campaigns
          .doc(campaignId)
          .entities
          .get();
      for (final e in allDirectEntities) {
        if (!e.deleted) {
          entitiesWithOrigin.add(
            EntityWithOrigin(
              entity: e,
              origin: const EntityOrigin(
                partType: 'campaign',
                partId: '',
                label: 'Campaign',
                path: '',
              ),
          );
        }
      }
    } catch (e) {
      logger.w('Failed to list campaign entities for $campaignId: $e');
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
      entitiesWithOrigin.addAll(chapterEntities);
    // Gather from all encounters
    final encounters = await odm.campaigns.doc(campaignId).encounters.get();
    for (final encounter in encounters) {
      if (encounter.entityIds.isNotEmpty) {
        final entities = await _fetchEntities(campaignId, encounter.entityIds);
        entitiesWithOrigin.addAll(
          entities.map(
            (e) => EntityWithOrigin(
              origin: EntityOrigin(
                partType: 'encounter',
                partId: encounter.id,
                label: 'Encounter: ${encounter.name}',
                path: encounter.name,
        );
    return _deduplicateEntities(entitiesWithOrigin);
  }
  /// Gather entities from a chapter and all its children
  Future<List<EntityWithOrigin>> gatherFromChapter(
    String campaignId,
    String chapterId,
  ) async {
    final chapterIndex = chapters.indexWhere((c) => c.id == chapterId);
    if (chapterIndex == -1) return [];
    return _gatherFromChapter(
      campaignId,
      chapters[chapterIndex],
      chapterIndex + 1,
    );
  Future<List<EntityWithOrigin>> _gatherFromChapter(
    Chapter chapter,
    int chapterNumber,
    // Add entities directly from chapter
    if (chapter.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(campaignId, chapter.entityIds);
              partType: 'chapter',
              partId: chapter.id,
              label: 'Chapter $chapterNumber',
              path: '$chapterNumber',
    // Gather from all adventures in this chapter
    final adventures = await odm.campaigns
        .doc(chapter.id)
        .adventures
    for (var i = 0; i < adventures.length; i++) {
      final adventure = adventures[i];
      final adventureEntities = await _gatherFromAdventure(
        chapter.id,
        adventure,
        chapterNumber,
      entitiesWithOrigin.addAll(adventureEntities);
    return entitiesWithOrigin;
  /// Gather entities from an adventure and all its children
  Future<List<EntityWithOrigin>> gatherFromAdventure(
    String adventureId,
        .doc(chapterId)
    final adventureIndex = adventures.indexWhere((a) => a.id == adventureId);
    if (adventureIndex == -1) return [];
    return _gatherFromAdventure(
      chapterId,
      adventures[adventureIndex],
      adventureIndex + 1,
  Future<List<EntityWithOrigin>> _gatherFromAdventure(
    Adventure adventure,
    int adventureNumber,
    // Add entities directly from adventure
    if (adventure.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(campaignId, adventure.entityIds);
              partType: 'adventure',
              partId: adventure.id,
              label: 'Adventure $chapterNumber.$adventureNumber',
              path: '$chapterNumber.$adventureNumber',
    // Gather from all scenes in this adventure
    final scenes = await odm.campaigns
        .doc(adventure.id)
        .scenes
    for (var i = 0; i < scenes.length; i++) {
      final scene = scenes[i];
      if (scene.entityIds.isNotEmpty) {
        final entities = await _fetchEntities(campaignId, scene.entityIds);
                partType: 'scene',
                partId: scene.id,
                label: 'Scene $chapterNumber.$adventureNumber.${i + 1}',
                path: '$chapterNumber.$adventureNumber.${i + 1}',
  /// Gather entities from a scene
  Future<List<EntityWithOrigin>> gatherFromScene(
    String sceneId,
        .doc(adventureId)
    final sceneIndex = scenes.indexWhere((s) => s.id == sceneId);
    if (sceneIndex == -1) return [];
    final scene = scenes[sceneIndex];
    // Add entities directly from scene with proper origin
    if (scene.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(campaignId, scene.entityIds);
      final chapterNumber = chapterIndex + 1;
      final adventureNumber = adventureIndex + 1;
      final sceneNumber = sceneIndex + 1;
              partType: 'scene',
              partId: scene.id,
              label: 'Scene $chapterNumber.$adventureNumber.$sceneNumber',
              path: '$chapterNumber.$adventureNumber.$sceneNumber',
  /// Gather entities from an encounter
  Future<List<EntityWithOrigin>> gatherFromEncounter(
    String encounterId,
    final encounter = await odm.campaigns
        .encounters
        .doc(encounterId)
    if (encounter == null) return [];
    // Add entities directly from encounter with proper origin
    if (encounter.entityIds.isNotEmpty) {
      final entities = await _fetchEntities(campaignId, encounter.entityIds);
              partType: 'encounter',
              partId: encounter.id,
              label: 'Encounter: ${encounter.name}',
              path: encounter.name,
  /// Fetch entities by IDs from a campaign
  Future<List<Entity>> _fetchEntities(
    List<String> entityIds,
      final entities = <Entity>[];
      for (final entityId in entityIds) {
        final entity = await odm.campaigns
            .doc(campaignId)
            .entities
            .doc(entityId)
            .get();
        if (entity != null && !entity.deleted) {
          entities.add(entity);
      return entities;
      logger.e('Error fetching entities: $e');
      return [];
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
    final seenIds = <String, EntityWithOrigin>{};
    for (final entityWithOrigin in entities) {
      final id = entityWithOrigin.entity.id;
      final existing = seenIds[id];
      if (existing == null) {
        seenIds[id] = entityWithOrigin;
      } else {
        if (rank(entityWithOrigin.origin) > rank(existing.origin)) {
          seenIds[id] = entityWithOrigin;
    return seenIds.values.toList();
}
