import 'package:flutter/material.dart';
import 'package:moonforge/core/services/open5e/models/character.dart';
import 'package:moonforge/core/widgets/surface_container.dart';

/// Widget to display a Background from Open5e
class BackgroundWidget extends StatelessWidget {
  final Background background;

  const BackgroundWidget({super.key, required this.background});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            background.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            background.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (background.skillProficiencies != null) ...[
            const SizedBox(height: 16),
            Text('Skill Proficiencies',
                style: theme.textTheme.titleSmall),
            Text(background.skillProficiencies!.join(', ')),
          ],
          if (background.toolProficiencies != null) ...[
            const SizedBox(height: 8),
            Text('Tool Proficiencies', style: theme.textTheme.titleSmall),
            Text(background.toolProficiencies!.join(', ')),
          ],
          if (background.languages != null) ...[
            const SizedBox(height: 8),
            Text('Languages', style: theme.textTheme.titleSmall),
            Text(background.languages!.join(', ')),
          ],
          if (background.equipment != null) ...[
            const SizedBox(height: 8),
            Text('Equipment', style: theme.textTheme.titleSmall),
            Text(background.equipment!),
          ],
          if (background.feature != null) ...[
            const SizedBox(height: 16),
            Text(background.feature!, style: theme.textTheme.titleMedium),
            if (background.featureDesc != null)
              Text(background.featureDesc!),
          ],
          if (background.document != null) ...[
            const SizedBox(height: 16),
            Text('Source: ${background.document}',
                style: theme.textTheme.labelSmall),
          ],
        ],
      ),
    );
  }
}

/// Widget to display a Feat from Open5e
class FeatWidget extends StatelessWidget {
  final Feat feat;

  const FeatWidget({super.key, required this.feat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            feat.name,
            style: theme.textTheme.headlineMedium,
          ),
          if (feat.prerequisite != null) ...[
            const SizedBox(height: 4),
            Text(
              'Prerequisite: ${feat.prerequisite}',
              style: theme.textTheme.labelMedium,
            ),
          ],
          const SizedBox(height: 8),
          Text(
            feat.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (feat.document != null) ...[
            const SizedBox(height: 16),
            Text('Source: ${feat.document}',
                style: theme.textTheme.labelSmall),
          ],
        ],
      ),
    );
  }
}

/// Widget to display a Race from Open5e
class RaceWidget extends StatelessWidget {
  final Race race;

  const RaceWidget({super.key, required this.race});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            race.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            race.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (race.asi != null) ...[
            const SizedBox(height: 16),
            Text('Ability Score Increase', style: theme.textTheme.titleSmall),
            Text(race.asi!),
            if (race.asiDesc != null) Text(race.asiDesc!),
          ],
          if (race.age != null) ...[
            const SizedBox(height: 8),
            Text('Age', style: theme.textTheme.titleSmall),
            Text(race.age!),
          ],
          if (race.alignment != null) ...[
            const SizedBox(height: 8),
            Text('Alignment', style: theme.textTheme.titleSmall),
            Text(race.alignment!),
          ],
          if (race.size != null) ...[
            const SizedBox(height: 8),
            Text('Size', style: theme.textTheme.titleSmall),
            Text(race.size!),
          ],
          if (race.speed != null) ...[
            const SizedBox(height: 8),
            Text('Speed', style: theme.textTheme.titleSmall),
            Text(race.speed!),
          ],
          if (race.languages != null) ...[
            const SizedBox(height: 8),
            Text('Languages', style: theme.textTheme.titleSmall),
            Text(race.languages!),
          ],
          if (race.vision != null) ...[
            const SizedBox(height: 8),
            Text('Vision', style: theme.textTheme.titleSmall),
            Text(race.vision!),
          ],
          if (race.traits != null) ...[
            const SizedBox(height: 16),
            Text('Traits', style: theme.textTheme.titleMedium),
            Text(race.traits!),
          ],
          if (race.document != null) ...[
            const SizedBox(height: 16),
            Text('Source: ${race.document}',
                style: theme.textTheme.labelSmall),
          ],
        ],
      ),
    );
  }
}

/// Widget to display a CharacterClass from Open5e
class CharacterClassWidget extends StatelessWidget {
  final CharacterClass characterClass;

  const CharacterClassWidget({super.key, required this.characterClass});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            characterClass.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            characterClass.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (characterClass.hitDice != null) ...[
            const SizedBox(height: 16),
            Text('Hit Dice', style: theme.textTheme.titleSmall),
            Text(characterClass.hitDice!),
          ],
          if (characterClass.hpAtFirstLevel != null) ...[
            const SizedBox(height: 8),
            Text('HP at 1st Level', style: theme.textTheme.titleSmall),
            Text(characterClass.hpAtFirstLevel!),
          ],
          if (characterClass.hpAtHigherLevels != null) ...[
            const SizedBox(height: 8),
            Text('HP at Higher Levels', style: theme.textTheme.titleSmall),
            Text(characterClass.hpAtHigherLevels!),
          ],
          if (characterClass.profArmor != null) ...[
            const SizedBox(height: 16),
            Text('Armor Proficiencies', style: theme.textTheme.titleSmall),
            Text(characterClass.profArmor!),
          ],
          if (characterClass.profWeapons != null) ...[
            const SizedBox(height: 8),
            Text('Weapon Proficiencies', style: theme.textTheme.titleSmall),
            Text(characterClass.profWeapons!),
          ],
          if (characterClass.profTools != null) ...[
            const SizedBox(height: 8),
            Text('Tool Proficiencies', style: theme.textTheme.titleSmall),
            Text(characterClass.profTools!),
          ],
          if (characterClass.profSavingThrows != null) ...[
            const SizedBox(height: 8),
            Text('Saving Throws', style: theme.textTheme.titleSmall),
            Text(characterClass.profSavingThrows!),
          ],
          if (characterClass.profSkills != null) ...[
            const SizedBox(height: 8),
            Text('Skills', style: theme.textTheme.titleSmall),
            Text(characterClass.profSkills!),
          ],
          if (characterClass.equipment != null) ...[
            const SizedBox(height: 16),
            Text('Equipment', style: theme.textTheme.titleSmall),
            Text(characterClass.equipment!),
          ],
          if (characterClass.spellcastingAbility != null) ...[
            const SizedBox(height: 16),
            Text('Spellcasting Ability', style: theme.textTheme.titleSmall),
            Text(characterClass.spellcastingAbility!),
          ],
          if (characterClass.document != null) ...[
            const SizedBox(height: 16),
            Text('Source: ${characterClass.document}',
                style: theme.textTheme.labelSmall),
          ],
        ],
      ),
    );
  }
}
