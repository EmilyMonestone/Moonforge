import 'package:flutter/material.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/party_repository.dart';

/// Provider for managing current party state and party switching
class PartyProvider with ChangeNotifier {
  static const String _currentPartyKey = 'current_party_id';
  final PersistenceService _persistence = PersistenceService();
  final PartyRepository _repository;

  Party? _currentParty;

  Party? get currentParty => _currentParty;

  PartyProvider(this._repository) {
    _loadPersistedPartyId();
  }

  /// Load the persisted party ID on initialization
  void _loadPersistedPartyId() {
    try {
      final partyId = _persistence.read<String>(_currentPartyKey);
      if (partyId != null) {
        logger.i('Loaded persisted party ID: $partyId');
        // Load the actual party data
        _loadParty(partyId);
      }
    } catch (e) {
      logger.e('Failed to load persisted party ID: $e');
    }
  }

  /// Load party data by ID
  Future<void> _loadParty(String partyId) async {
    try {
      final party = await _repository.getById(partyId);
      if (party != null) {
        _currentParty = party;
        notifyListeners();
      }
    } catch (e) {
      logger.e('Failed to load party: $e');
    }
  }

  /// Get the persisted party ID
  String? getPersistedPartyId() {
    return _persistence.read<String>(_currentPartyKey);
  }

  /// Set the current party
  void setCurrentParty(Party? party) {
    _currentParty = party;

    // Persist the party ID
    if (party != null) {
      _persistence.write(_currentPartyKey, party.id);
      logger.i('Persisted party ID: ${party.id}');
    } else {
      _persistence.remove(_currentPartyKey);
      logger.i('Removed persisted party ID');
    }

    notifyListeners();
  }

  /// Switch to a different party
  Future<void> switchParty(String partyId) async {
    await _loadParty(partyId);
    if (_currentParty != null) {
      _persistence.write(_currentPartyKey, partyId);
      logger.i('Switched to party: $partyId');
    }
  }

  /// Clear the persisted party
  void clearPersistedParty() {
    _persistence.remove(_currentPartyKey);
    _currentParty = null;
    notifyListeners();
  }

  /// Add a member to the current party
  Future<void> addMember(String playerId) async {
    if (_currentParty == null) return;

    final updatedMemberIds = List<String>.from(_currentParty!.memberPlayerIds ?? []);
    if (!updatedMemberIds.contains(playerId)) {
      updatedMemberIds.add(playerId);
      
      final updatedParty = Party(
        id: _currentParty!.id,
        campaignId: _currentParty!.campaignId,
        name: _currentParty!.name,
        summary: _currentParty!.summary,
        memberEntityIds: _currentParty!.memberEntityIds,
        memberPlayerIds: updatedMemberIds,
        createdAt: _currentParty!.createdAt,
        updatedAt: DateTime.now(),
        rev: _currentParty!.rev,
      );

      await _repository.update(updatedParty);
      _currentParty = updatedParty;
      notifyListeners();
      logger.i('Added member $playerId to party ${_currentParty!.id}');
    }
  }

  /// Remove a member from the current party
  Future<void> removeMember(String playerId) async {
    if (_currentParty == null) return;

    final updatedMemberIds = List<String>.from(_currentParty!.memberPlayerIds ?? []);
    if (updatedMemberIds.contains(playerId)) {
      updatedMemberIds.remove(playerId);
      
      final updatedParty = Party(
        id: _currentParty!.id,
        campaignId: _currentParty!.campaignId,
        name: _currentParty!.name,
        summary: _currentParty!.summary,
        memberEntityIds: _currentParty!.memberEntityIds,
        memberPlayerIds: updatedMemberIds,
        createdAt: _currentParty!.createdAt,
        updatedAt: DateTime.now(),
        rev: _currentParty!.rev,
      );

      await _repository.update(updatedParty);
      _currentParty = updatedParty;
      notifyListeners();
      logger.i('Removed member $playerId from party ${_currentParty!.id}');
    }
  }
}
