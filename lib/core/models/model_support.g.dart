// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_support.dart';

// **************************************************************************
// ModelBuilderGenerator
// **************************************************************************

/// Patch builder for `RichTextDoc` model
class RichTextDocPatchBuilder<$$T extends RichTextDoc?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `RichTextDoc`
  RichTextDocPatchBuilder({required super.toJson, super.field});

  /// Update type field `String`
  late final PatchBuilder<String, String> type = PatchBuilder(
    field: path.append('type'),
    toJson: (value) => (value as String),
  );

  /// Update nodes field `List<dynamic>`
  late final ListFieldUpdate<List<dynamic>, dynamic, dynamic> nodes =
      ListFieldUpdate(
        field: path.append('nodes'),
        elementToJson: (value) => (value as dynamic),
      );
}

/// Generated FilterBuilder for `RichTextDoc`
class RichTextDocFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `RichTextDoc`
  RichTextDocFilterBuilder({super.field});

  /// Filter by type
  late final ComparableFilterField<String> type = ComparableFilterField<String>(
    field: path.append('type'),
    toJson: (value) => (value as String),
  );

  /// Filter by nodes
  late final ArrayFilterField<List<dynamic>, dynamic, dynamic> nodes =
      ArrayFilterField<List<dynamic>, dynamic, dynamic>(
        field: path.append('nodes'),
        toJson: (value) => listToJson(value, (value) => (value as dynamic)),
        elementToJson: (value) => (value as dynamic),
      );
}

/// Generated RootFilterBuilder for `RichTextDoc`
class RichTextDocFilterBuilderRoot extends RichTextDocFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `RichTextDoc`
  RichTextDocFilterBuilderRoot();
}

/// Generated OrderByBuilder for `RichTextDoc`
class RichTextDocOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  RichTextDocOrderByBuilder({required super.context, super.field});

  /// Access nested type for ordering
  late final OrderByField<String> type = OrderByField<String>(
    field: path.append('type'),
    context: $context,
  );

  /// Access nested nodes for ordering
  late final OrderByField<List<dynamic>> nodes = OrderByField<List<dynamic>>(
    field: path.append('nodes'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `RichTextDoc`
class RichTextDocAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  RichTextDocAggregateFieldSelector({required super.context, super.field});
}

/// Generated AggregateFieldSelector for `RichTextDoc`
class RichTextDocAggregateBuilderRoot extends RichTextDocAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  RichTextDocAggregateBuilderRoot({required super.context, super.field});
}

/// Patch builder for `Mention` model
class MentionPatchBuilder<$$T extends Mention?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Mention`
  MentionPatchBuilder({required super.toJson, super.field});

  /// Update kind field `String`
  late final PatchBuilder<String, String> kind = PatchBuilder(
    field: path.append('kind'),
    toJson: (value) => (value as String),
  );

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );
}

/// Generated FilterBuilder for `Mention`
class MentionFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Mention`
  MentionFilterBuilder({super.field});

  /// Filter by kind
  late final ComparableFilterField<String> kind = ComparableFilterField<String>(
    field: path.append('kind'),
    toJson: (value) => (value as String),
  );

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );
}

/// Generated RootFilterBuilder for `Mention`
class MentionFilterBuilderRoot extends MentionFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `Mention`
  MentionFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Mention`
class MentionOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  MentionOrderByBuilder({required super.context, super.field});

  /// Access nested kind for ordering
  late final OrderByField<String> kind = OrderByField<String>(
    field: path.append('kind'),
    context: $context,
  );

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Mention`
class MentionAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  MentionAggregateFieldSelector({required super.context, super.field});
}

/// Generated AggregateFieldSelector for `Mention`
class MentionAggregateBuilderRoot extends MentionAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  MentionAggregateBuilderRoot({required super.context, super.field});
}

