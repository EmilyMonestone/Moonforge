import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:moonforge/data/db/app_db.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('campaign insert without id generates uuid', () async {
    final db = AppDb(NativeDatabase.memory());
    final before = await db.select(db.campaigns).get();

    final inserted = await db
        .into(db.campaigns)
        .insertReturning(
          CampaignsCompanion.insert(
            name: 'Test Campaign',
            description: 'Desc',
            entityIds: <String>[], // empty list handled by StringListConverter
            rev: 1,
          ),
        );

    expect(inserted.id, isNotEmpty);
    expect(inserted.id.length > 10, true); // simple sanity

    final after = await db.select(db.campaigns).get();
    expect(after.length, before.length + 1);

    await db.close();
  });
}
