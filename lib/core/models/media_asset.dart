import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moonforge/core/models/json_converters.dart';
import 'package:moonforge/core/models/model_support.dart';

part 'media_asset.freezed.dart';
part 'media_asset.g.dart';

@freezed
@firestoreOdm
class MediaAssetDoc with _$MediaAssetDoc {
  @JsonSerializable(explicitToJson: true)
  const factory MediaAssetDoc({
    @DocumentIdField() required String id,
    required String filename,
    int? size,
    String? mime,
    @Default(<String>[]) List<String> captions,
    String? alt,
    @Default(<MediaVariant>[]) List<MediaVariant> variants,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @Default(0) int rev,
  }) = _MediaAssetDoc;

  factory MediaAssetDoc.fromJson(Map<String, dynamic> json) =>
      _$MediaAssetDocFromJson(json);
}
