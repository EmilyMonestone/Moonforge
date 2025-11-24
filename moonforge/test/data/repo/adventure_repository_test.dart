import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdventureRepository (integration with in-memory DB)', () {
    late AppDb db;
    late AdventureRepository repo;

    setUp(() {
      db = AppDb(NativeDatabase.memory());
      repo = AdventureRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('create -> getById -> update -> delete', () async {
      // Ensure campaign exists (FK constraint for chapters)
      await db
          .into(db.campaigns)
          .insert(
            CampaignsCompanion.insert(
              name: 'campx',
              description: 'desc',
              entityIds: <String>[],
              rev: 1,
            ),
          );
      final campId = (await db.select(db.campaigns).get()).first.id;

      // Ensure chapter exists (FK constraint) - use Value wrappers
      await db
          .into(db.chapters)
          .insert(
            ChaptersCompanion.insert(
              campaignId: campId,
              name: 'Chapter 1',
              order: 1,
              entityIds: <String>[],
              rev: 1,
            ),
          );
      final chapId = (await db.select(db.chapters).get()).first.id;

      final adventure = Adventure(
        id: 'adv1',
        chapterId: chapId,
        name: 'Test Adventure',
        order: 1,
        summary: null,
        content: null,
        entityIds: <String>[],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
      );

      final created = await repo.create(adventure);
      expect(created.id, equals('adv1'));

      final fetched = await repo.getById('adv1');
      expect(fetched, isNotNull);
      expect(fetched!.name, equals('Test Adventure'));

      final updatedAdventure = Adventure(
        id: 'adv1',
        chapterId: 'ch1',
        name: 'Updated',
        order: 1,
        summary: null,
        content: null,
        entityIds: <String>[],
        createdAt: created.createdAt,
        updatedAt: DateTime.now(),
        rev: created.rev + 1,
      );

      final updated = await repo.update(updatedAdventure);
      expect(updated.name, equals('Updated'));

      await repo.delete('adv1');
      final afterDelete = await repo.getById('adv1');
      expect(afterDelete, isNull);
    });
  });
}
