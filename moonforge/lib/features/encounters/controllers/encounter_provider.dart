import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';

/// Provider for managing encounter state
class EncounterProvider with ChangeNotifier {
  final EncounterRepository _repository;

  Encounter? _currentEncounter;
  List<Encounter>? _encounters;

  Encounter? get currentEncounter => _currentEncounter;
  List<Encounter>? get encounters => _encounters;

  EncounterProvider(this._repository);

  /// Set the current encounter
  void setCurrentEncounter(Encounter? encounter) {
    _currentEncounter = encounter;
    notifyListeners();
  }

  /// Load encounters by origin (campaign, chapter, adventure, scene)
  Future<void> loadEncountersByOrigin(String originId) async {
    _encounters = await _repository.getByOrigin(originId);
    notifyListeners();
  }

  /// Load a specific encounter
  Future<void> loadEncounter(String id) async {
    _currentEncounter = await _repository.getById(id);
    notifyListeners();
  }

  /// Create a new encounter
  Future<void> createEncounter(Encounter encounter) async {
    await _repository.create(encounter);
    await loadEncountersByOrigin(encounter.originId);
  }

  /// Update an encounter
  Future<void> updateEncounter(Encounter encounter) async {
    await _repository.update(encounter);
    if (_currentEncounter?.id == encounter.id) {
      _currentEncounter = encounter;
    }
    notifyListeners();
  }

  /// Delete an encounter
  Future<void> deleteEncounter(String id) async {
    await _repository.delete(id);
    if (_currentEncounter?.id == id) {
      _currentEncounter = null;
    }
    if (_encounters != null) {
      _encounters = _encounters!.where((e) => e.id != id).toList();
    }
    notifyListeners();
  }

  /// Clear current encounter
  void clearCurrentEncounter() {
    _currentEncounter = null;
    notifyListeners();
  }
}
