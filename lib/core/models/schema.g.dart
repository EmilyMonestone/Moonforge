// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// Generator: SchemaGenerator2
// **************************************************************************

/// Identifiers for all Firestore collections in the schema
/// Used to map collection paths to their respective collection classes
/// By combining collection classes (e.g., as tuple types),
/// we can use extension methods with record types to reduce boilerplate
/// Example: (_$UsersCollection, _$PostsCollection)
final class _$CampaignsCollection {}

final class _$ChaptersCollection {}

final class _$AdventuresCollection {}

final class _$ScenesCollection {}

final class _$EntitiesCollection {}

final class _$EncountersCollection {}

final class _$SessionsCollection {}

final class _$MediaCollection {}

final class _$JoinsCollection {}

/// Generated schema class - dummy class that only serves as type marker
class AppSchema extends FirestoreSchema {
  const AppSchema();
}

/// Generated schema instance
const AppSchema _$AppSchema = AppSchema();

/// Class to add collections to `FirestoreODM<AppSchema>`
extension $AppSchemaODM on FirestoreODM<AppSchema> {
  /// Access campaigns collection
  @pragma('vm:prefer-inline')
  FirestoreCollection<
    AppSchema,
    Campaign,
    (_$CampaignsCollection,),
    CampaignPatchBuilder<Campaign>,
    CampaignFilterBuilderRoot,
    CampaignOrderByBuilder,
    CampaignAggregateBuilderRoot
  >
  get campaigns => FirestoreCollection(
    query: firestore.collection('campaigns'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Campaign.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: CampaignPatchBuilder<Campaign>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: CampaignFilterBuilderRoot(),
    orderByBuilderFunc: (context) => CampaignOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        CampaignAggregateBuilderRoot(context: context),
  );

  /// Access joins collection
  @pragma('vm:prefer-inline')
  FirestoreCollection<
    AppSchema,
    JoinCode,
    (_$JoinsCollection,),
    JoinCodePatchBuilder<JoinCode>,
    JoinCodeFilterBuilderRoot,
    JoinCodeOrderByBuilder,
    JoinCodeAggregateBuilderRoot
  >
  get joins => FirestoreCollection(
    query: firestore.collection('joins'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => JoinCode.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: JoinCodePatchBuilder<JoinCode>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: JoinCodeFilterBuilderRoot(),
    orderByBuilderFunc: (context) => JoinCodeOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        JoinCodeAggregateBuilderRoot(context: context),
  );
}

/// Extension to add collections to `TransactionContext<AppSchema>`
extension $AppSchemaTransactionContext on TransactionContext<AppSchema> {
  /// Access campaigns collection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    Campaign,
    (_$CampaignsCollection,),
    CampaignPatchBuilder<Campaign>
  >
  get campaigns =>
      TransactionCollection<
        AppSchema,
        Campaign,
        (_$CampaignsCollection,),
        CampaignPatchBuilder<Campaign>
      >(
        query: ref.collection('campaigns'),
        context: this,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) => Campaign.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: CampaignPatchBuilder<Campaign>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );

  /// Access joins collection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    JoinCode,
    (_$JoinsCollection,),
    JoinCodePatchBuilder<JoinCode>
  >
  get joins =>
      TransactionCollection<
        AppSchema,
        JoinCode,
        (_$JoinsCollection,),
        JoinCodePatchBuilder<JoinCode>
      >(
        query: ref.collection('joins'),
        context: this,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) => JoinCode.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: JoinCodePatchBuilder<JoinCode>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );
}

