import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:provider/provider.dart';
import 'package:moonforge/features/parties/controllers/player_provider.dart';

/// Widget for tracking and managing HP
class HpTrackerWidget extends StatefulWidget {
  final Player player;

  const HpTrackerWidget({
    super.key,
    required this.player,
  });

  @override
  State<HpTrackerWidget> createState() => _HpTrackerWidgetState();
}

class _HpTrackerWidgetState extends State<HpTrackerWidget> {
  final _damageController = TextEditingController();
  final _healController = TextEditingController();
  final _tempHpController = TextEditingController();

  @override
  void dispose() {
    _damageController.dispose();
    _healController.dispose();
    _tempHpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentHp = widget.player.hpCurrent ?? 0;
    final maxHp = widget.player.hpMax ?? 0;
    final tempHp = widget.player.hpTemp ?? 0;

    final hpPercentage = maxHp > 0 ? currentHp / maxHp : 0.0;
    final hpColor = _getHpColor(hpPercentage);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hit Points',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            
            // HP Bar
            Column(
              children: [
                LinearProgressIndicator(
                  value: hpPercentage,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(hpColor),
                  minHeight: 20,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$currentHp / $maxHp HP',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (tempHp > 0)
                      Chip(
                        label: Text('+$tempHp temp'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // HP Management Controls
            Row(
              children: [
                Expanded(
                  child: _buildHpControl(
                    context,
                    'Damage',
                    _damageController,
                    Icons.remove_circle_outline,
                    Colors.red,
                    () => _applyDamage(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildHpControl(
                    context,
                    'Heal',
                    _healController,
                    Icons.add_circle_outline,
                    Colors.green,
                    () => _applyHealing(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            _buildHpControl(
              context,
              'Temp HP',
              _tempHpController,
              Icons.shield_outlined,
              Colors.blue,
              () => _applyTempHp(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHpControl(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon,
    Color color,
    VoidCallback onApply,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onApply,
        ),
      ],
    );
  }

  void _applyDamage(BuildContext context) {
    final damage = int.tryParse(_damageController.text);
    if (damage != null && damage > 0) {
      final provider = Provider.of<PlayerProvider>(context, listen: false);
      provider.takeDamage(damage);
      _damageController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Applied $damage damage')),
      );
    }
  }

  void _applyHealing(BuildContext context) {
    final healing = int.tryParse(_healController.text);
    if (healing != null && healing > 0) {
      final provider = Provider.of<PlayerProvider>(context, listen: false);
      provider.heal(healing);
      _healController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Healed $healing HP')),
      );
    }
  }

  void _applyTempHp(BuildContext context) {
    final tempHp = int.tryParse(_tempHpController.text);
    if (tempHp != null && tempHp > 0) {
      final provider = Provider.of<PlayerProvider>(context, listen: false);
      provider.updateHp(temp: tempHp);
      _tempHpController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added $tempHp temporary HP')),
      );
    }
  }

  Color _getHpColor(double percentage) {
    if (percentage > 0.5) {
      return Colors.green;
    } else if (percentage > 0.25) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
