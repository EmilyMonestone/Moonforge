import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter.freezed.dart';
part 'chapter.g.dart';

@freezed
@firestoreOdm
abstract class Chapter with _$Chapter {
  const factory Chapter({
    @DocumentIdField() required String id,
    required String name,
    @Default(0) int order,
    String? summary,
    String? content, // quill delta json
    @Default([]) List<String> entityIds, // Related entities
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}
