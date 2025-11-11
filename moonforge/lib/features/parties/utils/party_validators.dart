import 'package:moonforge/data/db/app_db.dart';

/// Validators for party data
class PartyValidators {
  /// Validate party name
  static String? validatePartyName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Party name is required';
    }
    if (name.length < 2) {
      return 'Party name must be at least 2 characters';
    }
    if (name.length > 100) {
      return 'Party name must be less than 100 characters';
    }
    return null;
  }

  /// Validate party has at least one member
  static String? validatePartyMembers(Party party) {
    final memberIds = party.memberPlayerIds ?? [];
    if (memberIds.isEmpty) {
      return 'Party must have at least one member';
    }
    return null;
  }

  /// Check if party is valid for gameplay
  static List<String> validatePartyReadiness(
    Party party,
    List<Player> members,
  ) {
    final issues = <String>[];

    if (members.isEmpty) {
      issues.add('Party has no members');
      return issues;
    }

    // Check member levels
    final levels = members.map((m) => m.level).toList();
    final minLevel = levels.reduce((a, b) => a < b ? a : b);
    final maxLevel = levels.reduce((a, b) => a > b ? a : b);

    if (maxLevel - minLevel > 3) {
      issues.add(
        'Large level variance ($minLevel-$maxLevel) may cause balance issues',
      );
    }

    // Check for invalid HP
    for (final member in members) {
      if (member.hpMax == null || member.hpMax! <= 0) {
        issues.add('${member.name} has invalid max HP');
      }
      if (member.hpCurrent == null) {
        issues.add('${member.name} has no current HP set');
      }
    }

    return issues;
  }
}
