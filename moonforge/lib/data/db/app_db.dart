import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:drift/wasm.dart';
import 'tables.dart';
import 'converters.dart';
import 'daos/campaign_dao.dart';
import 'daos/chapter_dao.dart';
import 'daos/adventure_dao.dart';
import 'daos/scene_dao.dart';
import 'daos/party_dao.dart';
import 'daos/encounter_dao.dart';
import 'daos/entity_dao.dart';
import 'daos/combatant_dao.dart';
import 'daos/media_asset_dao.dart';
import 'daos/session_dao.dart';
import 'daos/outbox_dao.dart';

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
    OutboxEntries
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
    OutboxDao,
  ],
)
class AppDb extends _$AppDb {
  AppDb(QueryExecutor e) : super(e);
  
  @override 
  int get schemaVersion => 1;
  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Add migrations here as schema evolves
      },
    );
  }
}

// Factory to construct the right executor per platform
Future<AppDb> constructDb() async {
  if (kIsWeb) {
    final executor = await WasmDatabase.open(
      databaseName: 'app.sqlite',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );
    return AppDb(executor.resolvedExecutor);
  } else {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'app.sqlite'));
    return AppDb(NativeDatabase.createInBackground(file));
  }
}
