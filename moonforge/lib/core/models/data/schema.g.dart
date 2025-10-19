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

final class _$JoinsCollection {}

final class _$PartiesCollection {}

final class _$PlayersCollection {}

final class _$ChaptersCollection {}

final class _$AdventuresCollection {}

final class _$ScenesCollection {}

final class _$EntitiesCollection {}

final class _$EncountersCollection {}

final class _$SessionsCollection {}

final class _$MediaCollection {}

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
  /// Access parties subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    Party,
    (_$CampaignsCollection, _$PartiesCollection),
    PartyPatchBuilder<Party>
  >
  get parties =>
      TransactionCollection<
        AppSchema,
        Party,
        (_$CampaignsCollection, _$PartiesCollection),
        PartyPatchBuilder<Party>
      >(
        query: ref.collection('parties'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) => Party.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: PartyPatchBuilder<Party>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );

  /// Access players subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    Player,
    (_$CampaignsCollection, _$PlayersCollection),
    PlayerPatchBuilder<Player>
  >
  get players =>
      TransactionCollection<
        AppSchema,
        Player,
        (_$CampaignsCollection, _$PlayersCollection),
        PlayerPatchBuilder<Player>
      >(
        query: ref.collection('players'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) => Player.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: PlayerPatchBuilder<Player>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );

  /// Access chapters subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    Chapter,
    (_$CampaignsCollection, _$ChaptersCollection),
    ChapterPatchBuilder<Chapter>
  >
  get chapters =>
      TransactionCollection<
        AppSchema,
        Chapter,
        (_$CampaignsCollection, _$ChaptersCollection),
        ChapterPatchBuilder<Chapter>
      >(
        query: ref.collection('chapters'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) => Chapter.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: ChapterPatchBuilder<Chapter>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );

  /// Access entities subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    Entity,
    (_$CampaignsCollection, _$EntitiesCollection),
    EntityPatchBuilder<Entity>
  >
  get entities =>
      TransactionCollection<
        AppSchema,
        Entity,
        (_$CampaignsCollection, _$EntitiesCollection),
        EntityPatchBuilder<Entity>
      >(
        query: ref.collection('entities'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) => Entity.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: EntityPatchBuilder<Entity>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );

  /// Access encounters subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    Encounter,
    (_$CampaignsCollection, _$EncountersCollection),
    EncounterPatchBuilder<Encounter>
  >
  get encounters =>
      TransactionCollection<
        AppSchema,
        Encounter,
        (_$CampaignsCollection, _$EncountersCollection),
        EncounterPatchBuilder<Encounter>
      >(
        query: ref.collection('encounters'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) =>
            Encounter.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: EncounterPatchBuilder<Encounter>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );

  /// Access sessions subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    Session,
    (_$CampaignsCollection, _$SessionsCollection),
    SessionPatchBuilder<Session>
  >
  get sessions =>
      TransactionCollection<
        AppSchema,
        Session,
        (_$CampaignsCollection, _$SessionsCollection),
        SessionPatchBuilder<Session>
      >(
        query: ref.collection('sessions'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) => Session.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: SessionPatchBuilder<Session>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );

  /// Access media subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    MediaAsset,
    (_$CampaignsCollection, _$MediaCollection),
    MediaAssetPatchBuilder<MediaAsset>
  >
  get media =>
      TransactionCollection<
        AppSchema,
        MediaAsset,
        (_$CampaignsCollection, _$MediaCollection),
        MediaAssetPatchBuilder<MediaAsset>
      >(
        query: ref.collection('media'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) =>
            MediaAsset.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: MediaAssetPatchBuilder<MediaAsset>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );
}

