import 'package:flutter/material.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

enum EncounterCreationScope { campaign, chapter, adventure, scene }

/// Create a new encounter and navigate to the editor
Future<void> createEncounter(
  BuildContext context,
  db.Campaign campaign, {
  EncounterCreationScope scope = EncounterCreationScope.campaign,
  String? chapterId,
  String? adventureId,
  String? sceneId,
}) async {
  final repository = getIt<EncounterRepository>();
  final l10n = AppLocalizations.of(context)!;

  final originId = switch (scope) {
    EncounterCreationScope.campaign => campaign.id,
    EncounterCreationScope.chapter => chapterId ?? campaign.id,
    EncounterCreationScope.adventure => adventureId ?? chapterId ?? campaign.id,
    EncounterCreationScope.scene =>
      sceneId ?? adventureId ?? chapterId ?? campaign.id,
  };

  final encounter = db.Encounter(
    id: const Uuid().v4(),
    name: 'New Encounter',
    originId: originId,
    preset: false,
    notes: null,
    loot: null,
    combatants: const <Map<String, dynamic>>[],
    entityIds: const <String>[],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    rev: 0,
  );

  await repository.upsertLocal(encounter);

  if (context.mounted) {
    notification.success(context, title: Text(l10n.createEncounter));
    EncounterEditRouteData(encounterId: encounter.id).go(context);
  }
}
