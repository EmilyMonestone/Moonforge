import 'package:drift/drift.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/session_repository.dart';

/// Statistics data for dashboard overview
class DashboardStats {
  final int totalCampaigns;
  final int totalSessions;
  final int totalParties;
  final int totalEntities;
  final int upcomingSessions;
  final DateTime? lastActivity;

  const DashboardStats({
    required this.totalCampaigns,
    required this.totalSessions,
    required this.totalParties,
    required this.totalEntities,
    required this.upcomingSessions,
    this.lastActivity,
  });
}

/// Service for aggregating dashboard data and statistics
class DashboardService {
  final CampaignRepository _campaignRepo;
  final SessionRepository _sessionRepo;
  final PartyRepository _partyRepo;
  final EntityRepository _entityRepo;

  DashboardService({
    required CampaignRepository campaignRepo,
    required SessionRepository sessionRepo,
    required PartyRepository partyRepo,
    required EntityRepository entityRepo,
  }) : _campaignRepo = campaignRepo,
       _sessionRepo = sessionRepo,
       _partyRepo = partyRepo,
       _entityRepo = entityRepo;

  /// Fetch dashboard statistics for the current user
  Future<DashboardStats> fetchStats(String? userId) async {
    try {
      if (userId == null) {
        return const DashboardStats(
          totalCampaigns: 0,
          totalSessions: 0,
          totalParties: 0,
          totalEntities: 0,
          upcomingSessions: 0,
        );
      }

      // Fetch counts in parallel for better performance
      final results = await Future.wait([
        _fetchCampaignCount(userId),
        _fetchSessionCount(),
        _fetchPartyCount(),
        _fetchEntityCount(),
        _fetchUpcomingSessionCount(),
      ]);

      final lastActivity = await _fetchLastActivityTime(userId);

      return DashboardStats(
        totalCampaigns: results[0] as int,
        totalSessions: results[1] as int,
        totalParties: results[2] as int,
        totalEntities: results[3] as int,
        upcomingSessions: results[4] as int,
        lastActivity: lastActivity,
      );
    } catch (e) {
      logger.e('Error fetching dashboard stats: $e');
      rethrow;
    }
  }

  Future<int> _fetchCampaignCount(String userId) async {
    try {
      final campaigns = await _campaignRepo.customQuery(
        filter: (c) =>
            c.ownerUid.equals(userId) | c.memberUids.contains(userId),
      );
      return campaigns.length;
    } catch (e) {
      logger.e('Error fetching campaign count: $e');
      return 0;
    }
  }

  Future<int> _fetchSessionCount() async {
    try {
      final sessions = await _sessionRepo.customQuery();
      return sessions.length;
    } catch (e) {
      logger.e('Error fetching session count: $e');
      return 0;
    }
  }

  Future<int> _fetchPartyCount() async {
    try {
      final parties = await _partyRepo.customQuery();
      return parties.length;
    } catch (e) {
      logger.e('Error fetching party count: $e');
      return 0;
    }
  }

  Future<int> _fetchEntityCount() async {
    try {
      final entities = await _entityRepo.customQuery();
      return entities.length;
    } catch (e) {
      logger.e('Error fetching entity count: $e');
      return 0;
    }
  }

  Future<int> _fetchUpcomingSessionCount() async {
    try {
      final now = DateTime.now();
      final sessions = await _sessionRepo.customQuery(
        filter: (s) => s.datetime.isBiggerOrEqual(Variable(now)),
      );
      return sessions.length;
    } catch (e) {
      logger.e('Error fetching upcoming session count: $e');
      return 0;
    }
  }

  Future<DateTime?> _fetchLastActivityTime(String userId) async {
    try {
      final campaigns = await _campaignRepo.customQuery(
        filter: (c) =>
            c.ownerUid.equals(userId) | c.memberUids.contains(userId),
        sort: [
          (c) => OrderingTerm(expression: c.updatedAt, mode: OrderingMode.desc),
        ],
        limit: 1,
      );

      if (campaigns.isNotEmpty) {
        return campaigns.first.updatedAt;
      }
      return null;
    } catch (e) {
      logger.e('Error fetching last activity time: $e');
      return null;
    }
  }

  /// Fetch upcoming sessions (next 5)
  Future<List<Session>> fetchUpcomingSessions() async {
    try {
      final now = DateTime.now();
      final sessions = await _sessionRepo.customQuery(
        filter: (s) => s.datetime.isBiggerOrEqual(Variable(now)),
        sort: [
          (s) => OrderingTerm(expression: s.datetime, mode: OrderingMode.asc),
        ],
        limit: 5,
      );
      return sessions;
    } catch (e) {
      logger.e('Error fetching upcoming sessions: $e');
      return [];
    }
  }

  /// Fetch recent activity across all campaigns
  Future<List<Campaign>> fetchRecentActivity(
    String? userId, {
    int limit = 10,
  }) async {
    try {
      if (userId == null) return [];

      final campaigns = await _campaignRepo.customQuery(
        filter: (c) =>
            c.ownerUid.equals(userId) | c.memberUids.contains(userId),
        sort: [
          (c) => OrderingTerm(expression: c.updatedAt, mode: OrderingMode.desc),
        ],
        limit: limit,
      );
      return campaigns;
    } catch (e) {
      logger.e('Error fetching recent activity: $e');
      return [];
    }
  }
}