/// Patch builder for `MediaRef` model
class MediaRefPatchBuilder<$$T extends MediaRef?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `MediaRef`
  MediaRefPatchBuilder({required super.toJson, super.field});

  /// Update assetId field `String`
  late final PatchBuilder<String, String> assetId = PatchBuilder(
    field: path.append('assetId'),
    toJson: (value) => (value as String),
  );

  /// Update variant field `String?`
  late final PatchBuilder<String?, String?> variant = PatchBuilder(
    field: path.append('variant'),
    toJson: (value) => (value as String?),
  );
}

/// Generated FilterBuilder for `MediaRef`
class MediaRefFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `MediaRef`
  MediaRefFilterBuilder({super.field});

  /// Filter by assetId
  late final ComparableFilterField<String> assetId =
      ComparableFilterField<String>(
        field: path.append('assetId'),
        toJson: (value) => (value as String),
      );

  /// Filter by variant
  late final ComparableFilterField<String?> variant =
      ComparableFilterField<String?>(
        field: path.append('variant'),
        toJson: (value) => (value as String?),
      );
}

/// Generated RootFilterBuilder for `MediaRef`
class MediaRefFilterBuilderRoot extends MediaRefFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `MediaRef`
  MediaRefFilterBuilderRoot();
}

/// Generated OrderByBuilder for `MediaRef`
class MediaRefOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  MediaRefOrderByBuilder({required super.context, super.field});

  /// Access nested assetId for ordering
  late final OrderByField<String> assetId = OrderByField<String>(
    field: path.append('assetId'),
    context: $context,
  );

  /// Access nested variant for ordering
  late final OrderByField<String?> variant = OrderByField<String?>(
    field: path.append('variant'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `MediaRef`
class MediaRefAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  MediaRefAggregateFieldSelector({required super.context, super.field});
}

/// Generated AggregateFieldSelector for `MediaRef`
class MediaRefAggregateBuilderRoot extends MediaRefAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  MediaRefAggregateBuilderRoot({required super.context, super.field});
}

/// Patch builder for `ImageRef` model
class ImageRefPatchBuilder<$$T extends ImageRef?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `ImageRef`
  ImageRefPatchBuilder({required super.toJson, super.field});

  /// Update assetId field `String`
  late final PatchBuilder<String, String> assetId = PatchBuilder(
    field: path.append('assetId'),
    toJson: (value) => (value as String),
  );

  /// Update kind field `String?`
  late final PatchBuilder<String?, String?> kind = PatchBuilder(
    field: path.append('kind'),
    toJson: (value) => (value as String?),
  );
}

/// Generated FilterBuilder for `ImageRef`
class ImageRefFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `ImageRef`
  ImageRefFilterBuilder({super.field});

  /// Filter by assetId
  late final ComparableFilterField<String> assetId =
      ComparableFilterField<String>(
        field: path.append('assetId'),
        toJson: (value) => (value as String),
      );

  /// Filter by kind
  late final ComparableFilterField<String?> kind =
      ComparableFilterField<String?>(
        field: path.append('kind'),
        toJson: (value) => (value as String?),
      );
}

/// Generated RootFilterBuilder for `ImageRef`
class ImageRefFilterBuilderRoot extends ImageRefFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `ImageRef`
  ImageRefFilterBuilderRoot();
}

/// Generated OrderByBuilder for `ImageRef`
class ImageRefOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  ImageRefOrderByBuilder({required super.context, super.field});

  /// Access nested assetId for ordering
  late final OrderByField<String> assetId = OrderByField<String>(
    field: path.append('assetId'),
    context: $context,
  );

  /// Access nested kind for ordering
  late final OrderByField<String?> kind = OrderByField<String?>(
    field: path.append('kind'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `ImageRef`
class ImageRefAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  ImageRefAggregateFieldSelector({required super.context, super.field});
}

/// Generated AggregateFieldSelector for `ImageRef`
class ImageRefAggregateBuilderRoot extends ImageRefAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  ImageRefAggregateBuilderRoot({required super.context, super.field});
}

