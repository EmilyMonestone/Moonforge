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
  }) = _Campaign;

  factory Campaign.fromJson(Map<String, dynamic> json) => _$CampaignFromJson(json);
}