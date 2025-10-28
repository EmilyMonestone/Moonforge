import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moonforge/core/models/data/entity.dart';

part 'entity_with_origin.freezed.dart';
part 'entity_with_origin.g.dart';

/// Represents an entity with its origin information
@freezed
class EntityWithOrigin with _$EntityWithOrigin {
  const factory EntityWithOrigin({
    required Entity entity,
    EntityOrigin? origin, // null if entity is directly on current part
  }) = _EntityWithOrigin;

  factory EntityWithOrigin.fromJson(Map<String, dynamic> json) =>
      _$EntityWithOriginFromJson(json);
}

/// Origin information for an entity (which part it comes from)
@freezed
class EntityOrigin with _$EntityOrigin {
  const factory EntityOrigin({
    required String partType, // campaign, chapter, adventure, scene, encounter
    required String partId,
    required String label, // e.g., "Scene 1.3.2" or "Adventure 2.1"
    required String path, // e.g., "1.3.2" for hierarchical position
  }) = _EntityOrigin;

  factory EntityOrigin.fromJson(Map<String, dynamic> json) =>
      _$EntityOriginFromJson(json);
}
