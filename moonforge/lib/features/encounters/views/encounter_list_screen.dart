import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/encounters/widgets/encounter_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Screen to display a list of all encounters in a campaign
class EncounterListScreen extends StatelessWidget {
  const EncounterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    final encounters = context.watch<List<db.Encounter>>();
    final campaignEncounters = encounters
        .where((e) => e.originId == campaign.id)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Column(
      children: [
        SurfaceContainer(
          title: Row(
            children: [
              Text(
                'Encounters',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {
                  // TODO: Implement create encounter action
                  // encounter_utils.createEncounter(context, campaign);
                },
                icon: const Icon(Icons.add),
                label: const Text('New Encounter'),
              ),
            ],
          ),
          child: SizedBox.shrink(),
        ),
        Expanded(
          child: EncounterList(
            encounters: campaignEncounters,
            onEncounterTap: (encounter) {
              EncounterRoute(encounterId: encounter.id).go(context);
            },
          ),
        ),
      ],
    );
  }
}
