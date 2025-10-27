import 'package:get_storage/get_storage.dart';
import 'package:moonforge/core/utils/logger.dart';

enum StorageBox {
  defaultBox('moonforge_storage'),
  bestiary('bestiary');

  final String boxName;

  const StorageBox(this.boxName);
}

/// Service for managing persistent storage using get_storage
class PersistenceService {
  static final PersistenceService _instance = PersistenceService._internal();

  factory PersistenceService() => _instance;

  PersistenceService._internal();

  static final String _defaultBoxName = StorageBox.defaultBox.boxName;
  final Map<String, GetStorage> _boxes = {};

  /// Initialize the persistence service
  /// Must be called before using any persistence features
  /// Optionally provide additional box names to initialize
  static Future<void> init() async {
    try {
      for (final boxName in StorageBox.values.map((e) => e.boxName)) {
        await GetStorage.init(boxName);
      }
      logger.i('PersistenceService initialized');
    } catch (e) {
      logger.e('Failed to initialize PersistenceService: $e');
      rethrow;
    }
  }

  /// Get the storage box instance for a specific box name
  GetStorage _getBox(String boxName) {
    if (!_boxes.containsKey(boxName)) {
      _boxes[boxName] = GetStorage(boxName);
    }
    return _boxes[boxName]!;
  }

  /// Get the default storage box instance
  GetStorage get box => _getBox(_defaultBoxName);

  /// Save a value to storage
  Future<void> write(String key, dynamic value, {String? boxName}) async {
    boxName ??= _defaultBoxName;
    try {
      await _getBox(boxName).write(key, value);
      logger.d('Saved $key to storage box: $boxName');
    } catch (e) {
      logger.e('Failed to write $key to storage box $boxName: $e');
    }
  }

  /// Read a value from storage
  T? read<T>(String key, {String? boxName}) {
    boxName ??= _defaultBoxName;
    try {
      return _getBox(boxName).read<T>(key);
    } catch (e) {
      logger.e('Failed to read $key from storage box $boxName: $e');
      return null;
    }
  }

  /// Remove a value from storage
  Future<void> remove(String key, {String? boxName}) async {
    boxName ??= _defaultBoxName;
    try {
      await _getBox(boxName).remove(key);
      logger.d('Removed $key from storage box: $boxName');
    } catch (e) {
      logger.e('Failed to remove $key from storage box $boxName: $e');
    }
  }

  /// Listen to changes on a specific key
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

  /// Clear all data from storage
  Future<void> erase({String? boxName}) async {
    boxName ??= _defaultBoxName;
    try {
      await _getBox(boxName).erase();
      logger.i('Storage box erased: $boxName');
    } catch (e) {
      logger.e('Failed to erase storage box $boxName: $e');
    }
  }

  /// Check if a key exists in storage
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
