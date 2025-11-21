import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/session_repository.dart';
import 'package:moonforge/features/home/services/dashboard_service.dart';
import 'package:moonforge/features/home/widgets/placeholders.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Widget displaying upcoming game sessions
class UpcomingSessionsWidget extends StatelessWidget {
  const UpcomingSessionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final dashboardService = DashboardService(
      campaignRepo: context.read<CampaignRepository>(),
      sessionRepo: context.read<SessionRepository>(),
      partyRepo: context.read<PartyRepository>(),
      entityRepo: context.read<EntityRepository>(),
    );

    return FutureBuilder<List<Session>>(
      future: dashboardService.fetchUpcomingSessions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingPlaceholder();
        }

        if (snapshot.hasError) {
          logger.e('Error loading upcoming sessions: ${snapshot.error}');
          return const ErrorPlaceholder();
        }

        final sessions = snapshot.data ?? [];

        if (sessions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                l10n.noUpcomingSessions,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sessions.length,
          separatorBuilder: (context, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final session = sessions[index];
            return _SessionCard(session: session);
          },
        );
      },
    );
  }
}

class _SessionCard extends StatelessWidget {
  final Session session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();
    final timeFormat = DateFormat.jm();

    final sessionDate = session.datetime;
    final dateStr = sessionDate != null
        ? dateFormat.format(sessionDate.toLocal())
        : 'Date TBD';
    final timeStr = sessionDate != null
        ? timeFormat.format(sessionDate.toLocal())
        : '';

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHigh,
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
        title: Text(
          session.id.substring(0, 8),
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Text(
          '$dateStr${timeStr.isNotEmpty ? " • $timeStr" : ""}',
          style: theme.textTheme.bodySmall,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: Navigate to session details
          logger.i('Navigate to session: ${session.id}');
        },
      ),
    );
  }
}
