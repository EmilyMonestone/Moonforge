import 'package:freezed_annotation/freezed_annotation.dart';

part 'party.freezed.dart';
part 'party.g.dart';

@freezed
abstract class Party with _$Party {
  const factory Party({
    required String id,
    required String name,
    String? summary,
    List<String>? memberEntityIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(0) int rev,
  }) = _Party;

  factory Party.fromJson(Map<String, dynamic> json) => _$PartyFromJson(json);
}
