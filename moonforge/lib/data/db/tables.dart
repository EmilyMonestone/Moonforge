import 'package:drift/drift.dart';
import 'converters.dart';

class Campaigns extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  // Quill editor delta (JSON text)
  TextColumn get content => text().nullable().map(quillConv)();
  TextColumn get ownerUid => text().nullable()();
  TextColumn get memberUids => text().map(const StringListConverter()).nullable()();
  TextColumn get entityIds => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override Set<Column> get primaryKey => {id};
}

class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get campaignId => text().references(Campaigns, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn  get order => integer()();
  TextColumn get summary => text().nullable()();
  // Quill editor delta (JSON text)
  TextColumn get content => text().nullable().map(quillConv)();
  TextColumn get entityIds => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override Set<Column> get primaryKey => {id};
}

class Adventures extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId => text().references(Chapters, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn  get order => integer()();
  TextColumn get summary => text().nullable()();
  // Quill editor delta (JSON text)
  TextColumn get content => text().nullable().map(quillConv)();
  TextColumn get entityIds => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override Set<Column> get primaryKey => {id};
}

class Scenes extends Table {
  TextColumn get id => text()();
  TextColumn get adventureId => text().references(Adventures, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn  get order => integer()();
  TextColumn get summary => text().nullable()();
  // Quill editor delta (JSON text)
  TextColumn get content => text().nullable().map(quillConv)();
  TextColumn get entityIds => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override Set<Column> get primaryKey => {id};
}

class Parties extends Table {
  TextColumn get id => text()();
  TextColumn get campaignId => text().references(Campaigns, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get summary => text().nullable()();
  TextColumn get memberEntityIds => text().map(const StringListConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override Set<Column> get primaryKey => {id};
}

class Encounters extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get originId => text()(); // campaign/chapter/adventure/scene id
  BoolColumn get preset => boolean()();
  TextColumn get notes => text().nullable()();
  TextColumn get loot  => text().nullable()();
  TextColumn get combatants => text().map(const MapListConverter()).nullable()();
  TextColumn get entityIds => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override Set<Column> get primaryKey => {id};
}

class Entities extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get name => text()();
  TextColumn get originId => text()(); // campaign/chapter/adventure/scene id
  TextColumn get summary => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter()).nullable()();
  TextColumn get statblock => text().map(const MapJsonConverter())();  // Map JSON
  TextColumn get placeType => text().nullable()();
  TextColumn get parentPlaceId => text().nullable()();
  TextColumn get coords => text().map(const MapJsonConverter())();     // Map JSON
  // Quill editor delta (JSON text)
  TextColumn get content => text().nullable().map(quillConv)();
  TextColumn get images => text().map(const MapListConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  TextColumn get members => text().map(const StringListConverter()).nullable()();
  @override Set<Column> get primaryKey => {id};
}

class Combatants extends Table {
  TextColumn get id => text()();
  TextColumn get encounterId => text().references(Encounters, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get type => text()(); // enum as TEXT
  BoolColumn get isAlly => boolean()();
  IntColumn get currentHp => integer()();
  IntColumn get maxHp => integer()();
  IntColumn get armorClass => integer()();
  IntColumn get initiative => integer().nullable()();
  IntColumn get initiativeModifier => integer()();
  TextColumn get entityId => text().nullable()();
  TextColumn get bestiaryName => text().nullable()();
  TextColumn get cr => text().nullable()();
  IntColumn get xp => integer()();
  TextColumn get conditions => text().map(const StringListConverter())();
  TextColumn get notes => text().nullable()();
  IntColumn get order => integer()();
  @override Set<Column> get primaryKey => {id};
}

class MediaAssets extends Table {
  TextColumn get id => text()();
  TextColumn get filename => text()();
  IntColumn get size => integer()();
  TextColumn get mime => text()();
  TextColumn get captions => text().map(const StringListConverter()).nullable()();
  TextColumn get alt => text().nullable()();
  TextColumn get variants => text().map(const MapListConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override Set<Column> get primaryKey => {id};
}

class Sessions extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  // Quill editor delta (JSON text) - DM-only notes
  TextColumn get info => text().nullable().map(quillConv)();
  DateTimeColumn get datetime => dateTime().nullable()();
  // Quill editor delta (JSON text) - shared with players
  TextColumn get log => text().nullable().map(quillConv)();
  TextColumn get shareToken => text().nullable()();
  BoolColumn get shareEnabled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get shareExpiresAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override Set<Column> get primaryKey => {id};
}

// Outbox for sync (local -> cloud)
class OutboxEntries extends Table {
  TextColumn get id => text()();                // uuid
  TextColumn get table => text()();             // e.g. 'campaigns'
  TextColumn get rowId => text()();             // pk of target row
  TextColumn get op => text()();                // 'upsert' | 'delete'
  DateTimeColumn get changedAt => dateTime()(); // local time
  TextColumn get payload => text().nullable()();// optional JSON snapshot
  @override Set<Column> get primaryKey => {id};
}
