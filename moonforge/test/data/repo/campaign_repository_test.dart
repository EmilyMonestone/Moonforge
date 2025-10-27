import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';

void main() {
  late AppDatabase db;
  late CampaignRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = CampaignRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('CampaignRepository', () {
    test('upsertLocal creates campaign and enqueues operation', () async {
      final campaign = Campaign(
        id: 'test-1',
        name: 'Test Campaign',
        description: 'Test Description',
        rev: 0,
      );

      await repository.upsertLocal(campaign);

      // Verify local storage
      final stored = await db.campaignsDao.getById('test-1');
      expect(stored, isNotNull);
      expect(stored!.name, 'Test Campaign');

      // Verify marked as dirty
      final isDirty = await db.campaignsDao.isDirty('campaigns', 'test-1');
      expect(isDirty, isTrue);

      // Verify outbox operation
      final op = await db.outboxDao.nextOp();
      expect(op, isNotNull);
      expect(op!.docId, 'test-1');
      expect(op.opType, 'upsert');
    });

    test('patchLocal applies set operation', () async {
      // Create initial campaign
      final campaign = Campaign(
        id: 'test-1',
        name: 'Original Name',
        description: 'Original Description',
        rev: 0,
      );
      await db.campaignsDao.upsertCampaign(campaign);

      // Apply patch
      await repository.patchLocal(
        id: 'test-1',
        baseRev: 0,
        ops: [
          {'type': 'set', 'field': 'name', 'value': 'Updated Name'},
        ],
      );

      // Verify update
      final updated = await db.campaignsDao.getById('test-1');
      expect(updated!.name, 'Updated Name');
      expect(updated.description, 'Original Description');

      // Verify outbox operation
      final op = await db.outboxDao.nextOp();
      expect(op!.opType, 'patch');
    });

    test('patchLocal applies addToSet operation', () async {
      final campaign = Campaign(
        id: 'test-1',
        name: 'Test',
        description: 'Test',
        memberUids: ['uid1', 'uid2'],
        rev: 0,
      );
      await db.campaignsDao.upsertCampaign(campaign);

      await repository.patchLocal(
        id: 'test-1',
        baseRev: 0,
        ops: [
          {'type': 'addToSet', 'field': 'memberUids', 'value': 'uid3'},
        ],
      );

      final updated = await db.campaignsDao.getById('test-1');
      expect(updated!.memberUids, containsAll(['uid1', 'uid2', 'uid3']));
    });

    test('patchLocal applies removeFromSet operation', () async {
      final campaign = Campaign(
        id: 'test-1',
        name: 'Test',
        description: 'Test',
        memberUids: ['uid1', 'uid2', 'uid3'],
        rev: 0,
      );
      await db.campaignsDao.upsertCampaign(campaign);

      await repository.patchLocal(
        id: 'test-1',
        baseRev: 0,
        ops: [
          {'type': 'removeFromSet', 'field': 'memberUids', 'value': 'uid2'},
        ],
      );

      final updated = await db.campaignsDao.getById('test-1');
      expect(updated!.memberUids, ['uid1', 'uid3']);
    });

    test('watchAll streams campaigns', () async {
      final stream = repository.watchAll();

      // Initial empty state
      expect(await stream.first, isEmpty);

      // Add campaigns
      final campaign1 = Campaign(
        id: 'test-1',
        name: 'Campaign 1',
        description: 'Description 1',
        rev: 0,
      );
      await repository.upsertLocal(campaign1);

      final campaigns = await stream.first;
      expect(campaigns, hasLength(1));
      expect(campaigns[0].name, 'Campaign 1');
    });

    test('patchLocal handles multiple operations in sequence', () async {
      final campaign = Campaign(
        id: 'test-1',
        name: 'Original',
        description: 'Original Description',
        memberUids: ['uid1'],
        rev: 0,
      );
      await db.campaignsDao.upsertCampaign(campaign);

      await repository.patchLocal(
        id: 'test-1',
        baseRev: 0,
        ops: [
          {'type': 'set', 'field': 'name', 'value': 'Updated'},
          {'type': 'addToSet', 'field': 'memberUids', 'value': 'uid2'},
          {
            'type': 'set',
            'field': 'description',
            'value': 'Updated Description',
          },
        ],
      );

      final updated = await db.campaignsDao.getById('test-1');
      expect(updated!.name, 'Updated');
      expect(updated.description, 'Updated Description');
      expect(updated.memberUids, containsAll(['uid1', 'uid2']));
    });
  });
}
