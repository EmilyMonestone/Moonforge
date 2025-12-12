import 'package:moonforge/core/models/async_state.dart';
import 'package:moonforge/core/providers/base_async_provider.dart';
import 'package:moonforge/core/services/open5e/index.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Provider for managing bestiary data using Open5e API v2
class BestiaryProvider extends BaseAsyncProvider<List<Creature>> {
  final Open5eService _open5eService;
  DateTime? _lastSync;

  BestiaryProvider({Open5eService? open5eService})
      : _open5eService = open5eService ?? Open5eService(PersistenceService()) {
    // Load cached data on initialization
    _loadCachedData();
  }

  /// Get all creatures
  List<Creature> get creatures => state.dataOrNull ?? const [];

  /// Check if data is currently loading
  bool get isLoading => state.isLoading;

  /// Check if there was an error
  bool get hasError => state.hasError;

  /// Get error message if any
  String? get errorMessage => state.errorOrNull?.toString();

  /// Get last sync timestamp
  DateTime? get lastSync => _lastSync;

  /// Check if we have attempted to load data (not necessarily that cache exists)
  bool get hasLoadedData => creatures.isNotEmpty || _lastSync != null;

  /// Load cached data without triggering sync
  Future<void> _loadCachedData() async {
    try {
      final response = await _open5eService.getCreatures(
        options: Open5eQueryOptions(page: 1),
        useCache: true,
      );

      if (response != null && response.results.isNotEmpty) {
        updateState(AsyncState.data(response.results));
        _lastSync = DateTime.now();
      }
    } catch (e) {
      // Silent failure is acceptable for cached data loading during initialization
      logger.d('Failed to load cached bestiary data during initialization: $e',
          context: LogContext.network);
    }
  }

  /// Load creatures with optional query options
  Future<void> loadCreatures({
    Open5eQueryOptions? options,
    bool forceSync = false,
  }) async {
    updateState(const AsyncState.loading());
    try {
      final response = await _open5eService.getCreatures(
        options: options ?? Open5eQueryOptions(page: 1),
        useCache: !forceSync,
      );

      if (response != null) {
        updateState(AsyncState.data(response.results));
        _lastSync = DateTime.now();
      } else {
        updateState(const AsyncState.error('Failed to load creatures'));
      }
    } catch (e, st) {
      updateState(AsyncState.error(e, st));
    } finally {
      if (!state.hasData && !state.hasError) {
        reset();
      }
    }
  }

  /// Get a specific creature by key
  Future<Creature?> getCreatureByKey(String key) {
    return _open5eService.getCreatureByKey(key);
  }

  /// Force refresh from remote
  Future<void> refresh() async {
    await loadCreatures(forceSync: true);
  }

  /// Clear cached data
  Future<void> clearCache() async {
    await _open5eService.clearCache();
    reset();
    _lastSync = null;
  }
}
