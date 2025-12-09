enum Ability {
  strength,
  dexterity,
  constitution,
  intelligence,
  wisdom,
  charisma,
}

extension AbilityExtension on Ability {
  static Ability? fromString(String? str) {
    switch (str) {
      case 'strength':
        return Ability.strength;
      case 'dexterity':
        return Ability.dexterity;
      case 'constitution':
        return Ability.constitution;
      case 'intelligence':
        return Ability.intelligence;
      case 'wisdom':
        return Ability.wisdom;
      case 'charisma':
        return Ability.charisma;
      default:
        return null;
    }
  }
}

enum Skill {
  acrobatics,
  animalHandling,
  arcana,
  athletics,
  deception,
  history,
  insight,
  intimidation,
  investigation,
  medicine,
  nature,
  perception,
  performance,
  persuasion,
  religion,
  sleightOfHand,
  stealth,
  survival,
}

extension SkillExtension on Skill {
  static Skill? fromString(String? str) {
    switch (str) {
      case 'acrobatics':
        return Skill.acrobatics;
      case 'animalHandling':
        return Skill.animalHandling;
      case 'arcana':
        return Skill.arcana;
      case 'athletics':
        return Skill.athletics;
      case 'deception':
        return Skill.deception;
      case 'history':
        return Skill.history;
      case 'insight':
        return Skill.insight;
      case 'intimidation':
        return Skill.intimidation;
      case 'investigation':
        return Skill.investigation;
      case 'medicine':
        return Skill.medicine;
      case 'nature':
        return Skill.nature;
      case 'perception':
        return Skill.perception;
      case 'performance':
        return Skill.performance;
      case 'persuasion':
        return Skill.persuasion;
      case 'religion':
        return Skill.religion;
      case 'sleightOfHand':
        return Skill.sleightOfHand;
      case 'stealth':
        return Skill.stealth;
      case 'survival':
        return Skill.survival;
      default:
        return null;
    }
  }

  int abilityModifier(AbilityScores abilityScores) {
    switch (this) {
      case Skill.acrobatics:
      case Skill.sleightOfHand:
      case Skill.stealth:
        return abilityScores.dexterity;
      case Skill.animalHandling:
      case Skill.insight:
      case Skill.medicine:
      case Skill.perception:
      case Skill.survival:
        return abilityScores.wisdom;
      case Skill.arcana:
      case Skill.history:
      case Skill.investigation:
      case Skill.religion:
      case Skill.nature:
        return abilityScores.intelligence;
      case Skill.athletics:
        return abilityScores.strength;
      case Skill.deception:
      case Skill.intimidation:
      case Skill.performance:
      case Skill.persuasion:
        return abilityScores.charisma;
    }
  }
}

enum SpeedType { walk, fly, swim, burrow, climb, hover }

extension SpeedTypeExtension on SpeedType {
  static SpeedType fromString(String? str) {
    switch (str) {
      case 'fly':
        return SpeedType.fly;
      case 'swim':
        return SpeedType.swim;
      case 'burrow':
        return SpeedType.burrow;
      case 'climb':
        return SpeedType.climb;
      case 'hover':
        return SpeedType.hover;
      case 'walk':
      default:
        return SpeedType.walk;
    }
  }
}

enum DamageType {
  acid,
  bludgeoning,
  cold,
  fire,
  force,
  lightning,
  necrotic,
  piercing,
  poison,
  psychic,
  radiant,
  slashing,
  thunder,
}

extension DamageTypeExtension on DamageType {
  static DamageType? fromString(String? str) {
    switch (str) {
      case 'acid':
        return DamageType.acid;
      case 'bludgeoning':
        return DamageType.bludgeoning;
      case 'cold':
        return DamageType.cold;
      case 'fire':
        return DamageType.fire;
      case 'force':
        return DamageType.force;
      case 'lightning':
        return DamageType.lightning;
      case 'necrotic':
        return DamageType.necrotic;
      case 'piercing':
        return DamageType.piercing;
      case 'poison':
        return DamageType.poison;
      case 'psychic':
        return DamageType.psychic;
      case 'radiant':
        return DamageType.radiant;
      case 'slashing':
        return DamageType.slashing;
      case 'thunder':
        return DamageType.thunder;
      default:
        return null;
    }
  }
}

