import 'story_context.dart';

/// Base class for AI generation requests
class GenerationRequest {
  final StoryContext context;
  final GenerationType type;
  final String? additionalInstructions;
  final int maxTokens;

  const GenerationRequest({
    required this.context,
    required this.type,
    this.additionalInstructions,
    this.maxTokens = 1000,
  });

  Map<String, dynamic> toJson() => {
    'context': context.toJson(),
    'type': type.toString(),
    'additionalInstructions': additionalInstructions,
    'maxTokens': maxTokens,
  };

  factory GenerationRequest.fromJson(Map<String, dynamic> json) =>
      GenerationRequest(
        context: StoryContext.fromJson(json['context'] as Map<String, dynamic>),
        type: GenerationType.values.firstWhere(
          (e) => e.toString() == json['type'],
        ),
        additionalInstructions: json['additionalInstructions'] as String?,
        maxTokens: json['maxTokens'] as int? ?? 1000,
      );
}

/// Type of content to generate
enum GenerationType { completion, chapter, adventure, scene, npc }

/// Request for completing/continuing existing content
class CompletionRequest {
  final StoryContext context;
  final String currentContent;
  final String? desiredDirection;
  final int maxTokens;

  const CompletionRequest({
    required this.context,
    required this.currentContent,
    this.desiredDirection,
    this.maxTokens = 500,
  });

  Map<String, dynamic> toJson() => {
    'context': context.toJson(),
    'currentContent': currentContent,
    'desiredDirection': desiredDirection,
    'maxTokens': maxTokens,
  };

  factory CompletionRequest.fromJson(Map<String, dynamic> json) =>
      CompletionRequest(
        context: StoryContext.fromJson(json['context'] as Map<String, dynamic>),
        currentContent: json['currentContent'] as String,
        desiredDirection: json['desiredDirection'] as String?,
        maxTokens: json['maxTokens'] as int? ?? 500,
      );
}

/// Request for generating a full section (chapter/adventure/scene)
class SectionGenerationRequest {
  final StoryContext context;
  final String sectionType; // 'chapter', 'adventure', or 'scene'
  final String title;
  final String? outline;
  final String? previousSectionSummary;
  final List<String> keyElements;
  final int maxTokens;

  const SectionGenerationRequest({
    required this.context,
    required this.sectionType,
    required this.title,
    this.outline,
    this.previousSectionSummary,
    this.keyElements = const [],
    this.maxTokens = 1500,
  });

  Map<String, dynamic> toJson() => {
    'context': context.toJson(),
    'sectionType': sectionType,
    'title': title,
    'outline': outline,
    'previousSectionSummary': previousSectionSummary,
    'keyElements': keyElements,
    'maxTokens': maxTokens,
  };

  factory SectionGenerationRequest.fromJson(Map<String, dynamic> json) =>
      SectionGenerationRequest(
        context: StoryContext.fromJson(json['context'] as Map<String, dynamic>),
        sectionType: json['sectionType'] as String,
        title: json['title'] as String,
        outline: json['outline'] as String?,
        previousSectionSummary: json['previousSectionSummary'] as String?,
        keyElements: (json['keyElements'] as List?)?.cast<String>() ?? const [],
        maxTokens: json['maxTokens'] as int? ?? 1500,
      );
}

/// Request for generating an NPC
class NpcGenerationRequest {
  final StoryContext context;
  final String? role;
  final String? species;
  final String? alignment;
  final String? relationshipToParty;
  final List<String> traits;
  final String? backstory;
  final int maxTokens;

  const NpcGenerationRequest({
    required this.context,
    this.role,
    this.species,
    this.alignment,
    this.relationshipToParty,
    this.traits = const [],
    this.backstory,
    this.maxTokens = 800,
  });

  Map<String, dynamic> toJson() => {
    'context': context.toJson(),
    'role': role,
    'species': species,
    'alignment': alignment,
    'relationshipToParty': relationshipToParty,
    'traits': traits,
    'backstory': backstory,
    'maxTokens': maxTokens,
  };

  factory NpcGenerationRequest.fromJson(Map<String, dynamic> json) =>
      NpcGenerationRequest(
        context: StoryContext.fromJson(json['context'] as Map<String, dynamic>),
        role: json['role'] as String?,
        species: json['species'] as String?,
        alignment: json['alignment'] as String?,
        relationshipToParty: json['relationshipToParty'] as String?,
        traits: (json['traits'] as List?)?.cast<String>() ?? const [],
        backstory: json['backstory'] as String?,
        maxTokens: json['maxTokens'] as int? ?? 800,
      );
}
