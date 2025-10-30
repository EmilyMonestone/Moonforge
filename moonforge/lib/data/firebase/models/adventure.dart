import 'package:freezed_annotation/freezed_annotation.dart';

part 'adventure.freezed.dart';
part 'adventure.g.dart';

@freezed
abstract class Adventure with _$Adventure {
  const factory Adventure({
    required String id,
    required String name,
    @Default(0) int order,
    String? summary,
    String? content, // quill delta json
    @Default([]) List<String> entityIds, // Related entities
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _Adventure;

  factory Adventure.fromJson(Map<String, dynamic> json) =>
      _$AdventureFromJson(json);
}
