import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/controllers/campaign_list_controller.dart';
import 'package:moonforge/features/campaign/widgets/campaign_card.dart';
import 'package:provider/provider.dart';

/// Widget for displaying a list or grid of campaigns
class CampaignList extends StatelessWidget {
  final List<Campaign> campaigns;
  final ViewMode viewMode;
  final Function(Campaign)? onCampaignTap;
  final Function(Campaign)? onCampaignEdit;
  final Function(Campaign)? onCampaignDelete;

  const CampaignList({
    super.key,
    required this.campaigns,
    this.viewMode = ViewMode.grid,
    this.onCampaignTap,
    this.onCampaignEdit,
    this.onCampaignDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (campaigns.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.campaign_outlined, size: 64),
            SizedBox(height: 16),
            Text('No campaigns found'),
            SizedBox(height: 8),
            Text('Create a new campaign to get started'),
          ],
        ),
      );
    }

    final controller = context.watch<CampaignListController>();

    if (viewMode == ViewMode.grid) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          final campaign = campaigns[index];
          return CampaignCard(
            campaign: campaign,
            selected: controller.selectedCampaignIds.contains(campaign.id),
            onTap: () => onCampaignTap?.call(campaign),
            onEdit: onCampaignEdit != null
                ? () => onCampaignEdit!(campaign)
                : null,
            onDelete: onCampaignDelete != null
                ? () => onCampaignDelete!(campaign)
                : null,
            onSelectionToggle: () => controller.toggleSelection(campaign.id),
          );
        },
      );
    }

    // List view
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: campaigns.length,
      itemBuilder: (context, index) {
        final campaign = campaigns[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: CampaignCard(
            campaign: campaign,
            selected: controller.selectedCampaignIds.contains(campaign.id),
            onTap: () => onCampaignTap?.call(campaign),
            onEdit: onCampaignEdit != null
                ? () => onCampaignEdit!(campaign)
                : null,
            onDelete: onCampaignDelete != null
                ? () => onCampaignDelete!(campaign)
                : null,
            onSelectionToggle: () => controller.toggleSelection(campaign.id),
          ),
        );
      },
    );
  }
}
