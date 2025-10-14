// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'encounter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EncounterDoc _$EncounterDocFromJson(Map<String, dynamic> json) =>
    _EncounterDoc(
      id: json['id'] as String,
      name: json['name'] as String,
      preset: json['preset'] as bool? ?? false,
      notes: json['notes'] as String?,
      loot: json['loot'] as String?,
      combatants:
          (json['combatants'] as List<dynamic>?)
              ?.map((e) => Combatant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Combatant>[],
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
      rev: (json['rev'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$EncounterDocToJson(_EncounterDoc instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'preset': instance.preset,
      'notes': instance.notes,
      'loot': instance.loot,
      'combatants': instance.combatants.map((e) => e.toJson()).toList(),
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'rev': instance.rev,
    };

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `EncounterDoc` model
class EncounterDocPatchBuilder<$$T extends EncounterDoc?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `EncounterDoc`
  EncounterDocPatchBuilder({required super.toJson, super.field});

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

  /// Update preset field `bool`
  late final PatchBuilder<bool, bool> preset = PatchBuilder(
    field: path.append('preset'),
    toJson: (value) => (value as bool),
  );

  /// Update notes field `String?`
  late final PatchBuilder<String?, String?> notes = PatchBuilder(
    field: path.append('notes'),
    toJson: (value) => (value as String?),
  );

  /// Update loot field `String?`
  late final PatchBuilder<String?, String?> loot = PatchBuilder(
    field: path.append('loot'),
    toJson: (value) => (value as String?),
  );

  /// Update combatants field `List<Combatant>`
  late final ListFieldUpdate<List<Combatant>, Combatant, Map<String, dynamic>>
  combatants = ListFieldUpdate(
    field: path.append('combatants'),
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

/// Generated FilterBuilder for `EncounterDoc`
class EncounterDocFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `EncounterDoc`
  EncounterDocFilterBuilder({super.field});

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

  /// Filter by preset
  late final FilterField<bool, bool> preset = FilterField<bool, bool>(
    field: path.append('preset'),
    toJson: (value) => (value as bool),
  );

  /// Filter by notes
  late final ComparableFilterField<String?> notes =
      ComparableFilterField<String?>(
        field: path.append('notes'),
        toJson: (value) => (value as String?),
      );

  /// Filter by loot
  late final ComparableFilterField<String?> loot =
      ComparableFilterField<String?>(
        field: path.append('loot'),
        toJson: (value) => (value as String?),
      );

  /// Filter by combatants
  late final ArrayFilterField<List<Combatant>, Combatant, Map<String, dynamic>>
  combatants =
      ArrayFilterField<List<Combatant>, Combatant, Map<String, dynamic>>(
        field: path.append('combatants'),
        toJson: (value) => listToJson(
          value,
          (value) => (value.toJson() as Map<String, dynamic>),
        ),
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

/// Generated RootFilterBuilder for `EncounterDoc`
class EncounterDocFilterBuilderRoot extends EncounterDocFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `EncounterDoc`
  EncounterDocFilterBuilderRoot();
}

/// Generated OrderByBuilder for `EncounterDoc`
class EncounterDocOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  EncounterDocOrderByBuilder({required super.context, super.field});

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

  /// Access nested preset for ordering
  late final OrderByField<bool> preset = OrderByField<bool>(
    field: path.append('preset'),
    context: $context,
  );

  /// Access nested notes for ordering
  late final OrderByField<String?> notes = OrderByField<String?>(
    field: path.append('notes'),
    context: $context,
  );

  /// Access nested loot for ordering
  late final OrderByField<String?> loot = OrderByField<String?>(
    field: path.append('loot'),
    context: $context,
  );

  /// Access nested combatants for ordering
  late final OrderByField<List<Combatant>> combatants =
      OrderByField<List<Combatant>>(
        field: path.append('combatants'),
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

/// Generated AggregateFieldSelector for `EncounterDoc`
class EncounterDocAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  EncounterDocAggregateFieldSelector({required super.context, super.field});

  /// rev field for aggregation
  late final AggregateField<int> rev = AggregateField<int>(
    field: path.append('rev'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `EncounterDoc`
class EncounterDocAggregateBuilderRoot
    extends EncounterDocAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  EncounterDocAggregateBuilderRoot({required super.context, super.field});
}
