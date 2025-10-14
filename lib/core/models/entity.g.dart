// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EntityDoc _$EntityDocFromJson(Map<String, dynamic> json) => _EntityDoc(
  id: json['id'] as String,
  kind: json['kind'] as String,
  name: json['name'] as String,
  summary: json['summary'] as String?,
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  statblock: json['statblock'] == null
      ? null
      : Statblock.fromJson(json['statblock'] as Map<String, dynamic>),
  placeType: json['placeType'] as String?,
  parentPlaceId: json['parentPlaceId'] as String?,
  coords: json['coords'] == null
      ? null
      : Coords.fromJson(json['coords'] as Map<String, dynamic>),
  content: json['content'] == null
      ? null
      : RichTextDoc.fromJson(json['content'] as Map<String, dynamic>),
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => ImageRef.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ImageRef>[],
  members:
      (json['members'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  props: json['props'] as Map<String, dynamic>?,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
  rev: (json['rev'] as num?)?.toInt() ?? 0,
  deleted: json['deleted'] as bool? ?? false,
);

Map<String, dynamic> _$EntityDocToJson(_EntityDoc instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': instance.kind,
      'name': instance.name,
      'summary': instance.summary,
      'tags': instance.tags,
      'statblock': instance.statblock?.toJson(),
      'placeType': instance.placeType,
      'parentPlaceId': instance.parentPlaceId,
      'coords': instance.coords?.toJson(),
      'content': instance.content?.toJson(),
      'images': instance.images.map((e) => e.toJson()).toList(),
      'members': instance.members,
      'props': instance.props,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'rev': instance.rev,
      'deleted': instance.deleted,
    };

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `EntityDoc` model
class EntityDocPatchBuilder<$$T extends EntityDoc?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `EntityDoc`
  EntityDocPatchBuilder({required super.toJson, super.field});

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

  /// Update tags field `List<String>`
  late final ListFieldUpdate<List<String>, String, String> tags =
      ListFieldUpdate(
        field: path.append('tags'),
        elementToJson: (value) => (value as String),
      );

  /// Update statblock field `Statblock?`
  late final StatblockPatchBuilder<Statblock?> statblock =
      StatblockPatchBuilder(
        field: path.append('statblock'),
        toJson: (value) =>
            (value == null ? null : value!.toJson() as Map<String, dynamic>?),
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

  /// Update coords field `Coords?`
  late final CoordsPatchBuilder<Coords?> coords = CoordsPatchBuilder(
    field: path.append('coords'),
    toJson: (value) =>
        (value == null ? null : value!.toJson() as Map<String, dynamic>?),
  );

  /// Update content field `RichTextDoc?`
  late final RichTextDocPatchBuilder<RichTextDoc?> content =
      RichTextDocPatchBuilder(
        field: path.append('content'),
        toJson: (value) =>
            (value == null ? null : value!.toJson() as Map<String, dynamic>?),
      );

  /// Update images field `List<ImageRef>`
  late final ListFieldUpdate<List<ImageRef>, ImageRef, Map<String, dynamic>>
  images = ListFieldUpdate(
    field: path.append('images'),
    elementToJson: (value) => (value.toJson() as Map<String, dynamic>),
  );

  /// Update members field `List<String>`
  late final ListFieldUpdate<List<String>, String, String> members =
      ListFieldUpdate(
        field: path.append('members'),
        elementToJson: (value) => (value as String),
      );

  /// Update props field `Map<String, dynamic>?`
  late final DartMapFieldUpdate<Map<String, dynamic>?, String, dynamic, dynamic>
  props = DartMapFieldUpdate(
    field: path.append('props'),
    keyToJson: (value) => (value as String),
    valueToJson: (value) => (value as dynamic),
  );

  /// Update createdAt field `DateTime?`
  late final PatchBuilder<DateTime?, Object?> createdAt = PatchBuilder(
    field: path.append('createdAt'),
    toJson: const TimestampConverter().toJson,
  );

  /// Update updatedAt field `DateTime?`
  late final PatchBuilder<DateTime?, Object?> updatedAt = PatchBuilder(
    field: path.append('updatedAt'),
    toJson: const TimestampConverter().toJson,
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
}

/// Generated FilterBuilder for `EntityDoc`
class EntityDocFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `EntityDoc`
  EntityDocFilterBuilder({super.field});

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
  late final ArrayFilterField<List<String>, String, String> tags =
      ArrayFilterField<List<String>, String, String>(
        field: path.append('tags'),
        toJson: (value) => listToJson(value, (value) => (value as String)),
        elementToJson: (value) => (value as String),
      );

  /// Filter by statblock
  late final StatblockFilterBuilder statblock = StatblockFilterBuilder(
    field: path.append('statblock'),
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
  late final CoordsFilterBuilder coords = CoordsFilterBuilder(
    field: path.append('coords'),
  );

  /// Filter by content
  late final RichTextDocFilterBuilder content = RichTextDocFilterBuilder(
    field: path.append('content'),
  );

  /// Filter by images
  late final ArrayFilterField<List<ImageRef>, ImageRef, Map<String, dynamic>>
  images = ArrayFilterField<List<ImageRef>, ImageRef, Map<String, dynamic>>(
    field: path.append('images'),
    toJson: (value) =>
        listToJson(value, (value) => (value.toJson() as Map<String, dynamic>)),
    elementToJson: (value) => (value.toJson() as Map<String, dynamic>),
  );

  /// Filter by members
  late final ArrayFilterField<List<String>, String, String> members =
      ArrayFilterField<List<String>, String, String>(
        field: path.append('members'),
        toJson: (value) => listToJson(value, (value) => (value as String)),
        elementToJson: (value) => (value as String),
      );

  /// Filter by props
  late final MapFilterField<Map<String, dynamic>?, String, dynamic, dynamic>
  props = MapFilterField<Map<String, dynamic>?, String, dynamic, dynamic>(
    field: path.append('props'),
    toJson: (value) => value == null
        ? null
        : mapToJson(
            value!,
            (value) => (value as String),
            (value) => (value as dynamic),
          ),
    keyToJson: (value) => (value as String),
    valueToJson: (value) => (value as dynamic),
  );

  /// Filter by createdAt
  late final FilterField<DateTime?, Object?> createdAt =
      FilterField<DateTime?, Object?>(
        field: path.append('createdAt'),
        toJson: (value) => const TimestampConverter().toJson(value),
      );

  /// Filter by updatedAt
  late final FilterField<DateTime?, Object?> updatedAt =
      FilterField<DateTime?, Object?>(
        field: path.append('updatedAt'),
        toJson: (value) => const TimestampConverter().toJson(value),
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
}

/// Generated RootFilterBuilder for `EntityDoc`
class EntityDocFilterBuilderRoot extends EntityDocFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `EntityDoc`
  EntityDocFilterBuilderRoot();
}

/// Generated OrderByBuilder for `EntityDoc`
class EntityDocOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  EntityDocOrderByBuilder({required super.context, super.field});

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
  late final OrderByField<List<String>> tags = OrderByField<List<String>>(
    field: path.append('tags'),
    context: $context,
  );

  /// Access nested statblock for ordering
  late final StatblockOrderByBuilder statblock = StatblockOrderByBuilder(
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
  late final CoordsOrderByBuilder coords = CoordsOrderByBuilder(
    field: path.append('coords'),
    context: $context,
  );

  /// Access nested content for ordering
  late final RichTextDocOrderByBuilder content = RichTextDocOrderByBuilder(
    field: path.append('content'),
    context: $context,
  );

  /// Access nested images for ordering
  late final OrderByField<List<ImageRef>> images = OrderByField<List<ImageRef>>(
    field: path.append('images'),
    context: $context,
  );

  /// Access nested members for ordering
  late final OrderByField<List<String>> members = OrderByField<List<String>>(
    field: path.append('members'),
    context: $context,
  );

  /// Access nested props for ordering
  late final OrderByField<Map<String, dynamic>?> props =
      OrderByField<Map<String, dynamic>?>(
        field: path.append('props'),
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
}

/// Generated AggregateFieldSelector for `EntityDoc`
class EntityDocAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  EntityDocAggregateFieldSelector({required super.context, super.field});

  /// statblock field for aggregation
  late final StatblockAggregateFieldSelector statblock =
      StatblockAggregateFieldSelector(
        field: path.append('statblock'),
        context: $context,
      );

  /// coords field for aggregation
  late final CoordsAggregateFieldSelector coords = CoordsAggregateFieldSelector(
    field: path.append('coords'),
    context: $context,
  );

  /// content field for aggregation
  late final RichTextDocAggregateFieldSelector content =
      RichTextDocAggregateFieldSelector(
        field: path.append('content'),
        context: $context,
      );

  /// rev field for aggregation
  late final AggregateField<int> rev = AggregateField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `EntityDoc`
class EntityDocAggregateBuilderRoot extends EntityDocAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  EntityDocAggregateBuilderRoot({required super.context, super.field});
}
