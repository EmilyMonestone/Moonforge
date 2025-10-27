import 'package:flutter/foundation.dart';
import 'package:moonforge/core/services/bestiary_service.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Provider for managing bestiary data
class BestiaryProvider extends ChangeNotifier {
  final BestiaryService _bestiaryService;
  List<dynamic> _monsters = [];
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  DateTime? _lastSync;

  BestiaryProvider({BestiaryService? bestiaryService})
      : _bestiaryService = bestiaryService ?? BestiaryService(PersistenceService()) {
    // Load cached data on initialization
    _loadCachedData();
  }

  /// Get all monsters
  List<dynamic> get monsters => _monsters;

  /// Check if data is currently loading
  bool get isLoading => _isLoading;

  /// Check if there was an error
  bool get hasError => _hasError;

  /// Get error message if any
  String? get errorMessage => _errorMessage;

  /// Get last sync timestamp
  DateTime? get lastSync => _lastSync;

  /// Check if data is cached locally
  bool get isCached => _bestiaryService.isCached();

  /// Load cached data without triggering sync
  Future<void> _loadCachedData() async {
    if (!_bestiaryService.isCached()) return;

    try {
      _monsters = await _bestiaryService.getAll(ensureFresh: false);
      _lastSync = _bestiaryService.getLastSyncTime();
      notifyListeners();
    } catch (e) {
      // Silent failure is acceptable for cached data loading during initialization
      // The user can still trigger a manual load later
      logger.d('Failed to load cached bestiary data during initialization: $e');
    }
  }

  /// Load monsters with optional fresh sync
  Future<void> loadMonsters({bool forceSync = false}) async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      if (forceSync) {
        final success = await _bestiaryService.forceSync();
        if (!success) {
          _hasError = true;
          _errorMessage = 'Failed to sync bestiary data';
        }
      }

      _monsters = await _bestiaryService.getAll(ensureFresh: !forceSync);
      _lastSync = _bestiaryService.getLastSyncTime();
      _hasError = false;
      _errorMessage = null;
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Get a specific monster by name
  Future<Map<String, dynamic>?> getMonsterByName(String name) async {
    return await _bestiaryService.getByName(name);
  }

  /// Force refresh from remote
  Future<void> refresh() async {
    await loadMonsters(forceSync: true);
  }

  /// Clear cached data
  Future<void> clearCache() async {
    await _bestiaryService.clearCache();
    _monsters = [];
    _lastSync = null;
    notifyListeners();
  }
}
