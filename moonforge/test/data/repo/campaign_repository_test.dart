import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CampaignRepository (integration with in-memory DB)', () {
    late AppDb db;
    late CampaignRepository repo;

    setUp(() {
      db = AppDb(NativeDatabase.memory());
      repo = CampaignRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('create -> getById -> update -> delete', () async {
      final campaign = Campaign(
        id: 'camp1',
        name: 'Test Campaign',
        description: 'desc',
        content: null,
        ownerUid: 'owner',
        memberUids: null,
        entityIds: <String>[],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
      );

      final created = await repo.create(campaign);
      expect(created.id, equals('camp1'));

      final fetched = await repo.getById('camp1');
      expect(fetched, isNotNull);
      expect(fetched!.name, equals('Test Campaign'));

      final updatedCampaign = Campaign(
        id: 'camp1',
        name: 'Updated',
        description: 'desc',
        content: null,
        ownerUid: 'owner',
        memberUids: null,
        entityIds: <String>[],
        createdAt: created.createdAt,
        updatedAt: DateTime.now(),
        rev: created.rev + 1,
      );

      final updated = await repo.update(updatedCampaign);
      expect(updated.name, equals('Updated'));

      await repo.delete('camp1');
      final afterDelete = await repo.getById('camp1');
      expect(afterDelete, isNull);
    });
  });
}
