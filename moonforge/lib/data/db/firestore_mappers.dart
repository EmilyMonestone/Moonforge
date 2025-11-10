import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drift/drift.dart' as drift;
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Firestore <-> Drift mapping helpers

// Tolerant date parser that handles various formats
DateTime? _asDate(dynamic v) {
  if (v == null) return null;
  
  // Handle Firestore Timestamp
  if (v is Timestamp) {
    return v.toDate();
  }
  
  // Handle integer (seconds or milliseconds since epoch)
  if (v is int) {
    // Heuristic: if < year 3000 in seconds (32503680000), treat as seconds
    // Otherwise treat as milliseconds
    if (v < 32503680000) {
      return DateTime.fromMillisecondsSinceEpoch(v * 1000);
    } else {
      return DateTime.fromMillisecondsSinceEpoch(v);
    }
  }
  
  // Handle string representations
  if (v is String) {
    // Handle epoch seconds with optional 'Z' suffix (e.g., "1761490548Z" or "1761490548")
    final trimmed = v.trim();
    if (trimmed.endsWith('Z')) {
      // Strip trailing Z and parse as int seconds
      final withoutZ = trimmed.substring(0, trimmed.length - 1);
      final seconds = int.tryParse(withoutZ);
      if (seconds != null) {
        return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      }
    }
    
    // Try parsing as plain integer (epoch seconds)
    final seconds = int.tryParse(trimmed);
    if (seconds != null) {
      // Same heuristic as above
      if (seconds < 32503680000) {
        return DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(seconds);
      }
    }
    
    // Try parsing as ISO8601 or other standard DateTime format
    try {
      return DateTime.parse(trimmed);
    } catch (_) {
      logger.w('Failed to parse date string: $v');
      return null;
    }
  }
  
  logger.w('Unexpected date type: ${v.runtimeType} for value: $v');
  return null;
}

// Helper for required string fields with safe fallback
String _reqString(dynamic v, {String fallback = ''}) {
  if (v == null) return fallback;
  if (v is String) return v;
  return v.toString();
}

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
    name: drift.Value(_reqString(d['name'], fallback: 'Untitled Campaign')),
    description: drift.Value(_reqString(d['description'])),
    content: drift.Value(_asMap(d['content'])),
    ownerUid: drift.Value(d['ownerUid'] as String?),
    memberUids: drift.Value(_asStringList(d['memberUids']) ?? <String>[]),
    entityIds: drift.Value(_asStringList(d['entityIds']) ?? <String>[]),
    createdAt: drift.Value(_asDate(d['createdAt'])),
    updatedAt: drift.Value(_asDate(d['updatedAt'])),
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
    campaignId: drift.Value(_reqString(d['campaignId'], fallback: '')),
    name: drift.Value(_reqString(d['name'], fallback: 'Untitled Chapter')),
    order: drift.Value((d['order'] as int?) ?? 0),
    summary: drift.Value(d['summary'] as String?),
    content: drift.Value(_asMap(d['content'])),
    entityIds: drift.Value(_asStringList(d['entityIds']) ?? <String>[]),
    createdAt: drift.Value(_asDate(d['createdAt'])),
    updatedAt: drift.Value(_asDate(d['updatedAt'])),
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
    chapterId: drift.Value(_reqString(d['chapterId'], fallback: '')),
    name: drift.Value(_reqString(d['name'], fallback: 'Untitled Adventure')),
    order: drift.Value((d['order'] as int?) ?? 0),
    summary: drift.Value(d['summary'] as String?),
    content: drift.Value(_asMap(d['content'])),
    entityIds: drift.Value(_asStringList(d['entityIds']) ?? <String>[]),
    createdAt: drift.Value(_asDate(d['createdAt'])),
    updatedAt: drift.Value(_asDate(d['updatedAt'])),
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
    adventureId: drift.Value(_reqString(d['adventureId'], fallback: '')),
    name: drift.Value(_reqString(d['name'], fallback: 'Untitled Scene')),
    order: drift.Value((d['order'] as int?) ?? 0),
    summary: drift.Value(d['summary'] as String?),
    content: drift.Value(_asMap(d['content'])),
    entityIds: drift.Value(_asStringList(d['entityIds']) ?? <String>[]),
    createdAt: drift.Value(_asDate(d['createdAt'])),
    updatedAt: drift.Value(_asDate(d['updatedAt'])),
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
    campaignId: drift.Value(_reqString(d['campaignId'], fallback: '')),
    name: drift.Value(_reqString(d['name'], fallback: 'Untitled Party')),
    summary: drift.Value(d['summary'] as String?),
    memberEntityIds: drift.Value(_asStringList(d['memberEntityIds'])),
    memberPlayerIds: drift.Value(_asStringList(d['memberPlayerIds'])),
    createdAt: drift.Value(_asDate(d['createdAt'])),
    updatedAt: drift.Value(_asDate(d['updatedAt'])),
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
    name: drift.Value(_reqString(d['name'], fallback: 'Untitled Encounter')),
    originId: drift.Value(_reqString(d['originId'], fallback: '')),
    preset: drift.Value((d['preset'] as bool?) ?? false),
    notes: drift.Value(d['notes'] as String?),
    loot: drift.Value(d['loot'] as String?),
    combatants: drift.Value(_asMapList(d['combatants'])),
    entityIds: drift.Value(_asStringList(d['entityIds']) ?? <String>[]),
    createdAt: drift.Value(_asDate(d['createdAt'])),
    updatedAt: drift.Value(_asDate(d['updatedAt'])),
    rev: drift.Value((d['rev'] as int?) ?? 0),
  );
}

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

