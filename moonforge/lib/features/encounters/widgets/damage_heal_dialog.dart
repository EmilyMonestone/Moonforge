import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Dialog for applying damage or healing to a combatant
class DamageHealDialog extends StatefulWidget {
  final String combatantName;
  final int currentHp;
  final int maxHp;
  final bool isDamage;

  const DamageHealDialog({
    super.key,
    required this.combatantName,
    required this.currentHp,
    required this.maxHp,
    this.isDamage = true,
  });

  @override
  State<DamageHealDialog> createState() => _DamageHealDialogState();
}

class _DamageHealDialogState extends State<DamageHealDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(
        widget.isDamage ? 'Apply Damage' : 'Heal',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.combatantName,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Current HP: ${widget.currentHp} / ${widget.maxHp}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: widget.isDamage ? 'Damage Amount' : 'Healing Amount',
                border: const OutlineInputBorder(),
                suffixText: 'HP',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              autofocus: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = int.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid positive number';
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.isDamage ? 'Apply' : 'Heal'),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final amount = int.parse(_controller.text);
      Navigator.of(context).pop(amount);
    }
  }
}

/// Show damage dialog and return the damage amount, or null if cancelled
Future<int?> showDamageDialog(
  BuildContext context, {
  required String combatantName,
  required int currentHp,
  required int maxHp,
}) {
  return showDialog<int>(
    context: context,
    builder: (context) => DamageHealDialog(
      combatantName: combatantName,
      currentHp: currentHp,
      maxHp: maxHp,
      isDamage: true,
    ),
  );
}

/// Show healing dialog and return the healing amount, or null if cancelled
Future<int?> showHealDialog(
  BuildContext context, {
  required String combatantName,
  required int currentHp,
  required int maxHp,
}) {
  return showDialog<int>(
    context: context,
    builder: (context) => DamageHealDialog(
      combatantName: combatantName,
      currentHp: currentHp,
      maxHp: maxHp,
      isDamage: false,
    ),
  );
}
