import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/entity_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EntityRepository (in-memory DB)', () {
    late AppDb db;
    late EntityRepository repo;

    setUp(() {
      db = AppDb(NativeDatabase.memory());
      repo = EntityRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('create -> getById -> update -> delete', () async {
      // Ensure campaign exists for origin FK
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

      final entity = Entity(
        id: 'ent1',
        kind: 'npc',
        name: 'Goblin',
        originType: 'campaign',
        originId: (await db.select(db.campaigns).get()).first.id,
        summary: null,
        tags: null,
        statblock: <String, dynamic>{},
        placeType: null,
        parentPlaceId: null,
        coords: <String, dynamic>{},
        content: null,
        images: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
        deleted: false,
        members: null,
      );

      final created = await repo.create(entity);
      expect(created.id, 'ent1');

      final fetched = await repo.getById('ent1');
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Goblin');

      final updated = Entity(
        id: 'ent1',
        kind: 'npc',
        name: 'Goblin Chief',
        originType: entity.originType,
        originId: entity.originId,
        summary: entity.summary,
        tags: entity.tags,
        statblock: entity.statblock,
        placeType: entity.placeType,
        parentPlaceId: entity.parentPlaceId,
        coords: entity.coords,
        content: entity.content,
        images: entity.images,
        createdAt: entity.createdAt,
        updatedAt: DateTime.now(),
        rev: entity.rev + 1,
        deleted: entity.deleted,
        members: entity.members,
      );

      final up = await repo.update(updated);
      expect(up.name, 'Goblin Chief');

      await repo.delete('ent1');
      final after = await repo.getById('ent1');
      // Entities are soft-deleted; expect the deleted flag to be set
      expect(after, isNotNull);
      expect(after!.deleted, isTrue);
    });
  });
}
