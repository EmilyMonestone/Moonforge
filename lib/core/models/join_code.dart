import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moonforge/core/models/json_converters.dart';

part 'join_code.freezed.dart';
part 'join_code.g.dart';

@freezed
@firestoreOdm
class JoinCode with _$JoinCode {
  @JsonSerializable(explicitToJson: true)
  const factory JoinCode({
    @DocumentIdField() required String id, // code
    required String cid,
    required String sid,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? ttl,
  }) = _JoinCode;

  factory JoinCode.fromJson(Map<String, dynamic> json) =>
      _$JoinCodeFromJson(json);
}
