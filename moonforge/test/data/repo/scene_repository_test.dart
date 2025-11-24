import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/scene_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SceneRepository (in-memory DB)', () {
    late AppDb db;
    late SceneRepository repo;

    setUp(() {
      db = AppDb(NativeDatabase.memory());
      repo = SceneRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('create -> getById -> update -> delete', () async {
      // Need an adventure -> need campaign and chapter and adventure
      await db
          .into(db.campaigns)
          .insert(
            CampaignsCompanion.insert(
              name: 'camp',
              description: 'desc',
              entityIds: <String>[],
              rev: 1,
            ),
          );
      final campId = (await db.select(db.campaigns).get()).first.id;

      await db
          .into(db.chapters)
          .insert(
            ChaptersCompanion.insert(
              campaignId: campId,
              name: 'Chapter',
              order: 1,
              entityIds: <String>[],
              rev: 1,
            ),
          );
      final chapId = (await db.select(db.chapters).get()).first.id;

      await db
          .into(db.adventures)
          .insert(
            AdventuresCompanion.insert(
              chapterId: chapId,
              name: 'Adventure',
              order: 1,
              entityIds: <String>[],
              rev: 1,
            ),
          );
      final advId = (await db.select(db.adventures).get()).first.id;

      final scene = Scene(
        id: 'sc1',
        adventureId: advId,
        name: 'Scene 1',
        order: 1,
        summary: null,
        content: null,
        entityIds: <String>[],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
      );

      final created = await repo.create(scene);
      expect(created.id, 'sc1');

      final fetched = await repo.getById('sc1');
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Scene 1');

      final updated = Scene(
        id: 'sc1',
        adventureId: advId,
        name: 'Scene 1 Updated',
        order: 1,
        summary: scene.summary,
        content: scene.content,
        entityIds: scene.entityIds,
        createdAt: scene.createdAt,
        updatedAt: DateTime.now(),
        rev: scene.rev + 1,
      );

      final up = await repo.update(updated);
      expect(up.name, 'Scene 1 Updated');

      await repo.delete('sc1');
      final after = await repo.getById('sc1');
      expect(after, isNull);
    });
  });
}
