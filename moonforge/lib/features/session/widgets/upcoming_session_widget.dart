import 'package:flutter/material.dart';
import 'package:moonforge/core/services/router_config.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/session/utils/session_formatters.dart';

/// Widget for displaying the next upcoming session
class UpcomingSessionWidget extends StatelessWidget {
  const UpcomingSessionWidget({
    super.key,
    required this.session,
    required this.partyId,
  });

  final Session session;
  final String partyId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SurfaceContainer(
      child: InkWell(
        onTap: () {
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
                children: [
                  Icon(Icons.schedule, color: colorScheme.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Next Session',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (session.datetime != null) ...[
                Text(
                  DateTimeUtils.formatDateTime(session.datetime!),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  SessionFormatters.formatTimeUntilSession(session.datetime!),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ] else
                Text(
                  'No date set',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
