import 'package:drift/drift.dart' show Value;
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/combatant_repository.dart';
import 'package:uuid/uuid.dart';

/// Service for managing combatant operations
class CombatantService {
  final CombatantRepository _repository;
  final Uuid _uuid = const Uuid();

  CombatantService(this._repository);

  /// Create a new combatant
  Future<Combatant> createCombatant({
    required String encounterId,
    required String name,
    required String type,
    required bool isAlly,
    required int maxHp,
    required int armorClass,
    required int initiativeModifier,
    int? initiative,
    String? entityId,
    String? bestiaryName,
    String? cr,
    int xp = 0,
    List<String> conditions = const [],
    String? notes,
    int order = 0,
  }) async {
    final combatant = Combatant(
      id: _uuid.v4(),
      encounterId: encounterId,
      name: name,
      type: type,
      isAlly: isAlly,
      currentHp: maxHp,
      maxHp: maxHp,
      armorClass: armorClass,
      initiative: initiative,
      initiativeModifier: initiativeModifier,
      entityId: entityId,
      bestiaryName: bestiaryName,
      cr: cr,
      xp: xp,
      conditions: conditions,
      notes: notes,
      order: order,
    );

    await _repository.create(combatant);
    return combatant;
  }

  /// Apply damage to a combatant
  Future<Combatant> applyDamage(Combatant combatant, int damage) async {
    final newHp = (combatant.currentHp - damage).clamp(0, combatant.maxHp);
    final updated = combatant.copyWith(currentHp: newHp);
    await _repository.update(updated);
    return updated;
  }

  /// Heal a combatant
  Future<Combatant> heal(Combatant combatant, int healing) async {
    final newHp = (combatant.currentHp + healing).clamp(0, combatant.maxHp);
    final updated = combatant.copyWith(currentHp: newHp);
    await _repository.update(updated);
    return updated;
  }

  /// Set HP directly
  Future<Combatant> setHp(Combatant combatant, int hp) async {
    final newHp = hp.clamp(0, combatant.maxHp);
    final updated = combatant.copyWith(currentHp: newHp);
    await _repository.update(updated);
    return updated;
  }

  /// Add a condition to a combatant
  Future<Combatant> addCondition(Combatant combatant, String condition) async {
    if (combatant.conditions.contains(condition)) {
      return combatant;
    }
    final newConditions = [...combatant.conditions, condition];
    final updated = combatant.copyWith(conditions: newConditions);
    await _repository.update(updated);
    return updated;
  }

  /// Remove a condition from a combatant
  Future<Combatant> removeCondition(
    Combatant combatant,
    String condition,
  ) async {
    final newConditions = combatant.conditions
        .where((c) => c != condition)
        .toList();
    final updated = combatant.copyWith(conditions: newConditions);
    await _repository.update(updated);
    return updated;
  }

  /// Clear all conditions from a combatant
  Future<Combatant> clearConditions(Combatant combatant) async {
    final updated = combatant.copyWith(conditions: []);
    await _repository.update(updated);
    return updated;
  }

  /// Update initiative for a combatant
  Future<Combatant> setInitiative(Combatant combatant, int initiative) async {
    final updated = combatant.copyWith(initiative: Value(initiative));
    await _repository.update(updated);
    return updated;
  }

  /// Check if combatant is alive
  bool isAlive(Combatant combatant) => combatant.currentHp > 0;

  /// Check if combatant is bloodied (below 50% HP)
  bool isBloodied(Combatant combatant) =>
      combatant.currentHp <= (combatant.maxHp / 2);

  /// Get HP percentage
  double getHpPercentage(Combatant combatant) {
    if (combatant.maxHp == 0) return 0;
    return combatant.currentHp / combatant.maxHp;
  }

  /// Delete a combatant
  Future<void> deleteCombatant(String id) async {
    await _repository.delete(id);
  }

  /// Update combatant notes
  Future<Combatant> updateNotes(Combatant combatant, String notes) async {
    final updated = combatant.copyWith(notes: Value(notes));
    await _repository.update(updated);
    return updated;
  }

  /// Update combatant order
  Future<Combatant> updateOrder(Combatant combatant, int order) async {
    final updated = combatant.copyWith(order: order);
    await _repository.update(updated);
    return updated;
  }

  /// Duplicate a combatant (useful for adding multiple of the same monster)
  Future<Combatant> duplicateCombatant(
    Combatant combatant,
    String newName,
  ) async {
    final duplicate = Combatant(
      id: _uuid.v4(),
      encounterId: combatant.encounterId,
      name: newName,
      type: combatant.type,
      isAlly: combatant.isAlly,
      currentHp: combatant.maxHp,
      maxHp: combatant.maxHp,
      armorClass: combatant.armorClass,
      initiative: null,
      initiativeModifier: combatant.initiativeModifier,
      entityId: combatant.entityId,
      bestiaryName: combatant.bestiaryName,
      cr: combatant.cr,
      xp: combatant.xp,
      conditions: [],
      notes: combatant.notes,
      order: combatant.order + 1,
    );

    await _repository.create(duplicate);
    return duplicate;
  }
}
