import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/combatant_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/media_asset_repository.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/player_repository.dart';
import 'package:moonforge/data/repo/repository_factory.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/data/repo/session_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'db/app_db.dart';
import 'db/sync/sync_coordinator.dart';
import 'providers/sync_state_provider.dart';

List<SingleChildWidget> dbProviders(AppDb db) => [
  // Database instance
  Provider<AppDb>.value(value: db),

  // Repository factory
  Provider<RepositoryFactory>(
    create: (_) => RepositoryFactory(db, firestore: FirebaseFirestore.instance),
  ),

  // Sync coordinator
  Provider<SyncCoordinator>(
    create: (ctx) {
      logger.i('[dbProviders] Creating SyncCoordinator provider', context: LogContext.sync);
      return SyncCoordinator(db, FirebaseFirestore.instance)..start();
    },
    dispose: (_, sync) {
      logger.i('[dbProviders] Disposing SyncCoordinator provider', context: LogContext.sync);
      sync.stop();
    },
  ),

  // Sync state provider (polls outbox to show syncing/pending/error state)
  ChangeNotifierProvider<SyncStateProvider>(
    create: (_) => SyncStateProvider(db),
  ),

  // Drift streams for UI (reactive lists)
  /// usage: final campaigns = context.watch<List<Campaign>>();
  StreamProvider<List<Campaign>>(
    create: (_) => db.campaignDao.watchAll(),
    initialData: const <Campaign>[],
  ),
  StreamProvider<List<Chapter>>(
    create: (_) => db.chapterDao.watchAll(),
    initialData: const <Chapter>[],
  ),
  StreamProvider<List<Adventure>>(
    create: (_) => db.adventureDao.watchAll(),
    initialData: const <Adventure>[],
  ),
  StreamProvider<List<Scene>>(
    create: (_) => db.sceneDao.watchAll(),
    initialData: const <Scene>[],
  ),
  StreamProvider<List<Encounter>>(
    create: (_) => db.encounterDao.watchAll(),
    initialData: const <Encounter>[],
  ),
  StreamProvider<List<Entity>>(
    create: (_) => db.entityDao.watchAll(),
    initialData: const <Entity>[],
  ),
  StreamProvider<List<Party>>(
    create: (_) => db.partyDao.watchAll(),
    initialData: const <Party>[],
  ),
  StreamProvider<List<Session>>(
    create: (_) => db.sessionDao.watchAll(),
    initialData: const <Session>[],
  ),
  StreamProvider<List<MediaAsset>>(
    create: (_) => db.mediaAssetDao.watchAll(),
    initialData: const <MediaAsset>[],
  ),

  // Repositories (constructed via factory for consistency)
  Provider<CampaignRepository>(
    create: (ctx) => ctx.read<RepositoryFactory>().campaignRepo(),
  ),
  Provider<ChapterRepository>(
    create: (ctx) => ctx.read<RepositoryFactory>().chapterRepo(),
  ),
  Provider<AdventureRepository>(
    create: (ctx) => ctx.read<RepositoryFactory>().adventureRepo(),
  ),
  Provider<SceneRepository>(
    create: (ctx) => ctx.read<RepositoryFactory>().sceneRepo(),
  ),
  Provider<PartyRepository>(
    create: (ctx) => ctx.read<RepositoryFactory>().partyRepo(),
  ),
  Provider<EncounterRepository>(
    create: (ctx) => ctx.read<RepositoryFactory>().encounterRepo(),
  ),
  Provider<EntityRepository>(
    create: (ctx) => ctx.read<RepositoryFactory>().entityRepo(),
  ),
  Provider<MediaAssetRepository>(
    create: (ctx) => ctx.read<RepositoryFactory>().mediaRepo(),
  ),
  Provider<SessionRepository>(
    create: (ctx) => ctx.read<RepositoryFactory>().sessionRepo(),
  ),
  Provider<PlayerRepository>(
    create: (ctx) => ctx.read<RepositoryFactory>().playerRepo(),
  ),
  Provider<CombatantRepository>(
    create: (ctx) => ctx.read<RepositoryFactory>().combatantRepo(),
  ),
];
