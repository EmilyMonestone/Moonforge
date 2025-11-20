import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_context.freezed.dart';
part 'story_context.g.dart';

/// Represents the story context passed to Gemini AI for generating coherent content
@freezed
class StoryContext with _$StoryContext {
  const factory StoryContext({
    /// Campaign name
    required String campaignName,
    
    /// Campaign description/summary
    String? campaignDescription,
    
    /// Current chapter information
    String? chapterName,
    String? chapterSummary,
    
    /// Current adventure information
    String? adventureName,
    String? adventureSummary,
    
    /// Current scene information
    String? sceneName,
    String? sceneSummary,
    
    /// Recent story content (last few scenes/chapters)
    String? recentContent,
    
    /// List of key NPCs/entities with their descriptions
    @Default([]) List<EntityInfo> entities,
    
    /// World/setting notes
    String? worldNotes,
    
    /// Tone/style guidelines
    String? styleNotes,
  }) = _StoryContext;

  factory StoryContext.fromJson(Map<String, dynamic> json) =>
      _$StoryContextFromJson(json);
}

/// Information about an entity (NPC, location, item, etc.)
@freezed
class EntityInfo with _$EntityInfo {
  const factory EntityInfo({
    required String id,
    required String name,
    required String kind,
    String? summary,
    @Default([]) List<String> tags,
  }) = _EntityInfo;

  factory EntityInfo.fromJson(Map<String, dynamic> json) =>
      _$EntityInfoFromJson(json);
}
