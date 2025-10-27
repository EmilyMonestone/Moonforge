import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moonforge/core/models/data/campaign.dart';
import 'package:moonforge/data/drift/app_database.dart';
import 'package:moonforge/data/providers/sync_state_provider.dart';
import 'package:moonforge/data/repo/campaign_repository.dart';
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
  return [
    // AppDatabase singleton
    Provider<AppDatabase>(
      create: (_) => AppDatabase(),
      dispose: (_, db) => db.close(),
    ),

    // CampaignRepository
    ProxyProvider<AppDatabase, CampaignRepository>(
      update: (_, db, __) => CampaignRepository(db),
    ),

    // SyncEngine (requires Firestore)
    ProxyProvider<AppDatabase, SyncEngine>(
      update: (_, db, previous) {
        final engine = previous ?? SyncEngine(db, FirebaseFirestore.instance);
        if (previous == null) {
          engine.start();
        }
        return engine;
      },
      dispose: (_, engine) => engine.stop(),
    ),

    // SyncStateProvider for tracking sync status
    ChangeNotifierProxyProvider<AppDatabase, SyncStateProvider>(
      create: (context) => SyncStateProvider(context.read<AppDatabase>()),
      update: (_, db, previous) => previous ?? SyncStateProvider(db),
      dispose: (_, provider) => provider.dispose(),
    ),

    // StreamProvider for campaigns list
    StreamProvider<List<Campaign>>(
      create: (context) => context.read<CampaignRepository>().watchAll(),
      initialData: const [],
    ),
  ];
}
