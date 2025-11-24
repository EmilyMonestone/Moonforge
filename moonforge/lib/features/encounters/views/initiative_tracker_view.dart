import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart' as db;
import 'package:moonforge/features/encounters/services/initiative_tracker_service.dart';
import 'package:moonforge/features/encounters/widgets/combat_log_widget.dart';
import 'package:moonforge/features/encounters/widgets/combatant_card.dart';
import 'package:moonforge/l10n/app_localizations.dart';

class InitiativeTrackerView extends StatefulWidget {
  final List<db.Combatant> initialCombatants;
  final String encounterName;

  const InitiativeTrackerView({
    super.key,
    required this.initialCombatants,
    required this.encounterName,
  });

  @override
  State<InitiativeTrackerView> createState() => _InitiativeTrackerViewState();
}

class _InitiativeTrackerViewState extends State<InitiativeTrackerView> {
  List<db.Combatant> _combatants = [];
  int _currentIndex = 0;
  int _round = 1;
  final List<String> _combatLog = [];
  bool _hasRolledInitiative = false;

  @override
  void initState() {
    super.initState();
    _combatants = widget.initialCombatants;
  }

  void _rollInitiativeForAll() {
    final random = Random();
    setState(() {
      _combatants = _combatants.map((c) {
        final roll = random.nextInt(20) + 1;
        final total = roll + c.initiativeModifier;
        return c.copyWith(initiative: Value(total));
      }).toList();

      _combatants = InitiativeTrackerService.sortByInitiative(_combatants);
      _currentIndex = 0;
      _hasRolledInitiative = true;
      _addToLog('Initiative rolled for all combatants');
    });
  }

  void _nextTurn() {
    if (!_hasRolledInitiative) return;

    final oldIndex = _currentIndex;
    _currentIndex = InitiativeTrackerService.getNextCombatantIndex(
      _combatants,
      _currentIndex,
    );

    if (InitiativeTrackerService.isNewRound(oldIndex, _currentIndex)) {
      setState(() {
        _round++;
        _addToLog('--- Round $_round ---');
      });
    }

    setState(() {
      _addToLog('${_combatants[_currentIndex].name}\'s turn');
    });
  }

  void _previousTurn() {
    if (!_hasRolledInitiative) return;

    setState(() {
      _currentIndex = InitiativeTrackerService.getPreviousCombatantIndex(
        _combatants,
        _currentIndex,
      );
      _addToLog('Back to ${_combatants[_currentIndex].name}\'s turn');
    });
  }

  void _applyDamage(int index, int damage) {
    setState(() {
      final combatant = _combatants[index];
      final newHp = (combatant.currentHp - damage).clamp(0, combatant.maxHp);
      _combatants[index] = combatant.copyWith(currentHp: newHp);
      _addToLog(
        '${combatant.name} takes $damage damage (${_combatants[index].currentHp}/${combatant.maxHp} HP)',
      );

      if (_combatants[index].currentHp <= 0) {
        _addToLog('${combatant.name} is defeated!');

        if (InitiativeTrackerService.isEncounterOver(_combatants)) {
          final winner = InitiativeTrackerService.getWinner(_combatants);
          _addToLog(
            '--- Encounter Over! ${winner == 'allies' ? 'Party' : 'Enemies'} win! ---',
          );
        }
      }
    });
  }

  void _heal(int index, int amount) {
    setState(() {
      final combatant = _combatants[index];
      final newHp = (combatant.currentHp + amount).clamp(0, combatant.maxHp);
      _combatants[index] = combatant.copyWith(currentHp: newHp);
      _addToLog(
        '${combatant.name} heals $amount HP (${_combatants[index].currentHp}/${combatant.maxHp} HP)',
      );
    });
  }

  void _addCondition(int index, String condition) {
    setState(() {
      final combatant = _combatants[index];
      final conditions = [...combatant.conditions, condition];
      _combatants[index] = combatant.copyWith(conditions: conditions);
      _addToLog('${combatant.name} gains condition: $condition');
    });
  }

  void _removeCondition(int index, String condition) {
    setState(() {
      final combatant = _combatants[index];
      final conditions = combatant.conditions
          .where((c) => c != condition)
          .toList();
      _combatants[index] = combatant.copyWith(conditions: conditions);
      _addToLog('${combatant.name} loses condition: $condition');
    });
  }

  void _addToLog(String message) {
    _combatLog.add('[Round $_round] $message');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEncounterOver = InitiativeTrackerService.isEncounterOver(
      _combatants,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.initiativeTracker} - ${widget.encounterName}'),
        actions: [
          if (!_hasRolledInitiative)
            TextButton.icon(
              onPressed: _rollInitiativeForAll,
              icon: const Icon(Icons.casino),
              label: Text(l10n.rollInitiative),
            ),
        ],
      ),
      body: Row(
        children: [
          // Initiative Order
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Round Counter
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${l10n.round}: $_round',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (_hasRolledInitiative && !isEncounterOver) ...[
                        IconButton(
                          onPressed: _previousTurn,
                          icon: const Icon(Icons.skip_previous),
                          tooltip: l10n.previousTurn,
                        ),
                        IconButton(
                          onPressed: _nextTurn,
                          icon: const Icon(Icons.skip_next),
                          tooltip: l10n.nextTurn,
                        ),
                      ],
                    ],
                  ),
                ),

                // Combatants List
                Expanded(
                  child: ListView.builder(
                    itemCount: _combatants.length,
                    itemBuilder: (context, index) {
                      final combatant = _combatants[index];
                      final isCurrent =
                          _hasRolledInitiative && index == _currentIndex;

                      return CombatantCard(
                        combatant: combatant,
                        isCurrent: isCurrent,
                        index: index,
                        onDamage: (i, _) => _showDamageDialog(i),
                        onHeal: (i, _) => _showHealDialog(i),
                        onAddCondition: (i) => _showAddConditionDialog(i),
                        onRemoveCondition: (i, c) => _removeCondition(i, c),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Combat Log
          Expanded(
            flex: 1,
            child: SurfaceContainer(child: CombatLogWidget(log: _combatLog)),
          ),
        ],
      ),
    );
  }

  void _showDamageDialog(int index) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply Damage'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Damage',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final damage = int.tryParse(controller.text);
              if (damage != null && damage > 0) {
                _applyDamage(index, damage);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showHealDialog(int index) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Heal'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Healing',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(controller.text);
              if (amount != null && amount > 0) {
                _heal(index, amount);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Heal'),
          ),
        ],
      ),
    );
  }

  void _showAddConditionDialog(int index) {
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
                _addCondition(index, controller.text);
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
