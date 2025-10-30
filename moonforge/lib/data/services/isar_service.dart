import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/models/adventure.dart';
import 'package:moonforge/data/models/campaign.dart';
import 'package:moonforge/data/models/chapter.dart';
import 'package:moonforge/data/models/encounter.dart';
import 'package:moonforge/data/models/entity.dart';
import 'package:moonforge/data/models/media_asset.dart';
import 'package:moonforge/data/models/outbox_operation.dart';
import 'package:moonforge/data/models/party.dart';
import 'package:moonforge/data/models/player.dart';
import 'package:moonforge/data/models/scene.dart';
import 'package:moonforge/data/models/session.dart';

/// Service to manage Isar database instance
class IsarService {
  static Isar? _instance;

  /// Initialize Isar database
  static Future<Isar> init() async {
    if (_instance != null) return _instance!;

    logger.i('Initializing Isar database');

    final dir = await getApplicationDocumentsDirectory();
    
    _instance = await Isar.open(
      [
        CampaignSchema,
        AdventureSchema,
        ChapterSchema,
        SceneSchema,
        EncounterSchema,
        EntitySchema,
        PartySchema,
        PlayerSchema,
        SessionSchema,
        MediaAssetSchema,
        OutboxOperationSchema,
      ],
      directory: dir.path,
      name: 'moonforge',
      inspector: true, // Enable Isar Inspector for debugging
    );

    logger.i('Isar database initialized at ${dir.path}');
    return _instance!;
  }

  /// Get the Isar instance (must be initialized first)
  static Isar get instance {
    if (_instance == null) {
      throw StateError(
        'IsarService not initialized. Call IsarService.init() first.',
      );
    }
    return _instance!;
  }

  /// Check if Isar is initialized
  static bool get isInitialized => _instance != null;

  /// Close the database
  static Future<void> close() async {
    if (_instance != null) {
      logger.i('Closing Isar database');
      await _instance!.close();
      _instance = null;
    }
  }

  /// Clear all data (for testing or reset)
  static Future<void> clearAll() async {
    if (_instance == null) return;
    logger.w('Clearing all Isar data');
    await _instance!.writeTxn(() async {
      await _instance!.clear();
    });
  }
}
