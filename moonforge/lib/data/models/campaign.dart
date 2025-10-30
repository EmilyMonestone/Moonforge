import 'package:freezed_annotation/freezed_annotation.dart';

part 'campaign.freezed.dart';
part 'campaign.g.dart';

/// Campaign domain model
@freezed
class Campaign with _$Campaign {
  const factory Campaign({
    required String id,
    required String name,
    required String description,
    String? content, // Rich text content (Quill delta JSON)
    String? ownerUid,
    @Default([]) List<String> memberUids,
    @Default([]) List<String> entityIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev, // Revision number for conflict resolution
    @Default(false) bool isDeleted, // Soft delete flag
  }) = _Campaign;

  factory Campaign.fromJson(Map<String, dynamic> json) =>
      _$CampaignFromJson(json);
}
