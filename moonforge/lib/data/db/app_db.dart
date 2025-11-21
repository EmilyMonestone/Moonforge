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
  int get schemaVersion => 5; // bumped from 4 for originType addition

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
          await m.addColumn(parties, parties.memberPlayerIds);
        }
        if (from < 3) {
          await m.addColumn(players, players.ddbCharacterId);
          await m.addColumn(players, players.lastDdbSync);
        }
        if (from < 4) {
          await m.createTable(outboxEntries);
        }
        if (from < 5) {
          // Add originType to Entities, default to 'campaign' for existing rows
          // Be defensive in case the column already exists (e.g. partially
          // migrated dev databases).
          final result = await customSelect(
            "PRAGMA table_info(entities);",
          ).get();
          final hasOriginTypeColumn = result.any(
            (row) => row.data['name'] == 'origin_type',
          );

          if (!hasOriginTypeColumn) {
            await m.addColumn(entities, entities.originType);
          }

          await customStatement(
            "UPDATE entities SET origin_type = 'campaign' WHERE origin_type IS NULL OR origin_type = ''",
          );
        }
      },
      beforeOpen: (details) async {
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

// Lazily initialized singleton to avoid creating multiple AppDb instances with
// the same underlying QueryExecutor, which can cause race conditions.
AppDb? _singletonDb;

/// Returns the shared [AppDb] instance.
///
/// For typical app usage, this should be the only entry point to construct
/// the database. If [clearExistingData] is true, all existing rows in all
/// tables will be deleted on first creation of the singleton. This is
/// intended for development/troubleshooting only.
AppDb constructDb({bool clearExistingData = false}) {
  if (_singletonDb == null) {
    _singletonDb = AppDb();
    if (clearExistingData) {
      // Fire-and-forget; caller can await deleteEverything() explicitly
      // if they need to block on completion.
      _singletonDb!.deleteEverything();
    }
  }
  return _singletonDb!;
}

extension AppDbDevTools on AppDb {
  /// Deletes all rows from all tables in this database.
  ///
  /// This keeps the table schemas intact but removes all data. It temporarily
  /// disables foreign key enforcement while truncating to avoid constraint
  /// violations.
  ///
  /// This helper is meant for development and troubleshooting scenarios
  /// (e.g., resetting a broken local database) and should not normally be
  /// used in production flows.
  Future<void> deleteEverything() async {
    await customStatement('PRAGMA foreign_keys = OFF');
    try {
      await transaction(() async {
        for (final table in allTables) {
          await delete(table).go();
        }
      });
    } finally {
      await customStatement('PRAGMA foreign_keys = ON');
    }
  }
}
