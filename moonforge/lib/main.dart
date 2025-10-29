import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moonforge/app.dart';
import 'package:moonforge/core/providers/providers.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/auto_updater_service.dart';
import 'package:moonforge/core/services/deep_link_service.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/app_version.dart';
import 'package:moonforge/data/firebase/odm.dart';
import 'package:moonforge/firebase_options.dart';
import 'package:window_manager/window_manager.dart';

const kWindowsScheme = 'moonforge';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await AppVersion.init();

  // Initialize get_storage for persistence
  await PersistenceService.init();

  if (!(kIsWeb ||
      Platform.isAndroid ||
      Platform.isIOS ||
      Platform.isFuchsia ||
      Platform.isMacOS)) {
    windowManager.ensureInitialized();
    Window.initialize();

    Window.setEffect(effect: WindowEffect.acrylic);

    await windowManager.waitUntilReadyToShow();
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.setMinimumSize(const Size.fromWidth(200));
    windowManager.show();
  }

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Ensure Firebase Auth uses persistent LOCAL storage on web so sessions survive reloads
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  final firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(persistenceEnabled: true);
  /*  if (kIsWeb) {
    // ignore: deprecated_member_use
    await firestore.enablePersistence(
      const PersistenceSettings(synchronizeTabs: true),
    );
  }*/
  await Odm.init(firestore);

  // Check if this is a sub-window for desktop multi-window
  // The first argument after the window ID contains the route
  String? initialRoute;
  if (args.length > 1) {
    // args[0] is the window ID, args[1] is the route
    initialRoute = args[1];
  }

  // Initialize deep linking after the app router is available
  // The actual initialization happens after the first frame in App widget
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Navigate to the initial route if provided (for sub-windows)
    if (initialRoute != null && initialRoute.isNotEmpty) {
      AppRouter.router.go(initialRoute);
    }

    DeepLinkService.instance.initialize(AppRouter.router);
    // Initialize auto updater for desktop platforms only in release builds to avoid
    // platform thread assertions in debug on Windows.
    if (kReleaseMode && (Platform.isWindows || Platform.isMacOS)) {
      AutoUpdaterService.instance.initialize();
    }
  });

  runApp(MultiProviderWrapper(child: App()));
}
