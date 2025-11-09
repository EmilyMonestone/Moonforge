import 'package:flutter/material.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/campaign/services/campaign_service.dart';

/// Controller for managing campaign list state
class CampaignListController with ChangeNotifier {
  final CampaignService _service;

  CampaignListController(this._service);

  // Filter and search state
  String _searchQuery = '';
  String _sortBy = 'updated'; // 'name', 'created', 'updated'
  bool _descending = true;
  bool _showArchived = false;
  ViewMode _viewMode = ViewMode.grid;

  // Selection state for bulk operations
  final Set<String> _selectedCampaignIds = {};

  // Getters
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get descending => _descending;
  bool get showArchived => _showArchived;
  ViewMode get viewMode => _viewMode;
  Set<String> get selectedCampaignIds => Set.unmodifiable(_selectedCampaignIds);
  bool get hasSelection => _selectedCampaignIds.isNotEmpty;

  // Setters with notifications
  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      notifyListeners();
    }
  }

  void setSortBy(String sortBy) {
    if (_sortBy != sortBy) {
      _sortBy = sortBy;
      notifyListeners();
    }
  }

  void toggleSortDirection() {
    _descending = !_descending;
    notifyListeners();
  }

  void toggleShowArchived() {
    _showArchived = !_showArchived;
    notifyListeners();
  }

  void setViewMode(ViewMode mode) {
    if (_viewMode != mode) {
      _viewMode = mode;
      notifyListeners();
    }
  }

  // Selection management
  void toggleSelection(String campaignId) {
    if (_selectedCampaignIds.contains(campaignId)) {
      _selectedCampaignIds.remove(campaignId);
    } else {
      _selectedCampaignIds.add(campaignId);
    }
    notifyListeners();
  }

  void selectAll(List<Campaign> campaigns) {
    _selectedCampaignIds.clear();
    _selectedCampaignIds.addAll(campaigns.map((c) => c.id));
    notifyListeners();
  }

  void clearSelection() {
    _selectedCampaignIds.clear();
    notifyListeners();
  }

  // Get filtered campaigns
  Future<List<Campaign>> getFilteredCampaigns() async {
    return _service.getFilteredCampaigns(
      searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
      archived: _showArchived ? null : false,
      sortBy: _sortBy,
      descending: _descending,
    );
  }

  /// Reset all filters
  void resetFilters() {
    _searchQuery = '';
    _sortBy = 'updated';
    _descending = true;
    _showArchived = false;
    _selectedCampaignIds.clear();
    notifyListeners();
  }
}

enum ViewMode { grid, list }
