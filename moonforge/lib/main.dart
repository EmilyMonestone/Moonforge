import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/firebase_options.dart';
import 'package:window_manager/window_manager.dart';

const kWindowsScheme = 'moonforge';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await AppVersion.init();

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // IMPORTANT: Disable Firestore persistence since we use Drift as local storage
  // Set Firestore settings BEFORE any other Firestore operations.
  // On desktop (C++ SDK), changing settings after first use causes an Illegal state error.
  try {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false, // Disabled - using Drift instead
    );
  } catch (e) {
    // In rare cases (hot restart, early background init), Firestore might already be started.
    // Avoid crashing the app; settings can only be set once per process.
    debugPrint('Skipping Firestore settings update: $e');
  }

  // Initialize Drift database (local-first storage)
  final db = constructDb();

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

  runApp(MultiProviderWrapper(db: db, child: App()));
}

Future clearFirestoreCache() async {
  try {
    await FirebaseFirestore.instance.clearPersistence();
    debugPrint("Firestore cache cleared successfully.");
  } catch (e) {
    debugPrint("Failed to clear Firestore cache: $e");
  }
}
