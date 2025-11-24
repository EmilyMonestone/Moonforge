import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/services/service_factory.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';
import 'package:moonforge/features/entities/services/entity_service.dart';
import 'package:moonforge/features/home/services/quick_actions_service.dart';
import 'package:moonforge/features/parties/services/party_service.dart';
import 'package:moonforge/features/parties/services/player_character_service.dart';
import 'package:moonforge/features/session/services/session_service.dart';
import 'package:moonforge/features/settings/services/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Expose commonly used services via Providers for components that rely on Provider
List<SingleChildWidget> diProviders() {
  return [
    Provider.value(value: getIt<CampaignService>()),
    Provider.value(value: getIt<EntityService>()),
    Provider.value(value: getIt<SessionService>()),
    if (getIt.isRegistered<QuickActionsService>())
      Provider.value(value: getIt<QuickActionsService>()),
    if (getIt.isRegistered<SettingsService>())
      Provider.value(value: getIt<SettingsService>()),
    if (getIt.isRegistered<ServiceFactory>())
      Provider.value(value: getIt<ServiceFactory>()),
    Provider.value(value: getIt<PartyService>()),
    Provider.value(value: getIt<PlayerCharacterService>()),
  ];
}
