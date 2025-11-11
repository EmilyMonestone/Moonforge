import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Screen for campaign-specific settings and configuration
class CampaignSettingsScreen extends StatefulWidget {
  const CampaignSettingsScreen({super.key});

  @override
  State<CampaignSettingsScreen> createState() => _CampaignSettingsScreenState();
}

class _CampaignSettingsScreenState extends State<CampaignSettingsScreen> {
  late CampaignService _service;

  @override
  void initState() {
    super.initState();
    final db = context.read<AppDb>();
    _service = CampaignService(CampaignRepository(db));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final campaign = context.watch<CampaignProvider>().currentCampaign;

    if (campaign == null) {
      return Center(child: Text(l10n.noCampaignSelected));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Campaign Settings',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),

          // General Settings
          SurfaceContainer(
            title: const Row(
              children: [
                Icon(Icons.settings_outlined),
                SizedBox(width: 8),
                Text('General Settings'),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Edit Campaign'),
                  subtitle: const Text('Update name, description, and content'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    const CampaignEditRouteData().go(context);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  secondary: const Icon(Icons.visibility_outlined),
                  title: const Text('Public Campaign'),
                  subtitle: const Text('Allow others to view this campaign'),
                  value: false,
                  // Placeholder
                  onChanged: (value) {
                    // TODO: Implement visibility toggle
                  },
                ),
              ],
            ),
          ),

          // Privacy & Sharing
          SurfaceContainer(
            title: const Row(
              children: [
                Icon(Icons.share_outlined),
                SizedBox(width: 8),
                Text('Privacy & Sharing'),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.people_outlined),
                  title: const Text('Members'),
                  subtitle: Text(
                    '${(campaign.memberUids?.length ?? 0)} members',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    const CampaignMembersRouteData().go(context);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.link_outlined),
                  title: const Text('Share Link'),
                  subtitle: const Text(
                    'Generate a share link for this campaign',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Generate and show share link
                  },
                ),
              ],
            ),
          ),

          // Backup & Export
          SurfaceContainer(
            title: const Row(
              children: [
                Icon(Icons.backup_outlined),
                SizedBox(width: 8),
                Text('Backup & Export'),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: const Text('Export Campaign'),
                  subtitle: const Text('Download campaign data as JSON'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Implement export functionality
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.content_copy_outlined),
                  title: const Text('Duplicate Campaign'),
                  subtitle: const Text('Create a copy of this campaign'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    // Show dialog to enter new name
                    final newName = await _showDuplicateDialog(
                      context,
                      campaign.name,
                    );
                    if (newName != null && context.mounted) {
                      final newCampaign = await _service.duplicateCampaign(
                        campaign,
                        newName,
                      );
                      if (newCampaign != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Campaign duplicated: $newName'),
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          // Danger Zone
          SurfaceContainer(
            title: Row(
              children: [
                Icon(
                  Icons.warning_outlined,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  'Danger Zone',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.archive_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Archive Campaign',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  subtitle: const Text('Hide this campaign from your list'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final confirmed = await _showArchiveDialog(context);
                    if (confirmed == true && context.mounted) {
                      await _service.archiveCampaign(campaign);
                      if (context.mounted) {
                        const HomeRouteData().go(context);
                      }
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.delete_forever_outlined,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    'Delete Campaign',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  subtitle: const Text('Permanently delete this campaign'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final confirmed = await _showDeleteDialog(
                      context,
                      campaign.name,
                    );
                    if (confirmed == true && context.mounted) {
                      await CampaignRepository(
                        context.read<AppDb>(),
                      ).delete(campaign.id);
                      if (context.mounted) {
                        context
                            .read<CampaignProvider>()
                            .clearPersistedCampaign();
                        const HomeRouteData().go(context);
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<String?> _showDuplicateDialog(
    BuildContext context,
    String currentName,
  ) async {
    final controller = TextEditingController(text: '$currentName (Copy)');
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duplicate Campaign'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'New Campaign Name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                Navigator.of(context).pop(name);
              }
            },
            child: const Text('Duplicate'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showArchiveDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Campaign'),
        content: const Text(
          'Are you sure you want to archive this campaign? '
          'You can restore it later from the archived campaigns list.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteDialog(
    BuildContext context,
    String campaignName,
  ) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Campaign'),
        content: Text(
          'Are you sure you want to permanently delete "$campaignName"? '
          'This action cannot be undone and all related data will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
