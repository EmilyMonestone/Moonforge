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
    context.watch<List<adv_model.Adventure>>();
    context.watch<List<scene_model.Scene>>();
    context.watch<List<enc_model.Encounter>>();
    context.watch<List<entity_model.Entity>>();
    final campaign = campaigns.firstWhere(
      (c) => c.id == campaignId,
      orElse: () => const Campaign(id: '', name: '', description: ''),
    );
    if (campaign.id.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    // Use EntityGatherer to traverse hierarchy via ODM and deduplicate with consistent origins
    return FutureBuilder<List<EntityWithOrigin>>(
      future: EntityGatherer().gatherFromCampaign(campaignId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e('Error gathering campaign entities: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        final result = snapshot.data ?? const <EntityWithOrigin>[];
        return EntitiesWidget(entities: result);
      },
  }
}
/// Widget that displays entities for a chapter
class ChapterEntitiesWidget extends StatelessWidget {
  const ChapterEntitiesWidget({
    required this.campaignId,
    required this.chapterId,
    super.key,
  });
  final String chapterId;
    // Keep Provider dependencies for rebuild triggers
      future: EntityGatherer().gatherFromChapter(campaignId, chapterId),
          logger.e('Error gathering chapter entities: ${snapshot.error}');
/// Widget that displays entities for an adventure
class AdventureEntitiesWidget extends StatelessWidget {
  const AdventureEntitiesWidget({
    required this.adventureId,
  final String adventureId;
      future: EntityGatherer().gatherFromAdventure(
        campaignId,
        chapterId,
        adventureId,
      ),
          logger.e('Error gathering adventure entities: ${snapshot.error}');
/// Widget that displays entities for a scene
class SceneEntitiesWidget extends StatelessWidget {
  const SceneEntitiesWidget({
    required this.sceneId,
  final String sceneId;
      future: EntityGatherer().gatherFromScene(
        sceneId,
          logger.e('Error gathering scene entities: ${snapshot.error}');
/// Widget that displays entities for an encounter
class EncounterEntitiesWidget extends StatelessWidget {
  const EncounterEntitiesWidget({
    required this.encounterId,
  final String encounterId;
      future: EntityGatherer().gatherFromEncounter(campaignId, encounterId),
          logger.e('Error gathering encounter entities: ${snapshot.error}');
