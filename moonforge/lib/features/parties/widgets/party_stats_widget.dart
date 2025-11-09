import 'package:flutter/material.dart';
import 'package:moonforge/features/parties/services/party_service.dart';

/// Widget displaying party statistics
class PartyStatsWidget extends StatelessWidget {
  final String partyId;
  final PartyService partyService;

  const PartyStatsWidget({
    super.key,
    required this.partyId,
    required this.partyService,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PartyStatistics>(
      future: partyService.getPartyStatistics(partyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        final stats = snapshot.data;
        if (stats == null) {
          return const SizedBox.shrink();
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Party Statistics',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _buildStatRow(
                  context,
                  'Members',
                  stats.memberCount.toString(),
                  Icons.group,
                ),
                _buildStatRow(
                  context,
                  'Average Level',
                  stats.averageLevel.toStringAsFixed(1),
                  Icons.trending_up,
                ),
                _buildStatRow(
                  context,
                  'Total HP',
                  stats.totalHp.toString(),
                  Icons.favorite,
                ),
                _buildStatRow(
                  context,
                  'Average AC',
                  stats.averageAc.toStringAsFixed(1),
                  Icons.shield,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
