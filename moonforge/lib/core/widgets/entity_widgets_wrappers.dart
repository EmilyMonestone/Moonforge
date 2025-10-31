import 'package:flutter/material.dart';
import 'package:moonforge/core/services/entity_gatherer.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/entities_widget.dart';
import 'package:moonforge/data/db/app_db.dart';
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
    return FutureBuilder<List<EntityWithOrigin>>(
      future: EntityGatherer(
        campaignRepository: context.read(),
        chapterRepository: context.read(),
        adventureRepository: context.read(),
        sceneRepository: context.read(),
        encounterRepository: context.read(),
        entityRepository: context.read(),
      ).gatherFromCampaign(campaignId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e('Error gathering campaign entities: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final result = snapshot.data ?? const <EntityWithOrigin>[];
        return EntitiesWidget(entities: result);
      },
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

    return FutureBuilder<List<EntityWithOrigin>>(
      future: EntityGatherer(
        campaignRepository: context.read(),
        chapterRepository: context.read(),
        adventureRepository: context.read(),
        sceneRepository: context.read(),
        encounterRepository: context.read(),
        entityRepository: context.read(),
      ).gatherFromChapter(campaignId, chapterId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e('Error gathering chapter entities: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final result = snapshot.data ?? const <EntityWithOrigin>[];
        return EntitiesWidget(entities: result);
      },
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

    return FutureBuilder<List<EntityWithOrigin>>(
      future: EntityGatherer(
        campaignRepository: context.read(),
        chapterRepository: context.read(),
        adventureRepository: context.read(),
        sceneRepository: context.read(),
        encounterRepository: context.read(),
        entityRepository: context.read(),
      ).gatherFromAdventure(
        campaignId,
        chapterId,
        adventureId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e('Error gathering adventure entities: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final result = snapshot.data ?? const <EntityWithOrigin>[];
        return EntitiesWidget(entities: result);
      },
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

    return FutureBuilder<List<EntityWithOrigin>>(
      future: EntityGatherer(
        campaignRepository: context.read(),
        chapterRepository: context.read(),
        adventureRepository: context.read(),
        sceneRepository: context.read(),
        encounterRepository: context.read(),
        entityRepository: context.read(),
      ).gatherFromScene(
        campaignId,
        chapterId,
        adventureId,
        sceneId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e('Error gathering scene entities: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final result = snapshot.data ?? const <EntityWithOrigin>[];
        return EntitiesWidget(entities: result);
      },
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
    // Keep Provider dependencies for rebuild triggers
    context.watch<List<enc_model.Encounter>>();
    context.watch<List<entity_model.Entity>>();

    return FutureBuilder<List<EntityWithOrigin>>(
      future: EntityGatherer().gatherFromEncounter(campaignId, encounterId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e('Error gathering encounter entities: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final result = snapshot.data ?? const <EntityWithOrigin>[];
        return EntitiesWidget(entities: result);
      },
    );
  }
}
