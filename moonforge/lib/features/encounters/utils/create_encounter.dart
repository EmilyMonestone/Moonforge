import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

/// Create a new encounter and navigate to the editor
Future<void> createEncounter(BuildContext context, db.Campaign campaign) async {
  final repository = Provider.of<EncounterRepository>(context, listen: false);

  final encounter = db.Encounter(
    id: const Uuid().v4(),
    name: 'New Encounter',
    originId: campaign.id,
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
    EncounterEditRoute(encounterId: encounter.id).go(context);
  }
}
