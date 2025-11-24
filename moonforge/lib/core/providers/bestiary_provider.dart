import 'package:moonforge/core/models/async_state.dart';
import 'package:moonforge/core/providers/base_async_provider.dart';
import 'package:moonforge/core/services/bestiary_service.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Provider for managing bestiary data
class BestiaryProvider extends BaseAsyncProvider<List<dynamic>> {
  final BestiaryService _bestiaryService;
  DateTime? _lastSync;

  BestiaryProvider({BestiaryService? bestiaryService})
    : _bestiaryService =
          bestiaryService ?? BestiaryService(PersistenceService()) {
    // Load cached data on initialization
    _loadCachedData();
  }

  /// Get all monsters
  List<dynamic> get monsters => state.dataOrNull ?? const [];

  /// Check if data is currently loading
  bool get isLoading => state.isLoading;

  /// Check if there was an error
  bool get hasError => state.hasError;

  /// Get error message if any
  String? get errorMessage => state.errorOrNull?.toString();

  /// Get last sync timestamp
  DateTime? get lastSync => _lastSync;

  /// Check if data is cached locally
  bool get isCached => _bestiaryService.isCached();

  /// Load cached data without triggering sync
  Future<void> _loadCachedData() async {
    if (!_bestiaryService.isCached()) return;

    try {
      final cached = await _bestiaryService.getAll(ensureFresh: false);
      updateState(AsyncState.data(cached));
      _lastSync = _bestiaryService.getLastSyncTime();
    } catch (e) {
      // Silent failure is acceptable for cached data loading during initialization
      // The user can still trigger a manual load later
      logger.d('Failed to load cached bestiary data during initialization: $e');
    }
  }

  /// Load monsters with optional fresh sync
  Future<void> loadMonsters({bool forceSync = false}) async {
    updateState(const AsyncState.loading());
    try {
      if (forceSync) {
        final success = await _bestiaryService.forceSync();
        if (!success) {
          updateState(const AsyncState.error('Failed to sync bestiary data'));
          return;
        }
      }

      final monsters = await _bestiaryService.getAll(ensureFresh: !forceSync);
      updateState(AsyncState.data(monsters));
      _lastSync = _bestiaryService.getLastSyncTime();
    } catch (e, st) {
      updateState(AsyncState.error(e, st));
    } finally {
      if (!state.hasData && !state.hasError) {
        reset();
      }
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
    reset();
    _lastSync = null;
  }
}
