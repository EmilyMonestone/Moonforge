import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

part 'media_asset.g.dart';

@collection
@JsonSerializable(explicitToJson: true)
class MediaAsset {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true)
  late String id;

  late String filename;

  /// Size in bytes
  late int size;

  late String mime;

  @JsonKey(defaultValue: [])
  List<String> captions = [];

  String? alt;

  /// Stored as JSON string: [{ width, height, url, ... }]
  String? variants;

  DateTime? createdAt;
  DateTime? updatedAt;

  @JsonKey(defaultValue: 0)
  int rev = 0;

  @JsonKey(defaultValue: false)
  bool deleted = false;

  @JsonKey(defaultValue: 'synced')
  String syncStatus = 'synced';

  DateTime? lastSyncedAt;

  MediaAsset();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'filename': filename,
      'size': size,
      'mime': mime,
      'captions': captions,
      'alt': alt,
      'variants': variants != null ? jsonDecode(variants!) : null,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'rev': rev,
    };
  }

  factory MediaAsset.fromFirestore(Map<String, dynamic> data, String docId) {
    return MediaAsset()
      ..id = docId
      ..filename = data['filename'] as String? ?? ''
      ..size = data['size'] as int? ?? 0
      ..mime = data['mime'] as String? ?? ''
      ..captions = (data['captions'] as List?)?.cast<String>() ?? []
      ..alt = data['alt'] as String?
      ..variants = data['variants'] != null ? jsonEncode(data['variants']) : null
      ..createdAt = (data['createdAt'] as dynamic)?.toDate()
      ..updatedAt = (data['updatedAt'] as dynamic)?.toDate()
      ..rev = data['rev'] as int? ?? 0
      ..syncStatus = 'synced'
      ..lastSyncedAt = DateTime.now();
  }

  factory MediaAsset.fromJson(Map<String, dynamic> json) =>
      _$MediaAssetFromJson(json);

  Map<String, dynamic> toJson() => _$MediaAssetToJson(this);
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
