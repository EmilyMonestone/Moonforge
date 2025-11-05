import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';

/// Controller for managing session list state
class SessionListController with ChangeNotifier {
  List<Session> _sessions = [];
  String _searchQuery = '';
  SessionListSort _sortBy = SessionListSort.dateDescending;
  SessionListFilter _filter = SessionListFilter.all;

  List<Session> get sessions => _sessions;
  String get searchQuery => _searchQuery;
  SessionListSort get sortBy => _sortBy;
  SessionListFilter get filter => _filter;

  /// Get filtered and sorted sessions
  List<Session> get filteredSessions {
    var filtered = _sessions.where((session) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        // Search is case-insensitive
        final query = _searchQuery.toLowerCase();
        // Search in session datetime if available
        if (session.datetime != null) {
          final dateStr = session.datetime.toString().toLowerCase();
          if (dateStr.contains(query)) return true;
        }
        return false;
      }
      return true;
    }).toList();

    // Apply sorting
    switch (_sortBy) {
      case SessionListSort.dateAscending:
        filtered.sort((a, b) {
          if (a.datetime == null && b.datetime == null) return 0;
          if (a.datetime == null) return 1;
          if (b.datetime == null) return -1;
          return a.datetime!.compareTo(b.datetime!);
        });
        break;
      case SessionListSort.dateDescending:
        filtered.sort((a, b) {
          if (a.datetime == null && b.datetime == null) return 0;
          if (a.datetime == null) return 1;
          if (b.datetime == null) return -1;
          return b.datetime!.compareTo(a.datetime!);
        });
        break;
      case SessionListSort.createdAscending:
        filtered.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return a.createdAt!.compareTo(b.createdAt!);
        });
        break;
      case SessionListSort.createdDescending:
        filtered.sort((a, b) {
          if (a.createdAt == null && b.createdAt == null) return 0;
          if (a.createdAt == null) return 1;
          if (b.createdAt == null) return -1;
          return b.createdAt!.compareTo(a.createdAt!);
        });
        break;
    }

    return filtered;
  }

  /// Update the list of sessions
  void setSessions(List<Session> sessions) {
    _sessions = sessions;
    notifyListeners();
  }

  /// Update search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Update sort order
  void setSortBy(SessionListSort sort) {
    _sortBy = sort;
    notifyListeners();
  }

  /// Update filter
  void setFilter(SessionListFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  /// Clear all filters and search
  void clearFilters() {
    _searchQuery = '';
    _filter = SessionListFilter.all;
    notifyListeners();
  }
}

/// Sort options for session list
enum SessionListSort {
  dateAscending,
  dateDescending,
  createdAscending,
  createdDescending,
}

/// Filter options for session list
enum SessionListFilter {
  all,
  upcoming,
  past,
  shared,
}
