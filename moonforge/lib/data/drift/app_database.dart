import 'package:drift/drift.dart';
import 'package:moonforge/data/drift/connect/connect.dart' as impl;
import 'package:moonforge/data/drift/converters/json_list_converter.dart';
import 'package:moonforge/data/drift/converters/non_null_json_map_converter.dart';
import 'package:moonforge/data/drift/converters/non_null_string_list_converter.dart';
import 'package:moonforge/data/drift/converters/string_list_converter.dart';
import 'package:moonforge/data/drift/dao/adventures_dao.dart';
import 'package:moonforge/data/drift/dao/campaigns_dao.dart';
import 'package:moonforge/data/drift/dao/chapters_dao.dart';
import 'package:moonforge/data/drift/dao/encounters_dao.dart';
import 'package:moonforge/data/drift/dao/entities_dao.dart';
import 'package:moonforge/data/drift/dao/media_assets_dao.dart';
import 'package:moonforge/data/drift/dao/outbox_dao.dart';
import 'package:moonforge/data/drift/dao/parties_dao.dart';
import 'package:moonforge/data/drift/dao/players_dao.dart';
import 'package:moonforge/data/drift/dao/scenes_dao.dart';
import 'package:moonforge/data/drift/dao/sessions_dao.dart';
import 'package:moonforge/data/drift/dao/storage_queue_dao.dart';
import 'package:moonforge/data/drift/tables/adventures.dart';

// Keep old table for backward compatibility
import 'package:moonforge/data/drift/tables/campaign_local_metas.dart';
import 'package:moonforge/data/drift/tables/campaigns.dart';
import 'package:moonforge/data/drift/tables/chapters.dart';
import 'package:moonforge/data/drift/tables/encounters.dart';
import 'package:moonforge/data/drift/tables/entities.dart';
import 'package:moonforge/data/drift/tables/local_metas.dart';
import 'package:moonforge/data/drift/tables/media_assets.dart';
import 'package:moonforge/data/drift/tables/outbox_ops.dart';
import 'package:moonforge/data/drift/tables/parties.dart';
import 'package:moonforge/data/drift/tables/players.dart';
import 'package:moonforge/data/drift/tables/scenes.dart';
import 'package:moonforge/data/drift/tables/sessions.dart';
import 'package:moonforge/data/drift/tables/storage_queue.dart';
import 'package:moonforge/data/firebase/models/adventure.dart';

// Import model types used by @UseRowClass in table definitions so Drift generated code can reference them
import 'package:moonforge/data/firebase/models/campaign.dart';
import 'package:moonforge/data/firebase/models/chapter.dart';
import 'package:moonforge/data/firebase/models/encounter.dart';
import 'package:moonforge/data/firebase/models/entity.dart';
import 'package:moonforge/data/firebase/models/media_asset.dart';
import 'package:moonforge/data/firebase/models/party.dart';
import 'package:moonforge/data/firebase/models/player.dart';
import 'package:moonforge/data/firebase/models/scene.dart';
import 'package:moonforge/data/firebase/models/session.dart';

part 'app_database.g.dart';

/// Main Drift database for offline-first local storage
@DriftDatabase(
  tables: [
    // Content tables
    Campaigns,
    Adventures,
    Chapters,
    Encounters,
    Entities,
    Parties,
    Players,
    Scenes,
    Sessions,
    MediaAssets,
    // Metadata tables
    LocalMetas,
    CampaignLocalMetas, // Deprecated, kept for migration
    // Queue tables
    OutboxOps,
    StorageQueue,
  ],
  daos: [
    CampaignsDao,
    AdventuresDao,
    ChaptersDao,
    EncountersDao,
    EntitiesDao,
    PartiesDao,
    PlayersDao,
    ScenesDao,
    SessionsDao,
    MediaAssetsDao,
    OutboxDao,
    StorageQueueDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  /// Test constructor for in-memory database
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  // Idempotent column add to avoid duplicate-column crashes on partially-migrated DBs
  Future<void> _safeAddColumn(
    Migrator m,
    TableInfo<Table, Object?> table,
    GeneratedColumn column,
  ) async {
    try {
      await m.addColumn(table, column);
    } catch (e) {
      // Ignore "duplicate column name" errors, rethrow others
      final msg = e.toString();
      if (msg.contains('duplicate column name') ||
          msg.contains('ALTER TABLE') && msg.contains('duplicate')) {
        // no-op: column already exists
        return;
      }
      rethrow;
    }
  }

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Migration from v1 to v2: Add all new tables
        if (from < 2) {
          await m.createTable(adventures);
          await m.createTable(chapters);
          await m.createTable(encounters);
          await m.createTable(entities);
          await m.createTable(scenes);
          await m.createTable(sessions);
          await m.createTable(mediaAssets);
          await m.createTable(localMetas);
          await m.createTable(storageQueue);
        }

        // Migration from v2 to v3: Add share and revision fields to Sessions; Add entityIds column to content tables
        if (from < 3) {
          await _safeAddColumn(m, sessions, sessions.shareToken);
          await _safeAddColumn(m, sessions, sessions.shareEnabled);
          await _safeAddColumn(m, sessions, sessions.shareExpiresAt);
          await _safeAddColumn(m, sessions, sessions.updatedAt);
          await _safeAddColumn(m, sessions, sessions.rev);
          await _safeAddColumn(m, campaigns, campaigns.entityIds);
          await _safeAddColumn(m, chapters, chapters.entityIds);
          await _safeAddColumn(m, adventures, adventures.entityIds);
          await _safeAddColumn(m, scenes, scenes.entityIds);
          await _safeAddColumn(m, encounters, encounters.entityIds);
        }

        // Migration from v3 to v4: Add Parties and Players tables
        if (from < 4) {
          await m.createTable(parties);
          await m.createTable(players);
        }
      },
    );
  }
}
