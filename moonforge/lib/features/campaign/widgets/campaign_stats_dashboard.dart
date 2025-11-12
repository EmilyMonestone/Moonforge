import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';

/// Dashboard widget showing campaign statistics and overview
class CampaignStatsDashboard extends StatelessWidget {
  final Campaign campaign;
  final CampaignService? service;

  const CampaignStatsDashboard({
    super.key,
    required this.campaign,
    this.service,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CampaignStats>(
      future: service?.getCampaignStats(campaign),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final stats = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(
                icon: Icons.library_books_outlined,
                label: 'Chapters',
                value: stats?.chapterCount.toString() ?? '0',
                color: Colors.blue,
              ),
              _StatCard(
                icon: Icons.category_outlined,
                label: 'Entities',
                value:
                    stats?.entityCount.toString() ??
                    campaign.entityIds.length.toString(),
                color: Colors.green,
              ),
              _StatCard(
                icon: Icons.event_outlined,
                label: 'Sessions',
                value: stats?.sessionCount.toString() ?? '0',
                color: Colors.orange,
              ),
              if (stats != null && stats.totalPlayTimeMinutes > 0)
                _StatCard(
                  icon: Icons.timer_outlined,
                  label: 'Play Time',
                  value: _formatPlayTime(stats.totalPlayTimeMinutes),
                  color: Colors.purple,
                ),
              if ((campaign.memberUids?.isNotEmpty ?? false))
                _StatCard(
                  icon: Icons.group_outlined,
                  label: 'Members',
                  value: (campaign.memberUids?.length ?? 0).toString(),
                  color: Colors.teal,
                ),
            ],
          ),
        );
      },
    );
  }

  String _formatPlayTime(int minutes) {
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    if (remainingMinutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${remainingMinutes}m';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 120,
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
