import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/encounters/widgets/combatant_card.dart';

/// Widget to display the initiative order list
class InitiativeOrderList extends StatelessWidget {
  final List<Combatant> combatants;
  final int currentIndex;
  final Function(int)? onCombatantTap;
  final Function(int)? onDamage;
  final Function(int)? onHeal;

  const InitiativeOrderList({
    super.key,
    required this.combatants,
    this.currentIndex = 0,
    this.onCombatantTap,
    this.onDamage,
    this.onHeal,
  });

  @override
  Widget build(BuildContext context) {
    if (combatants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No combatants in this encounter',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: combatants.length,
      itemBuilder: (context, index) {
        final combatant = combatants[index];
        return CombatantCard(
          combatant: combatant,
          isCurrentTurn: index == currentIndex,
          onTap: onCombatantTap != null ? () => onCombatantTap!(index) : null,
          onDamage: onDamage != null ? () => onDamage!(index) : null,
          onHeal: onHeal != null ? () => onHeal!(index) : null,
        );
      },
    );
  }
}
