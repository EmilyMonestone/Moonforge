import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
@firestoreOdm
abstract class Session with _$Session {
  const factory Session({
    @DocumentIdField() required String id,
    DateTime? createdAt,
    String? info, // quill delta json (DM-only)
    DateTime? datetime,
    String? log, // quill delta json (shared with players)
    String? shareToken, // token for public read-only access
    @Default(false) bool shareEnabled, // whether sharing is enabled
    DateTime? shareExpiresAt, // optional expiration for share link
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
