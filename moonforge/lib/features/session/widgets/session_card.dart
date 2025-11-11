import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Card widget for displaying a session in lists
class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.session,
    required this.partyId,
    this.onTap,
  });

  final Session session;
  final String partyId;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SurfaceContainer(
      child: InkWell(
        onTap:
            onTap ??
            () {
              SessionRouteData(
                partyId: partyId,
                sessionId: session.id,
              ).push(context);
            },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      session.datetime != null
                          ? DateTimeUtils.formatDateTime(session.datetime!)
                          : 'No date set',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (session.shareEnabled)
                    Icon(Icons.share, size: 20, color: colorScheme.primary),
                ],
              ),
              const SizedBox(height: 8),
              if (session.datetime != null)
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getSessionStatus(session.datetime!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              if (session.createdAt != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Created ${DateTimeUtils.formatRelativeDate(session.createdAt!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getSessionStatus(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.isAfter(now)) {
      return 'Upcoming';
    } else {
      return 'Past';
    }
  }
}
