import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dialog for adding a new combatant to an encounter
class AddCombatantDialog extends StatefulWidget {
  const AddCombatantDialog({super.key});

  @override
  State<AddCombatantDialog> createState() => _AddCombatantDialogState();
}

class _AddCombatantDialogState extends State<AddCombatantDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _hpController = TextEditingController();
  final _acController = TextEditingController();
  final _initiativeModController = TextEditingController(text: '0');
  bool _isAlly = false;
  String _type = 'monster';

  final List<String> _combatantTypes = ['monster', 'player', 'npc'];

  @override
  void dispose() {
    _nameController.dispose();
    _hpController.dispose();
    _acController.dispose();
    _initiativeModController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

    return AlertDialog(
      title: const Text('Add Combatant'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Type dropdown
              DropdownButtonFormField<String>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: _combatantTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value ?? 'monster';
                  });
                },
              ),
              const SizedBox(height: 16),
              // HP field
              TextFormField(
                controller: _hpController,
                decoration: const InputDecoration(
                  labelText: 'Hit Points',
                  border: OutlineInputBorder(),
                  suffixText: 'HP',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter HP';
                  }
                  final hp = int.tryParse(value);
                  if (hp == null || hp <= 0) {
                    return 'Please enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // AC field
              TextFormField(
                controller: _acController,
                decoration: const InputDecoration(
                  labelText: 'Armor Class',
                  border: OutlineInputBorder(),
                  suffixText: 'AC',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter AC';
                  }
                  final ac = int.tryParse(value);
                  if (ac == null || ac < 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Initiative modifier field
              TextFormField(
                controller: _initiativeModController,
                decoration: const InputDecoration(
                  labelText: 'Initiative Modifier',
                  border: OutlineInputBorder(),
                  prefixText: '+',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^-?\d*')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter initiative modifier';
                  }
                  final mod = int.tryParse(value);
                  if (mod == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Is ally checkbox
              CheckboxListTile(
                title: const Text('Ally'),
                subtitle: const Text('Is this combatant an ally of the party?'),
                value: _isAlly,
                onChanged: (value) {
                  setState(() {
                    _isAlly = value ?? false;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': _nameController.text,
        'type': _type,
        'hp': int.parse(_hpController.text),
        'ac': int.parse(_acController.text),
        'initiativeMod': int.parse(_initiativeModController.text),
        'isAlly': _isAlly,
      };
      Navigator.of(context).pop(data);
    }
  }
}

/// Show add combatant dialog and return combatant data
Future<Map<String, dynamic>?> showAddCombatantDialog(BuildContext context) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => const AddCombatantDialog(),
  );
}
