import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'campaign.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class Campaign {
  /// Isar ID (auto-increment integer)
  Id isarId = Isar.autoIncrement;

  /// Firestore document ID
  @Index(unique: true)
  late String id;

  late String name;
  late String description;

  /// Quill delta JSON
  String? content;

  String? ownerUid;

  @JsonKey(defaultValue: [])
  List<String> memberUids = [];

  /// Related entity IDs
  @JsonKey(defaultValue: [])
  List<String> entityIds = [];

  DateTime? createdAt;
  DateTime? updatedAt;

  /// Revision number for optimistic locking
  @JsonKey(defaultValue: 0)
  int rev = 0;

  /// Soft delete flag
  @JsonKey(defaultValue: false)
  bool deleted = false;

  /// Sync status: 'synced', 'pending', 'conflict'
  @JsonKey(defaultValue: 'synced')
  @Enumerated(EnumType.name)
  String syncStatus = 'synced';

  /// Last time this document was synced with Firestore
  DateTime? lastSyncedAt;

  Campaign();

  /// Convert to Firestore document (JSON)
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'content': content,
      'ownerUid': ownerUid,
      'memberUids': memberUids,
      'entityIds': entityIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'rev': rev,
    };
  }

  /// Create from Firestore document
  factory Campaign.fromFirestore(Map<String, dynamic> data, String docId) {
    return Campaign()
      ..id = docId
      ..name = data['name'] as String? ?? ''
      ..description = data['description'] as String? ?? ''
      ..content = data['content'] as String?
      ..ownerUid = data['ownerUid'] as String?
      ..memberUids = (data['memberUids'] as List?)?.cast<String>() ?? []
      ..entityIds = (data['entityIds'] as List?)?.cast<String>() ?? []
      ..createdAt = (data['createdAt'] as dynamic)?.toDate()
      ..updatedAt = (data['updatedAt'] as dynamic)?.toDate()
      ..rev = data['rev'] as int? ?? 0
      ..syncStatus = 'synced'
      ..lastSyncedAt = DateTime.now();
  }

  /// JSON serialization for local storage
  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignToJson(this);
}

/// Extension to convert Timestamp to DateTime
extension on dynamic {
  DateTime? toDate() {
    if (this == null) return null;
    if (this is DateTime) return this as DateTime;
    // Handle Firestore Timestamp
    if (this.runtimeType.toString() == 'Timestamp') {
      return (this as dynamic).toDate() as DateTime;
    }
    return null;
  }
}
