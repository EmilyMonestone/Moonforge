import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Card widget to display an encounter in a list
class EncounterCard extends StatelessWidget {
  final Encounter encounter;
  final VoidCallback? onTap;

  const EncounterCard({
    super.key,
    required this.encounter,
    this.onTap,
  });

  int get _combatantCount {
    if (encounter.combatants == null) return 0;
    return (encounter.combatants as List).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap ??
            () {
              EncounterRoute(encounterId: encounter.id).go(context);
            },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      encounter.name,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                  if (encounter.preset)
                    Chip(
                      label: const Text('Preset'),
                      avatar: const Icon(Icons.bookmark, size: 16),
                      backgroundColor: colorScheme.secondaryContainer,
                      labelStyle: TextStyle(
                        color: colorScheme.onSecondaryContainer,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Combatant count
              Row(
                children: [
                  Icon(
                    Icons.groups,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$_combatantCount combatant${_combatantCount != 1 ? 's' : ''}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              // Notes preview
              if (encounter.notes != null && encounter.notes!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  encounter.notes!,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
