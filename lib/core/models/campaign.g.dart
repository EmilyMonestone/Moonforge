// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Campaign _$CampaignFromJson(Map<String, dynamic> json) => _Campaign(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$CampaignToJson(_Campaign instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
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
}

/// Generated AggregateFieldSelector for `Campaign`
class CampaignAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  CampaignAggregateFieldSelector({required super.context, super.field});
}

/// Generated AggregateFieldSelector for `Campaign`
class CampaignAggregateBuilderRoot extends CampaignAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  CampaignAggregateBuilderRoot({required super.context, super.field});
}
