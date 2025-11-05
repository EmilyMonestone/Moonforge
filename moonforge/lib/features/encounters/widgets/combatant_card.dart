import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/encounters/widgets/combatant_conditions_widget.dart';
import 'package:moonforge/features/encounters/widgets/combatant_hp_bar.dart';

/// Card widget to display a combatant in the initiative tracker
class CombatantCard extends StatelessWidget {
  final Combatant combatant;
  final bool isCurrentTurn;
  final VoidCallback? onTap;
  final VoidCallback? onDamage;
  final VoidCallback? onHeal;

  const CombatantCard({
    super.key,
    required this.combatant,
    this.isCurrentTurn = false,
    this.onTap,
    this.onDamage,
    this.onHeal,
  });

  bool get _isAlive => combatant.currentHp > 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: isCurrentTurn ? 4 : 1,
      color: isCurrentTurn
          ? colorScheme.primaryContainer
          : _isAlive
              ? null
              : colorScheme.surfaceContainerHighest.withOpacity(0.5),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with name and initiative
              Row(
                children: [
                  // Initiative badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${combatant.initiative ?? 0}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Name
                  Expanded(
                    child: Text(
                      combatant.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        decoration:
                            _isAlive ? null : TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                  // AC badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shield, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${combatant.armorClass}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onTertiaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // HP bar
              CombatantHpBar(combatant: combatant),
              // Conditions
              if (combatant.conditions.isNotEmpty) ...[
                const SizedBox(height: 8),
                CombatantConditionsWidget(
                  conditions: combatant.conditions,
                  compact: true,
                ),
              ],
              // Action buttons
              if (_isAlive && (onDamage != null || onHeal != null)) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onDamage != null)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 20,
                        tooltip: 'Damage',
                        onPressed: onDamage,
                      ),
                    if (onHeal != null)
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 20,
                        tooltip: 'Heal',
                        onPressed: onHeal,
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
