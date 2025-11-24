import 'package:get_storage/get_storage.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Simple persistence service wrapper around `get_storage` used by the app to
/// persist small, local key/value settings and lightweight app state.
///
/// This is a thin wrapper to centralize access and provide a single place to
/// mock or override storage behavior in tests. Use [write], [read], and
/// [remove] for basic CRUD operations. For larger datasets prefer the
/// app's repository/DB layer.
class PersistenceService {
  static final PersistenceService _instance = PersistenceService._internal();

  factory PersistenceService() => _instance;

  PersistenceService._internal();

  static final String _defaultBoxName = StorageBox.defaultBox.boxName;
  final Map<String, GetStorage> _boxes = {};

  /// Initialize `GetStorage` boxes used by the application. Call this once at
  /// application startup (e.g., in `main`) before using the service.
  static Future<void> init() async {
    try {
      for (final boxName in StorageBox.values.map((e) => e.boxName)) {
        await GetStorage.init(boxName);
      }
    } catch (e) {
      logger.e('Failed to initialize PersistenceService: $e');
      rethrow;
    }
  }

  /// Get the default storage box instance.
  GetStorage get box => _getBox(_defaultBoxName);

  /// Save a value to storage under [key]. Optionally provide a custom
  /// [boxName] to scope the value to a different box.
  ///
  /// This method catches and logs errors; callers generally do not need to
  /// handle exceptions for simple key/value persist operations.
  Future<void> write(String key, dynamic value, {String? boxName}) async {
    boxName ??= _defaultBoxName;
    try {
      await _getBox(boxName).write(key, value);
      logger.d('Saved $key to storage box: $boxName');
    } catch (e) {
      logger.e('Failed to write $key to storage box $boxName: $e');
    }
  }

  /// Read a strongly typed value from storage. Returns `null` when the key
  /// is not present or on error.
  T? read<T>(String key, {String? boxName}) {
    boxName ??= _defaultBoxName;
    try {
      return _getBox(boxName).read<T>(key);
    } catch (e) {
      logger.e('Failed to read $key from storage box $boxName: $e');
      return null;
    }
  }

  /// Remove a stored value by [key]. Returns when the removal completes.
  Future<void> remove(String key, {String? boxName}) async {
    boxName ??= _defaultBoxName;
    try {
      await _getBox(boxName).remove(key);
      logger.d('Removed $key from storage box: $boxName');
    } catch (e) {
      logger.e('Failed to remove $key from storage box $boxName: $e');
    }
  }

  /// Listen to a key's changes in the underlying storage box. This delegates
  /// to `GetStorage.listenKey` and is useful for reactive UI that depends on
  /// persisted values.
  void listenKey(
    String key,
    void Function(dynamic) callback, {
    String? boxName,
  }) {
    boxName ??= _defaultBoxName;
    try {
      _getBox(boxName).listenKey(key, callback);
    } catch (e) {
      logger.e('Failed to listen to $key in storage box $boxName: $e');
    }
  }

  /// Clears all data from the provided [boxName] (default: app's default
  /// box). Use with caution — this erases persisted settings in that box.
  Future<void> erase({String? boxName}) async {
    boxName ??= _defaultBoxName;
    try {
      await _getBox(boxName).erase();
      logger.i('Storage box erased: $boxName');
    } catch (e) {
      logger.e('Failed to erase storage box $boxName: $e');
    }
  }

  /// Check if a key exists in storage. Returns `true` when the key is present
  /// and readable.
  bool hasData(String key, {String? boxName}) {
    boxName ??= _defaultBoxName;
    try {
      return _getBox(boxName).hasData(key);
    } catch (e) {
      logger.e('Failed to check if $key exists in storage box $boxName: $e');
      return false;
    }
  }
}
