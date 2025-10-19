import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign.freezed.dart';
part 'campaign.g.dart';

@freezed
@firestoreOdm
abstract class Campaign with _$Campaign {
  const factory Campaign({
    @DocumentIdField() required String id,
    required String name,
    required String description,
    String? content, // quill delta json
    String? ownerUid,
    List<String>? memberUids,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _Campaign;

  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);
}
