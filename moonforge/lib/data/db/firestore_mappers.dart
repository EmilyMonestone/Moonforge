import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' as drift;
import 'package:moonforge/data/db/app_db.dart';

/// Firestore <-> Drift mapping helpers

// Campaign mappers
Map<String, Object?> campaignToFirestore(Campaign c) => {
  'name': c.name,
  'description': c.description,
  'content': c.content, // Quill JSON (Map) – Firestore stores natively
  'ownerUid': c.ownerUid,
  'memberUids': c.memberUids,
  'entityIds': c.entityIds,
  'createdAt': c.createdAt != null ? Timestamp.fromDate(c.createdAt!) : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': c.rev,
};

CampaignsCompanion campaignFromFirestore(String id, Map<String, dynamic> d) =>
    CampaignsCompanion(
      id: drift.Value(id),
      name: drift.Value(d['name'] as String),
      description: drift.Value(d['description'] as String),
      content: drift.Value(d['content'] as Map<String, dynamic>?),
      ownerUid: drift.Value(d['ownerUid'] as String?),
      memberUids: drift.Value(
        ((d['memberUids'] ?? <String>[]) as List).cast<String>(),
      ),
      entityIds: drift.Value(
        ((d['entityIds'] ?? <String>[]) as List).cast<String>(),
      ),
      createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
      updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
      rev: drift.Value((d['rev'] as int?) ?? 0),
    );

// Chapter mappers
Map<String, Object?> chapterToFirestore(Chapter c) => {
  'campaignId': c.campaignId,
  'name': c.name,
  'order': c.order,
  'summary': c.summary,
  'content': c.content,
  'entityIds': c.entityIds,
  'createdAt': c.createdAt != null ? Timestamp.fromDate(c.createdAt!) : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': c.rev,
};

ChaptersCompanion chapterFromFirestore(String id, Map<String, dynamic> d) =>
    ChaptersCompanion(
      id: drift.Value(id),
      campaignId: drift.Value(d['campaignId'] as String),
      name: drift.Value(d['name'] as String),
      order: drift.Value(d['order'] as int),
      summary: drift.Value(d['summary'] as String?),
      content: drift.Value(d['content'] as Map<String, dynamic>?),
      entityIds: drift.Value(
        ((d['entityIds'] ?? <String>[]) as List).cast<String>(),
      ),
      createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
      updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
      rev: drift.Value((d['rev'] as int?) ?? 0),
    );

// Adventure mappers
Map<String, Object?> adventureToFirestore(Adventure a) => {
  'chapterId': a.chapterId,
  'name': a.name,
  'order': a.order,
  'summary': a.summary,
  'content': a.content,
  'entityIds': a.entityIds,
  'createdAt': a.createdAt != null ? Timestamp.fromDate(a.createdAt!) : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': a.rev,
};

AdventuresCompanion adventureFromFirestore(String id, Map<String, dynamic> d) =>
    AdventuresCompanion(
      id: drift.Value(id),
      chapterId: drift.Value(d['chapterId'] as String),
      name: drift.Value(d['name'] as String),
      order: drift.Value(d['order'] as int),
      summary: drift.Value(d['summary'] as String?),
      content: drift.Value(d['content'] as Map<String, dynamic>?),
      entityIds: drift.Value(
        ((d['entityIds'] ?? <String>[]) as List).cast<String>(),
      ),
      createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
      updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
      rev: drift.Value((d['rev'] as int?) ?? 0),
    );

// Scene mappers
Map<String, Object?> sceneToFirestore(Scene s) => {
  'adventureId': s.adventureId,
  'name': s.name,
  'order': s.order,
  'summary': s.summary,
  'content': s.content,
  'entityIds': s.entityIds,
  'createdAt': s.createdAt != null ? Timestamp.fromDate(s.createdAt!) : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': s.rev,
};

