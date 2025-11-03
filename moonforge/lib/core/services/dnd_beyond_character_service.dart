import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/entity_repository.dart';

/// Service for importing D&D Beyond characters
class DndBeyondCharacterService {
  static const String _baseUrl = 'https://character-service.dndbeyond.com/character/v5/character';
  
  final EntityRepository _entityRepository;
  
  DndBeyondCharacterService(this._entityRepository);
  
  /// Ability score ID to name mapping
  static const Map<int, String> _abilityScoreMap = {
    1: 'strength',
    2: 'dexterity',
    3: 'constitution',
    4: 'intelligence',
    5: 'wisdom',
    6: 'charisma',
  };
  
  /// Extract character ID from input (URL or numeric ID)
  /// Returns null if input is invalid
  String? extractCharacterId(String input) {
    final trimmed = input.trim();
    
    // Check if it's a numeric ID
    if (RegExp(r'^\d+$').hasMatch(trimmed)) {
      return trimmed;
    }
    
    // Try to extract from URL
    final urlPattern = RegExp(r'characters/(\d+)');
    final match = urlPattern.firstMatch(trimmed);
    if (match != null) {
      return match.group(1);
    }
    
    return null;
  }
  
  /// Fetch character data from D&D Beyond API
  Future<Map<String, dynamic>?> fetchCharacterData(String characterId) async {
    try {
      final url = Uri.parse('$_baseUrl/$characterId');
      logger.d('Fetching D&D Beyond character: $characterId');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        logger.i('Successfully fetched D&D Beyond character: $characterId');
        return data;
      } else if (response.statusCode == 404) {
        logger.w('D&D Beyond character not found: $characterId');
        return null;
      } else {
        logger.e('Failed to fetch D&D Beyond character: HTTP ${response.statusCode}');
        return null;
      }
    } catch (e) {
      logger.e('Error fetching D&D Beyond character: $e');
      return null;
    }
  }
  
  /// Transform D&D Beyond character data to Entity statblock
  Map<String, dynamic> transformToStatblock(Map<String, dynamic> dndData) {
    final statblock = <String, dynamic>{};
    
    try {
      // Extract basic stats
      final data = dndData['data'] as Map<String, dynamic>?;
      if (data == null) return statblock;
      
      // Ability scores
      final stats = data['stats'] as List<dynamic>?;
      if (stats != null) {
        final abilities = <String, dynamic>{};
        for (final stat in stats) {
          if (stat is Map<String, dynamic>) {
            final id = stat['id'] as int?;
            final value = stat['value'] as int?;
            if (id != null && value != null && _abilityScoreMap.containsKey(id)) {
              final abilityName = _abilityScoreMap[id]!;
              abilities[abilityName] = value;
              
              // Also store modifier
              final modifier = ((value - 10) / 2).floor();
              abilities['${abilityName}_modifier'] = modifier;
            }
          }
        }
        statblock['abilities'] = abilities;
      }
      
      // Hit points
      final baseHitPoints = data['baseHitPoints'] as int?;
      final bonusHitPoints = data['bonusHitPoints'] as int?;
      final overrideHitPoints = data['overrideHitPoints'] as int?;
      final removedHitPoints = data['removedHitPoints'] as int? ?? 0;
      final temporaryHitPoints = data['temporaryHitPoints'] as int? ?? 0;
      
      if (overrideHitPoints != null) {
        statblock['hp'] = overrideHitPoints;
        statblock['hp_max'] = overrideHitPoints;
      } else if (baseHitPoints != null) {
        final maxHp = baseHitPoints + (bonusHitPoints ?? 0);
        statblock['hp_max'] = maxHp;
        statblock['hp'] = maxHp - removedHitPoints;
      }
      
      if (temporaryHitPoints > 0) {
        statblock['temp_hp'] = temporaryHitPoints;
      }
      
      // Armor class
      final armorClass = data['armorClass'] as int?;
      if (armorClass != null) {
        statblock['ac'] = armorClass;
      }
      
      // Speed
      final bonusSpeed = data['bonusSpeed'] as int? ?? 0;
      final race = data['race'] as Map<String, dynamic>?;
      if (race != null) {
        final baseSpeed = race['weightSpeeds']?['normal']?['walk'] as int? ?? 30;
        statblock['speed'] = baseSpeed + bonusSpeed;
      }
      
      // Proficiency bonus
      final proficiencyBonus = data['proficiencyBonus'] as int?;
      if (proficiencyBonus != null) {
        statblock['proficiency_bonus'] = proficiencyBonus;
      }
      
      // Initiative bonus
      final initiativeBonus = data['initiativeBonus'] as int?;
      if (initiativeBonus != null) {
        statblock['initiative_bonus'] = initiativeBonus;
      }
      
      // Classes (for multiclass info)
      final classes = data['classes'] as List<dynamic>?;
      if (classes != null && classes.isNotEmpty) {
        final classInfo = <Map<String, dynamic>>[];
        for (final cls in classes) {
          if (cls is Map<String, dynamic>) {
            final definition = cls['definition'] as Map<String, dynamic>?;
            if (definition != null) {
              classInfo.add({
                'name': definition['name'] ?? '',
                'level': cls['level'] ?? 1,
              });
            }
          }
        }
        if (classInfo.isNotEmpty) {
          statblock['classes'] = classInfo;
        }
      }
      
      // Race
      if (race != null) {
        final raceName = race['fullName'] ?? race['baseName'] ?? '';
        if (raceName.isNotEmpty) {
          statblock['race'] = raceName;
        }
      }
      
    } catch (e) {
      logger.e('Error transforming D&D Beyond data to statblock: $e');
    }
    
    return statblock;
  }
  
  /// Import a character from D&D Beyond
  /// Returns the created/updated entity ID on success, null on failure
  Future<String?> importCharacter({
    required String input,
    required String campaignId,
  }) async {
    // Extract character ID
    final characterId = extractCharacterId(input);
    if (characterId == null) {
      logger.w('Invalid D&D Beyond character ID or URL: $input');
      return null;
    }
    
    // Check if character already exists
    final existingEntity = await _findExistingEntity(characterId);
    
    // Fetch character data
    final dndData = await fetchCharacterData(characterId);
    if (dndData == null) {
      return null;
    }
    
    // Extract character info
    final data = dndData['data'] as Map<String, dynamic>?;
    if (data == null) {
      logger.e('Invalid D&D Beyond character data structure');
      return null;
    }
    
    final characterName = data['name'] as String? ?? 'Unknown Character';
    final statblock = transformToStatblock(dndData);
    
    // Determine character kind based on available data
    final kind = _determineEntityKind(data);
    
    if (existingEntity != null) {
      // Update existing entity
      final updatedEntity = existingEntity.copyWith(
        name: characterName,
        statblock: statblock,
        updatedAt: DateTime.now(),
      );
      await _entityRepository.update(updatedEntity);
      logger.i('Updated existing D&D Beyond character: $characterId');
      return existingEntity.id;
    } else {
      // Create new entity
      final entityId = 'entity-$campaignId-${DateTime.now().millisecondsSinceEpoch}';
      final entity = Entity(
        id: entityId,
        kind: kind,
        name: characterName,
        originId: campaignId,
        summary: _generateSummary(data),
        tags: const <String>[],
        statblock: statblock,
        placeType: null,
        parentPlaceId: null,
        coords: const <String, dynamic>{},
        content: null,
        images: const <Map<String, dynamic>>[],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 0,
        deleted: false,
        members: const <String>[],
        dndBeyondCharacterId: characterId,
      );
      
      await _entityRepository.create(entity);
      logger.i('Created new D&D Beyond character: $characterId');
      return entityId;
    }
  }
  
  /// Update an existing character by re-fetching from D&D Beyond
  Future<bool> updateCharacter(String entityId) async {
    final entity = await _entityRepository.getById(entityId);
    if (entity == null) {
      logger.w('Entity not found: $entityId');
      return false;
    }
    
    final characterId = entity.dndBeyondCharacterId;
    if (characterId == null || characterId.isEmpty) {
      logger.w('Entity does not have a D&D Beyond character ID: $entityId');
      return false;
    }
    
    // Fetch fresh data
    final dndData = await fetchCharacterData(characterId);
    if (dndData == null) {
      return false;
    }
    
    final data = dndData['data'] as Map<String, dynamic>?;
    if (data == null) {
      logger.e('Invalid D&D Beyond character data structure');
      return false;
    }
    
    final characterName = data['name'] as String? ?? entity.name;
    final statblock = transformToStatblock(dndData);
    
    // Update entity
    final updatedEntity = entity.copyWith(
      name: characterName,
      statblock: statblock,
      summary: _generateSummary(data),
      updatedAt: DateTime.now(),
    );
    
    await _entityRepository.update(updatedEntity);
    logger.i('Updated D&D Beyond character from remote: $characterId');
    return true;
  }
  
  /// Find existing entity by D&D Beyond character ID
  Future<Entity?> _findExistingEntity(String characterId) async {
    final allEntities = await _entityRepository.getAll();
    for (final entity in allEntities) {
      if (entity.dndBeyondCharacterId == characterId) {
        return entity;
      }
    }
    return null;
  }
  
  /// Determine entity kind from D&D Beyond data
  String _determineEntityKind(Map<String, dynamic> data) {
    // Check if it's a player character or NPC
    // Most D&D Beyond characters are player characters, so default to 'npc'
    // Could be enhanced with more logic based on character type
    return 'npc';
  }
  
  /// Generate a summary from character data
  String _generateSummary(Map<String, dynamic> data) {
    final parts = <String>[];
    
    // Level and class
    final classes = data['classes'] as List<dynamic>?;
    if (classes != null && classes.isNotEmpty) {
      final classStrings = <String>[];
      for (final cls in classes) {
        if (cls is Map<String, dynamic>) {
          final definition = cls['definition'] as Map<String, dynamic>?;
          final level = cls['level'] ?? 1;
          if (definition != null) {
            final name = definition['name'] ?? '';
            if (name.isNotEmpty) {
              classStrings.add('Level $level $name');
            }
          }
        }
      }
      if (classStrings.isNotEmpty) {
        parts.add(classStrings.join(', '));
      }
    }
    
    // Race
    final race = data['race'] as Map<String, dynamic>?;
    if (race != null) {
      final raceName = race['fullName'] ?? race['baseName'] ?? '';
      if (raceName.isNotEmpty) {
        parts.add(raceName);
      }
    }
    
    return parts.join(' • ');
  }
}
