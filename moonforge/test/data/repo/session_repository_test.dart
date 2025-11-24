import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/session_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SessionRepository (in-memory DB)', () {
    late AppDb db;
    late SessionRepository repo;

    setUp(() {
      db = AppDb(NativeDatabase.memory());
      repo = SessionRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('create -> getById -> update -> delete', () async {
      final session = Session(
        id: 'sess1',
        createdAt: DateTime.now(),
        info: null,
        datetime: DateTime.now(),
        log: null,
        shareToken: null,
        shareEnabled: false,
        shareExpiresAt: null,
        updatedAt: DateTime.now(),
        rev: 1,
      );

      final created = await repo.create(session);
      expect(created.id, 'sess1');

      final fetched = await repo.getById('sess1');
      expect(fetched, isNotNull);
      expect(fetched!.id, 'sess1');

      final updated = Session(
        id: 'sess1',
        createdAt: session.createdAt,
        info: session.info,
        datetime: session.datetime,
        log: session.log,
        shareToken: session.shareToken,
        shareEnabled: session.shareEnabled,
        shareExpiresAt: session.shareExpiresAt,
        updatedAt: DateTime.now(),
        rev: session.rev + 1,
      );

      final up = await repo.update(updated);
      expect(up.rev, session.rev + 1);

      await repo.delete('sess1');
      final after = await repo.getById('sess1');
      expect(after, isNull);
    });
  });
}
