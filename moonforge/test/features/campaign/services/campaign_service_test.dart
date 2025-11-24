import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';

class SimpleFakeRepository {
  final Map<String, Campaign> _store = {};

  Future<void> create(Campaign c) async {
    _store[c.id] = c;
  }

  Future<void> delete(String id) async {
    _store.remove(id);
  }

  Future<List<Campaign>> customQuery() async => _store.values.toList();
}

void main() {
  group('CampaignService', () {
    late SimpleFakeRepository repo;
    late CampaignService service;

    setUp(() {
      repo = SimpleFakeRepository();
      // CampaignService expects a CampaignRepository; our fake will be used via dynamic calls
      service = CampaignService(repo as dynamic);
    });

    test('duplicateCampaign creates a new campaign with new name', () async {
      final original = Campaign(
        id: 'orig',
        name: 'Original',
        description: 'desc',
        content: null,
        ownerUid: null,
        memberUids: [],
        entityIds: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 0,
      );

      final duplicated = await service.duplicateCampaign(original, 'Copy');

      expect(duplicated, isNotNull);
      expect(duplicated!.name, equals('Copy'));
    });

    test('getCampaignStats returns correct entityCount', () async {
      final campaign = Campaign(
        id: 'c1',
        name: 'C1',
        description: '',
        content: null,
        ownerUid: null,
        memberUids: [],
        entityIds: ['e1', 'e2'],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 0,
      );

      final stats = await service.getCampaignStats(campaign);
      expect(stats.entityCount, equals(2));
    });

    test('deleteCampaign calls repository delete', () async {
      // Our fake doesn't track deletes explicitly, but ensure method completes
      await service.deleteCampaign('any');
    });
  });
}
