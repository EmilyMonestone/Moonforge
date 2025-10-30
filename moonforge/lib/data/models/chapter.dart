import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter.freezed.dart';
part 'chapter.g.dart';

/// Chapter domain model
@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required String id,
    required String campaignId,
    required String name,
    required String description,
    String? content,
    int? orderIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
    @Default(false) bool isDeleted,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}