EntitiesCompanion entityFromFirestore(String id, Map<String, dynamic> d) {
  return EntitiesCompanion(
    id: drift.Value(id),
    kind: drift.Value(_reqString(d['kind'], fallback: 'unknown')),
    name: drift.Value(_reqString(d['name'], fallback: 'Unnamed Entity')),
    originId: drift.Value(_reqString(d['originId'], fallback: '')),
    summary: drift.Value(d['summary'] as String?),
    tags: drift.Value(_asStringList(d['tags'])),
    statblock: drift.Value(_asMap(d['statblock']) ?? <String, dynamic>{}),
    placeType: drift.Value(d['placeType'] as String?),
    parentPlaceId: drift.Value(d['parentPlaceId'] as String?),
    coords: drift.Value(_asMap(d['coords']) ?? <String, dynamic>{}),
    content: drift.Value(_asMap(d['content'])),
    images: drift.Value(_asMapList(d['images'])),
    createdAt: drift.Value(_asDate(d['createdAt'])),
    updatedAt: drift.Value(_asDate(d['updatedAt'])),
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
    filename: drift.Value(_reqString(d['filename'], fallback: 'unknown')),
    size: drift.Value((d['size'] as int?) ?? 0),
    mime: drift.Value(_reqString(d['mime'], fallback: 'application/octet-stream')),
    captions: drift.Value(_asStringList(d['captions'])),
    alt: drift.Value(d['alt'] as String?),
    variants: drift.Value(_asMapList(d['variants'])),
    createdAt: drift.Value(_asDate(d['createdAt'])),
    updatedAt: drift.Value(_asDate(d['updatedAt'])),
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
    createdAt: drift.Value(_asDate(d['createdAt'])),
    info: drift.Value(_asMap(d['info'])),
    datetime: drift.Value(_asDate(d['datetime'])),
    log: drift.Value(_asMap(d['log'])),
    shareToken: drift.Value(d['shareToken'] as String?),
    shareEnabled: drift.Value((d['shareEnabled'] ?? false) as bool),
    shareExpiresAt: drift.Value(_asDate(d['shareExpiresAt'])),
    updatedAt: drift.Value(_asDate(d['updatedAt'])),
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
    campaignId: drift.Value(_reqString(d['campaignId'], fallback: '')),
    playerUid: drift.Value(d['playerUid'] as String?),
    name: drift.Value(_reqString(d['name'], fallback: 'Unnamed Character')),
    className: drift.Value(_reqString(d['className'], fallback: '')),
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
    createdAt: drift.Value(_asDate(d['createdAt'])),
    updatedAt: drift.Value(_asDate(d['updatedAt'])),
    rev: drift.Value((d['rev'] as int?) ?? 0),
    deleted: drift.Value((d['deleted'] ?? false) as bool),
  );
}
