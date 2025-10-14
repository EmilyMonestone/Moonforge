import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moonforge/core/models/json_converters.dart';
import 'package:moonforge/core/models/model_support.dart';

part 'scene.freezed.dart';
part 'scene.g.dart';

@freezed
@firestoreOdm
class SceneDoc with _$SceneDoc {
  @JsonSerializable(explicitToJson: true)
  const factory SceneDoc({
    @DocumentIdField() required String id,
    required String title,
    RichTextDoc? content,
    @Default(<Mention>[]) List<Mention> mentions,
    @Default(<MediaRef>[]) List<MediaRef> mediaRefs,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @Default(0) int rev,
  }) = _SceneDoc;

  factory SceneDoc.fromJson(Map<String, dynamic> json) =>
      _$SceneDocFromJson(json);
}
