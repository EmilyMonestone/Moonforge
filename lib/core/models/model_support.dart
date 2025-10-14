import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_support.freezed.dart';
part 'model_support.g.dart';

@JsonSerializable(explicitToJson: true)
@freezed
@firestoreOdm
class RichTextDoc with _$RichTextDoc {
  const factory RichTextDoc({
    @Default('doc') String type,
    @Default(<dynamic>[]) List<dynamic> nodes,
  }) = _RichTextDoc;

  factory RichTextDoc.fromJson(Map<String, dynamic> json) =>
      _$RichTextDocFromJson(json);
}

@JsonSerializable(explicitToJson: true)
@freezed
@firestoreOdm
class Mention with _$Mention {
  const factory Mention({
    @Default('') String kind,
    @Default('') String id,
  }) = _Mention;

  factory Mention.fromJson(Map<String, dynamic> json) =>
      _$MentionFromJson(json);
}

@JsonSerializable(explicitToJson: true)
@freezed
@firestoreOdm
class MediaRef with _$MediaRef {
  const factory MediaRef({required String assetId, String? variant}) =
      _MediaRef;

  factory MediaRef.fromJson(Map<String, dynamic> json) =>
      _$MediaRefFromJson(json);
}

@JsonSerializable(explicitToJson: true)
@freezed
@firestoreOdm
class ImageRef with _$ImageRef {
  const factory ImageRef({required String assetId, String? kind}) = _ImageRef;

  factory ImageRef.fromJson(Map<String, dynamic> json) =>
      _$ImageRefFromJson(json);
}

@JsonSerializable(explicitToJson: true)
@freezed
@firestoreOdm
class Coords with _$Coords {
  const factory Coords({required double lat, required double lng}) = _Coords;

  factory Coords.fromJson(Map<String, dynamic> json) => _$CoordsFromJson(json);
}

@JsonSerializable(explicitToJson: true)
@freezed
@firestoreOdm
class Statblock with _$Statblock {
  const factory Statblock({
    String? source, // srd|custom
    String? srdRef,
    Map<String, dynamic>? data,
  }) = _Statblock;

  factory Statblock.fromJson(Map<String, dynamic> json) =>
      _$StatblockFromJson(json);
}

@JsonSerializable(explicitToJson: true)
@freezed
@firestoreOdm
class Hp with _$Hp {
  const factory Hp({required int current, required int max}) = _Hp;

  factory Hp.fromJson(Map<String, dynamic> json) => _$HpFromJson(json);
}

@JsonSerializable(explicitToJson: true)
@freezed
@firestoreOdm
class CombatantSource with _$CombatantSource {
  const factory CombatantSource({
    required String type, // entity | statblock | adHoc
    String? entityId,
    Map<String, dynamic>? snapshot,
  }) = _CombatantSource;

  factory CombatantSource.fromJson(Map<String, dynamic> json) =>
      _$CombatantSourceFromJson(json);
}

@JsonSerializable(explicitToJson: true)
@freezed
@firestoreOdm
class Combatant with _$Combatant {
  const factory Combatant({
    required String id,
    required CombatantSource source,
    required Hp hp,
    int? ac,
    @Default(<String>[]) List<String> conditions,
    String? note,
    int? initiative,
  }) = _Combatant;

  factory Combatant.fromJson(Map<String, dynamic> json) =>
      _$CombatantFromJson(json);
}

@JsonSerializable(explicitToJson: true)
@freezed
@firestoreOdm
class MediaVariant with _$MediaVariant {
  const factory MediaVariant({
    required String kind,
    required String path,
    int? width,
    int? height,
    int? bytes,
  }) = _MediaVariant;

  factory MediaVariant.fromJson(Map<String, dynamic> json) =>
      _$MediaVariantFromJson(json);
}