/// Transaction document class for campaigns collection
extension $AppSchemaCampaignsTransactionDocument
    on
        TransactionDocument<
          AppSchema,
          Campaign,
          (_$CampaignsCollection,),
          CampaignPatchBuilder<Campaign>
        > {
  /// Access chapters subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    ChapterDoc,
    (_$CampaignsCollection, _$ChaptersCollection),
    ChapterDocPatchBuilder<ChapterDoc>
  >
  get chapters =>
      TransactionCollection<
        AppSchema,
        ChapterDoc,
        (_$CampaignsCollection, _$ChaptersCollection),
        ChapterDocPatchBuilder<ChapterDoc>
      >(
        query: ref.collection('chapters'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) =>
            ChapterDoc.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: ChapterDocPatchBuilder<ChapterDoc>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );

  /// Access entities subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    EntityDoc,
    (_$CampaignsCollection, _$EntitiesCollection),
    EntityDocPatchBuilder<EntityDoc>
  >
  get entities =>
      TransactionCollection<
        AppSchema,
        EntityDoc,
        (_$CampaignsCollection, _$EntitiesCollection),
        EntityDocPatchBuilder<EntityDoc>
      >(
        query: ref.collection('entities'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) =>
            EntityDoc.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: EntityDocPatchBuilder<EntityDoc>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );

  /// Access encounters subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    EncounterDoc,
    (_$CampaignsCollection, _$EncountersCollection),
    EncounterDocPatchBuilder<EncounterDoc>
  >
  get encounters =>
      TransactionCollection<
        AppSchema,
        EncounterDoc,
        (_$CampaignsCollection, _$EncountersCollection),
        EncounterDocPatchBuilder<EncounterDoc>
      >(
        query: ref.collection('encounters'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) =>
            EncounterDoc.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: EncounterDocPatchBuilder<EncounterDoc>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );

  /// Access sessions subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    SessionDoc,
    (_$CampaignsCollection, _$SessionsCollection),
    SessionDocPatchBuilder<SessionDoc>
  >
  get sessions =>
      TransactionCollection<
        AppSchema,
        SessionDoc,
        (_$CampaignsCollection, _$SessionsCollection),
        SessionDocPatchBuilder<SessionDoc>
      >(
        query: ref.collection('sessions'),
        context: context,
        toJson: (value) => $SessionDocToJson(value),
        fromJson: (value) =>
            SessionDoc.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: SessionDocPatchBuilder<SessionDoc>(
          toJson: (value) => $SessionDocToJson(value),
        ),
      );

  /// Access media subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    MediaAssetDoc,
    (_$CampaignsCollection, _$MediaCollection),
    MediaAssetDocPatchBuilder<MediaAssetDoc>
  >
  get media =>
      TransactionCollection<
        AppSchema,
        MediaAssetDoc,
        (_$CampaignsCollection, _$MediaCollection),
        MediaAssetDocPatchBuilder<MediaAssetDoc>
      >(
        query: ref.collection('media'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) =>
            MediaAssetDoc.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: MediaAssetDocPatchBuilder<MediaAssetDoc>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );
}

