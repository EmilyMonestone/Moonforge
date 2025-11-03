import 'package:drift/drift.dart';
import 'package:moonforge/core/services/dndbeyond_import_service.dart';
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
      print('✓ Character imported successfully!');
      print('  Player ID: ${result.playerId}');

      // Fetch the imported player to display details
      final player = await playerRepository.getById(result.playerId!);
      if (player != null) {
        print('  Name: ${player.name}');
        print('  Class: ${player.className} (Level ${player.level})');
        print('  Race: ${player.race}');
        print('  D&D Beyond ID: ${player.ddbCharacterId}');
      }
    } else {
      print('✗ Import failed: ${result.errorMessage}');
    }
  }

  /// Example: Import a character by ID
  Future<void> importById(String campaignId) async {
    const ddbId = '152320860';

    final result = await importService.importCharacter(ddbId, campaignId);

    if (result.success) {
      print('✓ Character imported successfully!');
      print('  Player ID: ${result.playerId}');
    } else {
      print('✗ Import failed: ${result.errorMessage}');
    }
  }

  /// Example: Update an existing character from D&D Beyond
  Future<void> updateCharacter(String playerId) async {
    print('Updating character from D&D Beyond...');

    final result = await importService.updateCharacter(playerId);

    if (result.success) {
      print('✓ Character updated successfully!');

      // Fetch the updated player
      final player = await playerRepository.getById(playerId);
      if (player != null) {
        print('  Last sync: ${player.lastDdbSync}');
        print('  Level: ${player.level}');
        print('  HP: ${player.hpCurrent}/${player.hpMax}');
      }
    } else {
      print('✗ Update failed: ${result.errorMessage}');
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

    print('Found ${players.length} characters linked to D&D Beyond');

    for (final player in players) {
      print('\nSyncing ${player.name}...');
      final result = await importService.updateCharacter(player.id);

      if (result.success) {
        print('  ✓ Updated successfully');
      } else {
        print('  ✗ Failed: ${result.errorMessage}');
      }
    }
  }

  /// Example: Handle user input from a text field
  Future<void> importFromUserInput(String userInput, String campaignId) async {
    // The service automatically handles both URLs and IDs
    final result = await importService.importCharacter(userInput, campaignId);

    if (result.success) {
      print('Character imported: ${result.playerId}');
      // Navigate to character details or show success message
    } else {
      print('Import failed: ${result.errorMessage}');
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
      print('Character found:');
      print('  Name: ${player.name}');
      print('  ID: ${player.id}');
      print('  Campaign: ${player.campaignId}');
    } else {
      print('No character found with D&D Beyond ID: $ddbCharacterId');
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
