/// Represents the story context passed to Gemini AI for generating coherent content
class StoryContext {
  /// Campaign name
  final String campaignName;

  /// Campaign description/summary
  final String? campaignDescription;

  /// Current chapter information
  final String? chapterName;
  final String? chapterSummary;

  /// Current adventure information
  final String? adventureName;
  final String? adventureSummary;

  /// Current scene information
  final String? sceneName;
  final String? sceneSummary;

  /// Recent story content (last few scenes/chapters)
  final String? recentContent;

  /// List of key NPCs/entities with their descriptions
  final List<EntityInfo> entities;

  /// World/setting notes
  final String? worldNotes;

  /// Tone/style guidelines
  final String? styleNotes;

  /// Detected language of the campaign content
  final String? language;

  const StoryContext({
    required this.campaignName,
    this.campaignDescription,
    this.chapterName,
    this.chapterSummary,
    this.adventureName,
    this.adventureSummary,
    this.sceneName,
    this.sceneSummary,
    this.recentContent,
    this.entities = const [],
    this.worldNotes,
    this.styleNotes,
    this.language,
  });

  Map<String, dynamic> toJson() => {
    'campaignName': campaignName,
    'campaignDescription': campaignDescription,
    'chapterName': chapterName,
    'chapterSummary': chapterSummary,
    'adventureName': adventureName,
    'adventureSummary': adventureSummary,
    'sceneName': sceneName,
    'sceneSummary': sceneSummary,
    'recentContent': recentContent,
    'entities': entities.map((e) => e.toJson()).toList(),
    'worldNotes': worldNotes,
    'styleNotes': styleNotes,
    'language': language,
  };

  factory StoryContext.fromJson(Map<String, dynamic> json) => StoryContext(
    campaignName: json['campaignName'] as String,
    campaignDescription: json['campaignDescription'] as String?,
    chapterName: json['chapterName'] as String?,
    chapterSummary: json['chapterSummary'] as String?,
    adventureName: json['adventureName'] as String?,
    adventureSummary: json['adventureSummary'] as String?,
    sceneName: json['sceneName'] as String?,
    sceneSummary: json['sceneSummary'] as String?,
    recentContent: json['recentContent'] as String?,
    entities:
        (json['entities'] as List?)
            ?.map((e) => EntityInfo.fromJson(e as Map<String, dynamic>))
            .toList() ??
        const [],
    worldNotes: json['worldNotes'] as String?,
    styleNotes: json['styleNotes'] as String?,
    language: json['language'] as String?,
  );
}

/// Information about an entity (NPC, location, item, etc.)
class EntityInfo {
  final String id;
  final String name;
  final String kind;
  final String? summary;
  final List<String> tags;

  const EntityInfo({
    required this.id,
    required this.name,
    required this.kind,
    this.summary,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'kind': kind,
    'summary': summary,
    'tags': tags,
  };

  factory EntityInfo.fromJson(Map<String, dynamic> json) => EntityInfo(
    id: json['id'] as String,
    name: json['name'] as String,
    kind: json['kind'] as String,
    summary: json['summary'] as String?,
    tags: (json['tags'] as List?)?.cast<String>() ?? const [],
  );
}
