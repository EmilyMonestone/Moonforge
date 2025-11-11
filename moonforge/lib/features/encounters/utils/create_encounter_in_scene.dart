import 'package:flutter/material.dart';
import 'package:moonforge/core/services/notification_service.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Create a new encounter scoped to a scene via ID prefix
Future<void> createEncounterInScene(
  BuildContext context,
  db.Campaign campaign,
  String chapterId,
  String adventureId,
  String sceneId,
) async {
  final l10n = AppLocalizations.of(context)!;
  final repository = Provider.of<EncounterRepository>(context, listen: false);

  final encounter = db.Encounter(
    id: 'encounter-$sceneId-${DateTime.now().millisecondsSinceEpoch}',
    name: 'New Encounter',
    originId: sceneId,
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