ScenesCompanion sceneFromFirestore(String id, Map<String, dynamic> d) =>
    ScenesCompanion(
      id: drift.Value(id),
      adventureId: drift.Value(d['adventureId'] as String),
      name: drift.Value(d['name'] as String),
      order: drift.Value(d['order'] as int),
      summary: drift.Value(d['summary'] as String?),
      content: drift.Value(d['content'] as Map<String, dynamic>?),
      entityIds: drift.Value(
        ((d['entityIds'] ?? <String>[]) as List).cast<String>(),
      ),
      createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
      updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
      rev: drift.Value((d['rev'] as int?) ?? 0),
    );

// Party mappers
Map<String, Object?> partyToFirestore(Party p) => {
  'campaignId': p.campaignId,
  'name': p.name,
  'summary': p.summary,
  'memberEntityIds': p.memberEntityIds,
  'memberPlayerIds': p.memberPlayerIds,
  'createdAt': p.createdAt != null ? Timestamp.fromDate(p.createdAt!) : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': p.rev,
};

PartiesCompanion partyFromFirestore(String id, Map<String, dynamic> d) =>
    PartiesCompanion(
      id: drift.Value(id),
      campaignId: drift.Value(d['campaignId'] as String),
      name: drift.Value(d['name'] as String),
      summary: drift.Value(d['summary'] as String?),
      memberEntityIds: drift.Value(
        ((d['memberEntityIds'] ?? <String>[]) as List?)?.cast<String>(),
      ),
      memberPlayerIds: drift.Value(
        ((d['memberPlayerIds'] ?? <String>[]) as List?)?.cast<String>(),
      ),
      createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
      updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
      rev: drift.Value((d['rev'] as int?) ?? 0),
    );

// Encounter mappers
Map<String, Object?> encounterToFirestore(Encounter e) => {
  'name': e.name,
  'originId': e.originId,
  'preset': e.preset,
  'notes': e.notes,
  'loot': e.loot,
  'combatants': e.combatants,
  'entityIds': e.entityIds,
  'createdAt': e.createdAt != null ? Timestamp.fromDate(e.createdAt!) : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': e.rev,
};

