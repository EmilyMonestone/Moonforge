/// Response from AI generation
class GenerationResponse {
  final bool success;
  final String? content;
  final String? error;
  final int tokensUsed;
  final DateTime? generatedAt;

  const GenerationResponse({
    required this.success,
    this.content,
    this.error,
    this.tokensUsed = 0,
    this.generatedAt,
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'content': content,
    'error': error,
    'tokensUsed': tokensUsed,
    'generatedAt': generatedAt?.toIso8601String(),
  };

  factory GenerationResponse.fromJson(Map<String, dynamic> json) =>
      GenerationResponse(
        success: json['success'] as bool,
        content: json['content'] as String?,
        error: json['error'] as String?,
        tokensUsed: json['tokensUsed'] as int? ?? 0,
        generatedAt: json['generatedAt'] != null
            ? DateTime.parse(json['generatedAt'] as String)
            : null,
      );
}

/// Response for NPC generation with structured data
class NpcGenerationResponse {
  final bool success;
  final String? name;
  final String? appearance;
  final String? personality;
  final String? backstory;
  final String? role;
  final String? motivations;
  final String? secrets;
  final Map<String, dynamic> statblock;
  final String? error;
  final int tokensUsed;
  final DateTime? generatedAt;

  const NpcGenerationResponse({
    required this.success,
    this.name,
    this.appearance,
    this.personality,
    this.backstory,
    this.role,
    this.motivations,
    this.secrets,
    this.statblock = const {},
    this.error,
    this.tokensUsed = 0,
    this.generatedAt,
  });

  Map<String, dynamic> toJson() => {
    'success': success,
    'name': name,
    'appearance': appearance,
    'personality': personality,
    'backstory': backstory,
    'role': role,
    'motivations': motivations,
    'secrets': secrets,
    'statblock': statblock,
    'error': error,
    'tokensUsed': tokensUsed,
    'generatedAt': generatedAt?.toIso8601String(),
  };

  factory NpcGenerationResponse.fromJson(Map<String, dynamic> json) =>
      NpcGenerationResponse(
        success: json['success'] as bool,
        name: json['name'] as String?,
        appearance: json['appearance'] as String?,
        personality: json['personality'] as String?,
        backstory: json['backstory'] as String?,
        role: json['role'] as String?,
        motivations: json['motivations'] as String?,
        secrets: json['secrets'] as String?,
        statblock: json['statblock'] as Map<String, dynamic>? ?? const {},
        error: json['error'] as String?,
        tokensUsed: json['tokensUsed'] as int? ?? 0,
        generatedAt: json['generatedAt'] != null
            ? DateTime.parse(json['generatedAt'] as String)
            : null,
      );
}
