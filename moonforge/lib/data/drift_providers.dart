import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/firebase/models/adventure.dart';
import 'package:moonforge/data/firebase/models/campaign.dart';
import 'package:moonforge/data/firebase/models/chapter.dart';
import 'package:moonforge/data/firebase/models/encounter.dart';
import 'package:moonforge/data/firebase/models/entity.dart';
import 'package:moonforge/data/firebase/models/media_asset.dart';
import 'package:moonforge/data/firebase/models/party.dart';
import 'package:moonforge/data/firebase/models/player.dart';
import 'package:moonforge/data/firebase/models/scene.dart';
import 'package:moonforge/data/firebase/models/session.dart';
import 'package:moonforge/data/providers/sync_state_provider.dart';
import 'package:moonforge/data/repo/adventure_repository.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
import 'package:moonforge/data/repo/chapter_repository.dart';
import 'package:moonforge/data/repo/encounter_repository.dart';
import 'package:moonforge/data/repo/entity_repository.dart';
import 'package:moonforge/data/repo/media_asset_repository.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/player_repository.dart';
import 'package:moonforge/data/repo/scene_repository.dart';
import 'package:moonforge/data/repo/session_repository.dart';
import 'package:moonforge/data/sync/sync_engine.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// Drift offline-first providers for the application
///
/// Usage:
/// ```dart
/// MultiProvider(
///   providers: [
///     ...driftProviders(),
///     // ... other providers
///   ],
///   child: MyApp(),
/// )
/// ```
List<SingleChildWidget> driftProviders() {
  logger.i('Registering drift providers');
  return [
    // AppDatabase singleton
    Provider<AppDatabase>(
      create: (_) {
        logger.i('Creating AppDatabase');
        return AppDatabase();
      },
      dispose: (_, db) {
        logger.i('Disposing AppDatabase');
        db.close();
      },
    ),

    // Repositories
    ProxyProvider<AppDatabase, CampaignRepository>(
      update: (_, db, __) {
        logger.t('Init CampaignRepository');
        return CampaignRepository(db);
      },
    ),
    ProxyProvider<AppDatabase, AdventureRepository>(
      update: (_, db, __) {
        logger.t('Init AdventureRepository');
        return AdventureRepository(db);
      },
    ),
    ProxyProvider<AppDatabase, ChapterRepository>(
      update: (_, db, __) {
        logger.t('Init ChapterRepository');
        return ChapterRepository(db);
      },
    ),
    ProxyProvider<AppDatabase, SceneRepository>(
      update: (_, db, __) {
        logger.t('Init SceneRepository');
        return SceneRepository(db);
      },
    ),
    ProxyProvider<AppDatabase, EncounterRepository>(
      update: (_, db, __) {
        logger.t('Init EncounterRepository');
        return EncounterRepository(db);
      },
    ),
    ProxyProvider<AppDatabase, EntityRepository>(
      update: (_, db, __) {
        logger.t('Init EntityRepository');
        return EntityRepository(db);
      },
    ),
    ProxyProvider<AppDatabase, PartyRepository>(
      update: (_, db, __) {
        logger.t('Init PartyRepository');
        return PartyRepository(db);
      },
    ),
    ProxyProvider<AppDatabase, PlayerRepository>(
      update: (_, db, __) {
        logger.t('Init PlayerRepository');
        return PlayerRepository(db);
      },
    ),
    ProxyProvider<AppDatabase, SessionRepository>(
      update: (_, db, __) {
        logger.t('Init SessionRepository');
        return SessionRepository(db);
      },
    ),
    ProxyProvider<AppDatabase, MediaAssetRepository>(
      update: (_, db, __) {
        logger.t('Init MediaAssetRepository');
        return MediaAssetRepository(db);
      },
    ),

    // SyncEngine (requires Firestore) — eagerly create so it always starts
    Provider<SyncEngine>(
      lazy: false,
      create: (context) {
        debugPrint('Eagerly creating SyncEngine provider');
        final db = context.read<AppDatabase>();
        final engine = SyncEngine(db, FirebaseFirestore.instance);
        logger.i('Starting SyncEngine (eager)');
        // Defer start until after first frame to ensure platform thread is fully ready
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            // On Windows in debug mode, the Firebase C++ SDK has platform-thread violations
            // that cause abort() crashes. Disable SyncEngine in Windows debug builds.
            // See: https://github.com/firebase/flutterfire/issues/11933
            // See: https://docs.flutter.dev/platform-integration/platform-channels#channels-and-platform-threading
            if (Platform.isWindows && !kReleaseMode) {
              logger.w(
                'SyncEngine disabled on Windows debug builds due to Firebase C++ SDK '
                'platform-thread violations. Data will sync in release builds.',
              );
              return;
            }
            engine.start();
          } catch (e, st) {
            logger.e(
              'Failed to start SyncEngine: $e',
              error: e,
              stackTrace: st,
            );
          }
        });
        return engine;
      },
      dispose: (_, engine) {
        debugPrint('Disposing SyncEngine provider');
        logger.i('Stopping SyncEngine');
        engine.stop();
      },
    ),

    // SyncStateProvider for tracking sync status
    ChangeNotifierProxyProvider<AppDatabase, SyncStateProvider>(
      create: (context) {
        logger.t('Create SyncStateProvider');
        return SyncStateProvider(context.read<AppDatabase>());
      },
      update: (_, db, previous) {
        logger.t('Update SyncStateProvider');
        return previous ?? SyncStateProvider(db);
      },
    ),

    // StreamProviders for all models
    StreamProvider<List<Campaign>>(
      create: (context) {
        logger.t('StreamProvider<List<Campaign>> created');
        return context.read<CampaignRepository>().watchAll().handleError((
          error,
          stack,
        ) {
          logger.w('Stream<List<Campaign>> error suppressed: $error');
        });
      },
      initialData: const [],
    ),
    StreamProvider<List<Adventure>>(
      create: (context) {
        logger.t('StreamProvider<List<Adventure>> created');
        return context.read<AdventureRepository>().watchAll().handleError((
          error,
          stack,
        ) {
          logger.w('Stream<List<Adventure>> error suppressed: $error');
        });
      },
      initialData: const [],
    ),
    StreamProvider<List<Chapter>>(
      create: (context) {
        logger.t('StreamProvider<List<Chapter>> created');
        return context.read<ChapterRepository>().watchAll().handleError((
          error,
          stack,
        ) {
          logger.w('Stream<List<Chapter>> error suppressed: $error');
        });
      },
      initialData: const [],
    ),
    StreamProvider<List<Scene>>(
      create: (context) {
        logger.t('StreamProvider<List<Scene>> created');
        return context.read<SceneRepository>().watchAll().handleError((
          error,
          stack,
        ) {
          logger.w('Stream<List<Scene>> error suppressed: $error');
        });
      },
      initialData: const [],
    ),
    StreamProvider<List<Encounter>>(
      create: (context) {
        logger.t('StreamProvider<List<Encounter>> created');
        return context.read<EncounterRepository>().watchAll().handleError((
          error,
          stack,
        ) {
          logger.w('Stream<List<Encounter>> error suppressed: $error');
        });
      },
      initialData: const [],
    ),
    StreamProvider<List<Entity>>(
      create: (context) {
        logger.t('StreamProvider<List<Entity>> created');
        return context.read<EntityRepository>().watchAll().handleError((
          error,
          stack,
        ) {
          logger.w('Stream<List<Entity>> error suppressed: $error');
        });
      },
      initialData: const [],
    ),
    StreamProvider<List<Party>>(
      create: (context) {
        logger.t('StreamProvider<List<Party>> created');
        return context.read<PartyRepository>().watchAll().handleError((
          error,
          stack,
        ) {
          logger.w('Stream<List<Party>> error suppressed: $error');
        });
      },
      initialData: const [],
    ),
    StreamProvider<List<Player>>(
      create: (context) {
        logger.t('StreamProvider<List<Player>> created');
        return context.read<PlayerRepository>().watchAll().handleError((
          error,
          stack,
        ) {
          logger.w('Stream<List<Player>> error suppressed: $error');
        });
      },
      initialData: const [],
    ),
    StreamProvider<List<Session>>(
      create: (context) {
        logger.t('StreamProvider<List<Session>> created');
        return context.read<SessionRepository>().watchAll().handleError((
          error,
          stack,
        ) {
          logger.w('Stream<List<Session>> error suppressed: $error');
        });
      },
      initialData: const [],
    ),
    StreamProvider<List<MediaAsset>>(
      create: (context) {
        logger.t('StreamProvider<List<MediaAsset>> created');
        return context.read<MediaAssetRepository>().watchAll().handleError((
          error,
          stack,
        ) {
          logger.w('Stream<List<MediaAsset>> error suppressed: $error');
        });
      },
      initialData: const [],
    ),
  ];
}
