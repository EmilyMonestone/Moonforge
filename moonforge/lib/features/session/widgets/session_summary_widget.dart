import 'package:flutter/material.dart';
import 'package:moonforge/core/utils/datetime_utils.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Widget for displaying a session summary/recap
class SessionSummaryWidget extends StatelessWidget {
  const SessionSummaryWidget({
    super.key,
    required this.session,
    this.showInfo = false,
  });

  final Session session;
  final bool showInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SurfaceContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.summarize, color: colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Session Summary',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (session.datetime != null) ...[
              _buildInfoRow(
                context,
                icon: Icons.calendar_today,
                label: 'Date',
                value: DateTimeUtils.formatDateTime(session.datetime!),
              ),
              const SizedBox(height: 8),
            ],
            if (session.createdAt != null) ...[
              _buildInfoRow(
                context,
                icon: Icons.add_circle_outline,
                label: 'Created',
                value: DateTimeUtils.formatRelativeDate(session.createdAt!),
              ),
              const SizedBox(height: 8),
            ],
            if (session.shareEnabled) ...[
              _buildInfoRow(
                context,
                icon: Icons.share,
                label: 'Sharing',
                value: 'Enabled',
                valueColor: colorScheme.primary,
              ),
              const SizedBox(height: 8),
            ],
            const Divider(height: 24),
            if (session.log != null) ...[
              Text(
                'Session Log',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildQuillPreview(context, session.log!),
            ] else
              Text(
                'No session log available',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            if (showInfo && session.info != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'DM Notes',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildQuillPreview(context, session.info!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuillPreview(BuildContext context, Map<String, dynamic> delta) {
    final buffer = StringBuffer();
    final ops = delta['ops'] as List<dynamic>?;
    if (ops != null) {
      for (final op in ops) {
        if (op is Map && op['insert'] is String) {
          buffer.write(op['insert'] as String);
        }
      }
    }
    final text = buffer.toString().trim();
    if (text.isEmpty) return const Text('No content');
    return SingleChildScrollView(
      child: SelectableText(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
