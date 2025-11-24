import 'package:get_it/get_it.dart';
import 'package:moonforge/features/adventure/services/adventure_service.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';
import 'package:moonforge/features/chapter/services/chapter_navigation_service.dart';
import 'package:moonforge/features/chapter/services/chapter_service.dart';
import 'package:moonforge/features/encounters/services/combatant_service.dart';
import 'package:moonforge/features/entities/services/entity_service.dart';
import 'package:moonforge/features/home/services/dashboard_service.dart';
import 'package:moonforge/features/home/services/quick_actions_service.dart';
import 'package:moonforge/features/parties/services/party_service.dart';
import 'package:moonforge/features/parties/services/player_character_service.dart';
import 'package:moonforge/features/scene/services/scene_navigation_service.dart';
import 'package:moonforge/features/scene/services/scene_service.dart';
import 'package:moonforge/features/session/services/session_service.dart';
import 'package:moonforge/features/session/services/session_sharing_service.dart';
import 'package:moonforge/features/settings/services/settings_service.dart';

final GetIt _getIt = GetIt.instance;

/// A small, get_it-backed facade that exposes commonly used services.
///
/// This provides a single place for code to obtain feature services while
/// keeping the concrete DI container usage centralized.
class ServiceFactory {
  ServiceFactory._();

  /// Public factory to allow cross-file instantiation
  factory ServiceFactory.create() => ServiceFactory._();

  static ServiceFactory get instance => _getIt<ServiceFactory>();

  CampaignService? get campaign =>
      _getIt.isRegistered<CampaignService>() ? _getIt<CampaignService>() : null;

  EntityService? get entity =>
      _getIt.isRegistered<EntityService>() ? _getIt<EntityService>() : null;

  SessionService? get session =>
      _getIt.isRegistered<SessionService>() ? _getIt<SessionService>() : null;

  ChapterService? get chapter =>
      _getIt.isRegistered<ChapterService>() ? _getIt<ChapterService>() : null;

  SceneService? get scene =>
      _getIt.isRegistered<SceneService>() ? _getIt<SceneService>() : null;

  PartyService? get party =>
      _getIt.isRegistered<PartyService>() ? _getIt<PartyService>() : null;

  PlayerCharacterService? get playerCharacter =>
      _getIt.isRegistered<PlayerCharacterService>()
      ? _getIt<PlayerCharacterService>()
      : null;

  QuickActionsService? get quickActions =>
      _getIt.isRegistered<QuickActionsService>()
      ? _getIt<QuickActionsService>()
      : null;

  SettingsService? get settings =>
      _getIt.isRegistered<SettingsService>() ? _getIt<SettingsService>() : null;

  AdventureService? get adventure => _getIt.isRegistered<AdventureService>()
      ? _getIt<AdventureService>()
      : null;

  DashboardService? get dashboard => _getIt.isRegistered<DashboardService>()
      ? _getIt<DashboardService>()
      : null;

  ChapterNavigationService? get chapterNavigation =>
      _getIt.isRegistered<ChapterNavigationService>()
      ? _getIt<ChapterNavigationService>()
      : null;

  SceneNavigationService? get sceneNavigation =>
      _getIt.isRegistered<SceneNavigationService>()
      ? _getIt<SceneNavigationService>()
      : null;

  SessionSharingService? get sessionSharing =>
      _getIt.isRegistered<SessionSharingService>()
      ? _getIt<SessionSharingService>()
      : null;

  CombatantService? get combatant => _getIt.isRegistered<CombatantService>()
      ? _getIt<CombatantService>()
      : null;

  /// Safely try to obtain a service or null
  T? getIfRegistered<T extends Object>() =>
      _getIt.isRegistered<T>() ? _getIt<T>() : null;
}
