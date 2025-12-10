/// The main application widget.
/// This widget is the root of the application.
library;

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:m3e_collection/m3e_collection.dart';
import 'package:moonforge/core/design/design_system.dart';
import 'package:moonforge/core/providers/app_settings_provider.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/widgets/navigation_history_service.dart';
import 'package:moonforge/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class App extends StatefulWidget {
  const App({super.key});

  static final _defaultLightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.purple,
  );

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.purple,
    brightness: Brightness.dark,
  );

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettingsProvider>(context, listen: true);
    return ToastificationWrapper(
      child: DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) {
          return NavigationHistoryScope(
            notifier: AppRouter.navigationHistory,
            child: MaterialApp.router(
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
              theme: ThemeData(
                colorScheme: lightDynamic ?? App._defaultLightColorScheme,
                useMaterial3: true,
                extensions: [
                  AppThemeExtension.light(
                    lightDynamic ?? App._defaultLightColorScheme,
                  ),
                ],
              ).colorScheme.toM3EThemeData(),

              darkTheme: ThemeData(
                colorScheme: darkDynamic ?? App._defaultDarkColorScheme,
                useMaterial3: true,
                brightness: Brightness.dark,
                extensions: [
                  AppThemeExtension.dark(
                    darkDynamic ?? App._defaultDarkColorScheme,
                  ),
                ],
              ).colorScheme.toM3EThemeData(),

              themeMode: appSettings.themeMode,
              locale: appSettings.locale,
              localizationsDelegates: [
                ...AppLocalizations.localizationsDelegates,
                FlutterQuillLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: AppRouter.router,
            ),
          );
        },
      ),
    );
  }
}

extension BuildContextThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
}
