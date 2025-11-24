import 'package:flutter/material.dart';
import 'package:moonforge/core/design/design_system.dart';
import 'package:moonforge/core/widgets/empty_state.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/controllers/campaign_list_controller.dart';
import 'package:moonforge/features/campaign/utils/create_campaign.dart';
import 'package:moonforge/features/campaign/widgets/campaign_card.dart';
import 'package:moonforge/l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;

    if (campaigns.isEmpty) {
      return EmptyState(
        icon: Icons.campaign_outlined,
        title: l10n.emptyStateNoItems,
        message: l10n.emptyStateGenericMessage,
        actionLabel: l10n.createCampaignCta,
        onAction: () => createCampaignAndOpenEditor(context),
      );
    }

    final controller = context.watch<CampaignListController>();

    if (viewMode == ViewMode.grid) {
      return GridView.builder(
        padding: AppSpacing.paddingLg,
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
    return ListView.separated(
      padding: AppSpacing.paddingLg,
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
      separatorBuilder: (context, _) => const SizedBox(height: AppSpacing.sm),
    );
  }
}
