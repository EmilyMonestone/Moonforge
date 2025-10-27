import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/core/models/data/adventure.dart';
import 'package:moonforge/core/models/data/chapter.dart';
import 'package:moonforge/core/models/data/scene.dart';
import 'package:moonforge/core/models/data/encounter.dart';
import 'package:moonforge/core/models/data/entity.dart';
import 'package:moonforge/core/models/data/session.dart';
import 'package:moonforge/core/models/data/media_asset.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/providers/sync_state_provider.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/session_repository.dart';
import 'package:moonforge/data/repo/media_asset_repository.dart';
import 'package:moonforge/data/sync/sync_engine.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Drift offline-first providers for the application
/// 
/// Usage:
/// ```dart
/// MultiProvider(
///   providers: [
///     ...driftProviders(),
///     // ... other providers
///   ],
///   child: MyApp(),
/// )
/// ```
List<SingleChildWidget> driftProviders() {
  return [
    // AppDatabase singleton
    Provider<AppDatabase>(
      create: (_) => AppDatabase(),
      dispose: (_, db) => db.close(),
    ),

    // Repositories
    ProxyProvider<AppDatabase, CampaignRepository>(
      update: (_, db, __) => CampaignRepository(db),
    ),
    ProxyProvider<AppDatabase, AdventureRepository>(
      update: (_, db, __) => AdventureRepository(db),
    ),
    ProxyProvider<AppDatabase, ChapterRepository>(
      update: (_, db, __) => ChapterRepository(db),
    ),
    ProxyProvider<AppDatabase, SceneRepository>(
      update: (_, db, __) => SceneRepository(db),
    ),
    ProxyProvider<AppDatabase, EncounterRepository>(
      update: (_, db, __) => EncounterRepository(db),
    ),
    ProxyProvider<AppDatabase, EntityRepository>(
      update: (_, db, __) => EntityRepository(db),
    ),
    ProxyProvider<AppDatabase, SessionRepository>(
      update: (_, db, __) => SessionRepository(db),
    ),
    ProxyProvider<AppDatabase, MediaAssetRepository>(
      update: (_, db, __) => MediaAssetRepository(db),
    ),

    // SyncEngine (requires Firestore)
    ProxyProvider<AppDatabase, SyncEngine>(
      update: (_, db, previous) {
        final engine = previous ?? SyncEngine(db, FirebaseFirestore.instance);
        if (previous == null) {
          engine.start();
        }
        return engine;
      },
      dispose: (_, engine) => engine.stop(),
    ),

    // SyncStateProvider for tracking sync status
    ChangeNotifierProxyProvider<AppDatabase, SyncStateProvider>(
      create: (context) => SyncStateProvider(context.read<AppDatabase>()),
      update: (_, db, previous) => previous ?? SyncStateProvider(db),
    ),

    // StreamProviders for all models
    StreamProvider<List<Campaign>>(
      create: (context) => context.read<CampaignRepository>().watchAll(),
      initialData: const [],
    ),
    StreamProvider<List<Adventure>>(
      create: (context) => context.read<AdventureRepository>().watchAll(),
      initialData: const [],
    ),
    StreamProvider<List<Chapter>>(
      create: (context) => context.read<ChapterRepository>().watchAll(),
      initialData: const [],
    ),
    StreamProvider<List<Scene>>(
      create: (context) => context.read<SceneRepository>().watchAll(),
      initialData: const [],
    ),
    StreamProvider<List<Encounter>>(
      create: (context) => context.read<EncounterRepository>().watchAll(),
      initialData: const [],
    ),
    StreamProvider<List<Entity>>(
      create: (context) => context.read<EntityRepository>().watchAll(),
      initialData: const [],
    ),
    StreamProvider<List<Session>>(
      create: (context) => context.read<SessionRepository>().watchAll(),
      initialData: const [],
    ),
    StreamProvider<List<MediaAsset>>(
      create: (context) => context.read<MediaAssetRepository>().watchAll(),
      initialData: const [],
    ),
  ];
}
