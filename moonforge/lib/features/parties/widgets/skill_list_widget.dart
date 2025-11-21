import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/parties/services/player_character_service.dart';
import 'package:moonforge/features/parties/utils/character_calculations.dart';

/// Widget displaying skill list with modifiers
class SkillListWidget extends StatelessWidget {
  final Player player;
  final PlayerCharacterService characterService;

  const SkillListWidget({
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
            Text('Skills', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: CharacterCalculations.standardSkills.length,
              itemBuilder: (context, index) {
                final skill = CharacterCalculations.standardSkills[index];
                return _buildSkillItem(context, skill);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillItem(BuildContext context, String skill) {
    final modifier = characterService.getSkillModifier(player, skill);
    final modifierText = CharacterCalculations.formatModifier(modifier);
    final isProficient = player.skillProficiencies?.contains(skill) ?? false;
    final ability = CharacterCalculations.getSkillAbility(skill);

    return ListTile(
      dense: true,
      leading: Icon(
        isProficient ? Icons.check_circle : Icons.circle_outlined,
        size: 16,
        color: isProficient ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(skill),
      subtitle: Text(ability),
      trailing: Text(
        modifierText,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
