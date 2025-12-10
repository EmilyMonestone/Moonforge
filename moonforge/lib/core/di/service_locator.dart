import 'package:get_it/get_it.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/combatant_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/player_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/data/repo/session_repository.dart';
import 'package:moonforge/features/adventure/services/adventure_navigation_service.dart';
import 'package:moonforge/features/adventure/services/adventure_service.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';
import 'package:moonforge/features/chapter/services/chapter_navigation_service.dart';
import 'package:moonforge/features/encounters/services/combatant_service.dart';
import 'package:moonforge/features/entities/services/entity_service.dart';
import 'package:moonforge/features/home/services/dashboard_service.dart';
import 'package:moonforge/features/home/services/quick_actions_service.dart';
import 'package:moonforge/features/parties/services/party_service.dart';
import 'package:moonforge/features/parties/services/player_character_service.dart';
import 'package:moonforge/features/scene/services/scene_navigation_service.dart';
import 'package:moonforge/features/session/services/session_service.dart';
import 'package:moonforge/features/session/services/session_sharing_service.dart';

final GetIt getIt = GetIt.instance;

/// Setup service locator and register lazy singletons
Future<void> setupServiceLocator({required AppDb db}) async {
  // Register database instance
  if (!getIt.isRegistered<AppDb>()) {
    getIt.registerSingleton<AppDb>(db);
  }

  // Repositories
  if (!getIt.isRegistered<CampaignRepository>()) {
    getIt.registerLazySingleton<CampaignRepository>(
      () => CampaignRepository(getIt<AppDb>()),
    );
  }
  if (!getIt.isRegistered<EntityRepository>()) {
    getIt.registerLazySingleton<EntityRepository>(
      () => EntityRepository(getIt<AppDb>()),
    );
  }
  if (!getIt.isRegistered<SessionRepository>()) {
    getIt.registerLazySingleton<SessionRepository>(
      () => SessionRepository(getIt<AppDb>()),
    );
  }
  if (!getIt.isRegistered<SceneRepository>()) {
    // Scene repository is used by scene-related providers/widgets
    getIt.registerLazySingleton<SceneRepository>(
      () => SceneRepository(getIt<AppDb>()),
    );
  }
  if (!getIt.isRegistered<PartyRepository>()) {
    getIt.registerLazySingleton<PartyRepository>(
      () => PartyRepository(getIt<AppDb>()),
    );
  }
  if (!getIt.isRegistered<PlayerRepository>()) {
    getIt.registerLazySingleton<PlayerRepository>(
      () => PlayerRepository(getIt<AppDb>()),
    );
  }
  if (!getIt.isRegistered<AdventureRepository>()) {
    getIt.registerLazySingleton<AdventureRepository>(
      () => AdventureRepository(getIt<AppDb>()),
    );
  }
  if (!getIt.isRegistered<ChapterRepository>()) {
    getIt.registerLazySingleton<ChapterRepository>(
      () => ChapterRepository(getIt<AppDb>()),
    );
  }
  if (!getIt.isRegistered<EncounterRepository>()) {
    getIt.registerLazySingleton<EncounterRepository>(
      () => EncounterRepository(getIt<AppDb>()),
    );
  }
  if (!getIt.isRegistered<CombatantRepository>()) {
    getIt.registerLazySingleton<CombatantRepository>(
      () => CombatantRepository(getIt<AppDb>()),
    );
  }

  // Services
  if (!getIt.isRegistered<CampaignService>()) {
    getIt.registerLazySingleton<CampaignService>(
      () => CampaignService(getIt<CampaignRepository>()),
    );
  }
  // QuickActionsService is lightweight and can be registered without external deps
  if (!getIt.isRegistered<QuickActionsService>()) {
    getIt.registerLazySingleton<QuickActionsService>(
      () => QuickActionsService(),
    );
  }
  if (!getIt.isRegistered<EntityService>()) {
    getIt.registerLazySingleton<EntityService>(
      () => EntityService(getIt<EntityRepository>()),
    );
  }
  if (!getIt.isRegistered<SessionService>()) {
    getIt.registerLazySingleton<SessionService>(
      () => SessionService(getIt<SessionRepository>()),
    );
  }
  if (!getIt.isRegistered<PartyService>()) {
    getIt.registerLazySingleton<PartyService>(
      () => PartyService(getIt<PartyRepository>(), getIt<PlayerRepository>()),
    );
  }
  if (!getIt.isRegistered<PlayerCharacterService>()) {
    getIt.registerLazySingleton<PlayerCharacterService>(
      () => PlayerCharacterService(getIt<PlayerRepository>()),
    );
  }

  // Optional services - register if not already registered elsewhere
  if (!getIt.isRegistered<AdventureService>()) {
    getIt.registerLazySingleton<AdventureService>(
      () => AdventureService(
        getIt<AdventureRepository>(),
        getIt<SceneRepository>(),
      ),
    );
  }
  if (!getIt.isRegistered<DashboardService>()) {
    getIt.registerLazySingleton<DashboardService>(
      () => DashboardService(
        campaignRepo: getIt<CampaignRepository>(),
        sessionRepo: getIt<SessionRepository>(),
        partyRepo: getIt<PartyRepository>(),
        entityRepo: getIt<EntityRepository>(),
      ),
    );
  }
  if (!getIt.isRegistered<ChapterNavigationService>()) {
    getIt.registerLazySingleton<ChapterNavigationService>(
      () => ChapterNavigationService(repository: getIt<ChapterRepository>()),
    );
  }
  if (!getIt.isRegistered<SceneNavigationService>()) {
    getIt.registerLazySingleton<SceneNavigationService>(
      () => SceneNavigationService(
        sceneRepository: getIt<SceneRepository>(),
        adventureRepository: getIt<AdventureRepository>(),
      ),
    );
  }
  if (!getIt.isRegistered<SessionSharingService>()) {
    getIt.registerLazySingleton<SessionSharingService>(
      () => SessionSharingService(getIt<SessionRepository>()),
    );
  }
  if (!getIt.isRegistered<CombatantService>()) {
    getIt.registerLazySingleton<CombatantService>(
      () => CombatantService(getIt<CombatantRepository>()),
    );
  }
  if (!getIt.isRegistered<AdventureNavigationService>()) {
    getIt.registerLazySingleton<AdventureNavigationService>(
      () => AdventureNavigationService(getIt<AdventureRepository>()),
    );
  }
}
