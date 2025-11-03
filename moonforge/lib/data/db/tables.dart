import 'package:drift/drift.dart';

import 'converters.dart';

class Campaigns extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  // Quill editor delta (JSON text)
  TextColumn get content => text().nullable().map(quillConv)();
  TextColumn get ownerUid => text().nullable()();
  TextColumn get memberUids =>
      text().map(const StringListConverter()).nullable()();
  TextColumn get entityIds => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get campaignId =>
      text().references(Campaigns, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get order => integer()();
  TextColumn get summary => text().nullable()();
  // Quill editor delta (JSON text)
  TextColumn get content => text().nullable().map(quillConv)();
  TextColumn get entityIds => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Adventures extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId =>
      text().references(Chapters, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get order => integer()();
  TextColumn get summary => text().nullable()();
  // Quill editor delta (JSON text)
  TextColumn get content => text().nullable().map(quillConv)();
  TextColumn get entityIds => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Scenes extends Table {
  TextColumn get id => text()();
  TextColumn get adventureId =>
      text().references(Adventures, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get order => integer()();
  TextColumn get summary => text().nullable()();
  // Quill editor delta (JSON text)
  TextColumn get content => text().nullable().map(quillConv)();
  TextColumn get entityIds => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Parties extends Table {
  TextColumn get id => text()();
  TextColumn get campaignId =>
      text().references(Campaigns, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get summary => text().nullable()();
  // Legacy: entity-based membership
  TextColumn get memberEntityIds =>
      text().map(const StringListConverter()).nullable()();
  // New: player-based membership
  TextColumn get memberPlayerIds =>
      text().map(const StringListConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Encounters extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get originId => text()(); // campaign/chapter/adventure/scene id
  BoolColumn get preset => boolean()();
  TextColumn get notes => text().nullable()();
  TextColumn get loot => text().nullable()();
  TextColumn get combatants =>
      text().map(const MapListConverter()).nullable()();
  TextColumn get entityIds => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override
  Set<Column> get primaryKey => {id};
}

class Entities extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get name => text()();
  TextColumn get originId => text()(); // campaign/chapter/adventure/scene id
  TextColumn get summary => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter()).nullable()();
  TextColumn get statblock =>
      text().map(const MapJsonConverter())(); // Map JSON
  TextColumn get placeType => text().nullable()();
  TextColumn get parentPlaceId => text().nullable()();
  TextColumn get coords => text().map(const MapJsonConverter())(); // Map JSON
  // Quill editor delta (JSON text)
  TextColumn get content => text().nullable().map(quillConv)();
  TextColumn get images => text().map(const MapListConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  TextColumn get members =>
      text().map(const StringListConverter()).nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class Combatants extends Table {
  TextColumn get id => text()();
  TextColumn get encounterId =>
      text().references(Encounters, #id, onDelete: KeyAction.cascade)();
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
  @override
  Set<Column> get primaryKey => {id};
}

class MediaAssets extends Table {
  TextColumn get id => text()();
  TextColumn get filename => text()();
  IntColumn get size => integer()();
  TextColumn get mime => text()();
  TextColumn get captions =>
      text().map(const StringListConverter()).nullable()();
  TextColumn get alt => text().nullable()();
  TextColumn get variants => text().map(const MapListConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer()();
  @override
  Set<Column> get primaryKey => {id};
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
  @override
  Set<Column> get primaryKey => {id};
}

// New: Players table representing PC character sheets
class Players extends Table {
  TextColumn get id => text()();
  TextColumn get campaignId =>
      text().references(Campaigns, #id, onDelete: KeyAction.cascade)();
  TextColumn get playerUid => text().nullable()(); // optional Firebase Auth UID
  TextColumn get name => text()();
  TextColumn get className => text()();
  TextColumn get subclass => text().nullable()();
  IntColumn get level => integer().withDefault(const Constant(1))();
  TextColumn get race => text().nullable()();
  TextColumn get background => text().nullable()();
  TextColumn get alignment => text().nullable()();

  // Ability scores
  IntColumn get str => integer().withDefault(const Constant(10))();
  IntColumn get dex => integer().withDefault(const Constant(10))();
  IntColumn get con => integer().withDefault(const Constant(10))();
  IntColumn get intl => integer().withDefault(
    const Constant(10),
  )(); // 'int' reserved in Dart, use 'intl'
  IntColumn get wis => integer().withDefault(const Constant(10))();
  IntColumn get cha => integer().withDefault(const Constant(10))();

  // Core stats
  IntColumn get hpMax => integer().nullable()();
  IntColumn get hpCurrent => integer().nullable()();
  IntColumn get hpTemp => integer().nullable()();
  IntColumn get ac => integer().nullable()();
  IntColumn get proficiencyBonus => integer().nullable()();
  IntColumn get speed => integer().nullable()();

  // Arrays and rich fields
  TextColumn get savingThrowProficiencies =>
      text().map(const StringListConverter()).nullable()();
  TextColumn get skillProficiencies =>
      text().map(const StringListConverter()).nullable()();
  TextColumn get languages =>
      text().map(const StringListConverter()).nullable()();
  TextColumn get equipment =>
      text().map(const StringListConverter()).nullable()();
  TextColumn get features => text().map(const MapListConverter()).nullable()();
  TextColumn get spells => text().map(const StringListConverter()).nullable()();

  // Rich text (Quill) fields
  TextColumn get notes => text().nullable().map(quillConv)();
  TextColumn get bio => text().nullable().map(quillConv)();

  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  IntColumn get rev => integer().withDefault(const Constant(1))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

// Outbox for sync (local -> cloud)
class OutboxEntries extends Table {
  TextColumn get id => text()(); // uuid
  TextColumn get table => text()(); // e.g. 'campaigns'
  TextColumn get rowId => text()(); // pk of target row
  TextColumn get op => text()(); // 'upsert' | 'delete'
  DateTimeColumn get changedAt => dateTime()(); // local time
  TextColumn get payload => text().nullable()(); // optional JSON snapshot
  @override
  Set<Column> get primaryKey => {id};
}
