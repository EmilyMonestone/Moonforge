import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/data/repo/party_repository.dart';
import 'package:moonforge/data/repo/player_repository.dart';

/// Service for party operations and management
class PartyService {
  final PartyRepository _partyRepository;
  final PlayerRepository _playerRepository;

  PartyService(this._partyRepository, this._playerRepository);

  /// Get all members of a party
  Future<List<Player>> getPartyMembers(String partyId) async {
    final party = await _partyRepository.getById(partyId);
    if (party == null || party.memberPlayerIds == null) {
      return [];
    }

    final members = <Player>[];
    for (final playerId in party.memberPlayerIds!) {
      final player = await _playerRepository.getById(playerId);
      if (player != null && !player.deleted) {
        members.add(player);
      }
    }

    return members;
  }

  /// Get party statistics
  Future<PartyStatistics> getPartyStatistics(String partyId) async {
    final members = await getPartyMembers(partyId);

    if (members.isEmpty) {
      return PartyStatistics(
        memberCount: 0,
        averageLevel: 0.0,
        totalHp: 0,
        averageAc: 0.0,
      );
    }

    final totalLevel = members.fold<int>(0, (sum, member) => sum + member.level);
    final totalHp = members.fold<int>(
      0,
      (sum, member) => sum + (member.hpMax ?? 0),
    );
    final totalAc = members.fold<int>(0, (sum, member) => sum + (member.ac ?? 0));

    return PartyStatistics(
      memberCount: members.length,
      averageLevel: totalLevel / members.length,
      totalHp: totalHp,
      averageAc: totalAc / members.length,
    );
  }

  /// Get party composition (class distribution)
  Future<Map<String, int>> getPartyComposition(String partyId) async {
    final members = await getPartyMembers(partyId);
    final composition = <String, int>{};

    for (final member in members) {
      final className = member.className;
      composition[className] = (composition[className] ?? 0) + 1;
    }

    return composition;
  }

  /// Check if party is balanced (has diverse roles)
  Future<PartyBalanceCheck> checkPartyBalance(String partyId) async {
    final members = await getPartyMembers(partyId);
    
    if (members.isEmpty) {
      return PartyBalanceCheck(
        isBalanced: false,
        warnings: ['Party has no members'],
        suggestions: ['Add at least one character'],
      );
    }

    final warnings = <String>[];
    final suggestions = <String>[];

    // Check for healers (Cleric, Druid, Bard)
    final hasHealer = members.any((m) => 
      m.className.toLowerCase().contains('cleric') ||
      m.className.toLowerCase().contains('druid') ||
      m.className.toLowerCase().contains('bard')
    );

    if (!hasHealer) {
      warnings.add('No healing class detected');
      suggestions.add('Consider adding a Cleric, Druid, or Bard');
    }

    // Check for tanks (Barbarian, Fighter, Paladin)
    final hasTank = members.any((m) =>
      m.className.toLowerCase().contains('barbarian') ||
      m.className.toLowerCase().contains('fighter') ||
      m.className.toLowerCase().contains('paladin')
    );

    if (!hasTank) {
      warnings.add('No tank class detected');
      suggestions.add('Consider adding a Barbarian, Fighter, or Paladin');
    }

    // Check for damage dealers
    final hasDamageDealer = members.any((m) =>
      m.className.toLowerCase().contains('rogue') ||
      m.className.toLowerCase().contains('ranger') ||
      m.className.toLowerCase().contains('warlock') ||
      m.className.toLowerCase().contains('sorcerer') ||
      m.className.toLowerCase().contains('wizard')
    );

    if (!hasDamageDealer) {
      warnings.add('No dedicated damage dealer detected');
      suggestions.add('Consider adding a Rogue, Ranger, or spellcaster');
    }

    // Check party size
    if (members.length < 3) {
      warnings.add('Party is small (${members.length} members)');
      suggestions.add('Ideal party size is 4-6 characters');
    } else if (members.length > 7) {
      warnings.add('Party is large (${members.length} members)');
      suggestions.add('Large parties may slow down combat');
    }

    // Check level variance
    final levels = members.map((m) => m.level).toList();
    final minLevel = levels.reduce((a, b) => a < b ? a : b);
    final maxLevel = levels.reduce((a, b) => a > b ? a : b);
    
    if (maxLevel - minLevel > 2) {
      warnings.add('Large level variance (${minLevel}-${maxLevel})');
      suggestions.add('Consider balancing character levels');
    }

    return PartyBalanceCheck(
      isBalanced: warnings.isEmpty,
      warnings: warnings,
      suggestions: suggestions,
    );
  }
}

/// Statistics for a party
class PartyStatistics {
  final int memberCount;
  final double averageLevel;
  final int totalHp;
  final double averageAc;

  PartyStatistics({
    required this.memberCount,
    required this.averageLevel,
    required this.totalHp,
    required this.averageAc,
  });
}

/// Result of party balance check
class PartyBalanceCheck {
  final bool isBalanced;
  final List<String> warnings;
  final List<String> suggestions;

  PartyBalanceCheck({
    required this.isBalanced,
    required this.warnings,
    required this.suggestions,
  });
}
