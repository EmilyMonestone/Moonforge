import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/app_settings_provider.dart';
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/core/providers/bestiary_provider.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/db_providers.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/player_repository.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:moonforge/features/parties/controllers/party_provider.dart';
import 'package:moonforge/features/parties/controllers/player_provider.dart';
import 'package:provider/provider.dart';

class MultiProviderWrapper extends StatelessWidget {
  final AppDb db;
  final Widget child;

  const MultiProviderWrapper({super.key, required this.db, required this.child});

  @override
  Widget build(BuildContext context) {
    // Providers
    AuthProvider authProvider = AuthProvider();
    AppSettingsProvider appSettingsProvider = AppSettingsProvider();
    CampaignProvider campaignProvider = CampaignProvider();
    BestiaryProvider bestiaryProvider = BestiaryProvider();
    
    // Party and Player providers
    PartyProvider partyProvider = PartyProvider(PartyRepository(db));
    PlayerProvider playerProvider = PlayerProvider(PlayerRepository(db));

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProxyProvider<AuthProvider, AppSettingsProvider>(
          create: (BuildContext context) {
            return AppSettingsProvider();
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
        ChangeNotifierProvider<PartyProvider>.value(value: partyProvider),
        ChangeNotifierProvider<PlayerProvider>.value(value: playerProvider),
        ...dbProviders(db),
      ],
      child: child,
    );
  }
}
