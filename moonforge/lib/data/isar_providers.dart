import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/models/adventure.dart';
import 'package:moonforge/data/models/campaign.dart';
import 'package:moonforge/data/models/chapter.dart';
import 'package:moonforge/data/models/encounter.dart';
import 'package:moonforge/data/models/entity.dart';
import 'package:moonforge/data/models/media_asset.dart';
import 'package:moonforge/data/models/party.dart';
import 'package:moonforge/data/models/player.dart';
import 'package:moonforge/data/models/scene.dart';
import 'package:moonforge/data/models/session.dart';
import 'package:moonforge/data/providers/sync_state_provider.dart';
import 'package:moonforge/data/repositories/adventure_repository.dart';
import 'package:moonforge/data/repositories/campaign_repository.dart';
import 'package:moonforge/data/repositories/chapter_repository.dart';
import 'package:moonforge/data/repositories/encounter_repository.dart';
import 'package:moonforge/data/repositories/entity_repository.dart';
import 'package:moonforge/data/repositories/media_asset_repository.dart';
import 'package:moonforge/data/repositories/party_repository.dart';
import 'package:moonforge/data/repositories/player_repository.dart';
import 'package:moonforge/data/repositories/scene_repository.dart';
import 'package:moonforge/data/repositories/session_repository.dart';
import 'package:moonforge/data/services/isar_service.dart';
import 'package:moonforge/data/sync_service/isar_sync_engine.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:isar/isar.dart';

/// Isar local-first providers for the application
///
/// Usage:
/// ```dart
/// MultiProvider(
///   providers: [
///     ...isarProviders(),
///     // ... other providers
///   ],
///   child: MyApp(),
/// )
/// ```
List<SingleChildWidget> isarProviders() {
  logger.i('Registering Isar providers');
  return [
    // Isar instance singleton
    Provider<Isar>(
      create: (_) {
        logger.i('Creating Isar instance');
        throw StateError('Isar must be initialized before app starts');
      },
      lazy: false,
    ),

    // Repositories
    ProxyProvider<Isar, CampaignRepository>(
      update: (_, isar, __) {
        logger.t('Init CampaignRepository');
        return CampaignRepository(isar);
      },
    ),
    ProxyProvider<Isar, AdventureRepository>(
      update: (_, isar, __) {
        logger.t('Init AdventureRepository');
        return AdventureRepository(isar);
      },
    ),
    ProxyProvider<Isar, ChapterRepository>(
      update: (_, isar, __) {
        logger.t('Init ChapterRepository');
        return ChapterRepository(isar);
      },
    ),
    ProxyProvider<Isar, SceneRepository>(
      update: (_, isar, __) {
        logger.t('Init SceneRepository');
        return SceneRepository(isar);
      },
    ),
    ProxyProvider<Isar, EncounterRepository>(
      update: (_, isar, __) {
        logger.t('Init EncounterRepository');
        return EncounterRepository(isar);
      },
    ),
    ProxyProvider<Isar, EntityRepository>(
      update: (_, isar, __) {
        logger.t('Init EntityRepository');
        return EntityRepository(isar);
      },
    ),
    ProxyProvider<Isar, PartyRepository>(
      update: (_, isar, __) {
        logger.t('Init PartyRepository');
        return PartyRepository(isar);
      },
    ),
    ProxyProvider<Isar, PlayerRepository>(
      update: (_, isar, __) {
        logger.t('Init PlayerRepository');
        return PlayerRepository(isar);
      },
    ),
    ProxyProvider<Isar, SessionRepository>(
      update: (_, isar, __) {
        logger.t('Init SessionRepository');
        return SessionRepository(isar);
      },
    ),
    ProxyProvider<Isar, MediaAssetRepository>(
      update: (_, isar, __) {
        logger.t('Init MediaAssetRepository');
        return MediaAssetRepository(isar);
      },
    ),

    // SyncEngine (requires Firestore) — eagerly create so it always starts
    Provider<IsarSyncEngine>(
      lazy: false,
      create: (context) {
        debugPrint('Eagerly creating IsarSyncEngine provider');
        final isar = context.read<Isar>();
        final engine = IsarSyncEngine(isar, FirebaseFirestore.instance);
        logger.i('Starting IsarSyncEngine (eager)');
        
        // Defer start until after first frame
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            // On Windows in debug, add a tiny delay
            if (Platform.isWindows && !kReleaseMode) {
              await Future.delayed(const Duration(milliseconds: 250));
            }
            engine.start();
          } catch (e, st) {
            logger.e(
              'Failed to start IsarSyncEngine: $e',
              error: e,
              stackTrace: st,
            );
          }
        });
        return engine;
      },
      dispose: (_, engine) {
        debugPrint('Disposing IsarSyncEngine provider');
        logger.i('Stopping IsarSyncEngine');
        engine.stop();
      },
    ),

    // SyncStateProvider for tracking sync status
    ChangeNotifierProxyProvider<Isar, SyncStateProvider>(
      create: (context) {
        logger.t('Create SyncStateProvider');
        return SyncStateProvider(context.read<Isar>());
      },
      update: (_, isar, previous) {
        logger.t('Update SyncStateProvider');
        return previous ?? SyncStateProvider(isar);
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
