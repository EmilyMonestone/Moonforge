// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Entity _$EntityFromJson(Map<String, dynamic> json) => _Entity(
  id: json['id'] as String,
  kind: json['kind'] as String,
  name: json['name'] as String,
  summary: json['summary'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  statblock:
      json['statblock'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  placeType: json['placeType'] as String?,
  parentPlaceId: json['parentPlaceId'] as String?,
  coords: json['coords'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  content: json['content'] as String?,
  images: (json['images'] as List<dynamic>?)
      ?.map((e) => e as Map<String, dynamic>)
      .toList(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  rev: (json['rev'] as num?)?.toInt() ?? 0,
  deleted: json['deleted'] as bool? ?? false,
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$EntityToJson(_Entity instance) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind,
  'name': instance.name,
  'summary': instance.summary,
  'tags': instance.tags,
  'statblock': instance.statblock,
  'placeType': instance.placeType,
  'parentPlaceId': instance.parentPlaceId,
  'coords': instance.coords,
  'content': instance.content,
  'images': instance.images,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'rev': instance.rev,
  'deleted': instance.deleted,
  'members': instance.members,
};

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `Entity` model
class EntityPatchBuilder<$$T extends Entity?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Entity`
  EntityPatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update kind field `String`
  late final PatchBuilder<String, String> kind = PatchBuilder(
    field: path.append('kind'),
    toJson: (value) => (value as String),
  );

  /// Update name field `String`
  late final PatchBuilder<String, String> name = PatchBuilder(
    field: path.append('name'),
    toJson: (value) => (value as String),
  );

  /// Update summary field `String?`
  late final PatchBuilder<String?, String?> summary = PatchBuilder(
    field: path.append('summary'),
    toJson: (value) => (value as String?),
  );

  /// Update tags field `List<String>?`
  late final ListFieldUpdate<List<String>?, String, String> tags =
      ListFieldUpdate(
        field: path.append('tags'),
        elementToJson: (value) => (value as String),
      );

  /// Update statblock field `Map<String, dynamic>`
  late final DartMapFieldUpdate<Map<String, dynamic>, String, dynamic, dynamic>
  statblock = DartMapFieldUpdate(
    field: path.append('statblock'),
    keyToJson: (value) => (value as String),
    valueToJson: (value) => (value as dynamic),
  );

  /// Update placeType field `String?`
  late final PatchBuilder<String?, String?> placeType = PatchBuilder(
    field: path.append('placeType'),
    toJson: (value) => (value as String?),
  );

  /// Update parentPlaceId field `String?`
  late final PatchBuilder<String?, String?> parentPlaceId = PatchBuilder(
    field: path.append('parentPlaceId'),
    toJson: (value) => (value as String?),
  );

  /// Update coords field `Map<String, dynamic>`
  late final DartMapFieldUpdate<Map<String, dynamic>, String, dynamic, dynamic>
  coords = DartMapFieldUpdate(
    field: path.append('coords'),
    keyToJson: (value) => (value as String),
    valueToJson: (value) => (value as dynamic),
  );

  /// Update content field `String?`
  late final PatchBuilder<String?, String?> content = PatchBuilder(
    field: path.append('content'),
    toJson: (value) => (value as String?),
  );

  /// Update images field `List<Map<String, dynamic>>?`
  late final ListFieldUpdate<
    List<Map<String, dynamic>>?,
    Map<String, dynamic>,
    Map<String, dynamic>
  >
  images = ListFieldUpdate(
    field: path.append('images'),
    elementToJson: (value) => mapToJson(
      value,
      (value) => (value as String),
      (value) => (value as dynamic),
    ),
  );

  /// Update createdAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> createdAt = DateTimeFieldUpdate(
    field: path.append('createdAt'),
  );

  /// Update updatedAt field `DateTime?`
  late final DateTimeFieldUpdate<DateTime?> updatedAt = DateTimeFieldUpdate(
    field: path.append('updatedAt'),
  );

  /// Update rev field `int`
  late final NumericFieldUpdate<int> rev = NumericFieldUpdate(
    field: path.append('rev'),
  );

  /// Update deleted field `bool`
  late final PatchBuilder<bool, bool> deleted = PatchBuilder(
    field: path.append('deleted'),
    toJson: (value) => (value as bool),
  );

  /// Update members field `List<String>?`
  late final ListFieldUpdate<List<String>?, String, String> members =
      ListFieldUpdate(
        field: path.append('members'),
        elementToJson: (value) => (value as String),
      );
}

/// Generated FilterBuilder for `Entity`
class EntityFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Entity`
  EntityFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by kind
  late final ComparableFilterField<String> kind = ComparableFilterField<String>(
    field: path.append('kind'),
    toJson: (value) => (value as String),
  );

  /// Filter by name
  late final ComparableFilterField<String> name = ComparableFilterField<String>(
    field: path.append('name'),
    toJson: (value) => (value as String),
  );

  /// Filter by summary
  late final ComparableFilterField<String?> summary =
      ComparableFilterField<String?>(
        field: path.append('summary'),
        toJson: (value) => (value as String?),
      );

  /// Filter by tags
  late final ArrayFilterField<List<String>?, String, String> tags =
      ArrayFilterField<List<String>?, String, String>(
        field: path.append('tags'),
        toJson: (value) => value == null
            ? null
            : listToJson(value!, (value) => (value as String)),
        elementToJson: (value) => (value as String),
      );

  /// Filter by statblock
  late final MapFilterField<Map<String, dynamic>, String, dynamic, dynamic>
  statblock = MapFilterField<Map<String, dynamic>, String, dynamic, dynamic>(
    field: path.append('statblock'),
    toJson: (value) => mapToJson(
      value,
      (value) => (value as String),
      (value) => (value as dynamic),
    ),
    keyToJson: (value) => (value as String),
    valueToJson: (value) => (value as dynamic),
  );

  /// Filter by placeType
  late final ComparableFilterField<String?> placeType =
      ComparableFilterField<String?>(
        field: path.append('placeType'),
        toJson: (value) => (value as String?),
      );

  /// Filter by parentPlaceId
  late final ComparableFilterField<String?> parentPlaceId =
      ComparableFilterField<String?>(
        field: path.append('parentPlaceId'),
        toJson: (value) => (value as String?),
      );

  /// Filter by coords
  late final MapFilterField<Map<String, dynamic>, String, dynamic, dynamic>
  coords = MapFilterField<Map<String, dynamic>, String, dynamic, dynamic>(
    field: path.append('coords'),
    toJson: (value) => mapToJson(
      value,
      (value) => (value as String),
      (value) => (value as dynamic),
    ),
    keyToJson: (value) => (value as String),
    valueToJson: (value) => (value as dynamic),
  );

  /// Filter by content
  late final ComparableFilterField<String?> content =
      ComparableFilterField<String?>(
        field: path.append('content'),
        toJson: (value) => (value as String?),
      );

  /// Filter by images
  late final ArrayFilterField<
    List<Map<String, dynamic>>?,
    Map<String, dynamic>,
    Map<String, dynamic>
  >
  images =
      ArrayFilterField<
        List<Map<String, dynamic>>?,
        Map<String, dynamic>,
        Map<String, dynamic>
      >(
        field: path.append('images'),
        toJson: (value) => value == null
            ? null
            : listToJson(
                value!,
                (value) => mapToJson(
                  value,
                  (value) => (value as String),
                  (value) => (value as dynamic),
                ),
              ),
        elementToJson: (value) => mapToJson(
          value,
          (value) => (value as String),
          (value) => (value as dynamic),
        ),
      );

  /// Filter by createdAt
  late final ComparableFilterField<DateTime?> createdAt =
      ComparableFilterField<DateTime?>(
        field: path.append('createdAt'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );

  /// Filter by updatedAt
  late final ComparableFilterField<DateTime?> updatedAt =
      ComparableFilterField<DateTime?>(
        field: path.append('updatedAt'),
        toJson: (value) =>
            value == null ? null : const DateTimeConverter().toJson(value!),
      );

  /// Filter by rev
  late final ComparableFilterField<int> rev = ComparableFilterField<int>(
    field: path.append('rev'),
    toJson: (value) => (value as int),
  );

  /// Filter by deleted
  late final FilterField<bool, bool> deleted = FilterField<bool, bool>(
    field: path.append('deleted'),
    toJson: (value) => (value as bool),
  );

  /// Filter by members
  late final ArrayFilterField<List<String>?, String, String> members =
      ArrayFilterField<List<String>?, String, String>(
        field: path.append('members'),
        toJson: (value) => value == null
            ? null
            : listToJson(value!, (value) => (value as String)),
        elementToJson: (value) => (value as String),
      );
}

/// Generated RootFilterBuilder for `Entity`
class EntityFilterBuilderRoot extends EntityFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `Entity`
  EntityFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Entity`
class EntityOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  EntityOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested kind for ordering
  late final OrderByField<String> kind = OrderByField<String>(
    field: path.append('kind'),
    context: $context,
  );

  /// Access nested name for ordering
  late final OrderByField<String> name = OrderByField<String>(
    field: path.append('name'),
    context: $context,
  );

  /// Access nested summary for ordering
  late final OrderByField<String?> summary = OrderByField<String?>(
    field: path.append('summary'),
    context: $context,
  );

  /// Access nested tags for ordering
  late final OrderByField<List<String>?> tags = OrderByField<List<String>?>(
    field: path.append('tags'),
    context: $context,
  );

  /// Access nested statblock for ordering
  late final OrderByField<Map<String, dynamic>> statblock =
      OrderByField<Map<String, dynamic>>(
        field: path.append('statblock'),
        context: $context,
      );

  /// Access nested placeType for ordering
  late final OrderByField<String?> placeType = OrderByField<String?>(
    field: path.append('placeType'),
    context: $context,
  );

  /// Access nested parentPlaceId for ordering
  late final OrderByField<String?> parentPlaceId = OrderByField<String?>(
    field: path.append('parentPlaceId'),
    context: $context,
  );

  /// Access nested coords for ordering
  late final OrderByField<Map<String, dynamic>> coords =
      OrderByField<Map<String, dynamic>>(
        field: path.append('coords'),
        context: $context,
      );

  /// Access nested content for ordering
  late final OrderByField<String?> content = OrderByField<String?>(
    field: path.append('content'),
    context: $context,
  );

  /// Access nested images for ordering
  late final OrderByField<List<Map<String, dynamic>>?> images =
      OrderByField<List<Map<String, dynamic>>?>(
        field: path.append('images'),
        context: $context,
      );

  /// Access nested createdAt for ordering
  late final OrderByField<DateTime?> createdAt = OrderByField<DateTime?>(
    field: path.append('createdAt'),
    context: $context,
  );

  /// Access nested updatedAt for ordering
  late final OrderByField<DateTime?> updatedAt = OrderByField<DateTime?>(
    field: path.append('updatedAt'),
    context: $context,
  );

  /// Access nested rev for ordering
  late final OrderByField<int> rev = OrderByField<int>(
    field: path.append('rev'),
    context: $context,
  );

  /// Access nested deleted for ordering
  late final OrderByField<bool> deleted = OrderByField<bool>(
    field: path.append('deleted'),
    context: $context,
  );

  /// Access nested members for ordering
  late final OrderByField<List<String>?> members = OrderByField<List<String>?>(
    field: path.append('members'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Entity`
class EntityAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  EntityAggregateFieldSelector({required super.context, super.field});

  /// rev field for aggregation
  late final AggregateField<int> rev = AggregateField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Entity`
class EntityAggregateBuilderRoot extends EntityAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  EntityAggregateBuilderRoot({required super.context, super.field});
}
