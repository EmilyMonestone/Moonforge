import 'package:moonforge/data/models/dnd_helpers.dart';

class Entry {
  final String name;
  final List<String> entries;

  Entry({required this.name, required this.entries});

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      name: json['name'] as String,
      entries: (json['entries'] as List<dynamic>).cast<String>(),
    );
  }
}

List<Entry>? _parseEntries(dynamic json) {
  if (json == null) return null;
  if (json is List<dynamic>) {
    return json.map((e) => Entry.fromJson(e as Map<String, dynamic>)).toList();
  }
  return null;
}

List<Spell> _parseSpells(dynamic json) {
  if (json == null) return [];
  if (json is List<dynamic>) {
    return json.map((e) => Spell.fromJson(e as Map<String, dynamic>)).toList();
  }
  return [];
}

Map<int, List<Spell>> _parseSpellsPerDay(dynamic json) {
  final Map<int, List<Spell>> spellsPerDay = {};
  if (json == null) return spellsPerDay;
  if (json is Map<String, dynamic>) {
    json.forEach((key, value) {
      final dayCount = int.tryParse(key);
      if (dayCount != null && value is List<dynamic>) {
        spellsPerDay[dayCount] = value
            .map((e) => Spell.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    });
  }
  return spellsPerDay;
}

class Monster {
  final String name;
  final String source;
  final int? page;

  // Open5e slug / external id
  final String? slug;
  final int? xp;

  final List<String>? size;
  final String? type;
  final List<dynamic>? alignment; // mixed shapes → dynamic

  final List<dynamic>? ac; // [16] or [{...}]
  final Hp? hp;
  final Map<SpeedType, int>? speed;

  final AbilityScores abilityScores;

  final Map<Ability, String>? save; // e.g. { "dex": "+5" }
  final Map<Skill, String>? skill;

  final List<String>? senses;
  final int? passive;
  final List<String>? languages;
  final String? cr;
  final Ability? spellcastingAbility;

  final List<Entry>? actions;
  final List<Entry>? bonusActions;
  final List<Spell>? spellsAtWill;
  final Map<int, List<Spell>>? spellsPerDay;

  final List<Entry>? reactions;
  final List<Entry>? legendaryActions;
  final String? legendaryActionsLair;
  final List<Entry>? traits;

  /// Catch-all for everything we didn’t map explicitly
  final Map<String, dynamic> extra;

  Monster({
    required this.name,
    required this.source,
    this.page,
    this.slug,
    this.xp,
    this.size,
    this.type,
    this.alignment,
    this.ac,
    this.hp,
    this.speed,
    required this.abilityScores,
    this.save,
    this.skill,
    this.senses,
    this.passive,
    this.languages,
    this.cr,
    required this.spellcastingAbility,
    this.actions,
    this.bonusActions,
    this.spellsAtWill,
    this.spellsPerDay,
    this.reactions,
    this.legendaryActions,
    this.legendaryActionsLair,
    this.traits,
    this.extra = const {},
  });

  Map<Skill, int> get skillScores {
    final Map<Skill, int> scores = {};
    // for each enum Skill .abilityModifier(), get the corresponding ability score from abilityScores
    for (final skillValue in Skill.values) {
      var skillScore = skillValue.abilityModifier(abilityScores);
      // if skill is in skill map, parse the bonus and add it
      if (skill != null && skill!.containsKey(skillValue)) {
        final bonusString = skill![skillValue]!;
        // parse the bonus string, which is in the format "+5" or "-1"
        final bonus = int.tryParse(bonusString.replaceAll('+', '')) ?? 0;
        skillScore += bonus;
      }
      scores[skillValue] = skillScore;
    }
    return scores;
  }

  factory Monster.fromJson(Map<String, dynamic> json) {
    // Parse ability scores
    final abilityScores = AbilityScores.fromJson(json);

    return Monster(
      name: json['name'] as String,
      source: json['source'] as String,
      page: json['page'] as int?,
      size: (json['size'] as List<dynamic>?)?.cast<String>(),
      type: json['type'] as String?,
      alignment: json['alignment'] as List<dynamic>?,
      ac: json['ac'] as List<dynamic>?,
      hp: json['hp'] != null
          ? Hp.fromJson(json['hp'] as Map<String, dynamic>)
          : null,
      speed: (json['speed'] as Map<String, dynamic>?)?.map(
        (key, value) =>
            MapEntry(SpeedTypeExtension.fromString(key), value as int),
      ),
      abilityScores: abilityScores,
      save: (json['save'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          AbilityExtension.fromString(key) ?? Ability.intelligence,
          value as String,
        ),
      ),
      skill: (json['skill'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(
          SkillExtension.fromString(key) ?? Skill.acrobatics,
          value as String,
        ),
      ),
      senses: (json['senses'] as List<dynamic>?)?.cast<String>(),
      passive: json['passive'] as int?,
      languages: (json['languages'] as List<dynamic>?)?.cast<String>(),
      cr: json['cr'] as String?,
      spellcastingAbility: json['spellcastingAbility'] != null
          ? AbilityExtension.fromString(json['spellcastingAbility'] as String)
          : null,
      actions: _parseEntries(json['actions']),
      bonusActions: _parseEntries(json['bonusActions']),
      spellsAtWill: _parseSpells(json['will']),
      spellsPerDay: _parseSpellsPerDay(json['daily']),
      reactions: _parseEntries(json['reactions']),
      legendaryActions: _parseEntries(json['legendaryActions']),
      legendaryActionsLair: json['legendaryActionsLair'] as String?,
      traits: _parseEntries(json['traits']),
      extra: json,
    );
  }

  /// Factory specifically for Open5e monster JSON
  factory Monster.fromOpen5eJson(Map<String, dynamic> json) {
    // Open5e uses flat fields: name, slug, size, type, subtype, alignment, armor_class/hit_points/
    final nm = json['name'] as String? ?? json['title'] as String? ?? 'Unknown';
    final slug = json['slug'] as String?;

    // abilities
    final abilityScores = AbilityScores(
      strength: parseInt(json['strength']) ?? 10,
      dexterity: parseInt(json['dexterity']) ?? 10,
      constitution: parseInt(json['constitution']) ?? 10,
      intelligence: parseInt(json['intelligence']) ?? 10,
      wisdom: parseInt(json['wisdom']) ?? 10,
      charisma: parseInt(json['charisma']) ?? 10,
    );

    // HP
    final hp = json['hit_points'] != null
        ? Hp(
            average: parseInt(json['hit_points']) ?? 0,
            formula: json['hit_dice'] as String? ?? '',
          )
        : null;

    // speed
    final speed = parseSpeed(json['speed']);

    // skills and saves
    final skillMap = <Skill, String>{};
    if (json['skills'] is Map<String, dynamic>) {
      (json['skills'] as Map<String, dynamic>).forEach((k, v) {
        final s = SkillExtension.fromString(k) ?? Skill.acrobatics;
        final val = v is int ? v.toString() : (v?.toString() ?? '0');
        skillMap[s] = val;
      });
    }

    final saveMap = <Ability, String>{};
    for (final a in Ability.values) {
      final key = a.toString().split('.').last; // e.g., strength
      if (json['${key}_save'] != null) {
        saveMap[a] = (json['${key}_save']?.toString()) ?? '';
      }
    }

    // senses & languages
    final senses = (json['senses'] as String?)
        ?.split(',')
        .map((s) => s.trim())
        .toList();
    final languages = (json['languages'] as String?)
        ?.split(',')
        .map((s) => s.trim())
        .toList();

    // actions / abilities
    List<Entry>? actions;
    if (json['actions'] is List<dynamic>) {
      actions = (json['actions'] as List<dynamic>).map((e) {
        if (e is Map<String, dynamic>) {
          final name = e['name'] as String? ?? 'Action';
          final desc = (e['desc'] as String?) ?? '';
          return Entry(name: name, entries: [desc]);
        }
        return Entry(name: 'Action', entries: ['']);
      }).toList();
    }

    List<Entry>? special;
    if (json['special_abilities'] is List<dynamic>) {
      special = (json['special_abilities'] as List<dynamic>).map((e) {
        if (e is Map<String, dynamic>) {
          final name = e['name'] as String? ?? 'Trait';
          final desc = (e['desc'] as String?) ?? '';
          return Entry(name: name, entries: [desc]);
        }
        return Entry(name: 'Trait', entries: ['']);
      }).toList();
    }

    List<Entry>? legendary;
    if (json['legendary_actions'] is List<dynamic>) {
      legendary = (json['legendary_actions'] as List<dynamic>).map((e) {
        if (e is Map<String, dynamic>) {
          final name = e['name'] as String? ?? 'Legendary';
          final desc = (e['desc'] as String?) ?? '';
          return Entry(name: name, entries: [desc]);
        }
        return Entry(name: 'Legendary', entries: ['']);
      }).toList();
    }

    final cr = json['challenge_rating']?.toString() ?? json['cr']?.toString();

    return Monster(
      name: nm,
      source:
          json['document__title'] as String? ??
          json['source'] as String? ??
          'open5e',
      page: parseInt(json['page_no']),
      slug: slug,
      xp: parseInt(json['xp']),
      size: json['size'] != null ? [json['size'].toString()] : null,
      type: json['type'] as String?,
      alignment: json['alignment'] != null ? [json['alignment']] : null,
      ac: json['armor_class'] != null ? [json['armor_class']] : null,
      hp: hp,
      speed: speed,
      abilityScores: abilityScores,
      save: saveMap.map((k, v) => MapEntry(k, v)),
      skill: skillMap.map((k, v) => MapEntry(k, v)),
      senses: senses,
      passive:
          parseInt(json['perception']) ??
          parseInt(json['passive_perception']) ??
          parseInt(json['passive']),
      languages: languages,
      cr: cr,
      spellcastingAbility: null,
      actions: actions,
      bonusActions: null,
      spellsAtWill: null,
      spellsPerDay: null,
      reactions: null,
      legendaryActions: legendary,
      legendaryActionsLair: json['legendary_desc'] as String?,
      traits: special,
      extra: json,
    );
  }
}
