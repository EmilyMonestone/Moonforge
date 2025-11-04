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

        // Helper to check if a column exists on a table
        Future<bool> hasColumn(String table, String column) async {
          final rows = await customSelect('PRAGMA table_info("$table")').get();
          for (final row in rows) {
            final name = row.data['name'] as String?;
            if (name == column) return true;
          }
          return false;
        }

        // Normalize legacy epoch-as-text dates (e.g., '1761490548Z' or '1761490548')
        // to integer milliseconds since epoch for DateTime columns.
        // This block is idempotent and only touches TEXT-typed cells.
        Future<void> normalize(String table, String column) async {
          // Skip if column is not present (older DBs before migration)
          if (!await hasColumn(table, column)) return;
          // Strip trailing 'Z' if present, cast to INTEGER seconds, multiply to ms
          await customStatement('''
UPDATE "$table"
SET "$column" = (
  CASE
    WHEN typeof("$column") = 'text' AND "$column" GLOB '*Z' THEN CAST(REPLACE("$column", 'Z', '') AS INTEGER) * 1000
    WHEN typeof("$column") = 'text' AND "$column" GLOB '[0-9]*' THEN CAST("$column" AS INTEGER) * 1000
    ELSE "$column"
  END
)
WHERE typeof("$column") = 'text' AND ("$column" GLOB '*Z' OR "$column" GLOB '[0-9]*');
''');
        }

        // Campaigns
        await normalize('campaigns', 'created_at');
        await normalize('campaigns', 'updated_at');
        // Chapters
        await normalize('chapters', 'created_at');
        await normalize('chapters', 'updated_at');
        // Adventures
        await normalize('adventures', 'created_at');
        await normalize('adventures', 'updated_at');
        // Scenes
        await normalize('scenes', 'created_at');
        await normalize('scenes', 'updated_at');
        // Parties
        await normalize('parties', 'created_at');
        await normalize('parties', 'updated_at');
        // Encounters
        await normalize('encounters', 'created_at');
        await normalize('encounters', 'updated_at');
        // Entities
        await normalize('entities', 'created_at');
        await normalize('entities', 'updated_at');
        // Media assets
        await normalize('media_assets', 'created_at');
        await normalize('media_assets', 'updated_at');
        // Sessions
        await normalize('sessions', 'created_at');
        await normalize('sessions', 'updated_at');
        await normalize('sessions', 'datetime');
        await normalize('sessions', 'share_expires_at');
        // Players
        await normalize('players', 'created_at');
        await normalize('players', 'updated_at');
        await normalize('players', 'last_ddb_sync');
        // OutboxEntries
        await normalize('outbox_entries', 'changed_at');
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
