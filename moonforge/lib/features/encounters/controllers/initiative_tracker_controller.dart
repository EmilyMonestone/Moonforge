import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/encounters/services/initiative_tracker_service.dart';

/// Controller for managing initiative tracker state
class InitiativeTrackerController with ChangeNotifier {
  List<Combatant> _combatants = [];
  int _currentIndex = 0;
  int _round = 1;
  final List<String> _combatLog = [];
  bool _hasRolledInitiative = false;
  bool _isEncounterActive = false;

  List<Combatant> get combatants => _combatants;
  int get currentIndex => _currentIndex;
  int get round => _round;
  List<String> get combatLog => List.unmodifiable(_combatLog);
  bool get hasRolledInitiative => _hasRolledInitiative;
  bool get isEncounterActive => _isEncounterActive;

  Combatant? get currentCombatant =>
      _combatants.isEmpty ? null : _combatants[_currentIndex];

  /// Initialize the tracker with combatants
  void initialize(List<Combatant> combatants) {
    _combatants = combatants;
    _currentIndex = 0;
    _round = 1;
    _combatLog.clear();
    _hasRolledInitiative = false;
    _isEncounterActive = false;
    notifyListeners();
  }

  /// Sort combatants by initiative
  void sortByInitiative() {
    _combatants = InitiativeTrackerService.sortByInitiative(_combatants);
    _currentIndex = 0;
    notifyListeners();
  }

  /// Roll initiative for all combatants
  void rollInitiativeForAll() {
    _combatants = _combatants.map((c) {
      // Generate random roll (1-20) + modifier
      final roll = (DateTime.now().microsecondsSinceEpoch % 20) + 1;
      final total = roll + c.initiativeModifier;
      return c.copyWith(initiative: total);
    }).toList();

    sortByInitiative();
    _hasRolledInitiative = true;
    _isEncounterActive = true;
    addToLog('Initiative rolled for all combatants');
    notifyListeners();
  }

  /// Move to next turn
  void nextTurn() {
    if (!_hasRolledInitiative) return;

    final oldIndex = _currentIndex;
    _currentIndex = InitiativeTrackerService.getNextCombatantIndex(
      _combatants,
      _currentIndex,
    );

    if (InitiativeTrackerService.isNewRound(oldIndex, _currentIndex)) {
      _round++;
      addToLog('--- Round $_round ---');
    }

    if (_combatants.isNotEmpty) {
      addToLog('${_combatants[_currentIndex].name}\'s turn');
    }

    notifyListeners();
  }

  /// Move to previous turn
  void previousTurn() {
    if (!_hasRolledInitiative) return;

    _currentIndex = InitiativeTrackerService.getPreviousCombatantIndex(
      _combatants,
      _currentIndex,
    );

    if (_combatants.isNotEmpty) {
      addToLog('Back to ${_combatants[_currentIndex].name}\'s turn');
    }

    notifyListeners();
  }

  /// Update a combatant
  void updateCombatant(int index, Combatant combatant) {
    if (index >= 0 && index < _combatants.length) {
      _combatants[index] = combatant;
      notifyListeners();
    }
  }

  /// Apply damage to a combatant
  void applyDamage(int index, int damage) {
    if (index < 0 || index >= _combatants.length) return;

    final combatant = _combatants[index];
    final newHp = (combatant.currentHp - damage).clamp(0, combatant.maxHp);
    _combatants[index] = combatant.copyWith(currentHp: newHp);

    addToLog(
      '${combatant.name} takes $damage damage (${_combatants[index].currentHp}/${combatant.maxHp} HP)',
    );

    if (_combatants[index].currentHp <= 0) {
      addToLog('${combatant.name} is defeated!');

      if (InitiativeTrackerService.isEncounterOver(_combatants)) {
        final winner = InitiativeTrackerService.getWinner(_combatants);
        addToLog('Encounter over! $winner win!');
        _isEncounterActive = false;
      }
    }

    notifyListeners();
  }

  /// Heal a combatant
  void heal(int index, int healing) {
    if (index < 0 || index >= _combatants.length) return;

    final combatant = _combatants[index];
    final newHp = (combatant.currentHp + healing).clamp(0, combatant.maxHp);
    _combatants[index] = combatant.copyWith(currentHp: newHp);

    addToLog(
      '${combatant.name} heals $healing HP (${_combatants[index].currentHp}/${combatant.maxHp} HP)',
    );

    notifyListeners();
  }

  /// Add condition to a combatant
  void addCondition(int index, String condition) {
    if (index < 0 || index >= _combatants.length) return;

    final combatant = _combatants[index];
    if (!combatant.conditions.contains(condition)) {
      final newConditions = [...combatant.conditions, condition];
      _combatants[index] = combatant.copyWith(conditions: newConditions);
      addToLog('${combatant.name} gains condition: $condition');
      notifyListeners();
    }
  }

  /// Remove condition from a combatant
  void removeCondition(int index, String condition) {
    if (index < 0 || index >= _combatants.length) return;

    final combatant = _combatants[index];
    final newConditions =
        combatant.conditions.where((c) => c != condition).toList();
    _combatants[index] = combatant.copyWith(conditions: newConditions);
    addToLog('${combatant.name} loses condition: $condition');
    notifyListeners();
  }

  /// Set initiative for a combatant
  void setInitiative(int index, int initiative) {
    if (index < 0 || index >= _combatants.length) return;

    final combatant = _combatants[index];
    _combatants[index] = combatant.copyWith(initiative: initiative);
    sortByInitiative();
    addToLog('${combatant.name}\'s initiative set to $initiative');
    notifyListeners();
  }

  /// Add entry to combat log
  void addToLog(String message) {
    _combatLog.add(message);
    notifyListeners();
  }

  /// Clear combat log
  void clearLog() {
    _combatLog.clear();
    notifyListeners();
  }

  /// Check if encounter is over
  bool isEncounterOver() =>
      InitiativeTrackerService.isEncounterOver(_combatants);

  /// Get winner
  String? getWinner() {
    if (isEncounterOver()) {
      return InitiativeTrackerService.getWinner(_combatants);
    }
    return null;
  }

  /// Reset encounter
  void reset() {
    _currentIndex = 0;
    _round = 1;
    _combatLog.clear();
    _hasRolledInitiative = false;
    _isEncounterActive = false;

    // Reset all combatants to full HP and clear conditions
    _combatants = _combatants.map((c) {
      return c.copyWith(
        currentHp: c.maxHp,
        conditions: [],
        initiative: null,
      );
    }).toList();

    notifyListeners();
  }

  /// End encounter
  void endEncounter() {
    _isEncounterActive = false;
    addToLog('Encounter ended');
    notifyListeners();
  }
}
