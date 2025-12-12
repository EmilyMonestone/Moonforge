/// Spell-related models for Open5e API

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
