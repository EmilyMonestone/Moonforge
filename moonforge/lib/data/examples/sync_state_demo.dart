import 'package:flutter/material.dart';
import 'package:moonforge/data/widgets/sync_state_widget.dart';

/// Demo page showing all sync states for documentation
class SyncStateDemo extends StatefulWidget {
  const SyncStateDemo({super.key});

  @override
  State<SyncStateDemo> createState() => _SyncStateDemoState();
}

class _SyncStateDemoState extends State<SyncStateDemo> {
  SyncState _currentState = SyncState.synced;
  int _pendingCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync State Widget Demo'),
        actions: [
          AnimatedSyncStateWidget(
            state: _currentState,
            pendingCount: _pendingCount,
            errorMessage: 'Connection timeout',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sync state: ${_currentState.name}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Sync State Examples',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          _buildStateCard(
            state: SyncState.synced,
            title: 'Synced',
            description: 'All changes are synchronized with the server',
            icon: Icons.cloud_done,
            color: Colors.green,
          ),
          
          _buildStateCard(
            state: SyncState.syncing,
            title: 'Syncing',
            description: 'Currently synchronizing data (animated rotation)',
            icon: Icons.cloud_sync,
            color: Colors.blue,
          ),
          
          _buildStateCard(
            state: SyncState.pendingSync,
            title: 'Pending Sync',
            description: 'Changes waiting to be synchronized',
            icon: Icons.cloud_upload,
            color: Colors.purple,
            pendingCount: 3,
          ),
          
          _buildStateCard(
            state: SyncState.error,
            title: 'Error',
            description: 'Sync error occurred, will retry',
            icon: Icons.cloud_off,
            color: Colors.red,
          ),
          
          _buildStateCard(
            state: SyncState.offline,
            title: 'Offline',
            description: 'No connection, changes will sync when online',
            icon: Icons.cloud_off,
            color: Colors.grey,
          ),

          const SizedBox(height: 24),
          const Text(
            'Try It',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                onPressed: () => setState(() {
                  _currentState = SyncState.synced;
                  _pendingCount = 0;
                }),
                icon: const Icon(Icons.cloud_done),
                label: const Text('Synced'),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() {
                  _currentState = SyncState.syncing;
                }),
                icon: const Icon(Icons.cloud_sync),
                label: const Text('Syncing'),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() {
                  _currentState = SyncState.pendingSync;
                  _pendingCount = 5;
                }),
                icon: const Icon(Icons.cloud_upload),
                label: const Text('Pending'),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() {
                  _currentState = SyncState.error;
                }),
                icon: const Icon(Icons.cloud_off),
                label: const Text('Error'),
              ),
              ElevatedButton.icon(
                onPressed: () => setState(() {
                  _currentState = SyncState.offline;
                }),
                icon: const Icon(Icons.cloud_off),
                label: const Text('Offline'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStateCard({
    required SyncState state,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    int? pendingCount,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => setState(() {
          _currentState = state;
          _pendingCount = pendingCount ?? 0;
        }),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    if (pendingCount != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Pending: $pendingCount operations',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              AnimatedSyncStateWidget(
                state: state,
                pendingCount: pendingCount,
                errorMessage: 'Connection timeout',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
