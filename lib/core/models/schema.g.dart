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
}
