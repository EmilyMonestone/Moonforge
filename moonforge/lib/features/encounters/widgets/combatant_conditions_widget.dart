import 'package:flutter/material.dart';

/// Widget to display conditions applied to a combatant
class CombatantConditionsWidget extends StatelessWidget {
  final List<String> conditions;
  final VoidCallback? onTap;
  final bool compact;

  const CombatantConditionsWidget({
    super.key,
    required this.conditions,
    this.onTap,
    this.compact = false,
  });

  // Common D&D 5e conditions with icons
  static const Map<String, IconData> _conditionIcons = {
    'blinded': Icons.visibility_off,
    'charmed': Icons.favorite,
    'deafened': Icons.volume_off,
    'frightened': Icons.warning,
    'grappled': Icons.back_hand,
    'incapacitated': Icons.do_not_disturb,
    'invisible': Icons.visibility_off_outlined,
    'paralyzed': Icons.do_not_step,
    'petrified': Icons.pause_circle,
    'poisoned': Icons.water_drop,
    'prone': Icons.trending_down,
    'restrained': Icons.link,
    'stunned': Icons.flash_on,
    'unconscious': Icons.bedtime,
    'exhaustion': Icons.battery_alert,
    'concentrating': Icons.center_focus_strong,
  };

  @override
  Widget build(BuildContext context) {
    if (conditions.isEmpty) {
      return const SizedBox.shrink();
    }

    if (compact) {
      return Wrap(
        spacing: 4,
        runSpacing: 4,
        children: conditions.map((condition) {
          final icon = _conditionIcons[condition.toLowerCase()] ?? Icons.label;
          return Tooltip(
            message: condition,
            child: Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.error,
            ),
          );
        }).toList(),
      );
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: conditions.map((condition) {
        final icon = _conditionIcons[condition.toLowerCase()] ?? Icons.label;
        return Chip(
          avatar: Icon(icon, size: 16),
          label: Text(condition),
          labelStyle: Theme.of(context).textTheme.bodySmall,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          visualDensity: VisualDensity.compact,
          onDeleted: onTap,
          deleteIcon: const Icon(Icons.close, size: 16),
        );
      }).toList(),
    );
  }
}
