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
    String? info, // quill delta json
    DateTime? datetime,
    String? log, // quill delta json
  }) = _Session;

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
