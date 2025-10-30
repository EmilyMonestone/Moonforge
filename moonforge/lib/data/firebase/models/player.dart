// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
abstract class Player with _$Player {
  const factory Player({
    required String id,
    required String name,
    String? partyId,
    @JsonKey(name: 'class') String? playerClass,
    @Default(1) int level,
    String? species,
    String? info, // quill delta json
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
