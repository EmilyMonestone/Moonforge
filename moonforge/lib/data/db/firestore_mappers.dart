import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' as drift;
import 'package:moonforge/data/db/app_db.dart';

/// Firestore <-> Drift mapping helpers

// Helpers to coerce dynamic Firestore values to expected shapes
Map<String, dynamic>? _asMap(dynamic v) {
  if (v == null) return null;
  if (v is Map<String, dynamic>) return v;
  if (v is Map) return Map<String, dynamic>.from(v);
  if (v is List) return <String, dynamic>{'ops': v};
  if (v is String) {
    try {
      final decoded = jsonDecode(v);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      if (decoded is List) return <String, dynamic>{'ops': decoded};
    } catch (_) {}
    return null;
  }
  return null;
}

List<String>? _asStringList(dynamic v) {
  if (v == null) return null;
  if (v is List) return v.map((e) => e.toString()).toList();
  return null;
}

List<Map<String, dynamic>>? _asMapList(dynamic v) {
  if (v == null) return null;
  if (v is List) {
    return v
        .map(
          (e) => e is Map<String, dynamic>
              ? e
              : e is Map
              ? Map<String, dynamic>.from(e)
              : null,
        )
        .whereType<Map<String, dynamic>>()
        .toList();
  }
  return null;
}

// Campaign mappers
Map<String, Object?> campaignToFirestore(Campaign c) => {
  'name': c.name,
  'description': c.description,
  'content': c.content,
  'ownerUid': c.ownerUid,
  'memberUids': c.memberUids,
  'entityIds': c.entityIds,
  'createdAt': c.createdAt != null ? Timestamp.fromDate(c.createdAt!) : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': c.rev,
};

CampaignsCompanion campaignFromFirestore(String id, Map<String, dynamic> d) {
  return CampaignsCompanion(
    id: drift.Value(id),
    name: drift.Value(d['name'] as String),
    description: drift.Value(d['description'] as String),
    content: drift.Value(_asMap(d['content'])),
    ownerUid: drift.Value(d['ownerUid'] as String?),
    memberUids: drift.Value(_asStringList(d['memberUids']) ?? <String>[]),
    entityIds: drift.Value(_asStringList(d['entityIds']) ?? <String>[]),
    createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
    updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
    rev: drift.Value((d['rev'] as int?) ?? 0),
  );
}

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

ChaptersCompanion chapterFromFirestore(String id, Map<String, dynamic> d) {
  return ChaptersCompanion(
    id: drift.Value(id),
    campaignId: drift.Value(d['campaignId'] as String),
    name: drift.Value(d['name'] as String),
    order: drift.Value(d['order'] as int),
    summary: drift.Value(d['summary'] as String?),
    content: drift.Value(_asMap(d['content'])),
    entityIds: drift.Value(_asStringList(d['entityIds']) ?? <String>[]),
    createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
    updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
    rev: drift.Value((d['rev'] as int?) ?? 0),
  );
}

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

AdventuresCompanion adventureFromFirestore(String id, Map<String, dynamic> d) {
  return AdventuresCompanion(
    id: drift.Value(id),
    chapterId: drift.Value(d['chapterId'] as String),
    name: drift.Value(d['name'] as String),
    order: drift.Value(d['order'] as int),
    summary: drift.Value(d['summary'] as String?),
    content: drift.Value(_asMap(d['content'])),
    entityIds: drift.Value(_asStringList(d['entityIds']) ?? <String>[]),
    createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
    updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
    rev: drift.Value((d['rev'] as int?) ?? 0),
  );
}

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

ScenesCompanion sceneFromFirestore(String id, Map<String, dynamic> d) {
  return ScenesCompanion(
    id: drift.Value(id),
    adventureId: drift.Value(d['adventureId'] as String),
    name: drift.Value(d['name'] as String),
    order: drift.Value(d['order'] as int),
    summary: drift.Value(d['summary'] as String?),
    content: drift.Value(_asMap(d['content'])),
    entityIds: drift.Value(_asStringList(d['entityIds']) ?? <String>[]),
    createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
    updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
    rev: drift.Value((d['rev'] as int?) ?? 0),
  );
}

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

PartiesCompanion partyFromFirestore(String id, Map<String, dynamic> d) {
  return PartiesCompanion(
    id: drift.Value(id),
    campaignId: drift.Value(d['campaignId'] as String),
    name: drift.Value(d['name'] as String),
    summary: drift.Value(d['summary'] as String?),
    memberEntityIds: drift.Value(_asStringList(d['memberEntityIds'])),
    memberPlayerIds: drift.Value(_asStringList(d['memberPlayerIds'])),
    createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
    updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
    rev: drift.Value((d['rev'] as int?) ?? 0),
  );
}

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

