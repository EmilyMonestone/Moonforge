import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'encounter.freezed.dart';
part 'encounter.g.dart';

@freezed
@firestoreOdm
abstract class Encounter with _$Encounter {
  const factory Encounter({
    @DocumentIdField() required String id,
    required String name,
    @Default(false) bool preset,
    String? notes,
    String? loot,
    List<Map<String, dynamic>>? combatants,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _Encounter;

  factory Encounter.fromJson(Map<String, dynamic> json) =>
      _$EncounterFromJson(json);
}
