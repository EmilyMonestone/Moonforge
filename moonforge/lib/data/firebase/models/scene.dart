import 'package:freezed_annotation/freezed_annotation.dart';

part 'scene.freezed.dart';
part 'scene.g.dart';

@freezed
abstract class Scene with _$Scene {
  const factory Scene({
    required String id,
    required String title,
    @Default(0) int order,
    String? summary,
    String? content, // quill delta json
    List<Map<String, dynamic>>? mentions,
    List<Map<String, dynamic>>? mediaRefs,
    @Default([]) List<String> entityIds, // Related entities
    DateTime? updatedAt,
    DateTime? createdAt,
    @Default(0) int rev,
  }) = _Scene;

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);
}
