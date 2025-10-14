import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moonforge/core/models/json_converters.dart';
import 'package:moonforge/core/models/model_support.dart';

part 'entity.freezed.dart';
part 'entity.g.dart';

@freezed
@firestoreOdm
class EntityDoc with _$EntityDoc {
  @JsonSerializable(explicitToJson: true)
  const factory EntityDoc({
    @DocumentIdField() required String id,
    required String
    kind, // npc | monster | group | place | item | handout | journal
    required String name,
    String? summary,
    @Default(<String>[]) List<String> tags,

    // Optional union-specific fields
    Statblock? statblock,
    String? placeType, // for places
    String? parentPlaceId,
    Coords? coords,

    // Optional content/images
    RichTextDoc? content,
    @Default(<ImageRef>[]) List<ImageRef> images,

    // Optional group membership (for groups/parties)
    @Default(<String>[]) List<String> members,

    // Optional item props
    Map<String, dynamic>? props,

    // System
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @Default(0) int rev,
    @Default(false) bool deleted,
  }) = _EntityDoc;

  factory EntityDoc.fromJson(Map<String, dynamic> json) =>
      _$EntityDocFromJson(json);
}
