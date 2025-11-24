import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/features/home/services/dashboard_service.dart';
import 'package:moonforge/features/home/widgets/placeholders.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// Widget displaying campaign statistics summary on the dashboard
class StatsOverviewWidget extends StatelessWidget {
  const StatsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final uid = fb_auth.FirebaseAuth.instance.currentUser?.uid;
    final theme = Theme.of(context);

    final dashboardService = getIt<DashboardService>();

    return FutureBuilder<DashboardStats>(
      future: dashboardService.fetchStats(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPlaceholder();
        }

        if (snapshot.hasError) {
          logger.e('Error loading dashboard stats: ${snapshot.error}');
          return const ErrorPlaceholder();
        }

        final stats = snapshot.data;
        if (stats == null) {
          return const EmptyPlaceholder();
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(
                label: l10n.totalCampaigns,
                value: stats.totalCampaigns.toString(),
                icon: Icons.book,
                color: theme.colorScheme.primary,
              ),
              _StatCard(
                label: l10n.totalSessions,
                value: stats.totalSessions.toString(),
                icon: Icons.event,
                color: theme.colorScheme.secondary,
              ),
              _StatCard(
                label: l10n.totalParties,
                value: stats.totalParties.toString(),
                icon: Icons.group,
                color: theme.colorScheme.tertiary,
              ),
              _StatCard(
                label: l10n.totalEntities,
                value: stats.totalEntities.toString(),
                icon: Icons.person,
                color: theme.colorScheme.primary,
              ),
              _StatCard(
                label: l10n.upcomingSessionsCount,
                value: stats.upcomingSessions.toString(),
                icon: Icons.calendar_today,
                color: theme.colorScheme.secondary,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 140,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
