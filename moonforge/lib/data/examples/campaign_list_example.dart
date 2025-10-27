import 'package:flutter/material.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:provider/provider.dart';

/// Example widget showing how to consume the Drift offline-first campaigns
/// 
/// This demonstrates:
/// 1. Watching campaigns stream with context.watch
/// 2. Writing campaigns through repository
/// 3. Optimistic local updates with automatic sync
class CampaignListExample extends StatelessWidget {
  const CampaignListExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch campaigns stream (local-first, instant updates)
    final campaigns = context.watch<List<Campaign>>();
    final repository = context.read<CampaignRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaigns (Offline-First)'),
      ),
      body: ListView.builder(
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          final campaign = campaigns[index];
          return ListTile(
            title: Text(campaign.name),
            subtitle: Text(campaign.description),
            trailing: Text('rev: ${campaign.rev}'),
            onTap: () async {
              // Example: patch the campaign name
              await repository.patchLocal(
                id: campaign.id,
                baseRev: campaign.rev,
                ops: [
                  {
                    'type': 'set',
                    'field': 'name',
                    'value': '${campaign.name} (edited)',
                  }
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Example: create new campaign
          final newCampaign = Campaign(
            id: 'campaign_${DateTime.now().millisecondsSinceEpoch}',
            name: 'New Campaign',
            description: 'Created offline',
            rev: 0,
          );
          await repository.upsertLocal(newCampaign);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