/// Transaction document class for campaigns/*/chapters collection
extension $AppSchemaCampaignsChaptersTransactionDocument
    on
        TransactionDocument<
          AppSchema,
          Chapter,
          (_$CampaignsCollection, _$ChaptersCollection),
          ChapterPatchBuilder<Chapter>
        > {
  /// Access adventures subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    Adventure,
    (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
    AdventurePatchBuilder<Adventure>
  >
  get adventures =>
      TransactionCollection<
        AppSchema,
        Adventure,
        (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
        AdventurePatchBuilder<Adventure>
      >(
        query: ref.collection('adventures'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) =>
            Adventure.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: AdventurePatchBuilder<Adventure>(
          toJson: (value) => (value.toJson() as Map<String, dynamic>),
        ),
      );
}

/// Transaction document class for campaigns/*/chapters/*/adventures collection
extension $AppSchemaCampaignsChaptersAdventuresTransactionDocument
    on
        TransactionDocument<
          AppSchema,
          Adventure,
          (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
          AdventurePatchBuilder<Adventure>
        > {
  /// Access scenes subcollection
  @pragma('vm:prefer-inline')
  TransactionCollection<
    AppSchema,
    Scene,
    (
      _$CampaignsCollection,
      _$ChaptersCollection,
      _$AdventuresCollection,
      _$ScenesCollection,
    ),
    ScenePatchBuilder<Scene>
  >
  get scenes =>
      TransactionCollection<
        AppSchema,
        Scene,
        (
          _$CampaignsCollection,
          _$ChaptersCollection,
          _$AdventuresCollection,
          _$ScenesCollection,
        ),
        ScenePatchBuilder<Scene>
      >(
        query: ref.collection('scenes'),
        context: context,
        toJson: (value) => (value.toJson() as Map<String, dynamic>),
        fromJson: (value) => Scene.fromJson((value as Map<String, dynamic>)),
        documentIdField: 'id',
        patchBuilder: ScenePatchBuilder<Scene>(
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
  /// Access parties subcollection
  FirestoreCollection<
    AppSchema,
    Party,
    (_$CampaignsCollection, _$PartiesCollection),
    PartyPatchBuilder<Party>,
    PartyFilterBuilderRoot,
    PartyOrderByBuilder,
    PartyAggregateBuilderRoot
  >
  get parties => FirestoreCollection(
    query: ref.collection('parties'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Party.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: PartyPatchBuilder<Party>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: PartyFilterBuilderRoot(),
    orderByBuilderFunc: (context) => PartyOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        PartyAggregateBuilderRoot(context: context),
  );

  /// Access players subcollection
  FirestoreCollection<
    AppSchema,
    Player,
    (_$CampaignsCollection, _$PlayersCollection),
    PlayerPatchBuilder<Player>,
    PlayerFilterBuilderRoot,
    PlayerOrderByBuilder,
    PlayerAggregateBuilderRoot
  >
  get players => FirestoreCollection(
    query: ref.collection('players'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Player.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: PlayerPatchBuilder<Player>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: PlayerFilterBuilderRoot(),
    orderByBuilderFunc: (context) => PlayerOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        PlayerAggregateBuilderRoot(context: context),
  );

  /// Access chapters subcollection
  FirestoreCollection<
    AppSchema,
    Chapter,
    (_$CampaignsCollection, _$ChaptersCollection),
    ChapterPatchBuilder<Chapter>,
    ChapterFilterBuilderRoot,
    ChapterOrderByBuilder,
    ChapterAggregateBuilderRoot
  >
  get chapters => FirestoreCollection(
    query: ref.collection('chapters'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Chapter.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: ChapterPatchBuilder<Chapter>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: ChapterFilterBuilderRoot(),
    orderByBuilderFunc: (context) => ChapterOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        ChapterAggregateBuilderRoot(context: context),
  );

  /// Access entities subcollection
  FirestoreCollection<
    AppSchema,
    Entity,
    (_$CampaignsCollection, _$EntitiesCollection),
    EntityPatchBuilder<Entity>,
    EntityFilterBuilderRoot,
    EntityOrderByBuilder,
    EntityAggregateBuilderRoot
  >
  get entities => FirestoreCollection(
    query: ref.collection('entities'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Entity.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: EntityPatchBuilder<Entity>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: EntityFilterBuilderRoot(),
    orderByBuilderFunc: (context) => EntityOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        EntityAggregateBuilderRoot(context: context),
  );

  /// Access encounters subcollection
  FirestoreCollection<
    AppSchema,
    Encounter,
    (_$CampaignsCollection, _$EncountersCollection),
    EncounterPatchBuilder<Encounter>,
    EncounterFilterBuilderRoot,
    EncounterOrderByBuilder,
    EncounterAggregateBuilderRoot
  >
  get encounters => FirestoreCollection(
    query: ref.collection('encounters'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Encounter.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: EncounterPatchBuilder<Encounter>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: EncounterFilterBuilderRoot(),
    orderByBuilderFunc: (context) => EncounterOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        EncounterAggregateBuilderRoot(context: context),
  );

  /// Access sessions subcollection
  FirestoreCollection<
    AppSchema,
    Session,
    (_$CampaignsCollection, _$SessionsCollection),
    SessionPatchBuilder<Session>,
    SessionFilterBuilderRoot,
    SessionOrderByBuilder,
    SessionAggregateBuilderRoot
  >
  get sessions => FirestoreCollection(
    query: ref.collection('sessions'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Session.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: SessionPatchBuilder<Session>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: SessionFilterBuilderRoot(),
    orderByBuilderFunc: (context) => SessionOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        SessionAggregateBuilderRoot(context: context),
  );

  /// Access media subcollection
  FirestoreCollection<
    AppSchema,
    MediaAsset,
    (_$CampaignsCollection, _$MediaCollection),
    MediaAssetPatchBuilder<MediaAsset>,
    MediaAssetFilterBuilderRoot,
    MediaAssetOrderByBuilder,
    MediaAssetAggregateBuilderRoot
  >
  get media => FirestoreCollection(
    query: ref.collection('media'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => MediaAsset.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: MediaAssetPatchBuilder<MediaAsset>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: MediaAssetFilterBuilderRoot(),
    orderByBuilderFunc: (context) => MediaAssetOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        MediaAssetAggregateBuilderRoot(context: context),
  );
}

/// Document class for campaigns/*/chapters collection
extension $AppSchemaCampaignsChaptersDocument
    on
        FirestoreDocument<
          AppSchema,
          Chapter,
          (_$CampaignsCollection, _$ChaptersCollection),
          ChapterPatchBuilder<Chapter>
        > {
  /// Access adventures subcollection
  FirestoreCollection<
    AppSchema,
    Adventure,
    (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
    AdventurePatchBuilder<Adventure>,
    AdventureFilterBuilderRoot,
    AdventureOrderByBuilder,
    AdventureAggregateBuilderRoot
  >
  get adventures => FirestoreCollection(
    query: ref.collection('adventures'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Adventure.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: AdventurePatchBuilder<Adventure>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: AdventureFilterBuilderRoot(),
    orderByBuilderFunc: (context) => AdventureOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        AdventureAggregateBuilderRoot(context: context),
  );
}

/// Document class for campaigns/*/chapters/*/adventures collection
extension $AppSchemaCampaignsChaptersAdventuresDocument
    on
        FirestoreDocument<
          AppSchema,
          Adventure,
          (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
          AdventurePatchBuilder<Adventure>
        > {
  /// Access scenes subcollection
  FirestoreCollection<
    AppSchema,
    Scene,
    (
      _$CampaignsCollection,
      _$ChaptersCollection,
      _$AdventuresCollection,
      _$ScenesCollection,
    ),
    ScenePatchBuilder<Scene>,
    SceneFilterBuilderRoot,
    SceneOrderByBuilder,
    SceneAggregateBuilderRoot
  >
  get scenes => FirestoreCollection(
    query: ref.collection('scenes'),
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Scene.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: ScenePatchBuilder<Scene>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
    filterBuilder: SceneFilterBuilderRoot(),
    orderByBuilderFunc: (context) => SceneOrderByBuilder(context: context),
    aggregateBuilderFunc: (context) =>
        SceneAggregateBuilderRoot(context: context),
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
  /// Access parties subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    Party,
    (_$CampaignsCollection, _$PartiesCollection),
    PartyPatchBuilder<Party>
  >
  get parties => getBatchCollection(
    parent: this,
    name: 'parties',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Party.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: PartyPatchBuilder<Party>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );

  /// Access players subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    Player,
    (_$CampaignsCollection, _$PlayersCollection),
    PlayerPatchBuilder<Player>
  >
  get players => getBatchCollection(
    parent: this,
    name: 'players',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Player.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: PlayerPatchBuilder<Player>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );

  /// Access chapters subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    Chapter,
    (_$CampaignsCollection, _$ChaptersCollection),
    ChapterPatchBuilder<Chapter>
  >
  get chapters => getBatchCollection(
    parent: this,
    name: 'chapters',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Chapter.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: ChapterPatchBuilder<Chapter>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );

  /// Access entities subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    Entity,
    (_$CampaignsCollection, _$EntitiesCollection),
    EntityPatchBuilder<Entity>
  >
  get entities => getBatchCollection(
    parent: this,
    name: 'entities',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Entity.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: EntityPatchBuilder<Entity>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );

  /// Access encounters subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    Encounter,
    (_$CampaignsCollection, _$EncountersCollection),
    EncounterPatchBuilder<Encounter>
  >
  get encounters => getBatchCollection(
    parent: this,
    name: 'encounters',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Encounter.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: EncounterPatchBuilder<Encounter>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );

  /// Access sessions subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    Session,
    (_$CampaignsCollection, _$SessionsCollection),
    SessionPatchBuilder<Session>
  >
  get sessions => getBatchCollection(
    parent: this,
    name: 'sessions',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Session.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: SessionPatchBuilder<Session>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );

  /// Access media subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    MediaAsset,
    (_$CampaignsCollection, _$MediaCollection),
    MediaAssetPatchBuilder<MediaAsset>
  >
  get media => getBatchCollection(
    parent: this,
    name: 'media',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => MediaAsset.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: MediaAssetPatchBuilder<MediaAsset>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );
}

/// Batch document class for campaigns/*/chapters collection
extension $AppSchemaCampaignsChaptersBatchDocument
    on
        BatchDocument<
          AppSchema,
          Chapter,
          (_$CampaignsCollection, _$ChaptersCollection),
          ChapterPatchBuilder<Chapter>
        > {
  /// Access adventures subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    Adventure,
    (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
    AdventurePatchBuilder<Adventure>
  >
  get adventures => getBatchCollection(
    parent: this,
    name: 'adventures',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Adventure.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: AdventurePatchBuilder<Adventure>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );
}

/// Batch document class for campaigns/*/chapters/*/adventures collection
extension $AppSchemaCampaignsChaptersAdventuresBatchDocument
    on
        BatchDocument<
          AppSchema,
          Adventure,
          (_$CampaignsCollection, _$ChaptersCollection, _$AdventuresCollection),
          AdventurePatchBuilder<Adventure>
        > {
  /// Access scenes subcollection
  @pragma('vm:prefer-inline')
  BatchCollection<
    AppSchema,
    Scene,
    (
      _$CampaignsCollection,
      _$ChaptersCollection,
      _$AdventuresCollection,
      _$ScenesCollection,
    ),
    ScenePatchBuilder<Scene>
  >
  get scenes => getBatchCollection(
    parent: this,
    name: 'scenes',
    toJson: (value) => (value.toJson() as Map<String, dynamic>),
    fromJson: (value) => Scene.fromJson((value as Map<String, dynamic>)),
    documentIdField: 'id',
    patchBuilder: ScenePatchBuilder<Scene>(
      toJson: (value) => (value.toJson() as Map<String, dynamic>),
    ),
  );
}
