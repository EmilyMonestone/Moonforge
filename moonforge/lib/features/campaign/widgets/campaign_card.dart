import 'package:flutter/material.dart';
import 'package:moonforge/core/design/design_system.dart';
import 'package:moonforge/core/design/domain_visuals.dart';
import 'package:moonforge/core/models/domain_type.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final lastUpdated = campaign.updatedAt ?? campaign.createdAt;

    return Card(
      elevation: selected ? 4 : 1,
      color: selected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
          : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onSelectionToggle,
        child: Padding(
          padding: AppSpacing.paddingLg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (selected)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
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
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                const Icon(Icons.edit_outlined),
                                const SizedBox(width: 8),
                                Text(l10n.edit),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(Icons.delete_outlined),
                                const SizedBox(width: 8),
                                Text(l10n.delete),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                campaign.description.isEmpty
                    ? l10n.noDescriptionProvided
                    : campaign.description,
                style: theme.textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  _StatChip(
                    icon: DomainType.entityGeneric.icon,
                    label: l10n.campaignEntitiesCount(
                      campaign.entityIds.length,
                    ),
                  ),
                  if ((campaign.memberUids?.isNotEmpty ?? false))
                    _StatChip(
                      icon: DomainType.party.icon,
                      label: l10n.campaignMembersCount(
                        campaign.memberUids?.length ?? 0,
                      ),
                    ),
                ],
              ),
              if (lastUpdated != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.campaignUpdatedRelative(
                    _relativeTimeLabel(l10n, lastUpdated),
                  ),
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

  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      visualDensity: VisualDensity.compact,
      labelStyle: theme.textTheme.bodySmall,
      padding: AppSpacing.horizontalSm,
    );
  }
}

String _relativeTimeLabel(AppLocalizations l10n, DateTime dt) {
  final now = DateTime.now();
  final diff = now.difference(dt);
  if (diff.inSeconds < 60) return l10n.relativeJustNow;
  if (diff.inMinutes < 60) {
    final minutes = diff.inMinutes;
    return l10n.relativeMinutes(minutes);
  }
  if (diff.inHours < 24) {
    final hours = diff.inHours;
    return l10n.relativeHours(hours);
  }
  if (diff.inDays < 7) {
    final days = diff.inDays;
    return l10n.relativeDays(days);
  }
  if (diff.inDays < 30) {
    final weeks = (diff.inDays / 7).floor().clamp(1, diff.inDays);
    return l10n.relativeWeeks(weeks);
  }
  final months = (diff.inDays / 30).floor();
  if (months < 12) {
    return l10n.relativeMonths(months);
  }
  final years = (diff.inDays / 365).floor();
  return l10n.relativeYears(years);
}