/// Patch builder for `Coords` model
class CoordsPatchBuilder<$$T extends Coords?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Coords`
  CoordsPatchBuilder({required super.toJson, super.field});

  /// Update lat field `double`
  late final NumericFieldUpdate<double> lat = NumericFieldUpdate(
    field: path.append('lat'),
  );

  /// Update lng field `double`
  late final NumericFieldUpdate<double> lng = NumericFieldUpdate(
    field: path.append('lng'),
  );
}

/// Generated FilterBuilder for `Coords`
class CoordsFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Coords`
  CoordsFilterBuilder({super.field});

  /// Filter by lat
  late final ComparableFilterField<double> lat = ComparableFilterField<double>(
    field: path.append('lat'),
    toJson: (value) => (value as double),
  );

  /// Filter by lng
  late final ComparableFilterField<double> lng = ComparableFilterField<double>(
    field: path.append('lng'),
    toJson: (value) => (value as double),
  );
}

/// Generated RootFilterBuilder for `Coords`
class CoordsFilterBuilderRoot extends CoordsFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `Coords`
  CoordsFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Coords`
class CoordsOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  CoordsOrderByBuilder({required super.context, super.field});

  /// Access nested lat for ordering
  late final OrderByField<double> lat = OrderByField<double>(
    field: path.append('lat'),
    context: $context,
  );

  /// Access nested lng for ordering
  late final OrderByField<double> lng = OrderByField<double>(
    field: path.append('lng'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Coords`
class CoordsAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  CoordsAggregateFieldSelector({required super.context, super.field});

  /// lat field for aggregation
  late final AggregateField<double> lat = AggregateField<double>(
    field: path.append('lat'),
    context: $context,
  );

  /// lng field for aggregation
  late final AggregateField<double> lng = AggregateField<double>(
    field: path.append('lng'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Coords`
class CoordsAggregateBuilderRoot extends CoordsAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  CoordsAggregateBuilderRoot({required super.context, super.field});
}

/// Patch builder for `Statblock` model
class StatblockPatchBuilder<$$T extends Statblock?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Statblock`
  StatblockPatchBuilder({required super.toJson, super.field});

  /// Update source field `String?`
  late final PatchBuilder<String?, String?> source = PatchBuilder(
    field: path.append('source'),
    toJson: (value) => (value as String?),
  );

  /// Update srdRef field `String?`
  late final PatchBuilder<String?, String?> srdRef = PatchBuilder(
    field: path.append('srdRef'),
    toJson: (value) => (value as String?),
  );

  /// Update data field `Map<String, dynamic>?`
  late final DartMapFieldUpdate<Map<String, dynamic>?, String, dynamic, dynamic>
  data = DartMapFieldUpdate(
    field: path.append('data'),
    keyToJson: (value) => (value as String),
    valueToJson: (value) => (value as dynamic),
  );
}

/// Generated FilterBuilder for `Statblock`
class StatblockFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Statblock`
  StatblockFilterBuilder({super.field});

  /// Filter by source
  late final ComparableFilterField<String?> source =
      ComparableFilterField<String?>(
        field: path.append('source'),
        toJson: (value) => (value as String?),
      );

  /// Filter by srdRef
  late final ComparableFilterField<String?> srdRef =
      ComparableFilterField<String?>(
        field: path.append('srdRef'),
        toJson: (value) => (value as String?),
      );

  /// Filter by data
  late final MapFilterField<Map<String, dynamic>?, String, dynamic, dynamic>
  data = MapFilterField<Map<String, dynamic>?, String, dynamic, dynamic>(
    field: path.append('data'),
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
}

/// Generated RootFilterBuilder for `Statblock`
class StatblockFilterBuilderRoot extends StatblockFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `Statblock`
  StatblockFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Statblock`
class StatblockOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  StatblockOrderByBuilder({required super.context, super.field});

  /// Access nested source for ordering
  late final OrderByField<String?> source = OrderByField<String?>(
    field: path.append('source'),
    context: $context,
  );

  /// Access nested srdRef for ordering
  late final OrderByField<String?> srdRef = OrderByField<String?>(
    field: path.append('srdRef'),
    context: $context,
  );

  /// Access nested data for ordering
  late final OrderByField<Map<String, dynamic>?> data =
      OrderByField<Map<String, dynamic>?>(
        field: path.append('data'),
        context: $context,
      );
}

