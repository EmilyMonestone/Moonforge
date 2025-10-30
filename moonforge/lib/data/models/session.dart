import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class Session {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  DateTime? createdAt;

  /// Quill delta JSON (DM-only)
  String? info;

  DateTime? datetime;

  /// Quill delta JSON (shared with players)
  String? log;

  /// Token for public read-only access
  String? shareToken;

  @JsonKey(defaultValue: false)
  bool shareEnabled = false;

  /// Optional expiration for share link
  DateTime? shareExpiresAt;

  DateTime? updatedAt;

  @JsonKey(defaultValue: 0)
  int rev = 0;

  @JsonKey(defaultValue: false)
  bool deleted = false;

  @JsonKey(defaultValue: 'synced')
  String syncStatus = 'synced';

  DateTime? lastSyncedAt;

  Session();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'createdAt': createdAt,
      'info': info,
      'datetime': datetime,
      'log': log,
      'shareToken': shareToken,
      'shareEnabled': shareEnabled,
      'shareExpiresAt': shareExpiresAt,
      'updatedAt': updatedAt,
      'rev': rev,
    };
  }

  factory Session.fromFirestore(Map<String, dynamic> data, String docId) {
    return Session()
      ..id = docId
      ..createdAt = (data['createdAt'] as dynamic)?.toDate()
      ..info = data['info'] as String?
      ..datetime = (data['datetime'] as dynamic)?.toDate()
      ..log = data['log'] as String?
      ..shareToken = data['shareToken'] as String?
      ..shareEnabled = data['shareEnabled'] as bool? ?? false
      ..shareExpiresAt = (data['shareExpiresAt'] as dynamic)?.toDate()
      ..updatedAt = (data['updatedAt'] as dynamic)?.toDate()
      ..rev = data['rev'] as int? ?? 0
      ..syncStatus = 'synced'
      ..lastSyncedAt = DateTime.now();
  }

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
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
