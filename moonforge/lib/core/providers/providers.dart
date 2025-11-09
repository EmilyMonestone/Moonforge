import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/app_settings_provider.dart';
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/core/providers/bestiary_provider.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/db_providers.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/player_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/scene/controllers/scene_provider.dart';
import 'package:moonforge/features/settings/services/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiProviderWrapper extends StatelessWidget {
  final AppDb db;
  final Widget child;

  const MultiProviderWrapper({super.key, required this.db, required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        // While loading, show a loading indicator
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final prefs = snapshot.data!;
        final settingsService = SettingsService(prefs);
        
        // Providers
        AuthProvider authProvider = AuthProvider();
        AppSettingsProvider appSettingsProvider = AppSettingsProvider(settingsService);
        CampaignProvider campaignProvider = CampaignProvider();
        BestiaryProvider bestiaryProvider = BestiaryProvider();
        PartyProvider partyProvider = PartyProvider(PartyRepository(db));
        PlayerProvider playerProvider = PlayerProvider(PlayerRepository(db));

        return MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
            ChangeNotifierProxyProvider<AuthProvider, AppSettingsProvider>(
              create: (BuildContext context) {
                return appSettingsProvider;
              },
              update:
                  (
                    BuildContext context,
                    AuthProvider value,
                    AppSettingsProvider? previous,
                  ) {
                    appSettingsProvider.updateOnAuthChange(value);
                    return appSettingsProvider;
                  },
            ),
            ChangeNotifierProvider<CampaignProvider>.value(value: campaignProvider),
            ChangeNotifierProvider<BestiaryProvider>.value(value: bestiaryProvider),
            ChangeNotifierProxyProvider<SceneRepository, SceneProvider>(
              create: (context) => SceneProvider(context.read<SceneRepository>()),
              update: (context, sceneRepo, previous) =>
                  previous ?? SceneProvider(sceneRepo),
            ),
            ChangeNotifierProvider<PartyProvider>.value(value: partyProvider),
            ChangeNotifierProvider<PlayerProvider>.value(value: playerProvider),
            ...dbProviders(db),
          ],
          child: child,
        );
      },
    );
  }
}
