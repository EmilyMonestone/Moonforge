import 'package:flutter/material.dart';
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Screen for detailed campaign analytics and statistics
class CampaignAnalyticsScreen extends StatefulWidget {
  const CampaignAnalyticsScreen({super.key});

  @override
  State<CampaignAnalyticsScreen> createState() =>
      _CampaignAnalyticsScreenState();
}

class _CampaignAnalyticsScreenState extends State<CampaignAnalyticsScreen> {
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
              'Campaign Analytics',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),

          // Overview Statistics
          SurfaceContainer(
            title: const Row(
              children: [
                Icon(Icons.analytics_outlined),
                SizedBox(width: 8),
                Text('Overview'),
              ],
            ),
            child: FutureBuilder<CampaignStats>(
              future: _service.getCampaignStats(campaign),
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
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _MetricCard(
                      title: 'Total Chapters',
                      value: stats?.chapterCount.toString() ?? '0',
                      icon: DomainType.chapter.icon,
                      color: DomainType.chapter.color ?? Colors.blue,
                    ),
                    _MetricCard(
                      title: 'Total Entities',
                      value: stats?.entityCount.toString() ?? '0',
                      icon: Icons.category_outlined,
                      color: Colors.green,
                    ),
                    _MetricCard(
                      title: 'Total Sessions',
                      value: stats?.sessionCount.toString() ?? '0',
                      icon: Icons.event_outlined,
                      color: Colors.orange,
                    ),
                    if (stats != null && stats.totalPlayTimeMinutes > 0)
                      _MetricCard(
                        title: 'Total Play Time',
                        value: _formatPlayTime(stats.totalPlayTimeMinutes),
                        icon: Icons.timer_outlined,
                        color: Colors.purple,
                      ),
                  ],
                );
              },
            ),
          ),

          // Session History
          SurfaceContainer(
            title: const Row(
              children: [
                Icon(Icons.history_outlined),
                SizedBox(width: 8),
                Text('Session History'),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Session history chart will be displayed here',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),

          // Entity Distribution
          SurfaceContainer(
            title: const Row(
              children: [
                Icon(Icons.pie_chart),
                SizedBox(width: 8),
                Text('Entity Distribution'),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Entity distribution by type will be displayed here',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),

          // Activity Timeline
          SurfaceContainer(
            title: const Row(
              children: [
                Icon(Icons.timeline_outlined),
                SizedBox(width: 8),
                Text('Activity Timeline'),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Recent activity timeline will be displayed here',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
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

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
