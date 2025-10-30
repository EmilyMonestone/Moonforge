import 'package:drift/drift.dart';
import 'package:moonforge/data/db/converters/json_list_converter.dart';
import 'package:moonforge/data/db/daos/campaigns_dao.dart';
import 'package:moonforge/data/db/daos/chapters_dao.dart';
import 'package:moonforge/data/db/daos/checkpoints_dao.dart';
import 'package:moonforge/data/db/daos/entities_dao.dart';
import 'package:moonforge/data/db/daos/outbox_dao.dart';
import 'package:moonforge/data/db/daos/tombstones_dao.dart';
import 'package:moonforge/data/db/tables/campaigns.dart';
import 'package:moonforge/data/db/tables/chapters.dart';
import 'package:moonforge/data/db/tables/checkpoints.dart';
import 'package:moonforge/data/db/tables/entities.dart';
import 'package:moonforge/data/db/tables/outbox.dart';
import 'package:moonforge/data/db/tables/tombstones.dart';

part 'app_database.g.dart';

/// Main Drift database for local-first storage
/// 
/// This database serves as the source of truth for the app,
/// with bidirectional sync to Firestore handled by the SyncWorker.
@DriftDatabase(
  tables: [
    // Domain tables
    Campaigns,
    Chapters,
    Entities,
    // Sync infrastructure tables
    Outbox,
    Checkpoints,
    Tombstones,
  ],
  daos: [
    CampaignsDao,
    ChaptersDao,
    EntitiesDao,
    OutboxDao,
    CheckpointsDao,
    TombstonesDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future migrations will be handled here
        },
      );
}
