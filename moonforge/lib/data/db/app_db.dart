import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'converters.dart';
import 'daos/adventure_dao.dart';
import 'daos/campaign_dao.dart';
import 'daos/chapter_dao.dart';
import 'daos/combatant_dao.dart';
import 'daos/encounter_dao.dart';
import 'daos/entity_dao.dart';
import 'daos/media_asset_dao.dart';
import 'daos/outbox_dao.dart';
import 'daos/party_dao.dart';
import 'daos/player_dao.dart';
import 'daos/scene_dao.dart';
import 'daos/session_dao.dart';
import 'tables.dart';

part 'app_db.g.dart';

@DriftDatabase(
  tables: [
    Campaigns,
    Chapters,
    Adventures,
    Scenes,
    Parties,
    Encounters,
    Entities,
    Combatants,
    MediaAssets,
    Sessions,
    Players,
    OutboxEntries,
  ],
  daos: [
    CampaignDao,
    ChapterDao,
    AdventureDao,
    SceneDao,
    PartyDao,
    EncounterDao,
    EntityDao,
    CombatantDao,
    MediaAssetDao,
    SessionDao,
    PlayerDao,
    OutboxDao,
  ],
)
class AppDb extends _$AppDb {
  // Constructor for custom executor (useful for testing)
  AppDb([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add Players table
          await m.createTable(players);
          // Add memberPlayerIds to Parties if it doesn't exist
          await m.addColumn(parties, parties.memberPlayerIds);
        }
        if (from < 3) {
          // Add D&D Beyond integration fields to Players
          await m.addColumn(players, players.ddbCharacterId);
          await m.addColumn(players, players.lastDdbSync);
        }
        if (from < 4) {
          // Ensure OutboxEntries exists for sync
          await m.createTable(outboxEntries);
        }
      },
      beforeOpen: (details) async {
        // Enable foreign key constraints
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Platform-agnostic database connection using drift_flutter
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'moonforge_db',
      // For web support, ensure sqlite3.wasm and drift_worker.js are in web/
      // See: https://drift.simonbinder.eu/platforms/web/
    );
  }
}

// Simplified factory - now just creates AppDb with default connection
AppDb constructDb() => AppDb();
