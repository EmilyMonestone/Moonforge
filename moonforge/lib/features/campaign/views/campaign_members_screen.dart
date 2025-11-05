import 'package:flutter/material.dart';
import 'package:m3e_collection/m3e_collection.dart'
    show ButtonM3E, ButtonM3EStyle, ButtonM3EShape;
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Screen for managing campaign members and permissions
class CampaignMembersScreen extends StatefulWidget {
  const CampaignMembersScreen({super.key});

  @override
  State<CampaignMembersScreen> createState() => _CampaignMembersScreenState();
}

class _CampaignMembersScreenState extends State<CampaignMembersScreen> {
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
            child: Row(
              children: [
                Text(
                  'Campaign Members',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const Spacer(),
                ButtonM3E(
                  style: ButtonM3EStyle.filled,
                  shape: ButtonM3EShape.square,
                  icon: const Icon(Icons.person_add_outlined),
                  label: const Text('Invite Member'),
                  onPressed: () => _showInviteDialog(context),
                ),
              ],
            ),
          ),

          // Owner Section
          SurfaceContainer(
            title: const Row(
              children: [
                Icon(Icons.star_outlined),
                SizedBox(width: 8),
                Text('Owner'),
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  campaign.ownerUid?.substring(0, 2).toUpperCase() ?? 'OW',
                ),
              ),
              title: Text(campaign.ownerUid ?? 'Unknown'),
              subtitle: const Text('Campaign Owner'),
              trailing: const Chip(
                label: Text('Owner'),
                backgroundColor: Colors.blue,
              ),
            ),
          ),

          // Members Section
          SurfaceContainer(
            title: Row(
              children: [
                const Icon(Icons.group_outlined),
                const SizedBox(width: 8),
                Text('Members (${campaign.memberUids.length})'),
              ],
            ),
            child: campaign.memberUids.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No members yet. Invite members to collaborate on this campaign.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: campaign.memberUids.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final memberUid = campaign.memberUids[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            memberUid.substring(0, 2).toUpperCase(),
                          ),
                        ),
                        title: Text(memberUid),
                        subtitle: const Text('Member'),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'remove') {
                              _showRemoveMemberDialog(context, memberUid);
                            } else if (value == 'change_role') {
                              _showChangeRoleDialog(context, memberUid);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'change_role',
                              child: Row(
                                children: [
                                  Icon(Icons.edit_outlined),
                                  SizedBox(width: 8),
                                  Text('Change Role'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'remove',
                              child: Row(
                                children: [
                                  Icon(Icons.person_remove_outlined),
                                  SizedBox(width: 8),
                                  Text('Remove'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Pending Invitations
          SurfaceContainer(
            title: const Row(
              children: [
                Icon(Icons.pending_outlined),
                SizedBox(width: 8),
                Text('Pending Invitations'),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No pending invitations',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),

          // Sharing Settings
          SurfaceContainer(
            title: const Row(
              children: [
                Icon(Icons.share_outlined),
                SizedBox(width: 8),
                Text('Sharing Settings'),
              ],
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.link_outlined),
                  title: const Text('Share Link Enabled'),
                  subtitle: const Text('Allow users with link to join'),
                  value: false, // Placeholder
                  onChanged: (value) {
                    // TODO: Toggle share link
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.copy_outlined),
                  title: const Text('Copy Share Link'),
                  subtitle: const Text('Share this link with others'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Copy share link to clipboard
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

  void _showInviteDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invite Member'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Email or User ID',
                border: OutlineInputBorder(),
                hintText: 'user@example.com',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(),
              ),
              value: 'member',
              items: const [
                DropdownMenuItem(
                  value: 'member',
                  child: Text('Member'),
                ),
                DropdownMenuItem(
                  value: 'editor',
                  child: Text('Editor'),
                ),
                DropdownMenuItem(
                  value: 'viewer',
                  child: Text('Viewer'),
                ),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Send invitation
              Navigator.of(context).pop();
            },
            child: const Text('Send Invitation'),
          ),
        ],
      ),
    );
  }

  void _showRemoveMemberDialog(BuildContext context, String memberUid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text(
          'Are you sure you want to remove $memberUid from this campaign?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Remove member
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _showChangeRoleDialog(BuildContext context, String memberUid) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Change role for $memberUid'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'New Role',
                border: OutlineInputBorder(),
              ),
              value: 'member',
              items: const [
                DropdownMenuItem(
                  value: 'member',
                  child: Text('Member'),
                ),
                DropdownMenuItem(
                  value: 'editor',
                  child: Text('Editor'),
                ),
                DropdownMenuItem(
                  value: 'viewer',
                  child: Text('Viewer'),
                ),
              ],
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Update member role
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
