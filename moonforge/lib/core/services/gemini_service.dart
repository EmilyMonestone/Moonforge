import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:moonforge/core/models/ai/generation_request.dart';
import 'package:moonforge/core/models/ai/generation_response.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Service for integrating with Google's Gemini AI
class GeminiService {
  final Gemini _gemini;

  GeminiService(this._gemini);

  /// Continue/complete existing story content
  Future<GenerationResponse> continueStory(CompletionRequest request) async {
    try {
      final prompt = _buildCompletionPrompt(request);
      logger.d('Sending completion request to Gemini');

      final response = await _gemini.text(prompt);
      final content = response?.output ?? '';

      if (content.isEmpty) {
        return GenerationResponse(
          success: false,
          error: 'No content generated',
          generatedAt: DateTime.now(),
        );
      }

      return GenerationResponse(
        success: true,
        content: content.trim(),
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      logger.e('Error continuing story: $e');
      return GenerationResponse(
        success: false,
        error: e.toString(),
        generatedAt: DateTime.now(),
      );
    }
  }

  /// Generate a full section (chapter, adventure, or scene)
  Future<GenerationResponse> generateSection(
    SectionGenerationRequest request,
  ) async {
    try {
      final prompt = _buildSectionPrompt(request);
      logger.d('Sending section generation request to Gemini');

      final response = await _gemini.text(prompt);
      final content = response?.output ?? '';

      if (content.isEmpty) {
        return GenerationResponse(
          success: false,
          error: 'No content generated',
          generatedAt: DateTime.now(),
        );
      }

      return GenerationResponse(
        success: true,
        content: content.trim(),
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      logger.e('Error generating section: $e');
      return GenerationResponse(
        success: false,
        error: e.toString(),
        generatedAt: DateTime.now(),
      );
    }
  }

  /// Generate an NPC with structured information
  Future<NpcGenerationResponse> generateNpc(
    NpcGenerationRequest request,
  ) async {
    try {
      final prompt = _buildNpcPrompt(request);
      logger.d('Sending NPC generation request to Gemini');

      final response = await _gemini.text(prompt);
      final content = response?.output ?? '';

      if (content.isEmpty) {
        return NpcGenerationResponse(
          success: false,
          error: 'No content generated',
          generatedAt: DateTime.now(),
        );
      }

      // Parse the structured NPC response
      final npcData = _parseNpcResponse(content);

      return NpcGenerationResponse(
        success: true,
        name: npcData['name'],
        appearance: npcData['appearance'],
        personality: npcData['personality'],
        backstory: npcData['backstory'],
        role: npcData['role'],
        motivations: npcData['motivations'],
        secrets: npcData['secrets'],
        statblock: npcData['statblock'] ?? {},
        generatedAt: DateTime.now(),
      );
    } catch (e) {
      logger.e('Error generating NPC: $e');
      return NpcGenerationResponse(
        success: false,
        error: e.toString(),
        generatedAt: DateTime.now(),
      );
    }
  }

  /// Build prompt for story completion
  String _buildCompletionPrompt(CompletionRequest request) {
    final context = request.context;
    final buffer = StringBuffer();

    buffer.writeln('You are a creative dungeon master and storyteller.');
    buffer.writeln();
    buffer.writeln('Campaign: ${context.campaignName}');

    if (context.campaignDescription != null) {
      buffer.writeln('Campaign Description: ${context.campaignDescription}');
    }

    if (context.chapterName != null) {
      buffer.writeln('Chapter: ${context.chapterName}');
      if (context.chapterSummary != null) {
        buffer.writeln('Chapter Summary: ${context.chapterSummary}');
      }
    }

    if (context.adventureName != null) {
      buffer.writeln('Adventure: ${context.adventureName}');
      if (context.adventureSummary != null) {
        buffer.writeln('Adventure Summary: ${context.adventureSummary}');
      }
    }

    if (context.sceneName != null) {
      buffer.writeln('Scene: ${context.sceneName}');
      if (context.sceneSummary != null) {
        buffer.writeln('Scene Summary: ${context.sceneSummary}');
      }
    }

    if (context.entities.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Key Characters/Entities:');
      for (final entity in context.entities) {
        buffer.writeln('- ${entity.name} (${entity.kind})');
        if (entity.summary != null) {
          buffer.writeln('  ${entity.summary}');
        }
      }
    }

    if (context.worldNotes != null) {
      buffer.writeln();
      buffer.writeln('World/Setting Notes: ${context.worldNotes}');
    }

    if (context.styleNotes != null) {
      buffer.writeln();
      buffer.writeln('Style Guidelines: ${context.styleNotes}');
    }

    if (context.recentContent != null) {
      buffer.writeln();
      buffer.writeln('Recent Story Content:');
      buffer.writeln(context.recentContent);
    }

    buffer.writeln();
    buffer.writeln('Current Content:');
    buffer.writeln(request.currentContent);
    buffer.writeln();

    if (request.desiredDirection != null) {
      buffer.writeln('Desired Direction: ${request.desiredDirection}');
      buffer.writeln();
    }

    buffer.writeln(
      'Continue the story from where it left off. Maintain consistency with the established characters, setting, and tone. Write in an engaging, descriptive style suitable for a tabletop RPG campaign.',
    );

    // Add language instruction
    if (context.language != null && context.language != 'English') {
      buffer.writeln();
      buffer.writeln(
        'IMPORTANT: Write your response in ${context.language}. The campaign is written in ${context.language}, so maintain the same language throughout.',
      );
    }

    return buffer.toString();
  }

  /// Build prompt for section generation
  String _buildSectionPrompt(SectionGenerationRequest request) {
    final context = request.context;
    final buffer = StringBuffer();

    buffer.writeln('You are a creative dungeon master and storyteller.');
    buffer.writeln();
    buffer.writeln('Campaign: ${context.campaignName}');

    if (context.campaignDescription != null) {
      buffer.writeln('Campaign Description: ${context.campaignDescription}');
    }

    if (context.chapterName != null) {
      buffer.writeln('Current Chapter: ${context.chapterName}');
    }

    if (context.adventureName != null) {
      buffer.writeln('Current Adventure: ${context.adventureName}');
    }

    if (context.entities.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Key Characters/Entities:');
      for (final entity in context.entities) {
        buffer.writeln('- ${entity.name} (${entity.kind})');
        if (entity.summary != null) {
          buffer.writeln('  ${entity.summary}');
        }
      }
    }

    if (context.worldNotes != null) {
      buffer.writeln();
      buffer.writeln('World/Setting Notes: ${context.worldNotes}');
    }

    if (context.styleNotes != null) {
      buffer.writeln();
      buffer.writeln('Style Guidelines: ${context.styleNotes}');
    }

    if (request.previousSectionSummary != null) {
      buffer.writeln();
      buffer.writeln('Previous Section Summary:');
      buffer.writeln(request.previousSectionSummary);
    }

    buffer.writeln();
    buffer.writeln(
      'Generate a new ${request.sectionType} titled: ${request.title}',
    );

    if (request.outline != null) {
      buffer.writeln();
      buffer.writeln('Outline/Goals for this ${request.sectionType}:');
      buffer.writeln(request.outline);
    }

    if (request.keyElements.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Key elements to include:');
      for (final element in request.keyElements) {
        buffer.writeln('- $element');
      }
    }

    buffer.writeln();
    buffer.writeln(
      'Write a complete ${request.sectionType} that fits naturally into the campaign. Maintain consistency with established lore, characters, and tone. Include vivid descriptions, engaging dialogue, and clear plot progression. Write in a style suitable for a tabletop RPG campaign.',
    );
    buffer.writeln();
    buffer.writeln(
      'Format your response in Markdown. Use headers (##, ###), bold, italic, lists, blockquotes, and other Markdown formatting as appropriate for better readability.',
    );

    // Add language instruction
    if (context.language != null && context.language != 'English') {
      buffer.writeln();
      buffer.writeln(
        'IMPORTANT: Write your response in ${context.language}. The campaign is written in ${context.language}, so maintain the same language throughout.',
      );
    }

    return buffer.toString();
  }

  /// Build prompt for NPC generation
  String _buildNpcPrompt(NpcGenerationRequest request) {
    final context = request.context;
    final buffer = StringBuffer();

    buffer.writeln(
      'You are a creative dungeon master creating NPCs for a D&D campaign.',
    );
    buffer.writeln();
    buffer.writeln('Campaign: ${context.campaignName}');

    if (context.campaignDescription != null) {
      buffer.writeln('Campaign Description: ${context.campaignDescription}');
    }

    if (context.worldNotes != null) {
      buffer.writeln();
      buffer.writeln('World/Setting: ${context.worldNotes}');
    }

    if (context.entities.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('Existing Characters:');
      for (final entity in context.entities) {
        buffer.writeln('- ${entity.name} (${entity.kind})');
      }
    }

    buffer.writeln();
    buffer.writeln('Create a new NPC with the following constraints:');

    if (request.role != null) {
      buffer.writeln('Role: ${request.role}');
    }

    if (request.species != null) {
      buffer.writeln('Species/Race: ${request.species}');
    }

    if (request.alignment != null) {
      buffer.writeln('Alignment: ${request.alignment}');
    }

    if (request.relationshipToParty != null) {
      buffer.writeln('Relationship to Party: ${request.relationshipToParty}');
    }

    if (request.traits.isNotEmpty) {
      buffer.writeln('Desired Traits: ${request.traits.join(", ")}');
    }

    if (request.backstory != null) {
      buffer.writeln('Backstory Direction: ${request.backstory}');
    }

    buffer.writeln();
    buffer.writeln(
      'IMPORTANT: Return ONLY a valid JSON object with no additional text, markdown, or code blocks.',
    );
    buffer.writeln('Use this exact structure:');
    buffer.writeln('{');
    buffer.writeln('  "name": "Character name",');
    buffer.writeln('  "appearance": "Physical description",');
    buffer.writeln('  "personality": "Character traits and demeanor",');
    buffer.writeln('  "backstory": "Brief history and background",');
    buffer.writeln('  "role": "Their role in the story/world",');
    buffer.writeln('  "motivations": "What drives them",');
    buffer.writeln('  "secrets": "Hidden information or plot hooks"');
    buffer.writeln('}');
    buffer.writeln();
    buffer.writeln(
      'Make the NPC memorable, fit naturally into the campaign setting, and provide interesting roleplay opportunities.',
    );

    // Add language instruction
    if (context.language != null && context.language != 'English') {
      buffer.writeln();
      buffer.writeln(
        'IMPORTANT: Write all text fields in ${context.language}. The campaign is written in ${context.language}, so the NPC information must be in the same language.',
      );
    }

    return buffer.toString();
  }

  /// Parse structured NPC response from Gemini (now expects JSON)
  Map<String, dynamic> _parseNpcResponse(String content) {
    try {
      // Remove any markdown code blocks if present
      var jsonStr = content.trim();
      if (jsonStr.startsWith('```json')) {
        jsonStr = jsonStr.substring(7);
      } else if (jsonStr.startsWith('```')) {
        jsonStr = jsonStr.substring(3);
      }
      if (jsonStr.endsWith('```')) {
        jsonStr = jsonStr.substring(0, jsonStr.length - 3);
      }
      jsonStr = jsonStr.trim();

      // Parse JSON
      final decoded = jsonDecode(jsonStr);

      // Ensure it's a Map
      if (decoded is Map<String, dynamic>) {
        return decoded;
      } else if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      } else {
        throw FormatException(
          'Expected JSON object, got ${decoded.runtimeType}',
        );
      }
    } catch (e) {
      logger.e('Failed to parse NPC JSON response: $e');
      logger.d('Content was: $content');

      // Fallback to regex parsing
      final result = <String, dynamic>{};

      final nameMatch = RegExp(
        r'NAME:\s*(.+?)(?=\n|$)',
        caseSensitive: false,
      ).firstMatch(content);
      if (nameMatch != null) {
        result['name'] = nameMatch.group(1)?.trim();
      }

      final appearanceMatch = RegExp(
        r'APPEARANCE:\s*(.+?)(?=\n(?:NAME|PERSONALITY|BACKSTORY|ROLE|MOTIVATIONS|SECRETS):|$)',
        caseSensitive: false,
        dotAll: true,
      ).firstMatch(content);
      if (appearanceMatch != null) {
        result['appearance'] = appearanceMatch.group(1)?.trim();
      }

      final personalityMatch = RegExp(
        r'PERSONALITY:\s*(.+?)(?=\n(?:NAME|APPEARANCE|BACKSTORY|ROLE|MOTIVATIONS|SECRETS):|$)',
        caseSensitive: false,
        dotAll: true,
      ).firstMatch(content);
      if (personalityMatch != null) {
        result['personality'] = personalityMatch.group(1)?.trim();
      }

      final backstoryMatch = RegExp(
        r'BACKSTORY:\s*(.+?)(?=\n(?:NAME|APPEARANCE|PERSONALITY|ROLE|MOTIVATIONS|SECRETS):|$)',
        caseSensitive: false,
        dotAll: true,
      ).firstMatch(content);
      if (backstoryMatch != null) {
        result['backstory'] = backstoryMatch.group(1)?.trim();
      }

      final roleMatch = RegExp(
        r'ROLE:\s*(.+?)(?=\n(?:NAME|APPEARANCE|PERSONALITY|BACKSTORY|MOTIVATIONS|SECRETS):|$)',
        caseSensitive: false,
        dotAll: true,
      ).firstMatch(content);
      if (roleMatch != null) {
        result['role'] = roleMatch.group(1)?.trim();
      }

      final motivationsMatch = RegExp(
        r'MOTIVATIONS:\s*(.+?)(?=\n(?:NAME|APPEARANCE|PERSONALITY|BACKSTORY|ROLE|SECRETS):|$)',
        caseSensitive: false,
        dotAll: true,
      ).firstMatch(content);
      if (motivationsMatch != null) {
        result['motivations'] = motivationsMatch.group(1)?.trim();
      }

      final secretsMatch = RegExp(
        r'SECRETS:\s*(.+?)(?=\n(?:NAME|APPEARANCE|PERSONALITY|BACKSTORY|ROLE|MOTIVATIONS):|$)',
        caseSensitive: false,
        dotAll: true,
      ).firstMatch(content);
      if (secretsMatch != null) {
        result['secrets'] = secretsMatch.group(1)?.trim();
      }

      return result;
    }
  }
}