/// Generated AggregateFieldSelector for `Statblock`
class StatblockAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  StatblockAggregateFieldSelector({required super.context, super.field});
}

/// Generated AggregateFieldSelector for `Statblock`
class StatblockAggregateBuilderRoot extends StatblockAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  StatblockAggregateBuilderRoot({required super.context, super.field});
}

/// Patch builder for `Hp` model
class HpPatchBuilder<$$T extends Hp?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Hp`
  HpPatchBuilder({required super.toJson, super.field});

  /// Update current field `int`
  late final NumericFieldUpdate<int> current = NumericFieldUpdate(
    field: path.append('current'),
  );

  /// Update max field `int`
  late final NumericFieldUpdate<int> max = NumericFieldUpdate(
    field: path.append('max'),
  );
}

/// Generated FilterBuilder for `Hp`
class HpFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Hp`
  HpFilterBuilder({super.field});

  /// Filter by current
  late final ComparableFilterField<int> current = ComparableFilterField<int>(
    field: path.append('current'),
    toJson: (value) => (value as int),
  );

  /// Filter by max
  late final ComparableFilterField<int> max = ComparableFilterField<int>(
    field: path.append('max'),
    toJson: (value) => (value as int),
  );
}

/// Generated RootFilterBuilder for `Hp`
class HpFilterBuilderRoot extends HpFilterBuilder with FilterBuilderRoot {
  /// Creates a root filter selector for `Hp`
  HpFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Hp`
class HpOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  HpOrderByBuilder({required super.context, super.field});

  /// Access nested current for ordering
  late final OrderByField<int> current = OrderByField<int>(
    field: path.append('current'),
    context: $context,
  );

  /// Access nested max for ordering
  late final OrderByField<int> max = OrderByField<int>(
    field: path.append('max'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Hp`
class HpAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  HpAggregateFieldSelector({required super.context, super.field});

  /// current field for aggregation
  late final AggregateField<int> current = AggregateField<int>(
    field: path.append('current'),
    context: $context,
  );

