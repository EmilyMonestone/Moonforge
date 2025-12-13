import 'package:flutter/material.dart';
import 'package:moonforge/core/services/open5e/models/equipment.dart';
import 'package:moonforge/core/widgets/surface_container.dart';

/// Widget to display a generic Item from Open5e v2
class ItemWidget extends StatelessWidget {
  final Item item;

  const ItemWidget({super.key, required this.item});

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
          const SizedBox(height: 8),
          Text(
            item.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (item.document != null) ...[
            const SizedBox(height: 16),
            Text(
              'Source: ${item.document!.displayName}',
              style: theme.textTheme.labelSmall,
            ),
            if (item.document!.gamesystem != null)
              Text(
                'System: ${item.document!.gamesystem!.name}',
                style: theme.textTheme.labelSmall,
              ),
          ],
        ],
      ),
    );
  }
}

/// Widget to display a MagicItem from Open5e v2
class MagicItemWidget extends StatelessWidget {
  final MagicItem magicItem;

  const MagicItemWidget({super.key, required this.magicItem});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SurfaceContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            magicItem.name,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (magicItem.type != null)
                Text(
                  magicItem.type!,
                  style: theme.textTheme.labelLarge,
                ),
              if (magicItem.rarity != null) ...[
                if (magicItem.type != null) const Text(' • '),
                Text(
                  magicItem.rarity!,
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ],
          ),
          if (magicItem.requiresAttunement == true) ...[
            const SizedBox(height: 4),
            Text(
              'Requires Attunement',
              style: theme.textTheme.labelMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            magicItem.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (magicItem.document != null) ...[
            const SizedBox(height: 16),
            Text(
              'Source: ${magicItem.document!.displayName}',
              style: theme.textTheme.labelSmall,
            ),
            if (magicItem.document!.gamesystem != null)
              Text(
                'System: ${magicItem.document!.gamesystem!.name}',
                style: theme.textTheme.labelSmall,
              ),
          ],
        ],
      ),
    );
  }
}

/// Widget to display a Weapon from Open5e v2
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
          if (weapon.category != null) ...[
            const SizedBox(height: 4),
            Text(
              weapon.category!,
              style: theme.textTheme.labelLarge,
            ),
          ],
          const SizedBox(height: 16),
          if (weapon.damage != null)
            _buildWeaponStat('Damage', weapon.damage!, theme),
          if (weapon.damageType != null)
            _buildWeaponStat('Damage Type', weapon.damageType!, theme),
          if (weapon.weight != null)
            _buildWeaponStat('Weight', weapon.weight!, theme),
          if (weapon.properties != null)
            _buildWeaponStat('Properties', weapon.properties!, theme),
          const SizedBox(height: 8),
          Text(
            weapon.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (weapon.document != null) ...[
            const SizedBox(height: 16),
            Text(
              'Source: ${weapon.document!.displayName}',
              style: theme.textTheme.labelSmall,
            ),
            if (weapon.document!.gamesystem != null)
              Text(
                'System: ${weapon.document!.gamesystem!.name}',
                style: theme.textTheme.labelSmall,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeaponStat(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

/// Widget to display Armor from Open5e v2
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
          if (armor.category != null) ...[
            const SizedBox(height: 4),
            Text(
              armor.category!,
              style: theme.textTheme.labelLarge,
            ),
          ],
          const SizedBox(height: 16),
          if (armor.armorClass != null)
            _buildArmorStat('AC', armor.armorClass!, theme),
          if (armor.strength != null)
            _buildArmorStat('Strength Required', armor.strength!, theme),
          if (armor.stealthDisadvantage == true)
            Text(
              'Stealth Disadvantage',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          if (armor.weight != null)
            _buildArmorStat('Weight', armor.weight!, theme),
          const SizedBox(height: 8),
          Text(
            armor.desc,
            style: theme.textTheme.bodyMedium,
          ),
          if (armor.document != null) ...[
            const SizedBox(height: 16),
            Text(
              'Source: ${armor.document!.displayName}',
              style: theme.textTheme.labelSmall,
            ),
            if (armor.document!.gamesystem != null)
              Text(
                'System: ${armor.document!.gamesystem!.name}',
                style: theme.textTheme.labelSmall,
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildArmorStat(String label, String value, ThemeData theme) {
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
}
