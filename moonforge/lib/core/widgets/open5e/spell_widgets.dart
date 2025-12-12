import 'package:flutter/material.dart';
import 'package:moonforge/core/services/open5e/models/spells.dart';
import 'package:moonforge/core/widgets/surface_container.dart';

/// Widget to display a Spell from Open5e v2
class SpellWidget extends StatelessWidget {
  final Open5eSpell spell;

  const SpellWidget({super.key, required this.spell});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            spell.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Level ${spell.level ?? 0} ${spell.school ?? ''}${spell.ritual == true ? ' (ritual)' : ''}',
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          _buildSpellStat('Casting Time', spell.castingTime, theme),
          _buildSpellStat('Range', spell.range, theme),
          _buildSpellStat('Components', spell.components, theme),
          if (spell.material != null)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(spell.material!, style: theme.textTheme.bodySmall),
            ),
          _buildSpellStat('Duration',
              '${spell.duration ?? ''}${spell.concentration == true ? ' (concentration)' : ''}',
              theme),
          const SizedBox(height: 16),
          Text(
            spell.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (spell.higherLevel != null) ...[
            const SizedBox(height: 8),
            Text(
              'At Higher Levels: ${spell.higherLevel}',
              style: theme.textTheme.bodyMedium,
            ),
          ],
          if (spell.document != null) ...[
            const SizedBox(height: 16),
            Text(
              'Source: ${spell.document!.displayName}',
              style: theme.textTheme.labelSmall,
            ),
            if (spell.document!.gamesystem != null)
              Text(
                'System: ${spell.document!.gamesystem!.name}',
                style: theme.textTheme.labelSmall,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpellStat(String label, String? value, ThemeData theme) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
}
