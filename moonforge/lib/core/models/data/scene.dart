import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'scene.freezed.dart';
part 'scene.g.dart';

@freezed
@firestoreOdm
abstract class Scene with _$Scene {
  const factory Scene({
    @DocumentIdField() required String id,
    required String title,
    String? content, // quill delta json
    List<Map<String, dynamic>>? mentions,
    List<Map<String, dynamic>>? mediaRefs,
    DateTime? updatedAt,
    DateTime? createdAt,
    @Default(0) int rev,
  }) = _Scene;

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);
}
