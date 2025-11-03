import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/player_repository.dart';
import 'package:uuid/uuid.dart';

/// Result of a D&D Beyond character import operation
class DnDBeyondImportResult {
  final bool success;
  final String? playerId;
  final String? errorMessage;

  DnDBeyondImportResult({
    required this.success,
    this.playerId,
    this.errorMessage,
  });

  factory DnDBeyondImportResult.success(String playerId) {
    return DnDBeyondImportResult(success: true, playerId: playerId);
  }

  factory DnDBeyondImportResult.error(String message) {
    return DnDBeyondImportResult(success: false, errorMessage: message);
  }
}

/// Service for importing D&D Beyond characters into the local database
class DnDBeyondImportService {
  static const String _apiBaseUrl =
      'https://character-service.dndbeyond.com/character/v5/character';
  static final _uuid = Uuid();

  final PlayerRepository _playerRepository;
  final http.Client? _httpClient;

  DnDBeyondImportService(
    this._playerRepository, {
    http.Client? httpClient,
  })  : _httpClient = httpClient;

  /// Extract character ID from a D&D Beyond URL or ID string
  /// Supports formats:
  /// - "152320860" (just the ID)
  /// - "https://www.dndbeyond.com/characters/152320860"
  /// - "https://www.dndbeyond.com/characters/152320860/builder"
  String? extractCharacterId(String input) {
    if (input.isEmpty) return null;

    // Remove whitespace
    final trimmed = input.trim();

    // Check if it's just a numeric ID
    final numericRegex = RegExp(r'^\d+$');
    if (numericRegex.hasMatch(trimmed)) {
      return trimmed;
    }

    // Try to extract from URL
    final urlRegex = RegExp(r'dndbeyond\.com/characters/(\d+)');
    final match = urlRegex.firstMatch(trimmed);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }

