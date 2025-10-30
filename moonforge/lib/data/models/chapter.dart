import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chapter.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class Chapter {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String name;

  @JsonKey(defaultValue: 0)
  int order = 0;

  String? summary;

  /// Quill delta JSON
  String? content;

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

  Chapter();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'order': order,
      'summary': summary,
      'content': content,
      'entityIds': entityIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'rev': rev,
    };
  }

  factory Chapter.fromFirestore(Map<String, dynamic> data, String docId) {
    return Chapter()
      ..id = docId
      ..name = data['name'] as String? ?? ''
      ..order = data['order'] as int? ?? 0
      ..summary = data['summary'] as String?
      ..content = data['content'] as String?
      ..entityIds = (data['entityIds'] as List?)?.cast<String>() ?? []
      ..createdAt = (data['createdAt'] as dynamic)?.toDate()
      ..updatedAt = (data['updatedAt'] as dynamic)?.toDate()
      ..rev = data['rev'] as int? ?? 0
      ..syncStatus = 'synced'
      ..lastSyncedAt = DateTime.now();
  }

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterToJson(this);
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
