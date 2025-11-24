import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/db/daos/campaign_dao.dart';
import 'package:moonforge/data/db/tables.dart';
import 'package:moonforge/data/repo/base_repository.dart';
import 'package:moonforge/data/repo/pagination.dart';
import 'package:moonforge/data/repo/repository_cache.dart';

/// Query builder for campaign lookups.
class CampaignQuery {
  final String? ownerOrMember;
  final OrderingTerm Function(Campaigns c)? orderBy;
  final int? limit;

  const CampaignQuery({this.ownerOrMember, this.orderBy, this.limit});
}

/// Repository for Campaign operations.
class CampaignRepository extends BaseRepository<Campaign, String> {
  CampaignRepository(this._db);

  final AppDb _db;
  final RepositoryCache<Campaign, String> _cache = RepositoryCache();

  CampaignDao get _dao => _db.campaignDao;

  @override
  Future<Campaign?> getById(String id) => handleError(() async {
    final cached = _cache.get(id);
    if (cached != null) {
      return cached;
    }
    final result = await _dao.getById(id);
    if (result != null) {
      _cache.set(id, result);
    }
    return result;
  }, context: 'campaign.getById');

  @override
  Future<List<Campaign>> getAll() =>
      handleError(() => _dao.getAll(), context: 'campaign.getAll');

  @override
  Future<Campaign> create(Campaign campaign) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        CampaignsCompanion.insert(
          id: Value(campaign.id),
          name: campaign.name,
          description: campaign.description,
          content: Value(campaign.content),
          ownerUid: Value(campaign.ownerUid),
          memberUids: Value(campaign.memberUids),
          entityIds: campaign.entityIds,
          createdAt: Value(campaign.createdAt ?? DateTime.now()),
          updatedAt: Value(DateTime.now()),
          rev: campaign.rev,
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'campaigns',
        rowId: campaign.id,
        op: 'upsert',
      );
    });
    _cache.set(campaign.id, campaign);
    return campaign;
  }, context: 'campaign.create');

  @override
  Future<Campaign> update(Campaign campaign) => handleError(() async {
    await _db.transaction(() async {
      await _dao.upsert(
        CampaignsCompanion(
          id: Value(campaign.id),
          name: Value(campaign.name),
          description: Value(campaign.description),
          content: Value(campaign.content),
          ownerUid: Value(campaign.ownerUid),
          memberUids: Value(campaign.memberUids),
          entityIds: Value(campaign.entityIds),
          updatedAt: Value(DateTime.now()),
          rev: Value(campaign.rev + 1),
        ),
      );
      await _db.outboxDao.enqueue(
        table: 'campaigns',
        rowId: campaign.id,
        op: 'upsert',
      );
    });
    _cache.set(campaign.id, campaign);
    return campaign;
  }, context: 'campaign.update');

  @override
  Future<void> delete(String id) => handleError(() async {
    await _db.transaction(() async {
      await _dao.deleteById(id);
      await _db.outboxDao.enqueue(table: 'campaigns', rowId: id, op: 'delete');
    });
    _cache.remove(id);
  }, context: 'campaign.delete');

  @override
  Stream<Campaign?> watchById(String id) => handleStreamError(
    () => _dao.watchAll().map(
      (list) => list.firstWhereOrNull((campaign) => campaign.id == id),
    ),
    context: 'campaign.watchById',
  );

  @override
  Stream<List<Campaign>> watchAll() =>
      handleStreamError(_dao.watchAll, context: 'campaign.watchAll');

  /// Execute a structured campaign query.
  Future<List<Campaign>> query(CampaignQuery query) => handleError(() {
    return _dao.customQuery(
      filter: query.ownerOrMember != null
          ? (c) =>
                c.ownerUid.equals(query.ownerOrMember!) |
                c.memberUids.contains(query.ownerOrMember!)
          : null,
      sort: query.orderBy != null ? [query.orderBy!] : null,
      limit: query.limit,
    );
  }, context: 'campaign.query');

  /// Paginated campaign result helper.
  Future<PaginatedResult<Campaign>> getPaginated(PaginationParams params) =>
      handleError(() async {
        final items = await _dao.getPaginated(
          limit: params.limit,
          offset: params.offset,
        );
        final totalCount = await _dao.count();
        return PaginatedResult<Campaign>(
          items: items,
          totalCount: totalCount,
          page: params.page,
          pageSize: params.pageSize,
        );
      }, context: 'campaign.paginated');

  /// Fetch campaigns owned by or shared with [userId].
  Future<List<Campaign>> getByUser(String userId) =>
      query(CampaignQuery(ownerOrMember: userId));

  /// Watch campaigns owned by or shared with [userId].
  Stream<List<Campaign>> watchByUser(String userId) => handleStreamError(
    () => _dao.watchCampaignsByUser(userId),
    context: 'campaign.watchByUser',
  );

  /// Run a fully custom query passthrough for advanced filters.
  Future<List<Campaign>> customQuery({
    Expression<bool> Function(Campaigns c)? filter,
    List<OrderingTerm Function(Campaigns c)>? sort,
    int? limit,
  }) => handleError(
    () => _dao.customQuery(filter: filter, sort: sort, limit: limit),
    context: 'campaign.customQuery',
  );
}
