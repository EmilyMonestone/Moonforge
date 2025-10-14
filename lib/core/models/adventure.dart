import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moonforge/core/models/json_converters.dart';
import 'package:moonforge/core/models/model_support.dart';

part 'adventure.freezed.dart';
part 'adventure.g.dart';

@freezed
@firestoreOdm
class AdventureDoc with _$AdventureDoc {
  @JsonSerializable(explicitToJson: true)
  const factory AdventureDoc({
    @DocumentIdField() required String id,
    required String name,
    @Default(0) int order,
    String? summary,
    RichTextDoc? content,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @Default(0) int rev,
  }) = _AdventureDoc;

  factory AdventureDoc.fromJson(Map<String, dynamic> json) =>
      _$AdventureDocFromJson(json);
}
