import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'player.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class Player {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String name;

  String? partyId;

  /// Using 'playerClass' to avoid Dart keyword 'class'
  String? playerClass;

  @JsonKey(defaultValue: 1)
  int level = 1;

  String? species;

  /// Quill delta JSON
  String? info;

  DateTime? createdAt;
  DateTime? updatedAt;

  @JsonKey(defaultValue: 0)
  int rev = 0;

  @JsonKey(defaultValue: false)
  bool deleted = false;

  @JsonKey(defaultValue: 'synced')
  String syncStatus = 'synced';

  DateTime? lastSyncedAt;

  Player();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'partyId': partyId,
      'class': playerClass, // Map to 'class' in Firestore
      'level': level,
      'species': species,
      'info': info,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'rev': rev,
    };
  }

  factory Player.fromFirestore(Map<String, dynamic> data, String docId) {
    return Player()
      ..id = docId
      ..name = data['name'] as String? ?? ''
      ..partyId = data['partyId'] as String?
      ..playerClass = data['class'] as String? // Map from 'class' in Firestore
      ..level = data['level'] as int? ?? 1
      ..species = data['species'] as String?
      ..info = data['info'] as String?
      ..createdAt = (data['createdAt'] as dynamic)?.toDate()
      ..updatedAt = (data['updatedAt'] as dynamic)?.toDate()
      ..rev = data['rev'] as int? ?? 0
      ..syncStatus = 'synced'
      ..lastSyncedAt = DateTime.now();
  }

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerToJson(this);
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
