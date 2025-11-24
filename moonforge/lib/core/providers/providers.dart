import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:moonforge/core/di/di_providers.dart';
import 'package:moonforge/core/di/service_locator.dart';
import 'package:moonforge/core/providers/app_settings_provider.dart';
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/core/providers/bestiary_provider.dart';
import 'package:moonforge/core/providers/gemini_provider.dart';
import 'package:moonforge/core/services/gemini_service.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/db_providers.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/player_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/parties/controllers/party_provider.dart';
import 'package:moonforge/features/parties/controllers/player_provider.dart';
import 'package:moonforge/features/scene/controllers/scene_provider.dart';
import 'package:moonforge/features/settings/services/settings_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiProviderWrapper extends StatelessWidget {
  final AppDb db;
  final Widget child;

  const MultiProviderWrapper({
    super.key,
    required this.db,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        // While loading, show a loading indicator
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        final prefs = snapshot.data!;
        // Register SettingsService with DI so it can be injected via get_it
        final settingsService = SettingsService(prefs);
        if (!getIt.isRegistered<SettingsService>()) {
          getIt.registerSingleton<SettingsService>(settingsService);
        }

        // Initialize Gemini if API key is available
        final geminiApiKey = dotenv.env['GEMINI_API_KEY'];
        if (geminiApiKey != null && geminiApiKey.isNotEmpty) {
          try {
            GeminiProvider.initialize(geminiApiKey);
          } catch (e) {
            debugPrint('Failed to initialize Gemini: $e');
          }
        }

        // Providers
        AuthProvider authProvider = AuthProvider();
        AppSettingsProvider appSettingsProvider = AppSettingsProvider(
          settingsService,
        );
        CampaignProvider campaignProvider = CampaignProvider();
        BestiaryProvider bestiaryProvider = BestiaryProvider();
        // Use DI-registered repositories instead of direct construction
        PartyProvider partyProvider = PartyProvider(getIt<PartyRepository>());
        PlayerProvider playerProvider = PlayerProvider(
          getIt<PlayerRepository>(),
        );

        return MultiProvider(
          providers: [
            // expose DI-registered services via Provider for compatibility
            ...diProviders(),
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
            ChangeNotifierProvider<CampaignProvider>.value(
              value: campaignProvider,
            ),
            ChangeNotifierProvider<BestiaryProvider>.value(
              value: bestiaryProvider,
            ),
            ChangeNotifierProvider<PartyProvider>.value(value: partyProvider),
            ChangeNotifierProvider<PlayerProvider>.value(value: playerProvider),
            // Gemini AI provider - only if initialized
            if (GeminiProvider.isInitialized)
              ChangeNotifierProvider<GeminiProvider>(
                create: (context) =>
                    GeminiProvider(GeminiService(Gemini.instance)),
              ),
            // dbProviders may include repository providers that expect db; keep them for now
            ...dbProviders(db),
            ChangeNotifierProxyProvider<SceneRepository, SceneProvider>(
              create: (context) => SceneProvider(getIt<SceneRepository>()),
              update: (context, sceneRepo, previous) =>
                  previous ?? SceneProvider(getIt<SceneRepository>()),
            ),
          ],
          child: child,
        );
      },
    );
  }
}
