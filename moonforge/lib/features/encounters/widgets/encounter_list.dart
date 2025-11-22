import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/empty_state.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/encounters/widgets/encounter_card.dart';
import 'package:moonforge/l10n/app_localizations.dart';

/// Widget to display a list of encounters
class EncounterList extends StatelessWidget {
  final List<Encounter> encounters;
  final void Function(Encounter)? onEncounterTap;
  final Widget? emptyState;
  final String? emptyStateTitle;
  final String? emptyStateMessage;
  final VoidCallback? onCreateEncounter;

  const EncounterList({
    super.key,
    required this.encounters,
    this.onEncounterTap,
    this.emptyState,
    this.emptyStateTitle,
    this.emptyStateMessage,
    this.onCreateEncounter,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (encounters.isEmpty) {
      if (emptyState != null) return emptyState!;
      return EmptyState(
        icon: Icons.sports_kabaddi,
        title: emptyStateTitle ?? l10n.noEncountersYet,
        message: emptyStateMessage ?? l10n.emptyStateGenericMessage,
        actionLabel: onCreateEncounter != null ? l10n.createEncounter : null,
        onAction: onCreateEncounter,
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
