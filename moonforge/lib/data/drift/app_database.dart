import 'package:drift/drift.dart';
import 'package:moonforge/data/drift/connect/connect.dart' as impl;
import 'package:moonforge/data/drift/converters/string_list_converter.dart';
import 'package:moonforge/data/drift/dao/campaigns_dao.dart';
import 'package:moonforge/data/drift/dao/outbox_dao.dart';
import 'package:moonforge/data/drift/tables/campaign_local_metas.dart';
import 'package:moonforge/data/drift/tables/campaigns.dart';
import 'package:moonforge/data/drift/tables/outbox_ops.dart';

part 'app_database.g.dart';

/// Main Drift database for offline-first local storage
@DriftDatabase(
  tables: [Campaigns, CampaignLocalMetas, OutboxOps],
  daos: [CampaignsDao, OutboxDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());
  
  /// Test constructor for in-memory database
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Future migrations will be added here
        // Example for v2:
        // if (from < 2) {
        //   await m.addColumn(campaigns, campaigns.subtitle);
        // }
      },
    );
  }
}
