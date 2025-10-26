import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:moonforge/app.dart';
import 'package:moonforge/core/database/odm.dart';
import 'package:moonforge/core/services/app_router.dart';
import 'package:moonforge/core/services/deep_link_service.dart';
import 'package:moonforge/core/utils/app_version.dart';
import 'package:moonforge/firebase_options.dart';
import 'package:window_manager/window_manager.dart';

import 'core/models/data/schema.dart';

const kWindowsScheme = 'moonforge';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await AppVersion.init();

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
  if (kIsWeb) {
    // ignore: deprecated_member_use
    await firestore.enablePersistence(
      const PersistenceSettings(synchronizeTabs: true),
    );
  }
  await Odm.init(firestore);

  await Odm.init(appSchema, firestore);

  // Initialize deep linking after the app router is available
  // The actual initialization happens after the first frame in App widget
  WidgetsBinding.instance.addPostFrameCallback((_) {
    DeepLinkService.instance.initialize(AppRouter.router);
  });

  runApp(ProviderScope(child: App()));
}
