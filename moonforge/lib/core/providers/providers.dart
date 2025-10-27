import 'package:flutter/material.dart';
import 'package:moonforge/core/providers/app_settings_provider.dart';
import 'package:moonforge/core/providers/auth_providers.dart';
import 'package:moonforge/data/drift_providers.dart';
import 'package:moonforge/features/campaign/controllers/campaign_provider.dart';
import 'package:provider/provider.dart';

class MultiProviderWrapper extends StatelessWidget {
  final Widget child;

  const MultiProviderWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Providers
    AuthProvider authProvider = AuthProvider();
    AppSettingsProvider appSettingsProvider = AppSettingsProvider();
    CampaignProvider campaignProvider = CampaignProvider();

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
        ...driftProviders(),
      ],
      child: child,
    );
  }
}
