import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show BuildContextM3EX, ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/entity_widgets_wrappers.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/firebase/models/encounter.dart';
import 'package:moonforge/data/firebase/models/schema.dart';
import 'package:moonforge/data/firebase/odm.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EncounterScreen extends StatelessWidget {
  const EncounterScreen({super.key, required this.encounterId});

  final String encounterId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;
    final odm = Odm.instance;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    return FutureBuilder<Encounter?>(
      future: odm.campaigns.doc(campaign.id).encounters.doc(encounterId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          logger.e('Error fetching encounter: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final encounter = snapshot.data;
        if (encounter == null) {
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
                      EncounterEditRoute(encounterId: encounterId).go(context);
                    },
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: context.m3e.spacing.sm,
                children: [
                  if (encounter.notes != null && encounter.notes!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notes',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(encounter.notes!),
                      ],
                    ),
                  if (encounter.loot != null && encounter.loot!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Loot',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(encounter.loot!),
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
      },
    );
  }
}
