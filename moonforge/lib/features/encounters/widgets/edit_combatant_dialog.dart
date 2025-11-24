import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/l10n/app_localizations.dart';

class EditCombatantDialog extends StatefulWidget {
  final db.Combatant combatant;
  final Function(db.Combatant) onUpdate;

  const EditCombatantDialog({
    super.key,
    required this.combatant,
    required this.onUpdate,
  });

  @override
  State<EditCombatantDialog> createState() => _EditCombatantDialogState();
}

class _EditCombatantDialogState extends State<EditCombatantDialog> {
  late TextEditingController _hpController;
  late TextEditingController _maxHpController;
  late TextEditingController _acController;
  late TextEditingController _initiativeController;
  late List<String> _conditions;

  @override
  void initState() {
    super.initState();
    _hpController = TextEditingController(
      text: widget.combatant.currentHp.toString(),
    );
    _maxHpController = TextEditingController(
      text: widget.combatant.maxHp.toString(),
    );
    _acController = TextEditingController(
      text: widget.combatant.armorClass.toString(),
    );
    _initiativeController = TextEditingController(
      text: widget.combatant.initiative?.toString() ?? '',
    );
    _conditions = List.from(widget.combatant.conditions);
  }

  @override
  void dispose() {
    _hpController.dispose();
    _maxHpController.dispose();
    _acController.dispose();
    _initiativeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text('Edit ${widget.combatant.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HP
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hpController,
                    decoration: InputDecoration(
                      labelText: l10n.hitPoints,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Text('/'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _maxHpController,
                    decoration: InputDecoration(
                      labelText: 'Max HP',
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // AC
            TextField(
              controller: _acController,
              decoration: InputDecoration(
                labelText: l10n.armorClass,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Initiative
            TextField(
              controller: _initiativeController,
              decoration: InputDecoration(
                labelText: l10n.initiative,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Conditions
            Text(
              l10n.conditions,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ..._conditions.map(
                  (condition) => Chip(
                    label: Text(condition),
                    onDeleted: () {
                      setState(() {
                        _conditions.remove(condition);
                      });
                    },
                  ),
                ),
                ActionChip(
                  label: Text(l10n.addCondition),
                  avatar: const Icon(Icons.add, size: 16),
                  onPressed: () => _showAddConditionDialog(),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final updated = widget.combatant.copyWith(
              currentHp: int.tryParse(_hpController.text),
              maxHp: int.tryParse(_maxHpController.text),
              armorClass: int.tryParse(_acController.text),
              initiative: const Value.absent(),
              conditions: _conditions,
            );
            widget.onUpdate(updated);
            Navigator.of(context).pop();
          },
          child: Text(l10n.save),
        ),
      ],
    );
  }

  void _showAddConditionDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.addCondition),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'e.g., Poisoned, Stunned, Prone',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _conditions.add(controller.text);
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
