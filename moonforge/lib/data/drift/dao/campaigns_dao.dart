import 'package:drift/drift.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/drift/dao/local_meta_mixin.dart';
import 'package:moonforge/data/drift/tables/campaign_local_metas.dart';
import 'package:moonforge/data/drift/tables/campaigns.dart';
import 'package:moonforge/data/drift/tables/local_metas.dart';
import 'package:moonforge/data/firebase/models/campaign.dart';

part 'campaigns_dao.g.dart';

/// Data Access Object for Campaign operations
@DriftAccessor(tables: [Campaigns, CampaignLocalMetas, LocalMetas])
class CampaignsDao extends DatabaseAccessor<AppDatabase>
    with _$CampaignsDaoMixin, LocalMetaMixin {
  CampaignsDao(super.db);

  static const String collectionName = 'campaigns';

  /// Watch all campaigns as a stream
  Stream<List<Campaign>> watchAll() {
    logger.t('CampaignsDao.watchAll() subscribed');
    return select(campaigns).watch();
  }

  /// Get a single campaign by ID
  Future<Campaign?> getById(String id) {
    logger.t('CampaignsDao.getById($id)');
    return (select(campaigns)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  /// Upsert a campaign and optionally mark it as dirty
  Future<void> upsertCampaign(Campaign campaign, {bool markDirty = false}) {
    logger.d(
      'CampaignsDao.upsertCampaign(id=${campaign.id}, markDirty=$markDirty, rev=${campaign.rev})',
    );
    return transaction(() async {
      await into(campaigns).insert(
        CampaignsCompanion.insert(
          id: campaign.id,
          name: campaign.name,
          description: campaign.description,
          content: Value(campaign.content),
          ownerUid: Value(campaign.ownerUid),
          memberUids: Value(campaign.memberUids),
          createdAt: Value(campaign.createdAt),
          updatedAt: Value(campaign.updatedAt),
          rev: Value(campaign.rev),
        ),
        mode: InsertMode.insertOrReplace,
      );

      if (markDirty) {
        await this.markDirty(collectionName, campaign.id);
        logger.t('Marked ${campaign.id} dirty in LocalMetas');

        // Also update old table for backward compatibility
        await into(campaignLocalMetas).insert(
          CampaignLocalMetasCompanion.insert(
            docId: campaign.id,
            dirty: const Value(true),
            lastSyncedAt: Value(DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Mark a campaign as clean (sync'd) and update its revision
  Future<void> setClean(String id, int newRev) {
    logger.d('CampaignsDao.setClean(id=$id, newRev=$newRev)');
    return transaction(() async {
      await (update(campaigns)..where((c) => c.id.equals(id))).write(
        CampaignsCompanion(rev: Value(newRev)),
      );

      await markClean(collectionName, id);
      logger.t('Marked $id clean in LocalMetas');

      // Also update old table for backward compatibility
      await (update(
        campaignLocalMetas,
      )..where((m) => m.docId.equals(id))).write(
        CampaignLocalMetasCompanion(
          dirty: const Value(false),
          lastSyncedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  /// Get local metadata for a campaign (legacy method, uses old table)
  Future<CampaignLocalMeta?> getLegacyLocalMeta(String docId) {
    logger.t('CampaignsDao.getLegacyLocalMeta($docId)');
    return (select(
      campaignLocalMetas,
    )..where((m) => m.docId.equals(docId))).getSingleOrNull();
  }

  /// Check if a campaign has unsync'd changes
  @override
  Future<bool> isDirty(String collection, String docId) async {
    // Use new LocalMetas table
    final res = await super.isDirty(collection, docId);
    logger.t('CampaignsDao.isDirty($collection/$docId) => $res');
    return res;
  }
}
