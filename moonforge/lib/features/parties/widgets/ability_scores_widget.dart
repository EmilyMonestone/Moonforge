import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/parties/utils/character_calculations.dart';

/// Widget displaying ability scores with modifiers
class AbilityScoresWidget extends StatelessWidget {
  final Player player;
  final bool readOnly;
  final Function(String ability, int newValue)? onAbilityChanged;

  const AbilityScoresWidget({
    super.key,
    required this.player,
    this.readOnly = true,
    this.onAbilityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ability Scores',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildAbilityScore(context, 'STR', player.str),
                _buildAbilityScore(context, 'DEX', player.dex),
                _buildAbilityScore(context, 'CON', player.con),
                _buildAbilityScore(context, 'INT', player.intl),
                _buildAbilityScore(context, 'WIS', player.wis),
                _buildAbilityScore(context, 'CHA', player.cha),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAbilityScore(BuildContext context, String ability, int score) {
    final modifier = CharacterCalculations.calculateAbilityModifier(score);
    final modifierText = CharacterCalculations.formatModifier(modifier);

    return Container(
      width: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            ability,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 4),
          Text(
            modifierText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
