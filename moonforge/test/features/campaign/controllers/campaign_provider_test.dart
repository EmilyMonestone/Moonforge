import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';

void main() {
  group('CampaignProvider', () {
    test('initial state is idle', () {
      final provider = CampaignProvider();
      expect(provider.state.isIdle, true);
    });

    test('setCurrentCampaign updates state and persistence', () async {
      final provider = CampaignProvider();
      final campaign = createTestCampaign();

      provider.setCurrentCampaign(campaign);

      expect(provider.currentCampaign, isNotNull);
      expect(provider.currentCampaign!.id, equals(campaign.id));

      provider.clearPersistedCampaign();
      expect(provider.getPersistedCampaignId(), isNull);
    });
  });
}

Campaign createTestCampaign({String id = '1', String name = 'Test Campaign'}) {
  return Campaign(
    id: id,
    name: name,
    description: '',
    content: null,
    ownerUid: null,
    memberUids: [],
    entityIds: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    rev: 0,
  );
}
