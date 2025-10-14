import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moonforge/core/models/json_converters.dart';
import 'package:moonforge/core/models/model_support.dart';

part 'chapter.freezed.dart';
part 'chapter.g.dart';

@freezed
@firestoreOdm
class ChapterDoc with _$ChapterDoc {
  @JsonSerializable(explicitToJson: true)
  const factory ChapterDoc({
    @DocumentIdField() required String id,
    required String name,
    @Default(0) int order,
    String? summary,
    RichTextDoc? content,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @Default(0) int rev,
  }) = _ChapterDoc;

  factory ChapterDoc.fromJson(Map<String, dynamic> json) =>
      _$ChapterDocFromJson(json);
}
