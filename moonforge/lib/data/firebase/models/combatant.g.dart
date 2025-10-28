// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combatant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Combatant _$CombatantFromJson(Map<String, dynamic> json) => _Combatant(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$CombatantTypeEnumMap, json['type']),
  isAlly: json['isAlly'] as bool? ?? true,
  currentHp: (json['currentHp'] as num?)?.toInt() ?? 0,
  maxHp: (json['maxHp'] as num?)?.toInt() ?? 0,
  armorClass: (json['armorClass'] as num?)?.toInt() ?? 10,
  initiative: (json['initiative'] as num?)?.toInt(),
  initiativeModifier: (json['initiativeModifier'] as num?)?.toInt() ?? 0,
  entityId: json['entityId'] as String?,
  bestiaryName: json['bestiaryName'] as String?,
  cr: json['cr'] as String?,
  xp: (json['xp'] as num?)?.toInt() ?? 0,
  conditions:
      (json['conditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  notes: json['notes'] as String?,
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CombatantToJson(_Combatant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$CombatantTypeEnumMap[instance.type]!,
      'isAlly': instance.isAlly,
      'currentHp': instance.currentHp,
      'maxHp': instance.maxHp,
      'armorClass': instance.armorClass,
      'initiative': instance.initiative,
      'initiativeModifier': instance.initiativeModifier,
      'entityId': instance.entityId,
      'bestiaryName': instance.bestiaryName,
      'cr': instance.cr,
      'xp': instance.xp,
      'conditions': instance.conditions,
      'notes': instance.notes,
      'order': instance.order,
    };

const _$CombatantTypeEnumMap = {
  CombatantType.player: 'player',
  CombatantType.monster: 'monster',
  CombatantType.npc: 'npc',
};
