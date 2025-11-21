import 'package:flutter/material.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';

/// Controller for managing home dashboard state and preferences
class HomeController with ChangeNotifier {
  static const String _refreshKey = 'home_refresh_timestamp';
  static const String _widgetVisibilityKey = 'home_widget_visibility';

  final PersistenceService _persistence = PersistenceService();

  bool _isRefreshing = false;
  Map<String, bool> _widgetVisibility = {
    'stats': true,
    'quickActions': true,
    'upcomingSessions': true,
    'recentCampaigns': true,
    'recentSessions': true,
    'recentParties': true,
  };

  bool get isRefreshing => _isRefreshing;
  Map<String, bool> get widgetVisibility => Map.unmodifiable(_widgetVisibility);

  HomeController() {
    _loadPreferences();
  }

  /// Load persisted preferences
  void _loadPreferences() {
    try {
      final visibility = _persistence.read<Map<String, dynamic>>(
        _widgetVisibilityKey,
      );
      if (visibility != null) {
        _widgetVisibility = visibility.map(
          (key, value) => MapEntry(key, value as bool),
        );
        logger.i('Loaded home widget visibility preferences');
      }
    } catch (e) {
      logger.e('Failed to load home preferences: $e');
    }
  }

  /// Set widget visibility
  void setWidgetVisibility(String widgetKey, bool visible) {
    _widgetVisibility[widgetKey] = visible;
    _persistence.write(_widgetVisibilityKey, _widgetVisibility);
    notifyListeners();
  }

  /// Toggle widget visibility
  void toggleWidgetVisibility(String widgetKey) {
    final currentValue = _widgetVisibility[widgetKey] ?? true;
    setWidgetVisibility(widgetKey, !currentValue);
  }

  /// Check if a widget is visible
  bool isWidgetVisible(String widgetKey) {
    return _widgetVisibility[widgetKey] ?? true;
  }

  /// Set refresh state
  void setRefreshing(bool refreshing) {
    _isRefreshing = refreshing;
    if (refreshing) {
      _persistence.write(_refreshKey, DateTime.now().toIso8601String());
    }
    notifyListeners();
  }

  /// Trigger a refresh of dashboard data
  Future<void> refresh() async {
    setRefreshing(true);
    try {
      // Refresh is triggered, actual data fetching happens in widgets
      await Future.delayed(const Duration(milliseconds: 100));
    } finally {
      setRefreshing(false);
    }
  }

  /// Get last refresh timestamp
  DateTime? getLastRefreshTime() {
    try {
      final timestamp = _persistence.read<String>(_refreshKey);
      if (timestamp != null) {
        return DateTime.parse(timestamp);
      }
    } catch (e) {
      logger.e('Failed to parse refresh timestamp: $e');
    }
    return null;
  }
}
