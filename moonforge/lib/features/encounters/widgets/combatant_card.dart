import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/l10n/app_localizations.dart';

typedef OnDamage = void Function(int index, int damage);
typedef OnHeal = void Function(int index, int amount);
typedef OnAddCondition = void Function(int index);

class CombatantCard extends StatelessWidget {
  final db.Combatant combatant;
  final bool isCurrent;
  final int index;
  final OnDamage onDamage;
  final OnHeal onHeal;
  final OnAddCondition onAddCondition;
  final void Function(int index, String condition) onRemoveCondition;

  const CombatantCard({
    super.key,
    required this.combatant,
    required this.isCurrent,
    required this.index,
    required this.onDamage,
    required this.onHeal,
    required this.onAddCondition,
    required this.onRemoveCondition,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: isCurrent
          ? Theme.of(context).colorScheme.primaryContainer
          : combatant.currentHp > 0
          ? null
          : Colors.grey.shade300,
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: combatant.isAlly ? Colors.blue : Colors.red,
          child: Text(
            combatant.initiative?.toString() ?? '?',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          combatant.name,
          style: TextStyle(
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            decoration: combatant.currentHp > 0
                ? null
                : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'HP: ${combatant.currentHp}/${combatant.maxHp} • AC: ${combatant.armorClass}',
            ),
            if (combatant.conditions.isNotEmpty)
              Wrap(
                spacing: 4,
                children: combatant.conditions
                    .map(
                      (c) => Chip(
                        label: Text(c, style: const TextStyle(fontSize: 10)),
                        visualDensity: VisualDensity.compact,
                        onDeleted: () => onRemoveCondition(index, c),
                        deleteIconColor: Colors.red,
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: combatant.currentHp > 0
                            ? () => onDamage(index, 1)
                            : null,
                        icon: const Icon(Icons.remove),
                        label: const Text('Damage'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: combatant.currentHp > 0
                            ? () => onHeal(index, 1)
                            : null,
                        icon: const Icon(Icons.add),
                        label: const Text('Heal'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade100,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: combatant.currentHp > 0
                      ? () => onAddCondition(index)
                      : null,
                  icon: const Icon(Icons.add),
                  label: Text(l10n.addCondition),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
