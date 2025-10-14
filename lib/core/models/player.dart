// ignore_for_file: invalid_annotation_target
import 'package:firestore_odm/firestore_odm.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
@firestoreOdm
abstract class Player with _$Player {
  const factory Player({
    @DocumentIdField() required String id,
    required String name,
    String? partyId,
    String? playerClass,
    @Default(1) int level,
    String? species,
    String? info, // quill delta json
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
