// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_with_origin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EntityWithOrigin _$EntityWithOriginFromJson(Map<String, dynamic> json) =>
    _EntityWithOrigin(
      entity: Entity.fromJson(json['entity'] as Map<String, dynamic>),
      origin: json['origin'] == null
          ? null
          : EntityOrigin.fromJson(json['origin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EntityWithOriginToJson(_EntityWithOrigin instance) =>
    <String, dynamic>{
      'entity': instance.entity.toJson(),
      'origin': instance.origin?.toJson(),
    };

_EntityOrigin _$EntityOriginFromJson(Map<String, dynamic> json) =>
    _EntityOrigin(
      partType: json['partType'] as String,
      partId: json['partId'] as String,
      label: json['label'] as String,
      path: json['path'] as String,
    );

Map<String, dynamic> _$EntityOriginToJson(_EntityOrigin instance) =>
    <String, dynamic>{
      'partType': instance.partType,
      'partId': instance.partId,
      'label': instance.label,
      'path': instance.path,
    };