EncountersCompanion encounterFromFirestore(String id, Map<String, dynamic> d) =>
    EncountersCompanion(
      id: drift.Value(id),
      name: drift.Value(d['name'] as String),
      originId: drift.Value(d['originId'] as String),
      preset: drift.Value(d['preset'] as bool),
      notes: drift.Value(d['notes'] as String?),
      loot: drift.Value(d['loot'] as String?),
      combatants: drift.Value(
        ((d['combatants'] ?? <Map>[]) as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList(),
      ),
      entityIds: drift.Value(
        ((d['entityIds'] ?? <String>[]) as List).cast<String>(),
      ),
      createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
      updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
      rev: drift.Value((d['rev'] as int?) ?? 0),
    );

// Entity mappers
Map<String, Object?> entityToFirestore(Entity e) => {
  'kind': e.kind,
  'name': e.name,
  'originId': e.originId,
  'summary': e.summary,
  'tags': e.tags,
  'statblock': e.statblock,
  'placeType': e.placeType,
  'parentPlaceId': e.parentPlaceId,
  'coords': e.coords,
  'content': e.content,
  'images': e.images,
  'createdAt': e.createdAt != null ? Timestamp.fromDate(e.createdAt!) : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': e.rev,
  'deleted': e.deleted,
  'members': e.members,
};

EntitiesCompanion entityFromFirestore(
  String id,
  Map<String, dynamic> d,
) => EntitiesCompanion(
  id: drift.Value(id),
  kind: drift.Value(d['kind'] as String),
  name: drift.Value(d['name'] as String),
  originId: drift.Value(d['originId'] as String),
  summary: drift.Value(d['summary'] as String?),
  tags: drift.Value(((d['tags'] ?? <String>[]) as List?)?.cast<String>()),
  statblock: drift.Value(
    Map<String, dynamic>.from((d['statblock'] ?? {}) as Map),
  ),
  placeType: drift.Value(d['placeType'] as String?),
  parentPlaceId: drift.Value(d['parentPlaceId'] as String?),
  coords: drift.Value(Map<String, dynamic>.from((d['coords'] ?? {}) as Map)),
  content: drift.Value(d['content'] as Map<String, dynamic>?),
  images: drift.Value(
    ((d['images'] ?? <Map>[]) as List?)
        ?.map((e) => Map<String, dynamic>.from(e as Map))
        .toList(),
  ),
  createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
  updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
  rev: drift.Value((d['rev'] as int?) ?? 0),
  deleted: drift.Value((d['deleted'] ?? false) as bool),
  members: drift.Value(((d['members'] ?? <String>[]) as List?)?.cast<String>()),
);

// Combatant mappers (not typically synced to Firestore independently, but included for completeness)
Map<String, Object?> combatantToFirestore(Combatant c) => {
  'encounterId': c.encounterId,
  'name': c.name,
  'type': c.type,
  'isAlly': c.isAlly,
  'currentHp': c.currentHp,
  'maxHp': c.maxHp,
  'armorClass': c.armorClass,
  'initiative': c.initiative,
  'initiativeModifier': c.initiativeModifier,
  'entityId': c.entityId,
  'bestiaryName': c.bestiaryName,
  'cr': c.cr,
  'xp': c.xp,
  'conditions': c.conditions,
  'notes': c.notes,
  'order': c.order,
};

// MediaAsset mappers
Map<String, Object?> mediaAssetToFirestore(MediaAsset m) => {
  'filename': m.filename,
  'size': m.size,
  'mime': m.mime,
  'captions': m.captions,
  'alt': m.alt,
  'variants': m.variants,
  'createdAt': m.createdAt != null ? Timestamp.fromDate(m.createdAt!) : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': m.rev,
};

MediaAssetsCompanion mediaAssetFromFirestore(
  String id,
  Map<String, dynamic> d,
) => MediaAssetsCompanion(
  id: drift.Value(id),
  filename: drift.Value(d['filename'] as String),
  size: drift.Value(d['size'] as int),
  mime: drift.Value(d['mime'] as String),
  captions: drift.Value(
    ((d['captions'] ?? <String>[]) as List?)?.cast<String>(),
  ),
  alt: drift.Value(d['alt'] as String?),
  variants: drift.Value(
    ((d['variants'] ?? <Map>[]) as List?)
        ?.map((e) => Map<String, dynamic>.from(e as Map))
        .toList(),
  ),
  createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
  updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
  rev: drift.Value((d['rev'] as int?) ?? 0),
);

// Session mappers
Map<String, Object?> sessionToFirestore(Session s) => {
  'createdAt': s.createdAt != null ? Timestamp.fromDate(s.createdAt!) : null,
  'info': s.info, // Quill JSON
  'datetime': s.datetime != null ? Timestamp.fromDate(s.datetime!) : null,
  'log': s.log, // Quill JSON
  'shareToken': s.shareToken,
  'shareEnabled': s.shareEnabled,
  'shareExpiresAt': s.shareExpiresAt != null
      ? Timestamp.fromDate(s.shareExpiresAt!)
      : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': s.rev,
};

SessionsCompanion sessionFromFirestore(String id, Map<String, dynamic> d) =>
    SessionsCompanion(
      id: drift.Value(id),
      createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
      info: drift.Value(d['info'] as Map<String, dynamic>?),
      datetime: drift.Value((d['datetime'] as Timestamp?)?.toDate()),
      log: drift.Value(d['log'] as Map<String, dynamic>?),
      shareToken: drift.Value(d['shareToken'] as String?),
      shareEnabled: drift.Value((d['shareEnabled'] ?? false) as bool),
      shareExpiresAt: drift.Value(
        (d['shareExpiresAt'] as Timestamp?)?.toDate(),
      ),
      updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
      rev: drift.Value((d['rev'] as int?) ?? 0),
    );

// Player mappers
Map<String, Object?> playerToFirestore(Player p) => {
  'campaignId': p.campaignId,
  'playerUid': p.playerUid,
  'name': p.name,
  'className': p.className,
  'subclass': p.subclass,
  'level': p.level,
  'race': p.race,
  'background': p.background,
  'alignment': p.alignment,
  'str': p.str,
  'dex': p.dex,
  'con': p.con,
  'int': p.intl,
  'wis': p.wis,
  'cha': p.cha,
  'hpMax': p.hpMax,
  'hpCurrent': p.hpCurrent,
  'hpTemp': p.hpTemp,
  'ac': p.ac,
  'proficiencyBonus': p.proficiencyBonus,
  'speed': p.speed,
  'savingThrowProficiencies': p.savingThrowProficiencies,
  'skillProficiencies': p.skillProficiencies,
  'languages': p.languages,
  'equipment': p.equipment,
  'features': p.features,
  'spells': p.spells,
  'notes': p.notes,
  'bio': p.bio,
  'createdAt': p.createdAt != null ? Timestamp.fromDate(p.createdAt!) : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': p.rev,
  'deleted': p.deleted,
};

PlayersCompanion playerFromFirestore(
  String id,
  Map<String, dynamic> d,
) => PlayersCompanion(
  id: drift.Value(id),
  campaignId: drift.Value(d['campaignId'] as String),
  playerUid: drift.Value(d['playerUid'] as String?),
  name: drift.Value(d['name'] as String),
  className: drift.Value(d['className'] as String),
  subclass: drift.Value(d['subclass'] as String?),
  level: drift.Value((d['level'] as int?) ?? 1),
  race: drift.Value(d['race'] as String?),
  background: drift.Value(d['background'] as String?),
  alignment: drift.Value(d['alignment'] as String?),
  str: drift.Value((d['str'] as int?) ?? 10),
  dex: drift.Value((d['dex'] as int?) ?? 10),
  con: drift.Value((d['con'] as int?) ?? 10),
  intl: drift.Value((d['int'] as int?) ?? 10),
  wis: drift.Value((d['wis'] as int?) ?? 10),
  cha: drift.Value((d['cha'] as int?) ?? 10),
  hpMax: drift.Value(d['hpMax'] as int?),
  hpCurrent: drift.Value(d['hpCurrent'] as int?),
  hpTemp: drift.Value(d['hpTemp'] as int?),
  ac: drift.Value(d['ac'] as int?),
  proficiencyBonus: drift.Value(d['proficiencyBonus'] as int?),
  speed: drift.Value(d['speed'] as int?),
  savingThrowProficiencies: drift.Value(
    ((d['savingThrowProficiencies'] ?? <String>[]) as List?)?.cast<String>(),
  ),
  skillProficiencies: drift.Value(
    ((d['skillProficiencies'] ?? <String>[]) as List?)?.cast<String>(),
  ),
  languages: drift.Value(
    ((d['languages'] ?? <String>[]) as List?)?.cast<String>(),
  ),
  equipment: drift.Value(
    ((d['equipment'] ?? <String>[]) as List?)?.cast<String>(),
  ),
  features: drift.Value(
    ((d['features'] ?? <Map>[]) as List?)
        ?.map((e) => Map<String, dynamic>.from(e as Map))
        .toList(),
  ),
  spells: drift.Value(((d['spells'] ?? <String>[]) as List?)?.cast<String>()),
  notes: drift.Value(d['notes'] as Map<String, dynamic>?),
  bio: drift.Value(d['bio'] as Map<String, dynamic>?),
  createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
  updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
  rev: drift.Value((d['rev'] as int?) ?? 0),
  deleted: drift.Value((d['deleted'] ?? false) as bool),
);
