import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/entity_widgets_wrappers.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EncounterView extends StatelessWidget {
  const EncounterView({super.key, required this.encounterId});

  final String encounterId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    final encounters = context.watch<List<db.Encounter>>();
    final encounter = encounters.firstWhere(
      (e) => e.id == encounterId,
      orElse: () => db.Encounter(
        id: '',
        name: '',
        originId: campaign.id,
        preset: false,
        entityIds: const <String>[],
        rev: 0,
      ),
    );
    if (encounter.id.isEmpty) {
      return Center(child: Text('Encounter not found'));
    }

    return Column(
      children: [
        SurfaceContainer(
          title: Row(
            children: [
              Text(
                encounter.name,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Spacer(),
              ButtonM3E(
                style: ButtonM3EStyle.tonal,
                shape: ButtonM3EShape.square,
                icon: const Icon(Icons.edit_outlined),
                label: Text(l10n.edit),
                onPressed: () {
                  EncounterEditRouteData(encounterId: encounterId).go(context);
                },
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: context.m3e.spacing.sm,
            children: [
              if ((encounter.notes ?? '').isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(encounter.notes ?? ''),
                  ],
                ),
              if ((encounter.loot ?? '').isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loot',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(encounter.loot ?? ''),
                  ],
                ),
            ],
          ),
        ),
        EncounterEntitiesWidget(
          campaignId: campaign.id,
          encounterId: encounterId,
        ),
      ],
    );
  }
}
