/// The main application widget.
/// This widget is the root of the application.
library;

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:moonforge/core/services/app_router.dart';

class App extends StatelessWidget {
  final _appRouter = AppRouter();

  App({super.key});

  static final _defaultLightColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.purple,
  );

  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
    primarySwatch: Colors.purple,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp.router(
          title: 'Moonforge',
          theme: ThemeData(
            colorScheme: lightDynamic ?? _defaultLightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? _defaultDarkColorScheme,
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          routerConfig: _appRouter.config(),
        );
      },
    );
  }
}
