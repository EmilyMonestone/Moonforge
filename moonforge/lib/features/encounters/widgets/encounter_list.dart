import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/encounters/widgets/encounter_card.dart';

/// Widget to display a list of encounters
class EncounterList extends StatelessWidget {
  final List<Encounter> encounters;
  final void Function(Encounter)? onEncounterTap;
  final Widget? emptyState;

  const EncounterList({
    super.key,
    required this.encounters,
    this.onEncounterTap,
    this.emptyState,
  });

  @override
  Widget build(BuildContext context) {
    if (encounters.isEmpty) {
      return emptyState ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_kabaddi,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  'No encounters yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
    }

    return ListView.builder(
      itemCount: encounters.length,
      itemBuilder: (context, index) {
        final encounter = encounters[index];
        return EncounterCard(
          encounter: encounter,
          onTap: onEncounterTap != null
              ? () => onEncounterTap!(encounter)
              : null,
        );
      },
    );
  }
}
