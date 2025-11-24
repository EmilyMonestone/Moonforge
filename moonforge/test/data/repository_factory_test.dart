import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/repository_factory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('RepositoryFactory constructs repositories', () async {
    // Use an in-memory native database for fast, isolated tests
    final db = AppDb(NativeDatabase.memory());
    final factory = RepositoryFactory(db);

    expect(factory.campaignRepo(), isNotNull);
    expect(factory.chapterRepo(), isNotNull);
    expect(factory.adventureRepo(), isNotNull);
    expect(factory.sceneRepo(), isNotNull);
    expect(factory.encounterRepo(), isNotNull);
    expect(factory.entityRepo(), isNotNull);
    expect(factory.partyRepo(), isNotNull);
    expect(factory.sessionRepo(), isNotNull);
    expect(factory.mediaRepo(), isNotNull);
    expect(factory.playerRepo(), isNotNull);
    expect(factory.combatantRepo(), isNotNull);

    await db.close();
  });
}
