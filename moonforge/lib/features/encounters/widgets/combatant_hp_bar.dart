import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Widget to display HP bar for a combatant
class CombatantHpBar extends StatelessWidget {
  final Combatant combatant;
  final double height;
  final bool showLabel;

  const CombatantHpBar({
    super.key,
    required this.combatant,
    this.height = 8.0,
    this.showLabel = true,
  });

  double get _hpPercentage {
    if (combatant.maxHp == 0) return 0;
    return combatant.currentHp / combatant.maxHp;
  }

  Color get _hpColor {
    final percentage = _hpPercentage;
    if (percentage > 0.66) {
      return Colors.green;
    } else if (percentage > 0.33) {
      return Colors.orange;
    } else if (percentage > 0) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${combatant.currentHp} / ${combatant.maxHp} HP',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: SizedBox(
            height: height,
            child: LinearProgressIndicator(
              value: _hpPercentage,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(_hpColor),
            ),
          ),
        ),
      ],
    );
  }
}
