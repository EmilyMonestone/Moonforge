import 'package:flutter/material.dart';
import 'package:moonforge/core/services/open5e/models/creatures.dart';
import 'package:moonforge/core/services/open5e/models/mechanics.dart';
import 'package:moonforge/core/widgets/surface_container.dart';

/// Widget to display a Creature from Open5e v2 (formerly Monster)
class CreatureWidget extends StatelessWidget {
  final Creature creature;

  const CreatureWidget({super.key, required this.creature});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            creature.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (creature.size != null) Text(creature.size!),
              if (creature.type != null) ...[
                if (creature.size != null) const Text(' '),
                Text(creature.type!),
              ],
              if (creature.challengeRatingText != null) ...[
                const Text(' • CR '),
                Text(
                  creature.challengeRatingText!,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          if (creature.armorClass != null)
            _buildCreatureStat('AC', '${creature.armorClass}', theme),
          if (creature.hitPoints != null)
            _buildCreatureStat('HP', '${creature.hitPoints}', theme),
          if (creature.hitDice != null)
            _buildCreatureStat('Hit Dice', creature.hitDice!, theme),
          if (creature.speed != null)
            _buildCreatureStat('Speed', '${creature.speed} ft.', theme),
          const SizedBox(height: 16),
          // Ability Scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (creature.abilityScoreStrength != null)
                _buildAbilityScore('STR', creature.abilityScoreStrength!, theme),
              if (creature.abilityScoreDexterity != null)
                _buildAbilityScore('DEX', creature.abilityScoreDexterity!, theme),
              if (creature.abilityScoreConstitution != null)
                _buildAbilityScore('CON', creature.abilityScoreConstitution!, theme),
              if (creature.abilityScoreIntelligence != null)
                _buildAbilityScore('INT', creature.abilityScoreIntelligence!, theme),
              if (creature.abilityScoreWisdom != null)
                _buildAbilityScore('WIS', creature.abilityScoreWisdom!, theme),
              if (creature.abilityScoreCharisma != null)
                _buildAbilityScore('CHA', creature.abilityScoreCharisma!, theme),
            ],
          ),
          if (creature.passivePerception != null) ...[
            const SizedBox(height: 16),
            _buildCreatureStat('Passive Perception', 
                '${creature.passivePerception}', theme),
          ],
          if (creature.desc != null) ...[
            const SizedBox(height: 16),
            Text(
              creature.desc!,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          if (creature.document != null) ...[
            const SizedBox(height: 16),
            Text(
              'Source: ${creature.document!.displayName}',
              style: theme.textTheme.labelSmall,
            ),
            if (creature.document!.gamesystem != null)
              Text(
                'System: ${creature.document!.gamesystem!.name}',
                style: theme.textTheme.labelSmall,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildCreatureStat(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: theme.textTheme.titleSmall,
            ),
          ),
          Expanded(
            child: Text(value, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilityScore(String ability, int score, ThemeData theme) {
    final modifier = ((score - 10) / 2).floor();
    final modifierStr = modifier >= 0 ? '+$modifier' : '$modifier';
    
    return Column(
      children: [
        Text(
          ability,
          style: theme.textTheme.labelSmall,
        ),
        Text(
          '$score',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          modifierStr,
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}

/// Widget to display a Condition from Open5e v2
class ConditionWidget extends StatelessWidget {
  final Condition condition;

  const ConditionWidget({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            condition.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            condition.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (condition.document != null) ...[
            const SizedBox(height: 16),
            Text(
              'Source: ${condition.document!.displayName}',
              style: theme.textTheme.labelSmall,
            ),
            if (condition.document!.gamesystem != null)
              Text(
                'System: ${condition.document!.gamesystem!.name}',
                style: theme.textTheme.labelSmall,
              ),
          ],
        ],
      ),
    );
  }
}
