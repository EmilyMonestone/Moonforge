import 'package:drift/drift.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/tables/campaign_local_metas.dart';
import 'package:moonforge/data/drift/tables/campaigns.dart';

part 'campaigns_dao.g.dart';

/// Data Access Object for Campaign operations
@DriftAccessor(tables: [Campaigns, CampaignLocalMetas])
class CampaignsDao extends DatabaseAccessor<AppDatabase>
    with _$CampaignsDaoMixin {
  CampaignsDao(super.db);

  /// Watch all campaigns as a stream
  Stream<List<Campaign>> watchAll() {
    return select(campaigns).watch();
  }

  /// Get a single campaign by ID
  Future<Campaign?> getById(String id) {
    return (select(campaigns)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  /// Upsert a campaign and optionally mark it as dirty
  Future<void> upsertCampaign(Campaign campaign, {bool markDirty = false}) {
    return transaction(() async {
      await into(campaigns).insertOnConflictUpdate(campaign);
      
      if (markDirty) {
        await into(campaignLocalMetas).insertOnConflictUpdate(
          CampaignLocalMetasCompanion.insert(
            docId: campaign.id,
            dirty: const Value(true),
            lastSyncedAt: Value(DateTime.now()),
          ),
        );
      }
    });
  }

  /// Mark a campaign as clean (sync'd) and update its revision
  Future<void> setClean(String id, int newRev) {
    return transaction(() async {
      await (update(campaigns)..where((c) => c.id.equals(id)))
          .write(CampaignsCompanion(rev: Value(newRev)));
      
      await (update(campaignLocalMetas)..where((m) => m.docId.equals(id)))
          .write(CampaignLocalMetasCompanion(
            dirty: const Value(false),
            lastSyncedAt: Value(DateTime.now()),
          ));
    });
  }

  /// Get local metadata for a campaign
  Future<CampaignLocalMeta?> getLocalMeta(String docId) {
    return (select(campaignLocalMetas)..where((m) => m.docId.equals(docId)))
        .getSingleOrNull();
  }

  /// Check if a campaign has unsync'd changes
  Future<bool> isDirty(String docId) async {
    final meta = await getLocalMeta(docId);
    return meta?.dirty ?? false;
  }
}
