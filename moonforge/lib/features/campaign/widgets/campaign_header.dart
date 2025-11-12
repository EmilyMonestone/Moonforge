import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart';
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            campaign.name,
            style: theme.textTheme.displaySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 16),
          Flexible(
            fit: FlexFit.loose,
            child: ButtonGroupM3E(
              type: ButtonGroupM3EType.connected,
              style: ButtonM3EStyle.tonal,
              overflow: ButtonGroupM3EOverflow.menu,
              expanded: true,
              linearMainAxisAlignment: MainAxisAlignment.end,
              actions: [
                ButtonGroupM3EAction(
                  label: Text(l10n.edit),
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    const CampaignEditRouteData().go(context);
                  },
                ),
                if (onShare != null)
                  ButtonGroupM3EAction(
                    label: Text(l10n.share),
                    icon: const Icon(Icons.share_outlined),
                    onPressed: onShare,
                  ),
                if (onSettings != null)
                  ButtonGroupM3EAction(
                    label: Text(l10n.settings),
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: onSettings,
                  )
                else
                  ButtonGroupM3EAction(
                    label: Text(l10n.settings),
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      const CampaignSettingsRouteData().go(context);
                    },
                  ),
                ButtonGroupM3EAction(
                  label: Text(l10n.analytics),
                  icon: const Icon(Icons.analytics_outlined),
                  onPressed: () {},
                ),
                ButtonGroupM3EAction(
                  label: Text(l10n.duplicate),
                  icon: const Icon(Icons.content_copy_outlined),
                  onPressed: () {},
                ),
                ButtonGroupM3EAction(
                  label: Text(l10n.archive),
                  icon: const Icon(Icons.archive_outlined),
                  onPressed: () {},
                ),
                ButtonGroupM3EAction(
                  label: Text(l10n.export),
                  icon: const Icon(Icons.download_outlined),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
