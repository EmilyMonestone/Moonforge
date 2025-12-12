import 'package:flutter/material.dart';
import 'package:moonforge/core/services/open5e/models/mechanics.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/models/monster.dart';

/// Widget to display a Monster from Open5e
class MonsterWidget extends StatelessWidget {
  final Monster monster;

  const MonsterWidget({super.key, required this.monster});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            monster.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '${monster.size?.join(', ') ?? ''} ${monster.type ?? ''}${monster.alignment != null ? ', ${monster.alignment}' : ''}',
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          if (monster.ac != null) ...[
            Text('Armor Class: ${monster.ac}',
                style: theme.textTheme.bodyMedium),
          ],
          if (monster.hp != null) ...[
            Text('Hit Points: ${monster.hp!.average} (${monster.hp!.formula})',
                style: theme.textTheme.bodyMedium),
          ],
          if (monster.speed != null) ...[
            Text(
                'Speed: ${monster.speed!.entries.map((e) => '${e.key.toString().split('.').last} ${e.value} ft.').join(', ')}',
                style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: 16),
          Text('STR ${monster.abilityScores.strength} | '
              'DEX ${monster.abilityScores.dexterity} | '
              'CON ${monster.abilityScores.constitution} | '
              'INT ${monster.abilityScores.intelligence} | '
              'WIS ${monster.abilityScores.wisdom} | '
              'CHA ${monster.abilityScores.charisma}'),
          if (monster.cr != null) ...[
            const SizedBox(height: 16),
            Text('Challenge Rating: ${monster.cr}',
                style: theme.textTheme.titleSmall),
          ],
          if (monster.traits != null && monster.traits!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Traits', style: theme.textTheme.titleMedium),
            ...monster.traits!.map((trait) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trait.name, style: theme.textTheme.titleSmall),
                      ...trait.entries.map((e) => Text(e)),
                    ],
                  ),
                )),
          ],
          if (monster.actions != null && monster.actions!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Actions', style: theme.textTheme.titleMedium),
            ...monster.actions!.map((action) => Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(action.name, style: theme.textTheme.titleSmall),
                      ...action.entries.map((e) => Text(e)),
                    ],
                  ),
                )),
          ],
          const SizedBox(height: 16),
          Text('Source: ${monster.source}',
              style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

/// Widget to display a Condition from Open5e
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
            Text('Source: ${condition.document}',
                style: theme.textTheme.labelSmall),
          ],
        ],
      ),
    );
  }
}

/// Widget to display a Plane from Open5e
class PlaneWidget extends StatelessWidget {
  final Plane plane;

  const PlaneWidget({super.key, required this.plane});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plane.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            plane.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (plane.document != null) ...[
            const SizedBox(height: 16),
            Text('Source: ${plane.document}',
                style: theme.textTheme.labelSmall),
          ],
        ],
      ),
    );
  }
}
