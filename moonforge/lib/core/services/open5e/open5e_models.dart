/// Data models for Open5e API responses
/// 
/// These models represent the JSON structures returned by various Open5e endpoints.
/// They are kept minimal and type-safe, with factory constructors for JSON parsing.

/// Generic paginated response wrapper used by most Open5e list endpoints
class PaginatedResponse<T> {
  final int count;
  final String? next;
  final String? previous;
  final List<T> results;

  PaginatedResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => fromJsonT(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map(toJsonT).toList(),
    };
  }
}

/// Manifest entry - represents an available API resource
class ManifestEntry {
  final String title;
  final String description;
  final String slug;
  final String url;

  ManifestEntry({
    required this.title,
    required this.description,
    required this.slug,
    required this.url,
  });

  factory ManifestEntry.fromJson(Map<String, dynamic> json) {
    return ManifestEntry(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'slug': slug,
      'url': url,
    };
  }
}

/// Document - represents a rulebook or source
class Document {
  final String slug;
  final String title;
  final String desc;
  final String? license;
  final String? author;
  final String? organization;
  final String? version;
  final String? url;
  final String? copyright;

  Document({
    required this.slug,
    required this.title,
    required this.desc,
    this.license,
    this.author,
    this.organization,
    this.version,
    this.url,
    this.copyright,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      license: json['license'] as String?,
      author: json['author'] as String?,
      organization: json['organization'] as String?,
      version: json['version'] as String?,
      url: json['url'] as String?,
      copyright: json['copyright'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'title': title,
      'desc': desc,
      'license': license,
      'author': author,
      'organization': organization,
      'version': version,
      'url': url,
      'copyright': copyright,
    };
  }
}

/// Spell from Open5e API
class Open5eSpell {
  final String slug;
  final String name;
  final String desc;
  final String? higherLevel;
  final String? range;
  final String components;
  final String? material;
  final bool ritual;
  final String duration;
  final bool concentration;
  final String castingTime;
  final int level;
  final String school;
  final List<String> dndClass;
  final String? document;

  Open5eSpell({
    required this.slug,
    required this.name,
    required this.desc,
    this.higherLevel,
    this.range,
    required this.components,
    this.material,
    required this.ritual,
    required this.duration,
    required this.concentration,
    required this.castingTime,
    required this.level,
    required this.school,
    required this.dndClass,
    this.document,
  });

  factory Open5eSpell.fromJson(Map<String, dynamic> json) {
    return Open5eSpell(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      higherLevel: json['higher_level'] as String?,
      range: json['range'] as String?,
      components: json['components'] as String? ?? '',
      material: json['material'] as String?,
      ritual: json['ritual'] as bool? ?? false,
      duration: json['duration'] as String? ?? '',
      concentration: json['concentration'] as bool? ?? false,
      castingTime: json['casting_time'] as String? ?? '',
      level: json['level'] as int? ?? 0,
      school: json['school'] as String? ?? '',
      dndClass:
          (json['dnd_class'] as List<dynamic>?)?.cast<String>() ??
          (json['classes'] as List<dynamic>?)?.cast<String>() ??
          [],
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'desc': desc,
      'higher_level': higherLevel,
      'range': range,
      'components': components,
      'material': material,
      'ritual': ritual,
      'duration': duration,
      'concentration': concentration,
      'casting_time': castingTime,
      'level': level,
      'school': school,
      'dnd_class': dndClass,
      'document': document,
    };
  }
}

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

/// Condition from Open5e API
class Condition {
  final String slug;
  final String name;
  final String desc;
  final String? document;

  Condition({
    required this.slug,
    required this.name,
    required this.desc,
    this.document,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'desc': desc,
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

/// Magic Item from Open5e API
class MagicItem {
  final String slug;
  final String name;
  final String type;
  final String desc;
  final String? rarity;
  final bool? requiresAttunement;
  final String? document;

  MagicItem({
    required this.slug,
    required this.name,
    required this.type,
    required this.desc,
    this.rarity,
    this.requiresAttunement,
    this.document,
  });

  factory MagicItem.fromJson(Map<String, dynamic> json) {
    return MagicItem(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      rarity: json['rarity'] as String?,
      requiresAttunement: json['requires_attunement'] as bool?,
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'type': type,
      'desc': desc,
      'rarity': rarity,
      'requires_attunement': requiresAttunement,
      'document': document,
    };
  }
}

/// Weapon from Open5e API
class Weapon {
  final String slug;
  final String name;
  final String category;
  final String? damage;
  final String? damageType;
  final String? weight;
  final String? properties;
  final String? document;

  Weapon({
    required this.slug,
    required this.name,
    required this.category,
    this.damage,
    this.damageType,
    this.weight,
    this.properties,
    this.document,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      damage: json['damage'] as String?,
      damageType: json['damage_type'] as String?,
      weight: json['weight'] as String?,
      properties: json['properties'] as String?,
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'category': category,
      'damage': damage,
      'damage_type': damageType,
      'weight': weight,
      'properties': properties,
      'document': document,
    };
  }
}

/// Armor from Open5e API
class Armor {
  final String slug;
  final String name;
  final String category;
  final String? armorClass;
  final String? strength;
  final bool? stealthDisadvantage;
  final String? weight;
  final String? document;

  Armor({
    required this.slug,
    required this.name,
    required this.category,
    this.armorClass,
    this.strength,
    this.stealthDisadvantage,
    this.weight,
    this.document,
  });

  factory Armor.fromJson(Map<String, dynamic> json) {
    return Armor(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      armorClass: json['armor_class'] as String?,
      strength: json['strength'] as String?,
      stealthDisadvantage: json['stealth_disadvantage'] as bool?,
      weight: json['weight'] as String?,
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'category': category,
      'armor_class': armorClass,
      'strength': strength,
      'stealth_disadvantage': stealthDisadvantage,
      'weight': weight,
      'document': document,
    };
  }
}

/// Plane from Open5e API
class Plane {
  final String slug;
  final String name;
  final String desc;
  final String? document;

  Plane({
    required this.slug,
    required this.name,
    required this.desc,
    this.document,
  });

  factory Plane.fromJson(Map<String, dynamic> json) {
    return Plane(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'desc': desc,
      'document': document,
    };
  }
}

/// Section from Open5e API
class Section {
  final String slug;
  final String name;
  final String desc;
  final String? parent;
  final String? document;

  Section({
    required this.slug,
    required this.name,
    required this.desc,
    this.parent,
    this.document,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      parent: json['parent'] as String?,
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'desc': desc,
      'parent': parent,
      'document': document,
    };
  }
}

/// Spell List from Open5e API
class SpellList {
  final String slug;
  final String name;
  final String desc;
  final String? document;

  SpellList({
    required this.slug,
    required this.name,
    required this.desc,
    this.document,
  });

  factory SpellList.fromJson(Map<String, dynamic> json) {
    return SpellList(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      document: json['document'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'desc': desc,
      'document': document,
    };
  }
}
