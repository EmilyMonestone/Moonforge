import 'package:freezed_annotation/freezed_annotation.dart';

part 'generation_response.freezed.dart';
part 'generation_response.g.dart';

/// Response from AI generation
@freezed
class GenerationResponse with _$GenerationResponse {
  const factory GenerationResponse({
    required bool success,
    String? content,
    String? error,
    @Default(0) int tokensUsed,
    DateTime? generatedAt,
  }) = _GenerationResponse;

  factory GenerationResponse.fromJson(Map<String, dynamic> json) =>
      _$GenerationResponseFromJson(json);
}

/// Response for NPC generation with structured data
@freezed
class NpcGenerationResponse with _$NpcGenerationResponse {
  const factory NpcGenerationResponse({
    required bool success,
    String? name,
    String? appearance,
    String? personality,
    String? backstory,
    String? role,
    String? motivations,
    String? secrets,
    @Default({}) Map<String, dynamic> statblock,
    String? error,
    @Default(0) int tokensUsed,
    DateTime? generatedAt,
  }) = _NpcGenerationResponse;

  factory NpcGenerationResponse.fromJson(Map<String, dynamic> json) =>
      _$NpcGenerationResponseFromJson(json);
}
