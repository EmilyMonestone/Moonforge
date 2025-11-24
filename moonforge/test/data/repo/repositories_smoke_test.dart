import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/repository_factory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('repository smoke: getAll returns lists for all repos', () async {
    final db = AppDb(NativeDatabase.memory());
    final factory = RepositoryFactory(db);

    // Construct repos
    final repos = <dynamic>[
      factory.campaignRepo(),
      factory.chapterRepo(),
      factory.adventureRepo(),
      factory.sceneRepo(),
      factory.encounterRepo(),
      factory.entityRepo(),
      factory.partyRepo(),
      factory.sessionRepo(),
      factory.mediaRepo(),
      factory.playerRepo(),
      factory.combatantRepo(),
    ];

    for (final repo in repos) {
      try {
        final all = await (repo as dynamic).getAll();
        expect(all, isA<List>());
      } catch (e) {
        // Rethrow with context for test failure clarity
        rethrow;
      }
    }

    await db.close();
  });
}
