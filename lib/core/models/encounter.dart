import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moonforge/core/models/json_converters.dart';
import 'package:moonforge/core/models/model_support.dart';

part 'encounter.freezed.dart';
part 'encounter.g.dart';

@freezed
@firestoreOdm
class EncounterDoc with _$EncounterDoc {
  @JsonSerializable(explicitToJson: true)
  const factory EncounterDoc({
    @DocumentIdField() required String id,
    required String name,
    @Default(false) bool preset,
    String? notes,
    String? loot,
    @Default(<Combatant>[]) List<Combatant> combatants,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @Default(0) int rev,
  }) = _EncounterDoc;

  factory EncounterDoc.fromJson(Map<String, dynamic> json) =>
      _$EncounterDocFromJson(json);
}
