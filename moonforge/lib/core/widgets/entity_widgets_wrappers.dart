import 'package:flutter/material.dart';
import 'package:moonforge/core/models/entity_with_origin.dart';
import 'package:moonforge/core/services/entity_gatherer.dart';
import 'package:moonforge/core/widgets/entities_widget.dart';

/// Widget that displays entities for a campaign
class CampaignEntitiesWidget extends StatelessWidget {
  const CampaignEntitiesWidget({
    required this.campaignId,
    super.key,
  });

  final String campaignId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EntityWithOrigin>>(
      future: EntityGatherer().gatherFromCampaign(campaignId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final entities = snapshot.data ?? [];
        return EntitiesWidget(entities: entities);
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
    return FutureBuilder<List<EntityWithOrigin>>(
      future: EntityGatherer().gatherFromChapter(campaignId, chapterId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final entities = snapshot.data ?? [];
        return EntitiesWidget(entities: entities);
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
    return FutureBuilder<List<EntityWithOrigin>>(
      future: EntityGatherer().gatherFromAdventure(
        campaignId,
        chapterId,
        adventureId,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final entities = snapshot.data ?? [];
        return EntitiesWidget(entities: entities);
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
    return FutureBuilder<List<EntityWithOrigin>>(
      future: EntityGatherer().gatherFromScene(
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
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final entities = snapshot.data ?? [];
        return EntitiesWidget(entities: entities);
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
    return FutureBuilder<List<EntityWithOrigin>>(
      future: EntityGatherer().gatherFromEncounter(campaignId, encounterId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final entities = snapshot.data ?? [];
        return EntitiesWidget(entities: entities);
      },
    );
  }
}
