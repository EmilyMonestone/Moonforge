import 'package:get_storage/get_storage.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Service for managing persistent storage using get_storage
class PersistenceService {
  static final PersistenceService _instance = PersistenceService._internal();
  factory PersistenceService() => _instance;
  PersistenceService._internal();

  static const String _boxName = 'moonforge_storage';
  GetStorage? _box;

  /// Initialize the persistence service
  /// Must be called before using any persistence features
  static Future<void> init() async {
    try {
      await GetStorage.init(_boxName);
      logger.i('PersistenceService initialized');
    } catch (e) {
      logger.e('Failed to initialize PersistenceService: $e');
      rethrow;
    }
  }

  /// Get the storage box instance
  GetStorage get box {
    _box ??= GetStorage(_boxName);
    return _box!;
  }

  /// Save a value to storage
  Future<void> write(String key, dynamic value) async {
    try {
      await box.write(key, value);
      logger.d('Saved $key to storage');
    } catch (e) {
      logger.e('Failed to write $key to storage: $e');
    }
  }

  /// Read a value from storage
  T? read<T>(String key) {
    try {
      return box.read<T>(key);
    } catch (e) {
      logger.e('Failed to read $key from storage: $e');
      return null;
    }
  }

  /// Remove a value from storage
  Future<void> remove(String key) async {
    try {
      await box.remove(key);
      logger.d('Removed $key from storage');
    } catch (e) {
      logger.e('Failed to remove $key from storage: $e');
    }
  }

  /// Listen to changes on a specific key
  void listenKey(String key, void Function(dynamic) callback) {
    try {
      box.listenKey(key, callback);
    } catch (e) {
      logger.e('Failed to listen to $key: $e');
    }
  }

  /// Clear all data from storage
  Future<void> erase() async {
    try {
      await box.erase();
      logger.i('Storage erased');
    } catch (e) {
      logger.e('Failed to erase storage: $e');
    }
  }

  /// Check if a key exists in storage
  bool hasData(String key) {
    try {
      return box.hasData(key);
    } catch (e) {
      logger.e('Failed to check if $key exists: $e');
      return false;
    }
  }
}
