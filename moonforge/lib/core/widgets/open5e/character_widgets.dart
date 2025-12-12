import 'package:flutter/material.dart';
import 'package:moonforge/core/services/open5e/models/character.dart';
import 'package:moonforge/core/widgets/surface_container.dart';

/// Widget to display a Background from Open5e v2
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
          if (background.document != null) ...[
            const SizedBox(height: 16),
            Text(
              'Source: ${background.document!.displayName}',
              style: theme.textTheme.labelSmall,
            ),
            if (background.document!.gamesystem != null)
              Text(
                'System: ${background.document!.gamesystem!.name}',
                style: theme.textTheme.labelSmall,
              ),
          ],
        ],
      ),
    );
  }
}

/// Widget to display a Feat from Open5e v2
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
            Text(
              'Source: ${feat.document!.displayName}',
              style: theme.textTheme.labelSmall,
            ),
            if (feat.document!.gamesystem != null)
              Text(
                'System: ${feat.document!.gamesystem!.name}',
                style: theme.textTheme.labelSmall,
              ),
          ],
        ],
      ),
    );
  }
}

/// Widget to display a Species (formerly Race) from Open5e v2
class SpeciesWidget extends StatelessWidget {
  final Species species;

  const SpeciesWidget({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            species.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            species.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (species.document != null) ...[
            const SizedBox(height: 16),
            Text(
              'Source: ${species.document!.displayName}',
              style: theme.textTheme.labelSmall,
            ),
            if (species.document!.gamesystem != null)
              Text(
                'System: ${species.document!.gamesystem!.name}',
                style: theme.textTheme.labelSmall,
              ),
          ],
        ],
      ),
    );
  }
}

/// Widget to display a CharacterClass from Open5e v2
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
          if (characterClass.document != null) ...[
            const SizedBox(height: 16),
            Text(
              'Source: ${characterClass.document!.displayName}',
              style: theme.textTheme.labelSmall,
            ),
            if (characterClass.document!.gamesystem != null)
              Text(
                'System: ${characterClass.document!.gamesystem!.name}',
                style: theme.textTheme.labelSmall,
              ),
          ],
        ],
      ),
    );
  }
}

/// Widget to display an Ability from Open5e v2
class AbilityWidget extends StatelessWidget {
  final Ability ability;

  const AbilityWidget({super.key, required this.ability});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ability.name,
            style: theme.textTheme.headlineMedium,
          ),
          if (ability.fullName != null) ...[
            const SizedBox(height: 4),
            Text(
              ability.fullName!,
              style: theme.textTheme.titleMedium,
            ),
          ],
          const SizedBox(height: 8),
          Text(
            ability.desc,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Widget to display a Skill from Open5e v2
class SkillWidget extends StatelessWidget {
  final Skill skill;

  const SkillWidget({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            skill.name,
            style: theme.textTheme.headlineMedium,
          ),
          if (skill.ability != null) ...[
            const SizedBox(height: 4),
            Text(
              'Ability: ${skill.ability}',
              style: theme.textTheme.labelMedium,
            ),
          ],
          const SizedBox(height: 8),
          Text(
            skill.desc,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
