import 'package:flutter/material.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';

class AdventureProvider with ChangeNotifier {
  static const String _currentAdventureKey = 'current_adventure_id';
  final PersistenceService _persistence = PersistenceService();

  Adventure? _currentAdventure;

  Adventure? get currentAdventure => _currentAdventure;

  AdventureProvider() {
    _loadPersistedAdventureId();
  }

  /// Load the persisted adventure ID on initialization
  void _loadPersistedAdventureId() {
    try {
      final adventureId = _persistence.read<String>(_currentAdventureKey);
      if (adventureId != null) {
        logger.i('Loaded persisted adventure ID: $adventureId');
        // Note: The actual adventure data will be loaded from Firestore
        // This just restores the ID so the app knows which adventure to load
      }
    } catch (e) {
      logger.e('Failed to load persisted adventure ID: $e');
    }
  }

  /// Get the persisted adventure ID
  String? getPersistedAdventureId() {
    return _persistence.read<String>(_currentAdventureKey);
  }

  void setCurrentAdventure(Adventure? adventure) {
    _currentAdventure = adventure;

    // Persist the adventure ID
    if (adventure != null) {
      _persistence.write(_currentAdventureKey, adventure.id);
      logger.i('Persisted adventure ID: ${adventure.id}');
    } else {
      _persistence.remove(_currentAdventureKey);
      logger.i('Removed persisted adventure ID');
    }

    notifyListeners();
  }

  /// Clear the persisted adventure
  void clearPersistedAdventure() {
    _persistence.remove(_currentAdventureKey);
    _currentAdventure = null;
    notifyListeners();
  }
}
