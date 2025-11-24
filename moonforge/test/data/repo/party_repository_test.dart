import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/party_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PartyRepository (in-memory DB)', () {
    late AppDb db;
    late PartyRepository repo;

    setUp(() {
      db = AppDb(NativeDatabase.memory());
      repo = PartyRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('create -> getById -> update -> delete', () async {
      // Ensure campaign exists
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

      final campaignId = (await db.select(db.campaigns).get()).first.id;

      final party = Party(
        id: 'party1',
        campaignId: campaignId,
        name: 'Avengers',
        summary: null,
        memberEntityIds: <String>[],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
      );

      final created = await repo.create(party);
      expect(created.id, 'party1');

      final fetched = await repo.getById('party1');
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Avengers');

      final updated = Party(
        id: 'party1',
        campaignId: campaignId,
        name: 'Avengers Updated',
        summary: party.summary,
        memberEntityIds: party.memberEntityIds,
        createdAt: party.createdAt,
        updatedAt: DateTime.now(),
        rev: party.rev + 1,
      );

      final up = await repo.update(updated);
      expect(up.name, 'Avengers Updated');

      await repo.delete('party1');
      final after = await repo.getById('party1');
      expect(after, isNull);
    });
  });
}
