import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/app.dart';
import 'package:moonforge/core/database/odm.dart';
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

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final firestore = FirebaseFirestore.instance;
  firestore.settings = const Settings(persistenceEnabled: true);
  if (kIsWeb) {
    // ignore: deprecated_member_use
    await firestore.enablePersistence(
      const PersistenceSettings(synchronizeTabs: true),
    );
  }

  await Odm.init(appSchema, firestore);

  runApp(ProviderScope(child: App()));
}
