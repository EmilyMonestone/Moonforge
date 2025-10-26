import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/drift/app_database.dart';

void main() {
  group('Database Migrations', () {
    test('schema version 1 creates all tables', () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());

      // Verify tables exist by querying them
      final campaigns = await db.select(db.campaigns).get();
      final metas = await db.select(db.campaignLocalMetas).get();
      final outbox = await db.select(db.outboxOps).get();

      expect(campaigns, isEmpty);
      expect(metas, isEmpty);
      expect(outbox, isEmpty);

      await db.close();
    });

    // Example future migration test
    // Uncomment when adding schema v2
    /*
    test('migration from v1 to v2 adds subtitle column', () async {
      // Create v1 database
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      
      // Insert test data with v1 schema
      final campaign = Campaign(
        id: 'test-1',
        name: 'Test',
        description: 'Description',
        rev: 0,
      );
      await db.campaignsDao.upsertCampaign(campaign);
      
      await db.close();
      
      // Reopen with v2 schema (would need to bump schemaVersion to 2)
      final db2 = AppDatabase.forTesting(NativeDatabase.memory());
      
      // Verify subtitle column exists and is nullable
      final retrieved = await db2.campaignsDao.getById('test-1');
      expect(retrieved?.subtitle, isNull);
      
      await db2.close();
    });
    */
  });
}