EncountersCompanion encounterFromFirestore(String id, Map<String, dynamic> d) {
  return EncountersCompanion(
    id: drift.Value(id),
    name: drift.Value(d['name'] as String),
    originId: drift.Value(d['originId'] as String),
    preset: drift.Value(d['preset'] as bool),
    notes: drift.Value(d['notes'] as String?),
    loot: drift.Value(d['loot'] as String?),
    combatants: drift.Value(_asMapList(d['combatants'])),
    entityIds: drift.Value(_asStringList(d['entityIds']) ?? <String>[]),
    createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
    updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
    rev: drift.Value((d['rev'] as int?) ?? 0),
  );
}

// Entity mappers
Map<String, Object?> entityToFirestore(Entity e) => {
  'kind': e.kind,
  'name': e.name,
  'originType': e.originType, // new
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

EntitiesCompanion entityFromFirestore(String id, Map<String, dynamic> d) {
  return EntitiesCompanion(
    id: drift.Value(id),
    kind: drift.Value(d['kind'] as String),
    name: drift.Value(d['name'] as String),
    originType: drift.Value((d['originType'] as String?) ?? 'campaign'),
    originId: drift.Value(d['originId'] as String),
    summary: drift.Value(d['summary'] as String?),
    tags: drift.Value(_asStringList(d['tags'])),
    statblock: drift.Value(_asMap(d['statblock']) ?? <String, dynamic>{}),
    placeType: drift.Value(d['placeType'] as String?),
    parentPlaceId: drift.Value(d['parentPlaceId'] as String?),
    coords: drift.Value(_asMap(d['coords']) ?? <String, dynamic>{}),
    content: drift.Value(_asMap(d['content'])),
    images: drift.Value(_asMapList(d['images'])),
    createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
    updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
    rev: drift.Value((d['rev'] as int?) ?? 0),
    deleted: drift.Value((d['deleted'] ?? false) as bool),
    members: drift.Value(_asStringList(d['members'])),
  );
}

// Combatant mappers (not typically synced to Firestore independently)
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
) {
  return MediaAssetsCompanion(
    id: drift.Value(id),
    filename: drift.Value(d['filename'] as String),
    size: drift.Value(d['size'] as int),
    mime: drift.Value(d['mime'] as String),
    captions: drift.Value(_asStringList(d['captions'])),
    alt: drift.Value(d['alt'] as String?),
    variants: drift.Value(_asMapList(d['variants'])),
    createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
    updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
    rev: drift.Value((d['rev'] as int?) ?? 0),
  );
}

// Session mappers
Map<String, Object?> sessionToFirestore(Session s) => {
  'createdAt': s.createdAt != null ? Timestamp.fromDate(s.createdAt!) : null,
  'info': s.info,
  'datetime': s.datetime != null ? Timestamp.fromDate(s.datetime!) : null,
  'log': s.log,
  'shareToken': s.shareToken,
  'shareEnabled': s.shareEnabled,
  'shareExpiresAt': s.shareExpiresAt != null
      ? Timestamp.fromDate(s.shareExpiresAt!)
      : null,
  'updatedAt': FieldValue.serverTimestamp(),
  'rev': s.rev,
};

SessionsCompanion sessionFromFirestore(String id, Map<String, dynamic> d) {
  return SessionsCompanion(
    id: drift.Value(id),
    createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
    info: drift.Value(_asMap(d['info'])),
    datetime: drift.Value((d['datetime'] as Timestamp?)?.toDate()),
    log: drift.Value(_asMap(d['log'])),
    shareToken: drift.Value(d['shareToken'] as String?),
    shareEnabled: drift.Value((d['shareEnabled'] ?? false) as bool),
    shareExpiresAt: drift.Value((d['shareExpiresAt'] as Timestamp?)?.toDate()),
    updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
    rev: drift.Value((d['rev'] as int?) ?? 0),
  );
}

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

PlayersCompanion playerFromFirestore(String id, Map<String, dynamic> d) {
  return PlayersCompanion(
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
      _asStringList(d['savingThrowProficiencies']),
    ),
    skillProficiencies: drift.Value(_asStringList(d['skillProficiencies'])),
    languages: drift.Value(_asStringList(d['languages'])),
    equipment: drift.Value(_asStringList(d['equipment'])),
    features: drift.Value(_asMapList(d['features'])),
    spells: drift.Value(_asStringList(d['spells'])),
    notes: drift.Value(_asMap(d['notes'])),
    bio: drift.Value(_asMap(d['bio'])),
    createdAt: drift.Value((d['createdAt'] as Timestamp?)?.toDate()),
    updatedAt: drift.Value((d['updatedAt'] as Timestamp?)?.toDate()),
    rev: drift.Value((d['rev'] as int?) ?? 0),
    deleted: drift.Value((d['deleted'] ?? false) as bool),
  );
}
