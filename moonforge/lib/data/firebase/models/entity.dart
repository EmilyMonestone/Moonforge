import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity.freezed.dart';
part 'entity.g.dart';

@freezed
abstract class Entity with _$Entity {
  const factory Entity({
    required String id,
    required String
    kind, // npc | monster | group | place | item | handout | journal
    required String name,
    String? summary,
    List<String>? tags,

    // Optional union-specific fields
    @Default(<String, dynamic>{}) Map<String, dynamic> statblock,
    String?
    placeType, // world | continent | region | city | village | place | other
    String? parentPlaceId,
    @Default(<String, dynamic>{}) Map<String, dynamic> coords, // { lat, lng }
    // Optional rich content
    String? content, // quill delta json
    List<Map<String, dynamic>>? images, // [{ assetId, kind }]
    // System fields
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
    @Default(false) bool deleted,

    // Optional for groups/parties
    List<String>? members,
  }) = _Entity;

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);
}
