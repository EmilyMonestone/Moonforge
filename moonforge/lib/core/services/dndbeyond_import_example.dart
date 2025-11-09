import 'package:drift/drift.dart';
import 'package:moonforge/core/services/dndbeyond_import_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/player_repository.dart';

/// Example usage of the D&D Beyond character import service
/// This demonstrates how to integrate the import functionality into the app

class DnDBeyondImportExample {
  final AppDb appDb;
  late final PlayerRepository playerRepository;
  late final DnDBeyondImportService importService;

  DnDBeyondImportExample(this.appDb) {
    playerRepository = PlayerRepository(appDb);
    importService = DnDBeyondImportService(playerRepository);
  }

  /// Example: Import a character by URL
  Future<void> importByUrl(String campaignId) async {
    const ddbUrl = 'https://www.dndbeyond.com/characters/152320860';

    final result = await importService.importCharacter(ddbUrl, campaignId);

    if (result.success) {
      logger.i('Character imported successfully!');
      logger.i('Player ID: ${result.playerId}');

      // Fetch the imported player to display details
      final player = await playerRepository.getById(result.playerId!);
      if (player != null) {
        logger.i('Name: ${player.name}');
        logger.i('Class: ${player.className} (Level ${player.level})');
        logger.i('Race: ${player.race}');
        logger.i('D&D Beyond ID: ${player.ddbCharacterId}');
      }
    } else {
      logger.e('Import failed: ${result.errorMessage}');
    }
  }

  /// Example: Import a character by ID
  Future<void> importById(String campaignId) async {
    const ddbId = '152320860';

    final result = await importService.importCharacter(ddbId, campaignId);

    if (result.success) {
      logger.i('Character imported successfully!');
      logger.i('Player ID: ${result.playerId}');
    } else {
      logger.e('Import failed: ${result.errorMessage}');
    }
  }

  /// Example: Update an existing character from D&D Beyond
  Future<void> updateCharacter(String playerId) async {
    logger.i('Updating character from D&D Beyond...');

    final result = await importService.updateCharacter(playerId);

    if (result.success) {
      logger.i('Character updated successfully!');

      // Fetch the updated player
      final player = await playerRepository.getById(playerId);
      if (player != null) {
        logger.i('Last sync: ${player.lastDdbSync}');
        logger.i('Level: ${player.level}');
        logger.i('HP: ${player.hpCurrent}/${player.hpMax}');
      }
    } else {
      logger.e('Update failed: ${result.errorMessage}');
    }
  }

  /// Example: Sync all characters linked to D&D Beyond
  Future<void> syncAllLinkedCharacters(String campaignId) async {
    // Get all players in the campaign
    final players = await playerRepository.customQuery(
      filter: (p) =>
          p.campaignId.equals(campaignId) &
          p.ddbCharacterId.isNotNull() &
          p.deleted.equals(false),
    );

    logger.i('Found ${players.length} characters linked to D&D Beyond');

    for (final player in players) {
      logger.i('Syncing ${player.name}...');
      final result = await importService.updateCharacter(player.id);

      if (result.success) {
        logger.i('✓ Updated successfully');
      } else {
        logger.e('✗ Failed: ${result.errorMessage}');
      }
    }
  }

  /// Example: Handle user input from a text field
  Future<void> importFromUserInput(String userInput, String campaignId) async {
    // The service automatically handles both URLs and IDs
    final result = await importService.importCharacter(userInput, campaignId);

    if (result.success) {
      logger.i('Character imported: ${result.playerId}');
      // Navigate to character details or show success message
    } else {
      logger.e('Import failed: ${result.errorMessage}');
      // Show error message to user
    }
  }

  /// Example: Check if character is already imported
  Future<bool> isCharacterImported(String ddbCharacterId) async {
    final player = await playerRepository.getByDdbCharacterId(ddbCharacterId);
    return player != null;
  }

  /// Example: Get character by D&D Beyond ID
  Future<void> getCharacterByDdbId(String ddbCharacterId) async {
    final player = await playerRepository.getByDdbCharacterId(ddbCharacterId);

    if (player != null) {
      logger.i('Character found:');
      logger.i('Name: ${player.name}');
      logger.i('ID: ${player.id}');
      logger.i('Campaign: ${player.campaignId}');
    } else {
      logger.i('No character found with D&D Beyond ID: $ddbCharacterId');
    }
  }
}

/// Example of integrating into a UI controller or service
class PlayerImportController {
  final DnDBeyondImportService importService;
  final String campaignId;

  PlayerImportController({
    required this.importService,
    required this.campaignId,
  });

  /// Handle import with user feedback
  Future<String?> handleImport(String input) async {
    // Validate input
    final characterId = importService.extractCharacterId(input);
    if (characterId == null) {
      return 'Invalid D&D Beyond character ID or URL. Please provide a valid character ID or URL like:\n'
          '• https://www.dndbeyond.com/characters/152320860\n'
          '• 152320860';
    }

    // Attempt import
    final result = await importService.importCharacter(input, campaignId);

    if (result.success) {
      return null; // Success, no error message
    } else {
      return result.errorMessage;
    }
  }

  /// Handle update with user feedback
  Future<String?> handleUpdate(String playerId) async {
    final result = await importService.updateCharacter(playerId);

    if (result.success) {
      return null; // Success, no error message
    } else {
      return result.errorMessage;
    }
  }
}
