import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign.freezed.dart';
part 'campaign.g.dart';

@freezed
abstract class Campaign with _$Campaign {
  const factory Campaign({
    required String id,
    required String name,
    required String description,
    String? content, // quill delta json
    String? ownerUid,
    List<String>? memberUids,
    @Default([]) List<String> entityIds, // Related entities
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _Campaign;

  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);
}