class AbilityScores {
  final int strength;
  final int dexterity;
  final int constitution;
  final int intelligence;
  final int wisdom;
  final int charisma;

  AbilityScores({
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });

  factory AbilityScores.fromJson(Map<String, dynamic> json) {
    return AbilityScores(
      strength: json['str'] as int,
      dexterity: json['dex'] as int,
      constitution: json['con'] as int,
      intelligence: json['int'] as int,
      wisdom: json['wis'] as int,
      charisma: json['cha'] as int,
    );
  }
}

class Spell {
  final String name;
  final String source;
  final int? page;
  final int level;
  final String school;
  final List<dynamic> time;
  final Map<String, dynamic> range;
  final Map<String, dynamic> components;
  final List<dynamic> duration;
  final List<dynamic> entries;
  final List<String>? damageInflict;

  Spell({
    required this.name,
    required this.source,
    this.page,
    required this.level,
    required this.school,
    required this.time,
    required this.range,
    required this.components,
    required this.duration,
    required this.entries,
    this.damageInflict,
  });

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      name: json['name'] as String,
      source: json['source'] as String,
      page: json['page'] as int?,
      level: json['level'] as int,
      school: json['school'] as String,
      time: json['time'] as List<dynamic>,
      range: json['range'] as Map<String, dynamic>,
      components: json['components'] as Map<String, dynamic>,
      duration: json['duration'] as List<dynamic>,
      entries: json['entries'] as List<dynamic>,
      damageInflict: (json['damageInflict'] as List?)?.cast<String>(),
    );
  }
}

class Hp {
  final int average;
  final String formula;

  Hp({required this.average, required this.formula});

  factory Hp.fromJson(Map<String, dynamic> json) {
    return Hp(
      average: json['average'] as int,
      formula: json['formula'] as String,
    );
  }
}

// New helpers for Open5e parsing
int? parseInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) {
    final cleaned = v.replaceAll(RegExp(r"[^0-9\-]"), '');
    return int.tryParse(cleaned);
  }
  return null;
}

double? parseDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) {
    final cleaned = v.replaceAll(RegExp(r"[^0-9\.-]"), '');
    return double.tryParse(cleaned);
  }
  return null;
}

Map<SpeedType, int>? parseSpeed(dynamic json) {
  final Map<SpeedType, int> speeds = {};

  if (json is Map<String, dynamic>) {
    json.forEach((k, v) {
      final st = SpeedTypeExtension.fromString(k);
      final val =
          parseInt(v) ??
          (v is String ? parseInt(RegExp(r"(\d+)").stringMatch(v)) : null);
      if (val != null) speeds[st] = val;
    });
  } else if (json is String) {
    // Example: "30 ft., fly 60 ft."
    final parts = json.split(',');
    for (final part in parts) {
      final m = RegExp(r"(?:(\w+) )?(\d+)").firstMatch(part.trim());
      if (m != null) {
        final label = m.group(1);
        final num = int.tryParse(m.group(2)!);
        final st = label != null
            ? SpeedTypeExtension.fromString(label)
            : SpeedType.walk;
        if (num != null) speeds[st] = num;
      }
    }
  }

  return speeds;
}

Map<String, int> parseProficiencies(dynamic json) {
  final Map<String, int> prof = {};
  if (json == null) return prof;
  if (json is List<dynamic>) {
    for (final item in json) {
      if (item is Map<String, dynamic>) {
        final name = item['name'] as String?;
        final value = parseInt(item['value']);
        if (name != null && value != null) prof[name] = value;
      }
    }
  }
  return prof;
}
