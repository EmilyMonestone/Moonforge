import 'package:flutter/material.dart';
import 'package:moonforge/core/services/open5e/models/equipment.dart';
import 'package:moonforge/core/widgets/surface_container.dart';

/// Widget to display a MagicItem from Open5e
class MagicItemWidget extends StatelessWidget {
  final MagicItem item;

  const MagicItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '${item.type}${item.rarity != null ? ', ${item.rarity}' : ''}${item.requiresAttunement == true ? ' (requires attunement)' : ''}',
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          Text(
            item.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (item.document != null) ...[
            const SizedBox(height: 16),
            Text('Source: ${item.document}',
                style: theme.textTheme.labelSmall),
          ],
        ],
      ),
    );
  }
}

/// Widget to display a Weapon from Open5e
class WeaponWidget extends StatelessWidget {
  final Weapon weapon;

  const WeaponWidget({super.key, required this.weapon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weapon.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            weapon.category,
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          if (weapon.damage != null) ...[
            Text('Damage', style: theme.textTheme.titleSmall),
            Text('${weapon.damage}${weapon.damageType != null ? ' ${weapon.damageType}' : ''}'),
            const SizedBox(height: 8),
          ],
          if (weapon.properties != null) ...[
            Text('Properties', style: theme.textTheme.titleSmall),
            Text(weapon.properties!),
            const SizedBox(height: 8),
          ],
          if (weapon.weight != null) ...[
            Text('Weight', style: theme.textTheme.titleSmall),
            Text(weapon.weight!),
          ],
          if (weapon.document != null) ...[
            const SizedBox(height: 16),
            Text('Source: ${weapon.document}',
                style: theme.textTheme.labelSmall),
          ],
        ],
      ),
    );
  }
}

/// Widget to display Armor from Open5e
class ArmorWidget extends StatelessWidget {
  final Armor armor;

  const ArmorWidget({super.key, required this.armor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            armor.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            armor.category,
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 16),
          if (armor.armorClass != null) ...[
            Text('Armor Class', style: theme.textTheme.titleSmall),
            Text(armor.armorClass!),
            const SizedBox(height: 8),
          ],
          if (armor.strength != null) ...[
            Text('Strength Requirement', style: theme.textTheme.titleSmall),
            Text(armor.strength!),
            const SizedBox(height: 8),
          ],
          if (armor.stealthDisadvantage == true) ...[
            Text('Stealth Disadvantage',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: theme.colorScheme.error)),
            const SizedBox(height: 8),
          ],
          if (armor.weight != null) ...[
            Text('Weight', style: theme.textTheme.titleSmall),
            Text(armor.weight!),
          ],
          if (armor.document != null) ...[
            const SizedBox(height: 16),
            Text('Source: ${armor.document}',
                style: theme.textTheme.labelSmall),
          ],
        ],
      ),
    );
  }
}
