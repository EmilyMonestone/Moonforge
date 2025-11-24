import 'package:flutter/material.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/services/entity_gatherer.dart';
import 'package:moonforge/core/widgets/entities/gathered_entities_widget.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:provider/provider.dart';

/// Widget that displays entities for a campaign
class CampaignEntitiesWidget extends StatelessWidget {
  const CampaignEntitiesWidget({required this.campaignId, super.key});

  final String campaignId;

  @override
  Widget build(BuildContext context) {
    // Keep Provider dependencies to ensure rebuilds when local drift data updates
    final campaigns = context.watch<List<Campaign>>();
    context.watch<List<Chapter>>();
    context.watch<List<Adventure>>();
    context.watch<List<Scene>>();
    context.watch<List<Encounter>>();
    context.watch<List<Entity>>();

    final campaign = campaigns.firstWhere(
      (c) => c.id == campaignId,
      orElse: () => Campaign(
        id: '',
        name: '',
        description: '',
        content: null,
        ownerUid: null,
        memberUids: [],
        entityIds: [],
        createdAt: null,
        updatedAt: null,
        rev: 0,
      ),
    );
    if (campaign.id.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Use EntityGatherer to traverse hierarchy via repositories and deduplicate with consistent origins
    return GatheredEntitiesWidget(
      future: EntityGatherer(
        campaignRepo: getIt<CampaignRepository>(),
        chapterRepo: getIt<ChapterRepository>(),
        adventureRepo: getIt<AdventureRepository>(),
        sceneRepo: getIt<SceneRepository>(),
        encounterRepo: getIt<EncounterRepository>(),
        entityRepo: getIt<EntityRepository>(),
      ).gatherFromCampaign(campaignId),
    );
  }
}

/// Widget that displays entities for a chapter
class ChapterEntitiesWidget extends StatelessWidget {
  const ChapterEntitiesWidget({
    required this.campaignId,
    required this.chapterId,
    super.key,
  });

  final String campaignId;
  final String chapterId;

  @override
  Widget build(BuildContext context) {
    // Keep Provider dependencies for rebuild triggers
    context.watch<List<Chapter>>();
    context.watch<List<Adventure>>();
    context.watch<List<Scene>>();
    context.watch<List<Entity>>();

    return GatheredEntitiesWidget(
      future: EntityGatherer(
        campaignRepo: getIt<CampaignRepository>(),
        chapterRepo: getIt<ChapterRepository>(),
        adventureRepo: getIt<AdventureRepository>(),
        sceneRepo: getIt<SceneRepository>(),
        encounterRepo: getIt<EncounterRepository>(),
        entityRepo: getIt<EntityRepository>(),
      ).gatherFromChapter(campaignId, chapterId),
    );
  }
}

/// Widget that displays entities for an adventure
class AdventureEntitiesWidget extends StatelessWidget {
  const AdventureEntitiesWidget({
    required this.campaignId,
    required this.chapterId,
    required this.adventureId,
    super.key,
  });

  final String campaignId;
  final String chapterId;
  final String adventureId;

  @override
  Widget build(BuildContext context) {
    // Keep Provider dependencies for rebuild triggers
    context.watch<List<Adventure>>();
    context.watch<List<Scene>>();
    context.watch<List<Entity>>();

    return GatheredEntitiesWidget(
      future: EntityGatherer(
        campaignRepo: getIt<CampaignRepository>(),
        chapterRepo: getIt<ChapterRepository>(),
        adventureRepo: getIt<AdventureRepository>(),
        sceneRepo: getIt<SceneRepository>(),
        encounterRepo: getIt<EncounterRepository>(),
        entityRepo: getIt<EntityRepository>(),
      ).gatherFromAdventure(campaignId, chapterId, adventureId),
    );
  }
}

/// Widget that displays entities for a scene
class SceneEntitiesWidget extends StatelessWidget {
  const SceneEntitiesWidget({
    required this.campaignId,
    required this.chapterId,
    required this.adventureId,
    required this.sceneId,
    super.key,
  });

  final String campaignId;
  final String chapterId;
  final String adventureId;
  final String sceneId;

  @override
  Widget build(BuildContext context) {
    // Keep Provider dependencies for rebuild triggers
    context.watch<List<Scene>>();
    context.watch<List<Entity>>();

    return GatheredEntitiesWidget(
      future: EntityGatherer(
        campaignRepo: getIt<CampaignRepository>(),
        chapterRepo: getIt<ChapterRepository>(),
        adventureRepo: getIt<AdventureRepository>(),
        sceneRepo: getIt<SceneRepository>(),
        encounterRepo: getIt<EncounterRepository>(),
        entityRepo: getIt<EntityRepository>(),
      ).gatherFromScene(campaignId, chapterId, adventureId, sceneId),
    );
  }
}

/// Widget that displays entities for an encounter
class EncounterEntitiesWidget extends StatelessWidget {
  const EncounterEntitiesWidget({
    required this.campaignId,
    required this.encounterId,
    super.key,
  });

  final String campaignId;
  final String encounterId;

  @override
  Widget build(BuildContext context) {
    return GatheredEntitiesWidget(
      future: EntityGatherer(
        campaignRepo: getIt<CampaignRepository>(),
        chapterRepo: getIt<ChapterRepository>(),
        adventureRepo: getIt<AdventureRepository>(),
        sceneRepo: getIt<SceneRepository>(),
        encounterRepo: getIt<EncounterRepository>(),
        entityRepo: getIt<EntityRepository>(),
      ).gatherFromEncounter(campaignId, encounterId),
    );
  }
}
