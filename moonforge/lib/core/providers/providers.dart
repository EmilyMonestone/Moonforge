import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:moonforge/core/providers/app_settings_provider.dart';
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/core/providers/bestiary_provider.dart';
import 'package:moonforge/data/isar_providers.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:provider/provider.dart';

class MultiProviderWrapper extends StatelessWidget {
  final Widget child;
  final Isar isar;

  const MultiProviderWrapper({
    super.key,
    required this.child,
    required this.isar,
  });

  @override
  Widget build(BuildContext context) {
    // Providers
    AuthProvider authProvider = AuthProvider();
    AppSettingsProvider appSettingsProvider = AppSettingsProvider();
    CampaignProvider campaignProvider = CampaignProvider();
    BestiaryProvider bestiaryProvider = BestiaryProvider();

    return MultiProvider(
      providers: [
        Provider<Isar>.value(value: isar),
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
        ...isarProviders(),
      ],
      child: child,
    );
  }
}
