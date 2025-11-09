import 'package:flutter/material.dart'; // import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/features/session/services/session_service.dart';
import 'package:moonforge/features/session/utils/session_formatters.dart';

/// Widget for displaying session statistics
class SessionStatsWidget extends StatelessWidget {
  const SessionStatsWidget({super.key, required this.stats});

  final SessionStats stats;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SurfaceContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Session Statistics',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  context,
                  icon: Icons.event,
                  label: 'Total Sessions',
                  value: stats.totalSessions.toString(),
                  color: colorScheme.primary,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.timer,
                  label: 'Avg Duration',
                  value: SessionFormatters.formatDurationShort(
                    stats.averageDuration,
                  ),
                  color: colorScheme.secondary,
                ),
                _buildStatCard(
                  context,
                  icon: Icons.access_time,
                  label: 'Total Time',
                  value: SessionFormatters.formatDurationShort(
                    stats.totalDuration,
                  ),
                  color: colorScheme.tertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
