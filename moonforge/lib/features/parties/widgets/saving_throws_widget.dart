import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/parties/services/player_character_service.dart';
import 'package:moonforge/features/parties/utils/character_calculations.dart';

/// Widget displaying saving throws with modifiers
class SavingThrowsWidget extends StatelessWidget {
  final Player player;
  final PlayerCharacterService characterService;

  const SavingThrowsWidget({
    super.key,
    required this.player,
    required this.characterService,
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
              'Saving Throws',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: CharacterCalculations.abilityScores.length,
              itemBuilder: (context, index) {
                final ability = CharacterCalculations.abilityScores[index];
                return _buildSavingThrowItem(context, ability);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavingThrowItem(BuildContext context, String ability) {
    final modifier = characterService.getSavingThrowModifier(player, ability);
    final modifierText = CharacterCalculations.formatModifier(modifier);
    final isProficient = player.savingThrowProficiencies?.contains(ability) ?? false;
    final abilityName = CharacterCalculations.getAbilityName(ability);

    return ListTile(
      dense: true,
      leading: Icon(
        isProficient ? Icons.check_circle : Icons.circle_outlined,
        size: 16,
        color: isProficient ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(abilityName),
      trailing: Text(
        modifierText,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
