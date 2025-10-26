import 'package:drift/drift.dart';

/// Local metadata for tracking sync state of campaigns
/// Kept separate from domain model to avoid pollution
class CampaignLocalMetas extends Table {
  /// Foreign key to Campaigns.id
  TextColumn get docId => text()();
  
  /// Whether this document has unsync'd local changes
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();
  
  /// Last successful sync timestamp
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {docId};
}
