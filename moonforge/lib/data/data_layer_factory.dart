import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moonforge/data/connectivity/connectivity_service.dart';
import 'package:moonforge/data/db/app_database.dart';
import 'package:moonforge/data/db/connection/database_factory.dart';
import 'package:moonforge/data/firebase/auth_service.dart';
import 'package:moonforge/data/firebase/firestore_remote.dart';
import 'package:moonforge/data/repositories/campaign_repository.dart';
import 'package:moonforge/data/sync/sync_worker.dart';

/// Factory for creating and managing data layer instances
class DataLayerFactory {
  static AppDatabase? _database;
  static AuthService? _authService;
  static ConnectivityService? _connectivityService;
  static FirestoreRemote? _firestoreRemote;
  static SyncWorker? _syncWorker;
  static CampaignRepository? _campaignRepository;

  /// Initialize the data layer
  static Future<void> initialize() async {
    // Create database
    _database = DatabaseFactory.getInstance();

    // Create services
    _authService = AuthService();
    _connectivityService = ConnectivityService();
    _firestoreRemote = FirestoreRemote(FirebaseFirestore.instance);

    // Create repositories
    _campaignRepository = CampaignRepository(_database!, _authService!);

    // Create and start sync worker
    _syncWorker = SyncWorker(
      _database!,
      _firestoreRemote!,
      _authService!,
      _connectivityService!,
    );
    _syncWorker!.start();
  }

  /// Shutdown the data layer
  static Future<void> shutdown() async {
    _syncWorker?.stop();
    await DatabaseFactory.close();
    
    _database = null;
    _authService = null;
    _connectivityService = null;
    _firestoreRemote = null;
    _syncWorker = null;
    _campaignRepository = null;
  }

  // Getters
  static AppDatabase get database => _database!;
  static AuthService get authService => _authService!;
  static ConnectivityService get connectivityService => _connectivityService!;
  static FirestoreRemote get firestoreRemote => _firestoreRemote!;
  static SyncWorker get syncWorker => _syncWorker!;
  static CampaignRepository get campaignRepository => _campaignRepository!;
}
