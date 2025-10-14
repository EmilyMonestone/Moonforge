import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moonforge/core/models/json_converters.dart';

part 'session.freezed.dart';t';
part 'session.g.dart';

enum SessionStatus { inactive, active, paused, ended }

@freezed
@firestoreOdm
class SessionDoc with _$SessionDoc {
  @JsonSerializable(explicitToJson: true)
  const factory SessionDoc({
    @DocumentIdField() required String id,
    SessionStatus? status,
    @Default(0) int round,
    @Default(0) int turnIndex,
    @Default(<String>[]) List<String> order,
    String? visibleSceneId,
    @Default(0) int updatesRev,
    String? dmUid,
    @TimestampConverter() DateTime? createdAt,
  }) = _SessionDoc;

  factory SessionDoc.fromJson(Map<String, dynamic> json) =>
      _$SessionDocFromJson(json);
}
