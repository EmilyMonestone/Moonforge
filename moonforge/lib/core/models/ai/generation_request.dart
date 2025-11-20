import 'package:freezed_annotation/freezed_annotation.dart';
import 'story_context.dart';

part 'generation_request.freezed.dart';
part 'generation_request.g.dart';

/// Base class for AI generation requests
@freezed
class GenerationRequest with _$GenerationRequest {
  const factory GenerationRequest({
    required StoryContext context,
    required GenerationType type,
    String? additionalInstructions,
    @Default(1000) int maxTokens,
  }) = _GenerationRequest;

  factory GenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerationRequestFromJson(json);
}

/// Type of content to generate
enum GenerationType {
  completion,
  chapter,
  adventure,
  scene,
  npc,
}

/// Request for completing/continuing existing content
@freezed
class CompletionRequest with _$CompletionRequest {
  const factory CompletionRequest({
    required StoryContext context,
    required String currentContent,
    String? desiredDirection,
    @Default(500) int maxTokens,
  }) = _CompletionRequest;

  factory CompletionRequest.fromJson(Map<String, dynamic> json) =>
      _$CompletionRequestFromJson(json);
}

/// Request for generating a full section (chapter/adventure/scene)
@freezed
class SectionGenerationRequest with _$SectionGenerationRequest {
  const factory SectionGenerationRequest({
    required StoryContext context,
    required String sectionType, // 'chapter', 'adventure', or 'scene'
    required String title,
    String? outline,
    String? previousSectionSummary,
    @Default([]) List<String> keyElements,
    @Default(1500) int maxTokens,
  }) = _SectionGenerationRequest;

  factory SectionGenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$SectionGenerationRequestFromJson(json);
}

/// Request for generating an NPC
@freezed
class NpcGenerationRequest with _$NpcGenerationRequest {
  const factory NpcGenerationRequest({
    required StoryContext context,
    String? role,
    String? species,
    String? alignment,
    String? relationshipToParty,
    @Default([]) List<String> traits,
    String? backstory,
    @Default(800) int maxTokens,
  }) = _NpcGenerationRequest;

  factory NpcGenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$NpcGenerationRequestFromJson(json);
}
