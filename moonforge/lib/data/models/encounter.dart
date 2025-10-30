import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'encounter.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class Encounter {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String name;

  @JsonKey(defaultValue: false)
  bool preset = false;

  String? notes;
  String? loot;

  /// Stored as JSON string
  String? combatants;

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

  Encounter();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'preset': preset,
      'notes': notes,
      'loot': loot,
      'combatants': combatants != null ? jsonDecode(combatants!) : null,
      'entityIds': entityIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'rev': rev,
    };
  }

  factory Encounter.fromFirestore(Map<String, dynamic> data, String docId) {
    return Encounter()
      ..id = docId
      ..name = data['name'] as String? ?? ''
      ..preset = data['preset'] as bool? ?? false
      ..notes = data['notes'] as String?
      ..loot = data['loot'] as String?
      ..combatants = data['combatants'] != null ? jsonEncode(data['combatants']) : null
      ..entityIds = (data['entityIds'] as List?)?.cast<String>() ?? []
      ..createdAt = (data['createdAt'] as dynamic)?.toDate()
      ..updatedAt = (data['updatedAt'] as dynamic)?.toDate()
      ..rev = data['rev'] as int? ?? 0
      ..syncStatus = 'synced'
      ..lastSyncedAt = DateTime.now();
  }

  factory Encounter.fromJson(Map<String, dynamic> json) =>
      _$EncounterFromJson(json);

  Map<String, dynamic> toJson() => _$EncounterToJson(this);
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
