import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'db/app_db.dart';
import 'db/sync/sync_coordinator.dart';
import 'repo_new/campaign_repository.dart';
import 'repo_new/chapter_repository.dart';
import 'repo_new/adventure_repository.dart';
import 'repo_new/scene_repository.dart';
import 'repo_new/party_repository.dart';
import 'repo_new/encounter_repository.dart';
import 'repo_new/entity_repository.dart';
import 'repo_new/media_asset_repository.dart';

/// Providers for the new database layer
/// 
/// Usage:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp();
///   
///   // Disable Firestore persistence (we use Drift instead)
///   await FirebaseFirestore.instance.setPersistenceEnabled(false);
///   
///   // Construct database
///   final db = await constructDb();
///   
///   runApp(
///     MultiProvider(
///       providers: [
///         ...dbProviders(db),
///         // ... other providers
///       ],
///       child: MyApp(),
///     ),
///   );
/// }
/// ```
List<Provider> dbProviders(AppDb db) => [
  // Database instance
  Provider<AppDb>.value(value: db),
  
  // Sync coordinator
  Provider<SyncCoordinator>(
    create: (_) => SyncCoordinator(db, FirebaseFirestore.instance)..start(),
    dispose: (_, sync) => sync.stop(),
  ),
  
  // Repositories
  Provider<CampaignRepository>(
    create: (_) => CampaignRepository(db),
  ),
  Provider<ChapterRepository>(
    create: (_) => ChapterRepository(db),
  ),
  Provider<AdventureRepository>(
    create: (_) => AdventureRepository(db),
  ),
  Provider<SceneRepository>(
    create: (_) => SceneRepository(db),
  ),
  Provider<PartyRepository>(
    create: (_) => PartyRepository(db),
  ),
  Provider<EncounterRepository>(
    create: (_) => EncounterRepository(db),
  ),
  Provider<EntityRepository>(
    create: (_) => EntityRepository(db),
  ),
  Provider<MediaAssetRepository>(
    create: (_) => MediaAssetRepository(db),
  ),
];