/// Transaction document class for campaigns/*/chapters collection
extension $AppSchemaCampaignsChaptersTransactionDocument
    on
        TransactionDocument<
          AppSchema,
          ChapterDoc,
          (_$CampaignsCollection, _$ChaptersCollection),
          ChapterDocPatchBuilder<ChapterDoc>
        > {
  /// Access adventures subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    AdventureDoc,
    (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
    AdventureDocPatchBuilder<AdventureDoc>
  >
  get adventures =>
      TransactionCollection<
        AppSchema,
        AdventureDoc,
        (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
        AdventureDocPatchBuilder<AdventureDoc>
      >(
        query: ref.collection('adventures'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) =>
            AdventureDoc.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: AdventureDocPatchBuilder<AdventureDoc>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );
}

/// Transaction document class for campaigns/*/chapters/*/adventures collection
extension $AppSchemaCampaignsChaptersAdventuresTransactionDocument
    on
        TransactionDocument<
          AppSchema,
          AdventureDoc,
          (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
          AdventureDocPatchBuilder<AdventureDoc>
        > {
  /// Access scenes subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    SceneDoc,
    (
      _$CampaignsCollection,
      _$ChaptersCollection,
      _$AdventuresCollection,
      _$ScenesCollection,
    ),
    SceneDocPatchBuilder<SceneDoc>
  >
  get scenes =>
      TransactionCollection<
        AppSchema,
        SceneDoc,
        (
          _$CampaignsCollection,
          _$ChaptersCollection,
          _$AdventuresCollection,
          _$ScenesCollection,
        ),
        SceneDocPatchBuilder<SceneDoc>
      >(
        query: ref.collection('scenes'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) => SceneDoc.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: SceneDocPatchBuilder<SceneDoc>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );
}

/// Document class for campaigns collection
extension $AppSchemaCampaignsDocument
    on
        FirestoreDocument<
          AppSchema,
          Campaign,
          (_$CampaignsCollection,),
          CampaignPatchBuilder<Campaign>
        > {
  /// Access chapters subcollection
  FirestoreCollection<
    AppSchema,
    ChapterDoc,
    (_$CampaignsCollection, _$ChaptersCollection),
    ChapterDocPatchBuilder<ChapterDoc>,
    ChapterDocFilterBuilderRoot,
    ChapterDocOrderByBuilder,
    ChapterDocAggregateBuilderRoot
  >
  get chapters => FirestoreCollection(
    query: ref.collection('chapters'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => ChapterDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: ChapterDocPatchBuilder<ChapterDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: ChapterDocFilterBuilderRoot(),
    orderByBuilderFunc: (context) => ChapterDocOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        ChapterDocAggregateBuilderRoot(context: context),
  );

  /// Access entities subcollection
  FirestoreCollection<
    AppSchema,
    EntityDoc,
    (_$CampaignsCollection, _$EntitiesCollection),
    EntityDocPatchBuilder<EntityDoc>,
    EntityDocFilterBuilderRoot,
    EntityDocOrderByBuilder,
    EntityDocAggregateBuilderRoot
  >
  get entities => FirestoreCollection(
    query: ref.collection('entities'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => EntityDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: EntityDocPatchBuilder<EntityDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: EntityDocFilterBuilderRoot(),
    orderByBuilderFunc: (context) => EntityDocOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        EntityDocAggregateBuilderRoot(context: context),
  );

  /// Access encounters subcollection
  FirestoreCollection<
    AppSchema,
    EncounterDoc,
    (_$CampaignsCollection, _$EncountersCollection),
    EncounterDocPatchBuilder<EncounterDoc>,
    EncounterDocFilterBuilderRoot,
    EncounterDocOrderByBuilder,
    EncounterDocAggregateBuilderRoot
  >
  get encounters => FirestoreCollection(
    query: ref.collection('encounters'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => EncounterDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: EncounterDocPatchBuilder<EncounterDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: EncounterDocFilterBuilderRoot(),
    orderByBuilderFunc: (context) =>
        EncounterDocOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        EncounterDocAggregateBuilderRoot(context: context),
  );

  /// Access sessions subcollection
  FirestoreCollection<
    AppSchema,
    SessionDoc,
    (_$CampaignsCollection, _$SessionsCollection),
    SessionDocPatchBuilder<SessionDoc>,
    SessionDocFilterBuilderRoot,
    SessionDocOrderByBuilder,
    SessionDocAggregateBuilderRoot
  >
  get sessions => FirestoreCollection(
    query: ref.collection('sessions'),
    toJson: (value) => $SessionDocToJson(value),
    fromJson: (value) => SessionDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: SessionDocPatchBuilder<SessionDoc>(
      toJson: (value) => $SessionDocToJson(value),
    ),
    filterBuilder: SessionDocFilterBuilderRoot(),
    orderByBuilderFunc: (context) => SessionDocOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        SessionDocAggregateBuilderRoot(context: context),
  );

  /// Access media subcollection
  FirestoreCollection<
    AppSchema,
    MediaAssetDoc,
    (_$CampaignsCollection, _$MediaCollection),
    MediaAssetDocPatchBuilder<MediaAssetDoc>,
    MediaAssetDocFilterBuilderRoot,
    MediaAssetDocOrderByBuilder,
    MediaAssetDocAggregateBuilderRoot
  >
  get media => FirestoreCollection(
    query: ref.collection('media'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) =>
        MediaAssetDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: MediaAssetDocPatchBuilder<MediaAssetDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: MediaAssetDocFilterBuilderRoot(),
    orderByBuilderFunc: (context) =>
        MediaAssetDocOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        MediaAssetDocAggregateBuilderRoot(context: context),
  );
}

/// Document class for campaigns/*/chapters collection
extension $AppSchemaCampaignsChaptersDocument
    on
        FirestoreDocument<
          AppSchema,
          ChapterDoc,
          (_$CampaignsCollection, _$ChaptersCollection),
          ChapterDocPatchBuilder<ChapterDoc>
        > {
  /// Access adventures subcollection
  FirestoreCollection<
    AppSchema,
    AdventureDoc,
    (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
    AdventureDocPatchBuilder<AdventureDoc>,
    AdventureDocFilterBuilderRoot,
    AdventureDocOrderByBuilder,
    AdventureDocAggregateBuilderRoot
  >
  get adventures => FirestoreCollection(
    query: ref.collection('adventures'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => AdventureDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: AdventureDocPatchBuilder<AdventureDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: AdventureDocFilterBuilderRoot(),
    orderByBuilderFunc: (context) =>
        AdventureDocOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        AdventureDocAggregateBuilderRoot(context: context),
  );
}

/// Document class for campaigns/*/chapters/*/adventures collection
extension $AppSchemaCampaignsChaptersAdventuresDocument
    on
        FirestoreDocument<
          AppSchema,
          AdventureDoc,
          (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
          AdventureDocPatchBuilder<AdventureDoc>
        > {
  /// Access scenes subcollection
  FirestoreCollection<
    AppSchema,
    SceneDoc,
    (
      _$CampaignsCollection,
      _$ChaptersCollection,
      _$AdventuresCollection,
      _$ScenesCollection,
    ),
    SceneDocPatchBuilder<SceneDoc>,
    SceneDocFilterBuilderRoot,
    SceneDocOrderByBuilder,
    SceneDocAggregateBuilderRoot
  >
  get scenes => FirestoreCollection(
    query: ref.collection('scenes'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => SceneDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: SceneDocPatchBuilder<SceneDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: SceneDocFilterBuilderRoot(),
    orderByBuilderFunc: (context) => SceneDocOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        SceneDocAggregateBuilderRoot(context: context),
  );
}

/// Extension to add collections to BatchContext<AppSchema>
extension $AppSchemaBatchContextExtensions on BatchContext<AppSchema> {
  /// Access campaigns collection
  BatchCollection<
    AppSchema,
    Campaign,
    (_$CampaignsCollection,),
    CampaignPatchBuilder<Campaign>
  >
  get campaigns => BatchCollection(
    context: this,
    collection: firestoreInstance.collection('campaigns'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Campaign.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: CampaignPatchBuilder<Campaign>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );

  /// Access joins collection
  BatchCollection<
    AppSchema,
    JoinCode,
    (_$JoinsCollection,),
    JoinCodePatchBuilder<JoinCode>
  >
  get joins => BatchCollection(
    context: this,
    collection: firestoreInstance.collection('joins'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => JoinCode.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: JoinCodePatchBuilder<JoinCode>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );
}

/// Batch document class for campaigns collection
extension $AppSchemaCampaignsBatchDocument
    on
        BatchDocument<
          AppSchema,
          Campaign,
          (_$CampaignsCollection,),
          CampaignPatchBuilder<Campaign>
        > {
  /// Access chapters subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    ChapterDoc,
    (_$CampaignsCollection, _$ChaptersCollection),
    ChapterDocPatchBuilder<ChapterDoc>
  >
  get chapters => getBatchCollection(
    parent: this,
    name: 'chapters',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => ChapterDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: ChapterDocPatchBuilder<ChapterDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );

  /// Access entities subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    EntityDoc,
    (_$CampaignsCollection, _$EntitiesCollection),
    EntityDocPatchBuilder<EntityDoc>
  >
  get entities => getBatchCollection(
    parent: this,
    name: 'entities',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => EntityDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: EntityDocPatchBuilder<EntityDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );

  /// Access encounters subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    EncounterDoc,
    (_$CampaignsCollection, _$EncountersCollection),
    EncounterDocPatchBuilder<EncounterDoc>
  >
  get encounters => getBatchCollection(
    parent: this,
    name: 'encounters',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => EncounterDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: EncounterDocPatchBuilder<EncounterDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );

  /// Access sessions subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    SessionDoc,
    (_$CampaignsCollection, _$SessionsCollection),
    SessionDocPatchBuilder<SessionDoc>
  >
  get sessions => getBatchCollection(
    parent: this,
    name: 'sessions',
    toJson: (value) => $SessionDocToJson(value),
    fromJson: (value) => SessionDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: SessionDocPatchBuilder<SessionDoc>(
      toJson: (value) => $SessionDocToJson(value),
    ),
  );

  /// Access media subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    MediaAssetDoc,
    (_$CampaignsCollection, _$MediaCollection),
    MediaAssetDocPatchBuilder<MediaAssetDoc>
  >
  get media => getBatchCollection(
    parent: this,
    name: 'media',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) =>
        MediaAssetDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: MediaAssetDocPatchBuilder<MediaAssetDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );
}

/// Batch document class for campaigns/*/chapters collection
extension $AppSchemaCampaignsChaptersBatchDocument
    on
        BatchDocument<
          AppSchema,
          ChapterDoc,
          (_$CampaignsCollection, _$ChaptersCollection),
          ChapterDocPatchBuilder<ChapterDoc>
        > {
  /// Access adventures subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    AdventureDoc,
    (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
    AdventureDocPatchBuilder<AdventureDoc>
  >
  get adventures => getBatchCollection(
    parent: this,
    name: 'adventures',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => AdventureDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: AdventureDocPatchBuilder<AdventureDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );
}

/// Batch document class for campaigns/*/chapters/*/adventures collection
extension $AppSchemaCampaignsChaptersAdventuresBatchDocument
    on
        BatchDocument<
          AppSchema,
          AdventureDoc,
          (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
          AdventureDocPatchBuilder<AdventureDoc>
        > {
  /// Access scenes subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    SceneDoc,
    (
      _$CampaignsCollection,
      _$ChaptersCollection,
      _$AdventuresCollection,
      _$ScenesCollection,
    ),
    SceneDocPatchBuilder<SceneDoc>
  >
  get scenes => getBatchCollection(
    parent: this,
    name: 'scenes',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => SceneDoc.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: SceneDocPatchBuilder<SceneDoc>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );
}
