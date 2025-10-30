import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'party.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class Party {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String name;

  String? summary;

  @JsonKey(defaultValue: [])
  List<String> memberEntityIds = [];

  DateTime? createdAt;
  DateTime? updatedAt;

  @JsonKey(defaultValue: 0)
  int rev = 0;

  @JsonKey(defaultValue: false)
  bool deleted = false;

  @JsonKey(defaultValue: 'synced')
  String syncStatus = 'synced';

  DateTime? lastSyncedAt;

  Party();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'summary': summary,
      'memberEntityIds': memberEntityIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'rev': rev,
    };
  }

  factory Party.fromFirestore(Map<String, dynamic> data, String docId) {
    return Party()
      ..id = docId
      ..name = data['name'] as String? ?? ''
      ..summary = data['summary'] as String?
      ..memberEntityIds = (data['memberEntityIds'] as List?)?.cast<String>() ?? []
      ..createdAt = (data['createdAt'] as dynamic)?.toDate()
      ..updatedAt = (data['updatedAt'] as dynamic)?.toDate()
      ..rev = data['rev'] as int? ?? 0
      ..syncStatus = 'synced'
      ..lastSyncedAt = DateTime.now();
  }

  factory Party.fromJson(Map<String, dynamic> json) => _$PartyFromJson(json);

  Map<String, dynamic> toJson() => _$PartyToJson(this);
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