    return null;
  }

  /// Fetch character data from D&D Beyond API
  Future<Map<String, dynamic>?> fetchCharacterData(String characterId) async {
    http.Client? clientToClose;
    try {
      final client = _httpClient ?? (clientToClose = http.Client());
      final url = Uri.parse('$_apiBaseUrl/$characterId');
      logger.d('Fetching D&D Beyond character data from: $url');

      final response = await client.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        logger.i('Successfully fetched D&D Beyond character data');
        return data;
      } else if (response.statusCode == 404) {
        logger.w('D&D Beyond character not found: $characterId');
        return null;
      } else if (response.statusCode == 403) {
        logger.w('D&D Beyond character is private: $characterId');
        return null;
      } else {
        logger.e(
          'Failed to fetch D&D Beyond character: HTTP ${response.statusCode}',
        );
        return null;
      }
    } catch (e, stackTrace) {
      logger.e(
        'Error fetching D&D Beyond character data',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    } finally {
      clientToClose?.close();
    }
  }

  /// Map ability score ID to the stat value from D&D Beyond data
  /// ID mapping: 1=STR, 2=DEX, 3=CON, 4=INT, 5=WIS, 6=CHA
  int getAbilityScoreById(Map<String, dynamic> characterData, int statId) {
    try {
      // Try to find stats in the response
      final data = characterData['data'] as Map<String, dynamic>? ??
          characterData;
      final stats = data['stats'] as List<dynamic>?;
      if (stats == null) return 10; // Default ability score

      // Build a map for efficient lookups
      final statMap = <int, int>{};
      for (final stat in stats) {
        final s = stat as Map<String, dynamic>;
        final id = s['id'] as int?;
        final value = s['value'] as int?;
        if (id != null && value != null) {
          statMap[id] = value;
        }
      }
      
      return statMap[statId] ?? 10;
    } catch (e) {
      logger.w('Error extracting ability score for stat ID $statId: $e');
      return 10;
    }
  }

  /// Transform D&D Beyond character data to local Player model
  Player transformToPlayer(
    Map<String, dynamic> characterData,
    String campaignId,
    String ddbCharacterId,
  ) {
    final data = characterData['data'] as Map<String, dynamic>? ??
        characterData; // Handle both wrapped and unwrapped formats

    // Extract basic info
    final name = data['name'] as String? ?? 'Unknown Character';
    final level =
        data['classes']?[0]?['level'] as int? ?? 1; // First class level
    final race = data['race']?['fullName'] as String? ??
        data['race']?['baseRaceName'] as String?;
    final className = data['classes']?[0]?['definition']?['name'] as String? ??
        data['classes']?[0]?['name'] as String?;
    final subclass = data['classes']?[0]?['subclassDefinition']?['name']
            as String? ??
        data['classes']?[0]?['subclass']?['name'] as String?;
    final background = data['background']?['definition']?['name'] as String? ??
        data['background']?['name'] as String?;

    // Extract ability scores using the mapping
    final str = getAbilityScoreById(characterData, 1);
    final dex = getAbilityScoreById(characterData, 2);
    final con = getAbilityScoreById(characterData, 3);
    final intl = getAbilityScoreById(characterData, 4);
    final wis = getAbilityScoreById(characterData, 5);
    final cha = getAbilityScoreById(characterData, 6);

    // Extract combat stats
    final hpMax = data['baseHitPoints'] as int? ?? 0;
    final hpCurrent = data['currentHitPoints'] as int? ?? hpMax;
    final ac = data['armorClass'] as int?;
    final speed = data['speed'] as int? ??
        (data['race']?['weightSpeeds']?['normal']?['walk'] as int?);

    // Proficiency bonus calculation (standard D&D 5e formula)
    final proficiencyBonus = ((level - 1) ~/ 4) + 2;

    // Extract proficiencies
    final List<String> savingThrowProfs = [];
    final List<String> skillProfs = [];
    final List<String> languages = [];

    // Extract alignment
    final alignmentId = data['alignmentId'] as int?;
    String? alignment;
    if (alignmentId != null) {
      alignment = _getAlignmentName(alignmentId);
    }

    // Create player model
    return Player(
      id: _uuid.v4(),
      campaignId: campaignId,
      playerUid: null,
      name: name,
      className: className ?? 'Unknown',
      subclass: subclass,
      level: level,
      race: race,
      background: background,
      alignment: alignment,
      str: str,
      dex: dex,
      con: con,
      intl: intl,
      wis: wis,
      cha: cha,
      hpMax: hpMax,
      hpCurrent: hpCurrent,
      hpTemp: null,
      ac: ac,
      proficiencyBonus: proficiencyBonus,
      speed: speed,
      savingThrowProficiencies: savingThrowProfs.isEmpty ? null : savingThrowProfs,
      skillProficiencies: skillProfs.isEmpty ? null : skillProfs,
      languages: languages.isEmpty ? null : languages,
      equipment: null,
      features: null,
      spells: null,
      notes: null,
      bio: null,
      ddbCharacterId: ddbCharacterId,
      lastDdbSync: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rev: 1,
      deleted: false,
    );
  }

  /// Convert D&D Beyond alignment ID to alignment name
  String _getAlignmentName(int alignmentId) {
    switch (alignmentId) {
      case 1:
        return 'Lawful Good';
      case 2:
        return 'Neutral Good';
      case 3:
        return 'Chaotic Good';
      case 4:
        return 'Lawful Neutral';
      case 5:
        return 'True Neutral';
      case 6:
        return 'Chaotic Neutral';
      case 7:
        return 'Lawful Evil';
      case 8:
        return 'Neutral Evil';
      case 9:
        return 'Chaotic Evil';
      default:
        return 'Unaligned';
    }
  }

  /// Import a character from D&D Beyond by ID or URL
  /// Returns the imported player's ID on success, or null on failure
  Future<DnDBeyondImportResult> importCharacter(
    String input,
    String campaignId,
  ) async {
    try {
      // Extract character ID from input
      final characterId = extractCharacterId(input);
      if (characterId == null) {
        return DnDBeyondImportResult.error(
          'Invalid D&D Beyond character ID or URL',
        );
      }

      // Check if character already exists
      final existingPlayer =
          await _playerRepository.getByDdbCharacterId(characterId);
      if (existingPlayer != null) {
        return DnDBeyondImportResult.error(
          'Character already imported. Use update instead.',
        );
      }

      // Fetch character data
      final characterData = await fetchCharacterData(characterId);
      if (characterData == null) {
        return DnDBeyondImportResult.error(
          'Failed to fetch character data. Character may be private or not found.',
        );
      }

      // Transform and save
      final player = transformToPlayer(characterData, campaignId, characterId);
      await _playerRepository.create(player);

      logger.i('Successfully imported D&D Beyond character: ${player.name}');
      return DnDBeyondImportResult.success(player.id);
    } catch (e, stackTrace) {
      logger.e(
        'Error importing D&D Beyond character',
        error: e,
        stackTrace: stackTrace,
      );
      return DnDBeyondImportResult.error(
        'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Update an existing player from D&D Beyond using their stored ddbCharacterId
  Future<DnDBeyondImportResult> updateCharacter(String playerId) async {
    try {
      // Get existing player
      final existingPlayer = await _playerRepository.getById(playerId);
      if (existingPlayer == null) {
        return DnDBeyondImportResult.error('Player not found');
      }

      final ddbCharacterId = existingPlayer.ddbCharacterId;
      if (ddbCharacterId == null) {
        return DnDBeyondImportResult.error(
          'Player is not linked to a D&D Beyond character',
        );
      }

      // Fetch updated character data
      final characterData = await fetchCharacterData(ddbCharacterId);
      if (characterData == null) {
        return DnDBeyondImportResult.error(
          'Failed to fetch character data. Character may be private or not found.',
        );
      }

      // Transform and update (keep the same ID and campaign)
      final updatedPlayer = transformToPlayer(
        characterData,
        existingPlayer.campaignId,
        ddbCharacterId,
      );

      // Preserve the original player ID and some local-only fields
      final playerToUpdate = Player(
        id: existingPlayer.id, // Keep original ID
        campaignId: existingPlayer.campaignId,
        playerUid: existingPlayer.playerUid, // Preserve Firebase UID
        name: updatedPlayer.name,
        className: updatedPlayer.className,
        subclass: updatedPlayer.subclass,
        level: updatedPlayer.level,
        race: updatedPlayer.race,
        background: updatedPlayer.background,
        alignment: updatedPlayer.alignment,
        str: updatedPlayer.str,
        dex: updatedPlayer.dex,
        con: updatedPlayer.con,
        intl: updatedPlayer.intl,
        wis: updatedPlayer.wis,
        cha: updatedPlayer.cha,
        hpMax: updatedPlayer.hpMax,
        hpCurrent: updatedPlayer.hpCurrent,
        hpTemp: existingPlayer.hpTemp, // Keep local temp HP
        ac: updatedPlayer.ac,
        proficiencyBonus: updatedPlayer.proficiencyBonus,
        speed: updatedPlayer.speed,
        savingThrowProficiencies: updatedPlayer.savingThrowProficiencies,
        skillProficiencies: updatedPlayer.skillProficiencies,
        languages: updatedPlayer.languages,
        equipment: updatedPlayer.equipment,
        features: updatedPlayer.features,
        spells: updatedPlayer.spells,
        notes: existingPlayer.notes, // Preserve local notes
        bio: existingPlayer.bio, // Preserve local bio
        ddbCharacterId: ddbCharacterId,
        lastDdbSync: DateTime.now(),
        createdAt: existingPlayer.createdAt,
        updatedAt: DateTime.now(),
        rev: existingPlayer.rev,
        deleted: existingPlayer.deleted,
      );

      await _playerRepository.update(playerToUpdate);

      logger.i('Successfully updated D&D Beyond character: ${playerToUpdate.name}');
      return DnDBeyondImportResult.success(playerToUpdate.id);
    } catch (e, stackTrace) {
      logger.e(
        'Error updating D&D Beyond character',
        error: e,
        stackTrace: stackTrace,
      );
      return DnDBeyondImportResult.error(
        'Unexpected error: ${e.toString()}',
      );
    }
  }
}
