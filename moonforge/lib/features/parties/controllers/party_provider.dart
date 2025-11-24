import 'package:moonforge/core/models/async_state.dart';
import 'package:moonforge/core/providers/base_async_provider.dart';
import 'package:moonforge/core/services/persistence_service.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/party_repository.dart';

/// Provider for managing current party state and party switching
class PartyProvider extends BaseAsyncProvider<Party?> {
  static const String _currentPartyKey = 'current_party_id';
  final PersistenceService _persistence = PersistenceService();
  final PartyRepository _repository;

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
        updateState(AsyncState.data(party));
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
    if (party == null) {
      reset();
    } else {
      updateState(AsyncState.data(party));
    }

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
    if (state.dataOrNull != null) {
      _persistence.write(_currentPartyKey, partyId);
      logger.i('Switched to party: $partyId');
    }
  }

  /// Clear the persisted party
  void clearPersistedParty() {
    _persistence.remove(_currentPartyKey);
    reset();
    notifyListeners();
  }

  /// Add a member to the current party
  Future<void> addMember(String playerId) async {
    final current = currentParty;
    if (current == null) return;

    final updatedMemberIds = List<String>.from(current.memberPlayerIds ?? []);
    if (!updatedMemberIds.contains(playerId)) {
      updatedMemberIds.add(playerId);

      final updatedParty = Party(
        id: current.id,
        campaignId: current.campaignId,
        name: current.name,
        summary: current.summary,
        memberEntityIds: current.memberEntityIds,
        memberPlayerIds: updatedMemberIds,
        createdAt: current.createdAt,
        updatedAt: DateTime.now(),
        rev: current.rev,
      );

      await _repository.update(updatedParty);
      updateState(AsyncState.data(updatedParty));
      notifyListeners();
      logger.i('Added member $playerId to party ${updatedParty.id}');
    }
  }

  /// Remove a member from the current party
  Future<void> removeMember(String playerId) async {
    final current = currentParty;
    if (current == null) return;

    final updatedMemberIds = List<String>.from(current.memberPlayerIds ?? []);
    if (updatedMemberIds.contains(playerId)) {
      updatedMemberIds.remove(playerId);

      final updatedParty = Party(
        id: current.id,
        campaignId: current.campaignId,
        name: current.name,
        summary: current.summary,
        memberEntityIds: current.memberEntityIds,
        memberPlayerIds: updatedMemberIds,
        createdAt: current.createdAt,
        updatedAt: DateTime.now(),
        rev: current.rev,
      );

      await _repository.update(updatedParty);
      updateState(AsyncState.data(updatedParty));
      notifyListeners();
      logger.i('Removed member $playerId from party ${updatedParty.id}');
    }
  }

  Party? get currentParty => state.dataOrNull;
}
