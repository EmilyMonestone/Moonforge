import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/media_asset_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MediaAssetRepository (in-memory DB)', () {
    late AppDb db;
    late MediaAssetRepository repo;

    setUp(() {
      db = AppDb(NativeDatabase.memory());
      repo = MediaAssetRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('create -> getById -> update -> delete', () async {
      final asset = MediaAsset(
        id: 'asset1',
        filename: 'image.png',
        size: 1234,
        mime: 'image/png',
        captions: null,
        alt: null,
        variants: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rev: 1,
      );

      final created = await repo.create(asset);
      expect(created.id, 'asset1');

      final fetched = await repo.getById('asset1');
      expect(fetched, isNotNull);
      expect(fetched!.filename, 'image.png');

      final updated = MediaAsset(
        id: 'asset1',
        filename: 'image_updated.png',
        size: asset.size,
        mime: asset.mime,
        captions: asset.captions,
        alt: asset.alt,
        variants: asset.variants,
        createdAt: asset.createdAt,
        updatedAt: DateTime.now(),
        rev: asset.rev + 1,
      );

      final up = await repo.update(updated);
      expect(up.filename, 'image_updated.png');

      await repo.delete('asset1');
      final after = await repo.getById('asset1');
      expect(after, isNull);
    });
  });
}
