import 'package:freezed_annotation/freezed_annotation.dart';

part 'join_code.freezed.dart';
part 'join_code.g.dart';

@freezed
abstract class JoinCode with _$JoinCode {
  const factory JoinCode({
    required String id, // the short code
    required String cid,
    String? sid,
    DateTime? createdAt,
    DateTime? ttl,
  }) = _JoinCode;

  factory JoinCode.fromJson(Map<String, dynamic> json) =>
      _$JoinCodeFromJson(json);
}
