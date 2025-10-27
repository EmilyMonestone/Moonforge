import 'package:flutter/material.dart';
import 'package:moonforge/data/providers/sync_state_provider.dart';
import 'package:moonforge/data/widgets/sync_state_widget.dart';
import 'package:provider/provider.dart';

/// Example widget demonstrating how to use the SyncStateWidget
/// 
/// This can be placed in an app bar, toolbar, or any other location
/// to show the user the current sync status.
class SyncStateIndicatorExample extends StatelessWidget {
  const SyncStateIndicatorExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SyncStateProvider>(
      builder: (context, syncStateProvider, _) {
        return AnimatedSyncStateWidget(
          state: syncStateProvider.state,
          pendingCount: syncStateProvider.pendingCount,
          errorMessage: syncStateProvider.errorMessage,
          onTap: () => _showSyncDetails(context, syncStateProvider),
        );
      },
    );
  }

  void _showSyncDetails(BuildContext context, SyncStateProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusRow('State', _getStateLabel(provider.state)),
            if (provider.pendingCount > 0)
              _buildStatusRow('Pending', '${provider.pendingCount} operations'),
            if (provider.errorMessage != null)
              _buildStatusRow('Error', provider.errorMessage!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (provider.state == SyncState.error)
            TextButton(
              onPressed: () {
                provider.refresh();
                Navigator.of(context).pop();
              },
              child: const Text('Retry'),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getStateLabel(SyncState state) {
    switch (state) {
      case SyncState.synced:
        return 'Synced';
      case SyncState.syncing:
        return 'Syncing...';
      case SyncState.pendingSync:
        return 'Pending Sync';
      case SyncState.error:
        return 'Error';
      case SyncState.offline:
        return 'Offline';
    }
  }
}

/// Example showing sync state in an app bar
class AppBarWithSyncState extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppBarWithSyncState({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        const SyncStateIndicatorExample(),
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
