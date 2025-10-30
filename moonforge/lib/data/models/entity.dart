import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class Entity {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  /// npc | monster | group | place | item | handout | journal
  late String kind;

  late String name;

  String? summary;

  @JsonKey(defaultValue: [])
  List<String> tags = [];

  /// Stored as JSON string
  String? statblock;

  /// world | continent | region | city | village | place | other
  String? placeType;

  String? parentPlaceId;

  /// Stored as JSON string: { lat, lng }
  String? coords;

  /// Quill delta JSON
  String? content;

  /// Stored as JSON string: [{ assetId, kind }]
  String? images;

  DateTime? createdAt;
  DateTime? updatedAt;

  @JsonKey(defaultValue: 0)
  int rev = 0;

  @JsonKey(defaultValue: false)
  bool deleted = false;

  @JsonKey(defaultValue: [])
  List<String> members = [];

  @JsonKey(defaultValue: 'synced')
  String syncStatus = 'synced';

  DateTime? lastSyncedAt;

  Entity();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'kind': kind,
      'name': name,
      'summary': summary,
      'tags': tags,
      'statblock': statblock != null ? jsonDecode(statblock!) : {},
      'placeType': placeType,
      'parentPlaceId': parentPlaceId,
      'coords': coords != null ? jsonDecode(coords!) : {},
      'content': content,
      'images': images != null ? jsonDecode(images!) : null,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'rev': rev,
      'deleted': deleted,
      'members': members,
    };
  }

  factory Entity.fromFirestore(Map<String, dynamic> data, String docId) {
    return Entity()
      ..id = docId
      ..kind = data['kind'] as String? ?? ''
      ..name = data['name'] as String? ?? ''
      ..summary = data['summary'] as String?
      ..tags = (data['tags'] as List?)?.cast<String>() ?? []
      ..statblock = data['statblock'] != null ? jsonEncode(data['statblock']) : null
      ..placeType = data['placeType'] as String?
      ..parentPlaceId = data['parentPlaceId'] as String?
      ..coords = data['coords'] != null ? jsonEncode(data['coords']) : null
      ..content = data['content'] as String?
      ..images = data['images'] != null ? jsonEncode(data['images']) : null
      ..createdAt = (data['createdAt'] as dynamic)?.toDate()
      ..updatedAt = (data['updatedAt'] as dynamic)?.toDate()
      ..rev = data['rev'] as int? ?? 0
      ..deleted = data['deleted'] as bool? ?? false
      ..members = (data['members'] as List?)?.cast<String>() ?? []
      ..syncStatus = 'synced'
      ..lastSyncedAt = DateTime.now();
  }

  factory Entity.fromJson(Map<String, dynamic> json) => _$EntityFromJson(json);

  Map<String, dynamic> toJson() => _$EntityToJson(this);
}

extension on dynamic {
  DateTime? toDate() {
    if (this == null) return null;
    if (this is DateTime) return this as DateTime;
    if (this.runtimeType.toString() == 'Timestamp') {
      return (this as dynamic).toDate() as DateTime;
    }
    return null;
  }
}
