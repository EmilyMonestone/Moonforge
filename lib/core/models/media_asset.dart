import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_asset.freezed.dart';
part 'media_asset.g.dart';

@freezed
@firestoreOdm
abstract class MediaAsset with _$MediaAsset {
  const factory MediaAsset({
    @DocumentIdField() required String id,
    required String filename,
    required int size, // bytes
    required String mime,
    List<String>? captions,
    String? alt,
    List<Map<String, dynamic>>? variants,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _MediaAsset;

  factory MediaAsset.fromJson(Map<String, dynamic> json) =>
      _$MediaAssetFromJson(json);
}
