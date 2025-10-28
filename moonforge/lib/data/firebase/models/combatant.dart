import 'package:freezed_annotation/freezed_annotation.dart';

part 'combatant.freezed.dart';
part 'combatant.g.dart';

/// Represents a participant in an encounter (monster, NPC, or player character)
@freezed
abstract class Combatant with _$Combatant {
  const factory Combatant({
    required String id,
    required String name,
    required CombatantType type,
    @Default(true) bool isAlly,

    // Combat stats
    @Default(0) int currentHp,
    @Default(0) int maxHp,
    @Default(10) int armorClass,

    // Initiative
    int? initiative,
    @Default(0) int initiativeModifier,

    // Source information
    String?
    entityId, // Reference to Entity (for campaign-specific monsters/NPCs)
    String? bestiaryName, // Reference to bestiary entry
    String? cr, // Challenge Rating (for monsters)
    @Default(0) int xp, // XP value
    // Conditions and notes
    @Default([]) List<String> conditions,
    String? notes,

    // Position in initiative order (managed by tracker)
    @Default(0) int order,
  }) = _Combatant;

  factory Combatant.fromJson(Map<String, dynamic> json) =>
      _$CombatantFromJson(json);
}

/// Type of combatant in an encounter
enum CombatantType {
  @JsonValue('player')
  player,
  @JsonValue('monster')
  monster,
  @JsonValue('npc')
  npc,
}

/// Extension methods for Combatant
extension CombatantExtension on Combatant {
  /// Check if combatant is alive
  bool get isAlive => currentHp > 0;

  /// Check if combatant is enemy
  bool get isEnemy => !isAlly;

  /// Apply damage to the combatant
  Combatant applyDamage(int damage) {
    final newHp = (currentHp - damage).clamp(0, maxHp);
    return copyWith(currentHp: newHp);
  }

  /// Heal the combatant
  Combatant heal(int amount) {
    final newHp = (currentHp + amount).clamp(0, maxHp);
    return copyWith(currentHp: newHp);
  }

  /// Add a condition
  Combatant addCondition(String condition) {
    if (conditions.contains(condition)) return this;
    return copyWith(conditions: [...conditions, condition]);
  }

  /// Remove a condition
  Combatant removeCondition(String condition) {
    return copyWith(
      conditions: conditions.where((c) => c != condition).toList(),
    );
  }
}
