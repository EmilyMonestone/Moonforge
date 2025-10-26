import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/data/drift/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    // Use in-memory database for tests
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('CampaignsDao', () {
    test('upsertCampaign inserts new campaign', () async {
      final campaign = Campaign(
        id: 'test-1',
        name: 'Test Campaign',
        description: 'Test Description',
        rev: 0,
      );

      await db.campaignsDao.upsertCampaign(campaign);

      final retrieved = await db.campaignsDao.getById('test-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Test Campaign');
      expect(retrieved.description, 'Test Description');
      expect(retrieved.rev, 0);
    });

    test('upsertCampaign updates existing campaign', () async {
      final campaign = Campaign(
        id: 'test-1',
        name: 'Original',
        description: 'Original Description',
        rev: 0,
      );

      await db.campaignsDao.upsertCampaign(campaign);

      final updated = campaign.copyWith(
        name: 'Updated',
        rev: 1,
      );

      await db.campaignsDao.upsertCampaign(updated);

      final retrieved = await db.campaignsDao.getById('test-1');
      expect(retrieved!.name, 'Updated');
      expect(retrieved.rev, 1);
    });

    test('markDirty sets dirty flag', () async {
      final campaign = Campaign(
        id: 'test-1',
        name: 'Test',
        description: 'Test',
        rev: 0,
      );

      await db.campaignsDao.upsertCampaign(campaign, markDirty: true);

      final isDirty = await db.campaignsDao.isDirty('test-1');
      expect(isDirty, isTrue);
    });

    test('setClean updates rev and clears dirty flag', () async {
      final campaign = Campaign(
        id: 'test-1',
        name: 'Test',
        description: 'Test',
        rev: 0,
      );

      await db.campaignsDao.upsertCampaign(campaign, markDirty: true);
      await db.campaignsDao.setClean('test-1', 5);

      final retrieved = await db.campaignsDao.getById('test-1');
      expect(retrieved!.rev, 5);

      final isDirty = await db.campaignsDao.isDirty('test-1');
      expect(isDirty, isFalse);
    });

    test('watchAll streams campaigns', () async {
      final campaign1 = Campaign(
        id: 'test-1',
        name: 'Campaign 1',
        description: 'Description 1',
        rev: 0,
      );

      final campaign2 = Campaign(
        id: 'test-2',
        name: 'Campaign 2',
        description: 'Description 2',
        rev: 0,
      );

      final stream = db.campaignsDao.watchAll();

      // Initial empty state
      expect(await stream.first, isEmpty);

      await db.campaignsDao.upsertCampaign(campaign1);
      await db.campaignsDao.upsertCampaign(campaign2);

      final campaigns = await stream.first;
      expect(campaigns, hasLength(2));
      expect(campaigns.map((c) => c.id), containsAll(['test-1', 'test-2']));
    });
  });

  group('OutboxDao', () {
    test('enqueue adds operation', () async {
      final id = await db.outboxDao.enqueue(
        docPath: 'campaigns',
        docId: 'test-1',
        baseRev: 0,
        opType: 'upsert',
        payload: '{"name":"Test"}',
      );

      expect(id, greaterThan(0));

      final op = await db.outboxDao.nextOp();
      expect(op, isNotNull);
      expect(op!.docId, 'test-1');
      expect(op.opType, 'upsert');
    });

    test('nextOp returns oldest operation', () async {
      await db.outboxDao.enqueue(
        docPath: 'campaigns',
        docId: 'test-1',
        baseRev: 0,
        opType: 'upsert',
        payload: '{}',
      );

      await Future.delayed(const Duration(milliseconds: 10));

      await db.outboxDao.enqueue(
        docPath: 'campaigns',
        docId: 'test-2',
        baseRev: 0,
        opType: 'upsert',
        payload: '{}',
      );

      final op = await db.outboxDao.nextOp();
      expect(op!.docId, 'test-1');
    });

    test('remove deletes operation', () async {
      final id = await db.outboxDao.enqueue(
        docPath: 'campaigns',
        docId: 'test-1',
        baseRev: 0,
        opType: 'upsert',
        payload: '{}',
      );

      await db.outboxDao.remove(id);

      final op = await db.outboxDao.nextOp();
      expect(op, isNull);
    });

    test('pendingCount returns correct count', () async {
      expect(await db.outboxDao.pendingCount(), 0);

      await db.outboxDao.enqueue(
        docPath: 'campaigns',
        docId: 'test-1',
        baseRev: 0,
        opType: 'upsert',
        payload: '{}',
      );

      await db.outboxDao.enqueue(
        docPath: 'campaigns',
        docId: 'test-2',
        baseRev: 0,
        opType: 'upsert',
        payload: '{}',
      );

      expect(await db.outboxDao.pendingCount(), 2);
    });
  });
}

