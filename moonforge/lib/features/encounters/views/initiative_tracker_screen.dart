import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moonforge/core/widgets/surface_container.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/encounters/services/initiative_tracker_service.dart';
import 'package:moonforge/l10n/app_localizations.dart';
class InitiativeTrackerScreen extends StatefulWidget {
  final List<Combatant> initialCombatants;
  final String encounterName;
  const InitiativeTrackerScreen({
    super.key,
    required this.initialCombatants,
    required this.encounterName,
  });
  @override
  State<InitiativeTrackerScreen> createState() =>
      _InitiativeTrackerScreenState();
}
class _InitiativeTrackerScreenState extends State<InitiativeTrackerScreen> {
  List<Combatant> _combatants = [];
  int _currentIndex = 0;
  int _round = 1;
  final List<String> _combatLog = [];
  bool _hasRolledInitiative = false;
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
        return c.copyWith(initiative: total);
      }).toList();
      _combatants = InitiativeTrackerService.sortByInitiative(_combatants);
      _currentIndex = 0;
      _hasRolledInitiative = true;
      _addToLog('Initiative rolled for all combatants');
    });
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
      _addToLog('${_combatants[_currentIndex].name}\'s turn');
  void _previousTurn() {
      _currentIndex = InitiativeTrackerService.getPreviousCombatantIndex(
        _combatants,
        _currentIndex,
      );
      _addToLog('Back to ${_combatants[_currentIndex].name}\'s turn');
  void _applyDamage(int index, int damage) {
      final combatant = _combatants[index];
      _combatants[index] = combatant.applyDamage(damage);
      _addToLog(
        '${combatant.name} takes $damage damage (${_combatants[index].currentHp}/${combatant.maxHp} HP)',
      if (!_combatants[index].isAlive) {
        _addToLog('${combatant.name} is defeated!');
        if (InitiativeTrackerService.isEncounterOver(_combatants)) {
          final winner = InitiativeTrackerService.getWinner(_combatants);
          _addToLog(
            '--- Encounter Over! ${winner == 'allies' ? 'Party' : 'Enemies'} win! ---',
          );
        }
      }
  void _heal(int index, int amount) {
      _combatants[index] = combatant.heal(amount);
        '${combatant.name} heals $amount HP (${_combatants[index].currentHp}/${combatant.maxHp} HP)',
  void _addCondition(int index, String condition) {
      _combatants[index] = combatant.addCondition(condition);
      _addToLog('${combatant.name} gains condition: $condition');
  void _removeCondition(int index, String condition) {
      _combatants[index] = combatant.removeCondition(condition);
      _addToLog('${combatant.name} loses condition: $condition');
  void _addToLog(String message) {
    _combatLog.add('[Round $_round] $message');
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEncounterOver = InitiativeTrackerService.isEncounterOver(
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
                          onPressed: _nextTurn,
                          icon: const Icon(Icons.skip_next),
                          tooltip: l10n.nextTurn,
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
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        color: isCurrent
                            ? Theme.of(context).colorScheme.primaryContainer
                            : combatant.isAlive
                            ? null
                            : Colors.grey.shade300,
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: combatant.isAlly
                                ? Colors.blue
                                : Colors.red,
                            child: Text(
                              combatant.initiative?.toString() ?? '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            combatant.name,
                            style: TextStyle(
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              decoration: combatant.isAlive
                                  ? null
                                  : TextDecoration.lineThrough,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'HP: ${combatant.currentHp}/${combatant.maxHp} • AC: ${combatant.armorClass}',
                              if (combatant.conditions.isNotEmpty)
                                Wrap(
                                  spacing: 4,
                                  children: combatant.conditions
                                      .map(
                                        (c) => Chip(
                                          label: Text(
                                            c,
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          ),
                                          visualDensity: VisualDensity.compact,
                                          onDeleted: () =>
                                              _removeCondition(index, c),
                                          deleteIconColor: Colors.red,
                                        ),
                                      )
                                      .toList(),
                                ),
                            ],
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // HP Management
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: combatant.isAlive
                                              ? () => _showDamageDialog(index)
                                              : null,
                                          icon: const Icon(Icons.remove),
                                          label: const Text('Damage'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.red.shade100,
                                      ),
                                      const SizedBox(width: 8),
                                              ? () => _showHealDialog(index)
                                          icon: const Icon(Icons.add),
                                          label: const Text('Heal'),
                                                Colors.green.shade100,
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Condition Management
                                  ElevatedButton.icon(
                                    onPressed: combatant.isAlive
                                        ? () => _showAddConditionDialog(index)
                                        : null,
                                    icon: const Icon(Icons.add),
                                    label: Text(l10n.addCondition),
                                ],
                          ],
                      );
                    },
              ],
          ),
          // Combat Log
            flex: 1,
            child: SurfaceContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Combat Log',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: _combatLog.length,
                      itemBuilder: (context, index) {
                        final logIndex = _combatLog.length - 1 - index;
                        return ListTile(
                          dense: true,
                            _combatLog[logIndex],
                            style: const TextStyle(fontSize: 12),
                        );
                      },
                ],
              ),
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
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ElevatedButton(
            onPressed: () {
              final damage = int.tryParse(controller.text);
              if (damage != null && damage > 0) {
                _applyDamage(index, damage);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Apply'),
  void _showHealDialog(int index) {
        title: const Text('Heal'),
            labelText: 'Healing',
              final amount = int.tryParse(controller.text);
              if (amount != null && amount > 0) {
                _heal(index, amount);
            child: const Text('Heal'),
  void _showAddConditionDialog(int index) {
        title: Text(AppLocalizations.of(context)!.addCondition),
            hintText: 'e.g., Poisoned, Stunned, Prone',
              if (controller.text.isNotEmpty) {
                _addCondition(index, controller.text);
            child: const Text('Add'),
