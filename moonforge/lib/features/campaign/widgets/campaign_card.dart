import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:timeago/timeago.dart' as timeago;

/// A card widget for displaying a campaign in a list or grid
class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool selected;
  final VoidCallback? onSelectionToggle;

  const CampaignCard({
    super.key,
    required this.campaign,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.selected = false,
    this.onSelectionToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastUpdated = campaign.updatedAt ?? campaign.createdAt;

    return Card(
      elevation: selected ? 4 : 1,
      color: selected
          ? theme.colorScheme.primaryContainer.withOpacity(0.3)
          : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onSelectionToggle,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (selected)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.check_circle,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      campaign.name,
                      style: theme.textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onEdit != null || onDelete != null)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) {
                          onEdit!();
                        } else if (value == 'delete' && onDelete != null) {
                          onDelete!();
                        }
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outlined),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                campaign.description.isEmpty
                    ? 'No description provided'
                    : campaign.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _StatChip(
                    icon: Icons.book_outlined,
                    label: '${campaign.entityIds.length} entities',
                  ),
                  if (campaign.memberUids.isNotEmpty)
                    _StatChip(
                      icon: Icons.group_outlined,
                      label: '${campaign.memberUids.length} members',
                    ),
                ],
              ),
              if (lastUpdated != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Updated ${timeago.format(lastUpdated)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
      labelStyle: theme.textTheme.bodySmall,
      padding: EdgeInsets.zero,
    );
  }
}
