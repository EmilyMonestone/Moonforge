import 'package:intl/intl.dart';
import 'package:moonforge/data/db/app_db.dart';
import 'package:moonforge/features/parties/utils/character_calculations.dart';

/// Formatters for displaying character information
class CharacterFormatters {
  /// Format character level with suffix (e.g., "5th Level")
  static String formatLevel(int level) {
    return '${level}${_getLevelSuffix(level)} Level';
  }

  /// Get ordinal suffix for level
  static String _getLevelSuffix(int level) {
    if (level >= 11 && level <= 13) return 'th';
    switch (level % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  /// Format character title (e.g., "5th Level Human Fighter")
  static String formatCharacterTitle(Player player) {
    final parts = <String>[];
    
    parts.add(formatLevel(player.level));
    
    if (player.race != null && player.race!.isNotEmpty) {
      parts.add(player.race!);
    }
    
    parts.add(player.className);
    
    if (player.subclass != null && player.subclass!.isNotEmpty) {
      parts.add('(${player.subclass})');
    }
    
    return parts.join(' ');
  }

  /// Format HP as "current/max" or with temp HP
  static String formatHp(Player player) {
    final current = player.hpCurrent ?? 0;
    final max = player.hpMax ?? 0;
    final temp = player.hpTemp ?? 0;
    
    if (temp > 0) {
      return '$current/$max (+$temp temp)';
    }
    return '$current/$max';
  }

  /// Format HP percentage for display
  static String formatHpPercentage(Player player) {
    final current = player.hpCurrent ?? 0;
    final max = player.hpMax ?? 0;
    
    if (max == 0) return '0%';
    
    final percentage = (current / max * 100).round();
    return '$percentage%';
  }

  /// Format ability score with modifier (e.g., "16 (+3)")
  static String formatAbilityScore(int score) {
    final modifier = CharacterCalculations.calculateAbilityModifier(score);
    final modText = CharacterCalculations.formatModifier(modifier);
    return '$score ($modText)';
  }

  /// Format all ability scores as a compact string
  static String formatAllAbilityScores(Player player) {
    return 'STR ${player.str} | DEX ${player.dex} | CON ${player.con} | '
           'INT ${player.intl} | WIS ${player.wis} | CHA ${player.cha}';
  }

  /// Format speed (e.g., "30 ft.")
  static String formatSpeed(int? speed) {
    return '${speed ?? 30} ft.';
  }

  /// Format initiative modifier
  static String formatInitiative(Player player) {
    final initiative = CharacterCalculations.calculateInitiativeModifier(player.dex);
    return CharacterCalculations.formatModifier(initiative);
  }

  /// Format passive perception
  static String formatPassivePerception(Player player, {bool isProficient = false}) {
    final proficiencyBonus = player.proficiencyBonus ?? 
      CharacterCalculations.calculateProficiencyBonus(player.level);
    
    final pp = CharacterCalculations.calculatePassivePerception(
      wisdom: player.wis,
      proficiencyBonus: proficiencyBonus,
      isProficient: isProficient,
    );
    
    return pp.toString();
  }

  /// Format last sync time for D&D Beyond
  static String formatLastDdbSync(DateTime? lastSync) {
    if (lastSync == null) return 'Never synced';
    
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      return DateFormat('MMM d, yyyy').format(lastSync);
    }
  }

  /// Format proficiency list as comma-separated string
  static String formatProficiencyList(List<String>? proficiencies) {
    if (proficiencies == null || proficiencies.isEmpty) {
      return 'None';
    }
    return proficiencies.join(', ');
  }

  /// Format equipment list
  static String formatEquipment(List<String>? equipment) {
    if (equipment == null || equipment.isEmpty) {
      return 'No equipment';
    }
    return equipment.join(', ');
  }

  /// Format spell list with counts
  static String formatSpellCount(List<String>? spells) {
    if (spells == null || spells.isEmpty) {
      return 'No spells';
    }
    final count = spells.length;
    return '$count spell${count > 1 ? 's' : ''} known';
  }

  /// Format character summary for tooltips/cards
  static String formatCharacterSummary(Player player) {
    final parts = <String>[];
    
    parts.add(formatCharacterTitle(player));
    parts.add('HP: ${formatHp(player)}');
    parts.add('AC: ${player.ac ?? 10}');
    
    if (player.alignment != null && player.alignment!.isNotEmpty) {
      parts.add('Alignment: ${player.alignment}');
    }
    
    return parts.join(' • ');
  }
}
