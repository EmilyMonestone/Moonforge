import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/media_asset_repository.dart';
import 'package:moonforge/data/repo/party_repository.dart';
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

  // Sync coordinator
  Provider<SyncCoordinator>(
    create: (_) => SyncCoordinator(db, FirebaseFirestore.instance)..start(),
    dispose: (_, sync) => sync.stop(),
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

  // Repositories
  Provider<CampaignRepository>(create: (_) => CampaignRepository(db)),
  Provider<ChapterRepository>(create: (_) => ChapterRepository(db)),
  Provider<AdventureRepository>(create: (_) => AdventureRepository(db)),
  Provider<SceneRepository>(create: (_) => SceneRepository(db)),
  Provider<PartyRepository>(create: (_) => PartyRepository(db)),
  Provider<EncounterRepository>(create: (_) => EncounterRepository(db)),
  Provider<EntityRepository>(create: (_) => EntityRepository(db)),
  Provider<MediaAssetRepository>(create: (_) => MediaAssetRepository(db)),
  Provider<SessionRepository>(create: (_) => SessionRepository(db)),
];
