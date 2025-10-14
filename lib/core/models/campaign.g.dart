// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Campaign _$CampaignFromJson(Map<String, dynamic> json) => _Campaign(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  content: json['content'] == null
      ? null
      : RichTextDoc.fromJson(json['content'] as Map<String, dynamic>),
  ownerUid: json['ownerUid'] as String?,
  memberUids:
      (json['memberUids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
  rev: (json['rev'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CampaignToJson(_Campaign instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'content': instance.content?.toJson(),
  'ownerUid': instance.ownerUid,
  'memberUids': instance.memberUids,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'rev': instance.rev,
};

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `Campaign` model
class CampaignPatchBuilder<$$T extends Campaign?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Campaign`
  CampaignPatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update name field `String`
  late final PatchBuilder<String, String> name = PatchBuilder(
    field: path.append('name'),
    toJson: (value) => (value as String),
  );

  /// Update description field `String`
  late final PatchBuilder<String, String> description = PatchBuilder(
    field: path.append('description'),
    toJson: (value) => (value as String),
  );

  /// Update content field `RichTextDoc?`
  late final RichTextDocPatchBuilder<RichTextDoc?> content =
      RichTextDocPatchBuilder(
        field: path.append('content'),
        toJson: (value) =>
            (value == null ? null : value!.toJson() as Map<String, dynamic>?),
      );

  /// Update ownerUid field `String?`
  late final PatchBuilder<String?, String?> ownerUid = PatchBuilder(
    field: path.append('ownerUid'),
    toJson: (value) => (value as String?),
  );

  /// Update memberUids field `List<String>`
  late final ListFieldUpdate<List<String>, String, String> memberUids =
      ListFieldUpdate(
        field: path.append('memberUids'),
        elementToJson: (value) => (value as String),
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

/// Generated FilterBuilder for `Campaign`
class CampaignFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Campaign`
  CampaignFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by name
  late final ComparableFilterField<String> name = ComparableFilterField<String>(
    field: path.append('name'),
    toJson: (value) => (value as String),
  );

  /// Filter by description
  late final ComparableFilterField<String> description =
      ComparableFilterField<String>(
        field: path.append('description'),
        toJson: (value) => (value as String),
      );

  /// Filter by content
  late final RichTextDocFilterBuilder content = RichTextDocFilterBuilder(
    field: path.append('content'),
  );

  /// Filter by ownerUid
  late final ComparableFilterField<String?> ownerUid =
      ComparableFilterField<String?>(
        field: path.append('ownerUid'),
        toJson: (value) => (value as String?),
      );

  /// Filter by memberUids
  late final ArrayFilterField<List<String>, String, String> memberUids =
      ArrayFilterField<List<String>, String, String>(
        field: path.append('memberUids'),
        toJson: (value) => listToJson(value, (value) => (value as String)),
        elementToJson: (value) => (value as String),
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

/// Generated RootFilterBuilder for `Campaign`
class CampaignFilterBuilderRoot extends CampaignFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `Campaign`
  CampaignFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Campaign`
class CampaignOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  CampaignOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested name for ordering
  late final OrderByField<String> name = OrderByField<String>(
    field: path.append('name'),
    context: $context,
  );

  /// Access nested description for ordering
  late final OrderByField<String> description = OrderByField<String>(
    field: path.append('description'),
    context: $context,
  );

  /// Access nested content for ordering
  late final RichTextDocOrderByBuilder content = RichTextDocOrderByBuilder(
    field: path.append('content'),
    context: $context,
  );

  /// Access nested ownerUid for ordering
  late final OrderByField<String?> ownerUid = OrderByField<String?>(
    field: path.append('ownerUid'),
    context: $context,
  );

  /// Access nested memberUids for ordering
  late final OrderByField<List<String>> memberUids = OrderByField<List<String>>(
    field: path.append('memberUids'),
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

/// Generated AggregateFieldSelector for `Campaign`
class CampaignAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  CampaignAggregateFieldSelector({required super.context, super.field});

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

/// Generated AggregateFieldSelector for `Campaign`
class CampaignAggregateBuilderRoot extends CampaignAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  CampaignAggregateBuilderRoot({required super.context, super.field});
}
