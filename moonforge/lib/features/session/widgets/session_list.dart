import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'session_card.dart';

/// Widget for displaying a list of sessions
class SessionList extends StatelessWidget {
  const SessionList({
    super.key,
    required this.sessions,
    required this.partyId,
    this.emptyMessage = 'No sessions found',
    this.onSessionTap,
  });

  final List<Session> sessions;
  final String partyId;
  final String emptyMessage;
  final void Function(Session)? onSessionTap;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            emptyMessage,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: sessions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final session = sessions[index];
        return SessionCard(
          session: session,
          partyId: partyId,
          onTap: onSessionTap != null ? () => onSessionTap!(session) : null,
        );
      },
    );
  }
}
