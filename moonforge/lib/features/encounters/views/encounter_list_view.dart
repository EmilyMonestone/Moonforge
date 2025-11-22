import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/action_button.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/encounters/widgets/encounter_list.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Screen to display a list of all encounters in a campaign
class EncounterListView extends StatelessWidget {
  const EncounterListView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    final encounters = context.watch<List<db.Encounter>>();
    final campaignEncounters =
        encounters.where((e) => e.originId == campaign.id).toList()
          ..sort((a, b) => a.name.compareTo(b.name));

    return Column(
      children: [
        SurfaceContainer(
          title: Row(
            children: [
              Text(
                l10n.encounters,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Spacer(),
              ActionButton(
                label: l10n.createEncounter,
                icon: Icons.add,
                onPressed: () {
                  // TODO: Implement create encounter action
                },
              ),
            ],
          ),
          child: SizedBox.shrink(),
        ),
        Expanded(
          child: EncounterList(
            encounters: campaignEncounters,
            onEncounterTap: (encounter) {
              EncounterRouteData(encounterId: encounter.id).go(context);
            },
            emptyStateTitle: l10n.noEncountersYet,
            emptyStateMessage: l10n.emptyStateGenericMessage,
            onCreateEncounter: () {
              // TODO: Hook up encounter creation
            },
          ),
        ),
      ],
    );
  }
}
