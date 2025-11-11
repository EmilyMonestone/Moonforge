import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// Header widget for campaign screens with title and action buttons
class CampaignHeader extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback? onShare;
  final VoidCallback? onSettings;

  const CampaignHeader({
    super.key,
    required this.campaign,
    this.onShare,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(campaign.name, style: theme.textTheme.displaySmall),
                    if (campaign.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        campaign.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: l10n.edit,
                onPressed: () {
                  const CampaignEditRouteData().go(context);
                },
              ),
              if (onShare != null)
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  tooltip: 'Share',
                  onPressed: onShare,
                ),
              if (onSettings != null)
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: l10n.settings,
                  onPressed: onSettings,
                )
              else
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: l10n.settings,
                  onPressed: () {
                    const CampaignSettingsRouteData().go(context);
                  },
                ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  // Handle menu actions
                  switch (value) {
                    case 'analytics':
                      const CampaignAnalyticsRouteData().go(context);
                      break;
                    case 'duplicate':
                      // Duplicate campaign
                      break;
                    case 'archive':
                      // Archive campaign
                      break;
                    case 'export':
                      // Export campaign
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'analytics',
                    child: Row(
                      children: [
                        Icon(Icons.analytics_outlined),
                        SizedBox(width: 8),
                        Text('Analytics'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.content_copy_outlined),
                        SizedBox(width: 8),
                        Text('Duplicate'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'archive',
                    child: Row(
                      children: [
                        Icon(Icons.archive_outlined),
                        SizedBox(width: 8),
                        Text('Archive'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'export',
                    child: Row(
                      children: [
                        Icon(Icons.download_outlined),
                        SizedBox(width: 8),
                        Text('Export'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
