/// Character-related models for Open5e API

/// Background from Open5e API
class Background {
  final String slug;
  final String name;
  final String desc;
  final List<String>? skillProficiencies;
  final List<String>? toolProficiencies;
  final List<String>? languages;
  final String? equipment;
  final String? feature;
  final String? featureDesc;
  final String? document;

  Background({
    required this.slug,
    required this.name,
    required this.desc,
    this.skillProficiencies,
    this.toolProficiencies,
    this.languages,
    this.equipment,
    this.feature,
    this.featureDesc,
    this.document,
  });

  factory Background.fromJson(Map<String, dynamic> json) {
    return Background(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      skillProficiencies:
          (json['skill_proficiencies'] as List<dynamic>?)?.cast<String>(),
      toolProficiencies:
          (json['tool_proficiencies'] as List<dynamic>?)?.cast<String>(),
      languages: (json['languages'] as List<dynamic>?)?.cast<String>(),
      equipment: json['equipment'] as String?,
      feature: json['feature'] as String?,
      featureDesc: json['feature_desc'] as String?,
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'desc': desc,
      'skill_proficiencies': skillProficiencies,
      'tool_proficiencies': toolProficiencies,
      'languages': languages,
      'equipment': equipment,
      'feature': feature,
      'feature_desc': featureDesc,
      'document': document,
    };
  }
}

/// Feat from Open5e API
class Feat {
  final String slug;
  final String name;
  final String desc;
  final String? prerequisite;
  final String? document;

  Feat({
    required this.slug,
    required this.name,
    required this.desc,
    this.prerequisite,
    this.document,
  });

  factory Feat.fromJson(Map<String, dynamic> json) {
    return Feat(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      prerequisite: json['prerequisite'] as String?,
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'desc': desc,
      'prerequisite': prerequisite,
      'document': document,
    };
  }
}

/// Race from Open5e API
class Race {
  final String slug;
  final String name;
  final String desc;
  final String? asi;
  final String? asiDesc;
  final String? age;
  final String? alignment;
  final String? size;
  final String? speed;
  final String? languages;
  final String? vision;
  final String? traits;
  final String? document;

  Race({
    required this.slug,
    required this.name,
    required this.desc,
    this.asi,
    this.asiDesc,
    this.age,
    this.alignment,
    this.size,
    this.speed,
    this.languages,
    this.vision,
    this.traits,
    this.document,
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      asi: json['asi'] as String?,
      asiDesc: json['asi_desc'] as String?,
      age: json['age'] as String?,
      alignment: json['alignment'] as String?,
      size: json['size'] as String?,
      speed: json['speed'] as String?,
      languages: json['languages'] as String?,
      vision: json['vision'] as String?,
      traits: json['traits'] as String?,
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'desc': desc,
      'asi': asi,
      'asi_desc': asiDesc,
      'age': age,
      'alignment': alignment,
      'size': size,
      'speed': speed,
      'languages': languages,
      'vision': vision,
      'traits': traits,
      'document': document,
    };
  }
}

/// Character class from Open5e API
class CharacterClass {
  final String slug;
  final String name;
  final String desc;
  final String? hitDice;
  final String? hpAtFirstLevel;
  final String? hpAtHigherLevels;
  final String? profArmor;
  final String? profWeapons;
  final String? profTools;
  final String? profSavingThrows;
  final String? profSkills;
  final String? equipment;
  final String? spellcastingAbility;
  final String? subtypesName;
  final String? document;

  CharacterClass({
    required this.slug,
    required this.name,
    required this.desc,
    this.hitDice,
    this.hpAtFirstLevel,
    this.hpAtHigherLevels,
    this.profArmor,
    this.profWeapons,
    this.profTools,
    this.profSavingThrows,
    this.profSkills,
    this.equipment,
    this.spellcastingAbility,
    this.subtypesName,
    this.document,
  });

  factory CharacterClass.fromJson(Map<String, dynamic> json) {
    return CharacterClass(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      hitDice: json['hit_dice'] as String?,
      hpAtFirstLevel: json['hp_at_1st_level'] as String?,
      hpAtHigherLevels: json['hp_at_higher_levels'] as String?,
      profArmor: json['prof_armor'] as String?,
      profWeapons: json['prof_weapons'] as String?,
      profTools: json['prof_tools'] as String?,
      profSavingThrows: json['prof_saving_throws'] as String?,
      profSkills: json['prof_skills'] as String?,
      equipment: json['equipment'] as String?,
      spellcastingAbility: json['spellcasting_ability'] as String?,
      subtypesName: json['subtypes_name'] as String?,
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'desc': desc,
      'hit_dice': hitDice,
      'hp_at_1st_level': hpAtFirstLevel,
      'hp_at_higher_levels': hpAtHigherLevels,
      'prof_armor': profArmor,
      'prof_weapons': profWeapons,
      'prof_tools': profTools,
      'prof_saving_throws': profSavingThrows,
      'prof_skills': profSkills,
      'equipment': equipment,
      'spellcasting_ability': spellcastingAbility,
      'subtypes_name': subtypesName,
      'document': document,
    };
  }
}
