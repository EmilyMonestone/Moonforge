import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:moonforge/core/utils/logger.dart';

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
          
          // Log what we're about to check
          logger.d('Checking $table.$column for legacy date formats');
          
          // Check how many TEXT values exist
          final countResult = await customSelect(
            'SELECT COUNT(*) as count FROM "$table" WHERE typeof("$column") = \'text\''
          ).getSingleOrNull();
          final textCount = countResult?.data['count'] ?? 0;
          
          if (textCount > 0) {
            logger.w('Found $textCount TEXT values in $table.$column');
            
            // Log sample values
            final sampleResult = await customSelect(
              'SELECT "$column" FROM "$table" WHERE typeof("$column") = \'text\' LIMIT 5'
            ).get();
            for (final row in sampleResult) {
              logger.w('  Sample TEXT value: ${row.data[column]}');
            }
          }
          
          // First, handle epoch seconds with 'Z' suffix (e.g., '1761490548Z')
          // Use a more flexible pattern that handles any number of digits followed by Z
          await customStatement('''
UPDATE "$table"
SET "$column" = CAST(REPLACE("$column", 'Z', '') AS INTEGER) * 1000
WHERE typeof("$column") = 'text' 
  AND "$column" LIKE '%Z'
  AND CAST(REPLACE("$column", 'Z', '') AS INTEGER) > 0;
''');
          logger.d('Processed rows with Z suffix in $table.$column');
          
          // Then, handle plain epoch seconds (9-11 digits, common epoch second range)
          await customStatement('''
UPDATE "$table"
SET "$column" = CAST("$column" AS INTEGER) * 1000
WHERE typeof("$column") = 'text' 
  AND length("$column") >= 9
  AND length("$column") <= 11
  AND CAST("$column" AS INTEGER) > 0;
''');
          logger.d('Processed plain epoch seconds in $table.$column');
          
          // Check if any TEXT values remain
          final remainingResult = await customSelect(
            'SELECT COUNT(*) as count FROM "$table" WHERE typeof("$column") = \'text\''
          ).getSingleOrNull();
          final remainingCount = remainingResult?.data['count'] ?? 0;
          
          if (remainingCount > 0) {
            logger.e('Still have $remainingCount TEXT values in $table.$column after normalization!');
            
            // Log remaining problematic values
            final remainingSample = await customSelect(
              'SELECT "$column" FROM "$table" WHERE typeof("$column") = \'text\' LIMIT 5'
            ).get();
            for (final row in remainingSample) {
              logger.e('  Remaining TEXT value: ${row.data[column]}');
            }
          } else {
            logger.i('Successfully normalized all TEXT dates in $table.$column');
          }
        }

        // Fix NULL values in non-nullable JSON fields
        Future<void> fixNullJsonFields(String table, String column, String defaultValue) async {
          if (!await hasColumn(table, column)) return;
          
          final nullCount = await customSelect(
            'SELECT COUNT(*) as count FROM "$table" WHERE "$column" IS NULL'
          ).getSingleOrNull();
          final count = nullCount?.data['count'] ?? 0;
          
          if (count > 0) {
            logger.w('Found $count NULL values in $table.$column, setting defaults');
            await customStatement('''
UPDATE "$table"
SET "$column" = '$defaultValue'
WHERE "$column" IS NULL;
''');
            logger.i('Set default values for $count rows in $table.$column');
          }
        }

        // Campaigns
        await normalize('campaigns', 'created_at');
        await normalize('campaigns', 'updated_at');
        await fixNullJsonFields('campaigns', 'name', 'Untitled Campaign');
        await fixNullJsonFields('campaigns', 'description', '');
        // Chapters
        await normalize('chapters', 'created_at');
        await normalize('chapters', 'updated_at');
        await fixNullJsonFields('chapters', 'name', 'Untitled Chapter');
        // Adventures
        await normalize('adventures', 'created_at');
        await normalize('adventures', 'updated_at');
        await fixNullJsonFields('adventures', 'name', 'Untitled Adventure');
        // Scenes
        await normalize('scenes', 'created_at');
        await normalize('scenes', 'updated_at');
        await fixNullJsonFields('scenes', 'name', 'Untitled Scene');
        // Parties
        await normalize('parties', 'created_at');
        await normalize('parties', 'updated_at');
        await fixNullJsonFields('parties', 'name', 'Untitled Party');
        // Encounters
        await normalize('encounters', 'created_at');
        await normalize('encounters', 'updated_at');
        await fixNullJsonFields('encounters', 'name', 'Untitled Encounter');
        await fixNullJsonFields('encounters', 'origin_id', '');
        // Entities
        await normalize('entities', 'created_at');
        await normalize('entities', 'updated_at');
        // Fix NULL values in non-nullable fields for Entities
        await fixNullJsonFields('entities', 'statblock', '{}');
        await fixNullJsonFields('entities', 'coords', '{}');
        await fixNullJsonFields('entities', 'kind', 'unknown');
        await fixNullJsonFields('entities', 'name', 'Unnamed Entity');
        await fixNullJsonFields('entities', 'origin_id', '');
        // Media assets
        await normalize('media_assets', 'created_at');
        await normalize('media_assets', 'updated_at');
        await fixNullJsonFields('media_assets', 'filename', 'unknown');
        // Sessions
        await normalize('sessions', 'created_at');
        await normalize('sessions', 'updated_at');
        await normalize('sessions', 'datetime');
        await normalize('sessions', 'share_expires_at');
        // Players
        await normalize('players', 'created_at');
        await normalize('players', 'updated_at');
        await normalize('players', 'last_ddb_sync');
        await fixNullJsonFields('players', 'name', 'Unnamed Player');
        // Combatants
        await fixNullJsonFields('combatants', 'name', 'Unnamed Combatant');
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
