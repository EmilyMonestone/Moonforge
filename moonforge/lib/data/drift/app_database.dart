import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/adventure.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/core/models/data/chapter.dart';
import 'package:moonforge/core/models/data/encounter.dart';
import 'package:moonforge/core/models/data/entity.dart';
import 'package:moonforge/core/models/data/media_asset.dart';
import 'package:moonforge/core/models/data/scene.dart';
import 'package:moonforge/core/models/data/session.dart';
import 'package:moonforge/data/drift/connect/connect.dart' as impl;
import 'package:moonforge/data/drift/converters/json_list_converter.dart';
import 'package:moonforge/data/drift/converters/non_null_json_map_converter.dart';
import 'package:moonforge/data/drift/converters/string_list_converter.dart';
import 'package:moonforge/data/drift/converters/non_null_string_list_converter.dart';
import 'package:moonforge/data/drift/dao/adventures_dao.dart';
import 'package:moonforge/data/drift/dao/campaigns_dao.dart';
import 'package:moonforge/data/drift/dao/chapters_dao.dart';
import 'package:moonforge/data/drift/dao/encounters_dao.dart';
import 'package:moonforge/data/drift/dao/entities_dao.dart';
import 'package:moonforge/data/drift/dao/media_assets_dao.dart';
import 'package:moonforge/data/drift/dao/outbox_dao.dart';
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
import 'package:moonforge/data/drift/tables/scenes.dart';
import 'package:moonforge/data/drift/tables/sessions.dart';
import 'package:moonforge/data/drift/tables/storage_queue.dart';

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
  int get schemaVersion => 3;

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
          await m.addColumn(sessions, sessions.shareToken);
          await m.addColumn(sessions, sessions.shareEnabled);
          await m.addColumn(sessions, sessions.shareExpiresAt);
          await m.addColumn(sessions, sessions.updatedAt);
          await m.addColumn(sessions, sessions.rev);
          await m.addColumn(campaigns, campaigns.entityIds);
          await m.addColumn(chapters, chapters.entityIds);
          await m.addColumn(adventures, adventures.entityIds);
          await m.addColumn(scenes, scenes.entityIds);
          await m.addColumn(encounters, encounters.entityIds);
        }
      },
    );
  }
}
