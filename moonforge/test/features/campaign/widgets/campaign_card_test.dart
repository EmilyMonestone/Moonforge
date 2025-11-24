import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/widgets/campaign_card.dart';

import '../../../test_config.dart';

Campaign createTestCampaign({String id = '1', String name = 'Test Campaign'}) {
  return Campaign(
    id: id,
    name: name,
    description: 'Test Description',
    content: null,
    ownerUid: null,
    memberUids: [],
    entityIds: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    rev: 0,
  );
}

void main() {
  testWidgets('CampaignCard displays name and description', (tester) async {
    final campaign = createTestCampaign();
    await pumpWidget(tester, CampaignCard(campaign: campaign));

    expect(find.text('Test Campaign'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
  });

  testWidgets('CampaignCard onTap works', (tester) async {
    final campaign = createTestCampaign();
    var tapped = false;
    await pumpWidget(
      tester,
      CampaignCard(campaign: campaign, onTap: () => tapped = true),
    );

    await tester.tap(find.byType(CampaignCard));
    await tester.pumpAndSettle();
    expect(tapped, true);
  });
}
