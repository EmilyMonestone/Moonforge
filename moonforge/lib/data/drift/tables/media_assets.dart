import 'package:drift/drift.dart';
import 'package:moonforge/data/drift/converters/json_list_converter.dart';
import 'package:moonforge/data/drift/converters/string_list_converter.dart';
import 'package:moonforge/data/firebase/models/media_asset.dart';

/// Drift table for MediaAsset, reusing the Freezed model via @UseRowClass
@UseRowClass(MediaAsset)
class MediaAssets extends Table {
  TextColumn get id => text()();

  TextColumn get filename => text()();

  IntColumn get size => integer()();

  TextColumn get mime => text()();

  TextColumn get captions =>
      text().nullable().map(const StringListConverter())();

  TextColumn get alt => text().nullable()();

  TextColumn get variants => text().nullable().map(const JsonListConverter())();

  DateTimeColumn get createdAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  IntColumn get rev => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
