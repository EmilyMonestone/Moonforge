import 'package:flutter/material.dart';

/// Dialog for selecting conditions to apply to a combatant
class ConditionSelector extends StatefulWidget {
  final List<String> currentConditions;

  const ConditionSelector({super.key, this.currentConditions = const []});

  @override
  State<ConditionSelector> createState() => _ConditionSelectorState();
}

class _ConditionSelectorState extends State<ConditionSelector> {
  late Set<String> _selectedConditions;

  // Common D&D 5e conditions
  static const List<String> _conditions = [
    'Blinded',
    'Charmed',
    'Deafened',
    'Frightened',
    'Grappled',
    'Incapacitated',
    'Invisible',
    'Paralyzed',
    'Petrified',
    'Poisoned',
    'Prone',
    'Restrained',
    'Stunned',
    'Unconscious',
    'Exhaustion',
    'Concentrating',
  ];

  @override
  void initState() {
    super.initState();
    _selectedConditions = widget.currentConditions.toSet();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Conditions'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _conditions.length,
          itemBuilder: (context, index) {
            final condition = _conditions[index];
            final isSelected = _selectedConditions.contains(condition);

            return CheckboxListTile(
              title: Text(condition),
              value: isSelected,
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selectedConditions.add(condition);
                  } else {
                    _selectedConditions.remove(condition);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedConditions.toList());
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

/// Show condition selector dialog and return selected conditions
Future<List<String>?> showConditionSelector(
  BuildContext context, {
  List<String> currentConditions = const [],
}) {
  return showDialog<List<String>>(
    context: context,
    builder: (context) =>
        ConditionSelector(currentConditions: currentConditions),
  );
}
