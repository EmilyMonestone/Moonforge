import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity.freezed.dart';
part 'entity.g.dart';

/// Entity domain model (NPC, location, item, organization, etc.)
@freezed
class Entity with _$Entity {
  const factory Entity({
    required String id,
    required String campaignId,
    required String name,
    required String entityType, // 'npc', 'location', 'item', 'organization'
    String? description,
    String? content,
    @Default([]) List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
    @Default(false) bool isDeleted,
  }) = _Entity;

  factory Entity.fromJson(Map<String, dynamic> json) =>
      _$EntityFromJson(json);
}