  /// max field for aggregation
  late final AggregateField<int> max = AggregateField<int>(
    field: path.append('max'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Hp`
class HpAggregateBuilderRoot extends HpAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  HpAggregateBuilderRoot({required super.context, super.field});
}

/// Patch builder for `CombatantSource` model
class CombatantSourcePatchBuilder<$$T extends CombatantSource?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `CombatantSource`
  CombatantSourcePatchBuilder({required super.toJson, super.field});

  /// Update type field `String`
  late final PatchBuilder<String, String> type = PatchBuilder(
    field: path.append('type'),
    toJson: (value) => (value as String),
  );

  /// Update entityId field `String?`
  late final PatchBuilder<String?, String?> entityId = PatchBuilder(
    field: path.append('entityId'),
    toJson: (value) => (value as String?),
  );

  /// Update snapshot field `Map<String, dynamic>?`
  late final DartMapFieldUpdate<Map<String, dynamic>?, String, dynamic, dynamic>
  snapshot = DartMapFieldUpdate(
    field: path.append('snapshot'),
    keyToJson: (value) => (value as String),
    valueToJson: (value) => (value as dynamic),
  );
}

/// Generated FilterBuilder for `CombatantSource`
class CombatantSourceFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `CombatantSource`
  CombatantSourceFilterBuilder({super.field});

  /// Filter by type
  late final ComparableFilterField<String> type = ComparableFilterField<String>(
    field: path.append('type'),
    toJson: (value) => (value as String),
  );

  /// Filter by entityId
  late final ComparableFilterField<String?> entityId =
      ComparableFilterField<String?>(
        field: path.append('entityId'),
        toJson: (value) => (value as String?),
      );

  /// Filter by snapshot
  late final MapFilterField<Map<String, dynamic>?, String, dynamic, dynamic>
  snapshot = MapFilterField<Map<String, dynamic>?, String, dynamic, dynamic>(
    field: path.append('snapshot'),
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
}

/// Generated RootFilterBuilder for `CombatantSource`
class CombatantSourceFilterBuilderRoot extends CombatantSourceFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `CombatantSource`
  CombatantSourceFilterBuilderRoot();
}

/// Generated OrderByBuilder for `CombatantSource`
class CombatantSourceOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  CombatantSourceOrderByBuilder({required super.context, super.field});

  /// Access nested type for ordering
  late final OrderByField<String> type = OrderByField<String>(
    field: path.append('type'),
    context: $context,
  );

  /// Access nested entityId for ordering
  late final OrderByField<String?> entityId = OrderByField<String?>(
    field: path.append('entityId'),
    context: $context,
  );

  /// Access nested snapshot for ordering
  late final OrderByField<Map<String, dynamic>?> snapshot =
      OrderByField<Map<String, dynamic>?>(
        field: path.append('snapshot'),
        context: $context,
      );
}

/// Generated AggregateFieldSelector for `CombatantSource`
class CombatantSourceAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  CombatantSourceAggregateFieldSelector({required super.context, super.field});
}

/// Generated AggregateFieldSelector for `CombatantSource`
class CombatantSourceAggregateBuilderRoot
    extends CombatantSourceAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  CombatantSourceAggregateBuilderRoot({required super.context, super.field});
}

/// Patch builder for `Combatant` model
class CombatantPatchBuilder<$$T extends Combatant?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `Combatant`
  CombatantPatchBuilder({required super.toJson, super.field});

  /// Update id field `String`
  late final PatchBuilder<String, String> id = PatchBuilder(
    field: path.append('id'),
    toJson: (value) => (value as String),
  );

  /// Update source field `CombatantSource`
  late final CombatantSourcePatchBuilder<CombatantSource> source =
      CombatantSourcePatchBuilder(
        field: path.append('source'),
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
      );

  /// Update hp field `Hp`
  late final HpPatchBuilder<Hp> hp = HpPatchBuilder(
    field: path.append('hp'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
  );

  /// Update ac field `int?`
  late final NumericFieldUpdate<int?> ac = NumericFieldUpdate(
    field: path.append('ac'),
  );

  /// Update conditions field `List<String>`
  late final ListFieldUpdate<List<String>, String, String> conditions =
      ListFieldUpdate(
        field: path.append('conditions'),
        elementToJson: (value) => (value as String),
      );

  /// Update note field `String?`
  late final PatchBuilder<String?, String?> note = PatchBuilder(
    field: path.append('note'),
    toJson: (value) => (value as String?),
  );

  /// Update initiative field `int?`
  late final NumericFieldUpdate<int?> initiative = NumericFieldUpdate(
    field: path.append('initiative'),
  );
}

/// Generated FilterBuilder for `Combatant`
class CombatantFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `Combatant`
  CombatantFilterBuilder({super.field});

  /// Filter by id
  late final ComparableFilterField<String> id = ComparableFilterField<String>(
    field: FieldPath.documentId,
    toJson: (value) => (value as String),
  );

  /// Filter by source
  late final CombatantSourceFilterBuilder source = CombatantSourceFilterBuilder(
    field: path.append('source'),
  );

  /// Filter by hp
  late final HpFilterBuilder hp = HpFilterBuilder(field: path.append('hp'));

  /// Filter by ac
  late final ComparableFilterField<int?> ac = ComparableFilterField<int?>(
    field: path.append('ac'),
    toJson: (value) => (value as int?),
  );

  /// Filter by conditions
  late final ArrayFilterField<List<String>, String, String> conditions =
      ArrayFilterField<List<String>, String, String>(
        field: path.append('conditions'),
        toJson: (value) => listToJson(value, (value) => (value as String)),
        elementToJson: (value) => (value as String),
      );

  /// Filter by note
  late final ComparableFilterField<String?> note =
      ComparableFilterField<String?>(
        field: path.append('note'),
        toJson: (value) => (value as String?),
      );

  /// Filter by initiative
  late final ComparableFilterField<int?> initiative =
      ComparableFilterField<int?>(
        field: path.append('initiative'),
        toJson: (value) => (value as int?),
      );
}

/// Generated RootFilterBuilder for `Combatant`
class CombatantFilterBuilderRoot extends CombatantFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `Combatant`
  CombatantFilterBuilderRoot();
}

/// Generated OrderByBuilder for `Combatant`
class CombatantOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  CombatantOrderByBuilder({required super.context, super.field});

  /// Access nested id for ordering
  late final OrderByField<String> id = OrderByField<String>(
    field: FieldPath.documentId,
    context: $context,
  );

  /// Access nested source for ordering
  late final CombatantSourceOrderByBuilder source =
      CombatantSourceOrderByBuilder(
        field: path.append('source'),
        context: $context,
      );

  /// Access nested hp for ordering
  late final HpOrderByBuilder hp = HpOrderByBuilder(
    field: path.append('hp'),
    context: $context,
  );

  /// Access nested ac for ordering
  late final OrderByField<int?> ac = OrderByField<int?>(
    field: path.append('ac'),
    context: $context,
  );

  /// Access nested conditions for ordering
  late final OrderByField<List<String>> conditions = OrderByField<List<String>>(
    field: path.append('conditions'),
    context: $context,
  );

  /// Access nested note for ordering
  late final OrderByField<String?> note = OrderByField<String?>(
    field: path.append('note'),
    context: $context,
  );

  /// Access nested initiative for ordering
  late final OrderByField<int?> initiative = OrderByField<int?>(
    field: path.append('initiative'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Combatant`
class CombatantAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  CombatantAggregateFieldSelector({required super.context, super.field});

  /// source field for aggregation
  late final CombatantSourceAggregateFieldSelector source =
      CombatantSourceAggregateFieldSelector(
        field: path.append('source'),
        context: $context,
      );

  /// hp field for aggregation
  late final HpAggregateFieldSelector hp = HpAggregateFieldSelector(
    field: path.append('hp'),
    context: $context,
  );

  /// ac field for aggregation
  late final AggregateField<int?> ac = AggregateField<int?>(
    field: path.append('ac'),
    context: $context,
  );

  /// initiative field for aggregation
  late final AggregateField<int?> initiative = AggregateField<int?>(
    field: path.append('initiative'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `Combatant`
class CombatantAggregateBuilderRoot extends CombatantAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  CombatantAggregateBuilderRoot({required super.context, super.field});
}

/// Patch builder for `MediaVariant` model
class MediaVariantPatchBuilder<$$T extends MediaVariant?>
    extends PatchBuilder<$$T, Map<String, dynamic>?> {
  /// Creates a patch builder for `MediaVariant`
  MediaVariantPatchBuilder({required super.toJson, super.field});

  /// Update kind field `String`
  late final PatchBuilder<String, String> kind = PatchBuilder(
    field: path.append('kind'),
    toJson: (value) => (value as String),
  );

  /// Update path field `String`
  late final PatchBuilder<String, String> path = PatchBuilder(
    field: path.append('path'),
    toJson: (value) => (value as String),
  );

  /// Update width field `int?`
  late final NumericFieldUpdate<int?> width = NumericFieldUpdate(
    field: path.append('width'),
  );

  /// Update height field `int?`
  late final NumericFieldUpdate<int?> height = NumericFieldUpdate(
    field: path.append('height'),
  );

  /// Update bytes field `int?`
  late final NumericFieldUpdate<int?> bytes = NumericFieldUpdate(
    field: path.append('bytes'),
  );
}

/// Generated FilterBuilder for `MediaVariant`
class MediaVariantFilterBuilder extends FilterBuilderNode {
  /// Creates a filter selector for `MediaVariant`
  MediaVariantFilterBuilder({super.field});

  /// Filter by kind
  late final ComparableFilterField<String> kind = ComparableFilterField<String>(
    field: path.append('kind'),
    toJson: (value) => (value as String),
  );

  /// Filter by path
  late final ComparableFilterField<String> path = ComparableFilterField<String>(
    field: path.append('path'),
    toJson: (value) => (value as String),
  );

  /// Filter by width
  late final ComparableFilterField<int?> width = ComparableFilterField<int?>(
    field: path.append('width'),
    toJson: (value) => (value as int?),
  );

  /// Filter by height
  late final ComparableFilterField<int?> height = ComparableFilterField<int?>(
    field: path.append('height'),
    toJson: (value) => (value as int?),
  );

  /// Filter by bytes
  late final ComparableFilterField<int?> bytes = ComparableFilterField<int?>(
    field: path.append('bytes'),
    toJson: (value) => (value as int?),
  );
}

/// Generated RootFilterBuilder for `MediaVariant`
class MediaVariantFilterBuilderRoot extends MediaVariantFilterBuilder
    with FilterBuilderRoot {
  /// Creates a root filter selector for `MediaVariant`
  MediaVariantFilterBuilderRoot();
}

/// Generated OrderByBuilder for `MediaVariant`
class MediaVariantOrderByBuilder extends OrderByFieldNode {
  /// Constructor for OrderByBuilder
  MediaVariantOrderByBuilder({required super.context, super.field});

  /// Access nested kind for ordering
  late final OrderByField<String> kind = OrderByField<String>(
    field: path.append('kind'),
    context: $context,
  );

  /// Access nested path for ordering
  late final OrderByField<String> path = OrderByField<String>(
    field: path.append('path'),
    context: $context,
  );

  /// Access nested width for ordering
  late final OrderByField<int?> width = OrderByField<int?>(
    field: path.append('width'),
    context: $context,
  );

  /// Access nested height for ordering
  late final OrderByField<int?> height = OrderByField<int?>(
    field: path.append('height'),
    context: $context,
  );

  /// Access nested bytes for ordering
  late final OrderByField<int?> bytes = OrderByField<int?>(
    field: path.append('bytes'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `MediaVariant`
class MediaVariantAggregateFieldSelector extends AggregateFieldNode {
  /// Constructor for AggregateFieldSelector
  MediaVariantAggregateFieldSelector({required super.context, super.field});

  /// width field for aggregation
  late final AggregateField<int?> width = AggregateField<int?>(
    field: path.append('width'),
    context: $context,
  );

  /// height field for aggregation
  late final AggregateField<int?> height = AggregateField<int?>(
    field: path.append('height'),
    context: $context,
  );

  /// bytes field for aggregation
  late final AggregateField<int?> bytes = AggregateField<int?>(
    field: path.append('bytes'),
    context: $context,
  );
}

/// Generated AggregateFieldSelector for `MediaVariant`
class MediaVariantAggregateBuilderRoot
    extends MediaVariantAggregateFieldSelector
    with AggregateRootMixin
    implements AggregateBuilderRoot {
  /// Constructor for AggregateFieldSelector
  MediaVariantAggregateBuilderRoot({required super.context, super.field});
}
