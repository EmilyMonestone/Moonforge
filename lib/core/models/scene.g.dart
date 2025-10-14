// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SceneDoc _$SceneDocFromJson(Map<String, dynamic> json) => _SceneDoc(
  id: json['id'] as String,
  title: json['title'] as String,
  content: json['content'] == null
      ? null
      : RichTextDoc.fromJson(json['content'] as Map<String, dynamic>),
  mentions:
      (json['mentions'] as List<dynamic>?)
          ?.map((e) => Mention.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Mention>[],
  mediaRefs:
      (json['mediaRefs'] as List<dynamic>?)
          ?.map((e) => MediaRef.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MediaRef>[],
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
  rev: (json['rev'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SceneDocToJson(_SceneDoc instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content?.toJson(),
  'mentions': instance.mentions.map((e) => e.toJson()).toList(),
  'mediaRefs': instance.mediaRefs.map((e) => e.toJson()).toList(),
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'rev': instance.rev,
};

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `SceneDoc` model
class SceneDocPatchBuilder<$$T extends SceneDoc?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `SceneDoc`
  SceneDocPatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update title field `String`
  late final PatchBuilder<String, String> title = PatchBuilder(
    field: path.append('title'),
    toJson: (value) => (value as String),
  );

  /// Update content field `RichTextDoc?`
  late final RichTextDocPatchBuilder<RichTextDoc?> content =
      RichTextDocPatchBuilder(
        field: path.append('content'),
        toJson: (value) =>
            (value == null ? null : value!.toJson() as Map<String, dynamic>?),
      );

  /// Update mentions field `List<Mention>`
  late final ListFieldUpdate<List<Mention>, Mention, Map<String, dynamic>>
  mentions = ListFieldUpdate(
    field: path.append('mentions'),
    elementToJson: (value) => (value.toJson() as Map<String, dynamic>),
  );

  /// Update mediaRefs field `List<MediaRef>`
  late final ListFieldUpdate<List<MediaRef>, MediaRef, Map<String, dynamic>>
  mediaRefs = ListFieldUpdate(
    field: path.append('mediaRefs'),
    elementToJson: (value) => (value.toJson() as Map<String, dynamic>),
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
}

/// Generated FilterBuilder for `SceneDoc`
class SceneDocFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `SceneDoc`
  SceneDocFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by title
  late final ComparableFilterField<String> title =
      ComparableFilterField<String>(
        field: path.append('title'),
        toJson: (value) => (value as String),
      );

  /// Filter by content
  late final RichTextDocFilterBuilder content = RichTextDocFilterBuilder(
    field: path.append('content'),
  );

  /// Filter by mentions
  late final ArrayFilterField<List<Mention>, Mention, Map<String, dynamic>>
  mentions = ArrayFilterField<List<Mention>, Mention, Map<String, dynamic>>(
    field: path.append('mentions'),
    toJson: (value) =>
        listToJson(value, (value) => (value.toJson() as Map<String, dynamic>)),
    elementToJson: (value) => (value.toJson() as Map<String, dynamic>),
  );

  /// Filter by mediaRefs
  late final ArrayFilterField<List<MediaRef>, MediaRef, Map<String, dynamic>>
  mediaRefs = ArrayFilterField<List<MediaRef>, MediaRef, Map<String, dynamic>>(
    field: path.append('mediaRefs'),
    toJson: (value) =>
        listToJson(value, (value) => (value.toJson() as Map<String, dynamic>)),
    elementToJson: (value) => (value.toJson() as Map<String, dynamic>),
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
}

/// Generated RootFilterBuilder for `SceneDoc`
class SceneDocFilterBuilderRoot extends SceneDocFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `SceneDoc`
  SceneDocFilterBuilderRoot();
}

/// Generated OrderByBuilder for `SceneDoc`
class SceneDocOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  SceneDocOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested title for ordering
  late final OrderByField<String> title = OrderByField<String>(
    field: path.append('title'),
    context: $context,
  );

  /// Access nested content for ordering
  late final RichTextDocOrderByBuilder content = RichTextDocOrderByBuilder(
    field: path.append('content'),
    context: $context,
  );

  /// Access nested mentions for ordering
  late final OrderByField<List<Mention>> mentions = OrderByField<List<Mention>>(
    field: path.append('mentions'),
    context: $context,
  );

  /// Access nested mediaRefs for ordering
  late final OrderByField<List<MediaRef>> mediaRefs =
      OrderByField<List<MediaRef>>(
        field: path.append('mediaRefs'),
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
}

/// Generated AggregateFieldSelector for `SceneDoc`
class SceneDocAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  SceneDocAggregateFieldSelector({required super.context, super.field});

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

/// Generated AggregateFieldSelector for `SceneDoc`
class SceneDocAggregateBuilderRoot extends SceneDocAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  SceneDocAggregateBuilderRoot({required super.context, super.field});
}
