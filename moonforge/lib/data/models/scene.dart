import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scene.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class Scene {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String title;

  @JsonKey(defaultValue: 0)
  int order = 0;

  String? summary;

  /// Quill delta JSON
  String? content;

  /// Stored as JSON string
  String? mentions;

  /// Stored as JSON string
  String? mediaRefs;

  @JsonKey(defaultValue: [])
  List<String> entityIds = [];

  DateTime? createdAt;
  DateTime? updatedAt;

  @JsonKey(defaultValue: 0)
  int rev = 0;

  @JsonKey(defaultValue: false)
  bool deleted = false;

  @JsonKey(defaultValue: 'synced')
  String syncStatus = 'synced';

  DateTime? lastSyncedAt;

  Scene();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'order': order,
      'summary': summary,
      'content': content,
      'mentions': mentions != null ? _decodeJson(mentions!) : null,
      'mediaRefs': mediaRefs != null ? _decodeJson(mediaRefs!) : null,
      'entityIds': entityIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'rev': rev,
    };
  }

  factory Scene.fromFirestore(Map<String, dynamic> data, String docId) {
    return Scene()
      ..id = docId
      ..title = data['title'] as String? ?? ''
      ..order = data['order'] as int? ?? 0
      ..summary = data['summary'] as String?
      ..content = data['content'] as String?
      ..mentions = data['mentions'] != null ? _encodeJson(data['mentions']) : null
      ..mediaRefs = data['mediaRefs'] != null ? _encodeJson(data['mediaRefs']) : null
      ..entityIds = (data['entityIds'] as List?)?.cast<String>() ?? []
      ..createdAt = (data['createdAt'] as dynamic)?.toDate()
      ..updatedAt = (data['updatedAt'] as dynamic)?.toDate()
      ..rev = data['rev'] as int? ?? 0
      ..syncStatus = 'synced'
      ..lastSyncedAt = DateTime.now();
  }

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);

  Map<String, dynamic> toJson() => _$SceneToJson(this);

  static String _encodeJson(dynamic data) {
    return data is String ? data : jsonEncode(data);
  }

  static dynamic _decodeJson(String data) {
    try {
      return jsonDecode(data);
    } catch (_) {
      return data;
    }
  }
}

import 'dart:convert';

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
