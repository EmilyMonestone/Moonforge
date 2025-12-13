/// Spell-related models for Open5e API v2

import 'package:moonforge/core/services/open5e/models/common.dart';

/// Spell from Open5e API v2
class Open5eSpell {
  final String url;
  final String key;
  final String name;
  final String desc;
  final String? higherLevel;
  final String? range;
  final String? components;
  final String? material;
  final bool? ritual;
  final String? duration;
  final bool? concentration;
  final String? castingTime;
  final int? level;
  final String? school;
  final Document? document;

  Open5eSpell({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.higherLevel,
    this.range,
    this.components,
    this.material,
    this.ritual,
    this.duration,
    this.concentration,
    this.castingTime,
    this.level,
    this.school,
    this.document,
  });

  factory Open5eSpell.fromJson(Map<String, dynamic> json) {
    return Open5eSpell(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      higherLevel: json['higher_level'] as String?,
      range: json['range'] as String?,
      components: json['components'] as String?,
      material: json['material'] as String?,
      ritual: json['ritual'] as bool?,
      duration: json['duration'] as String?,
      concentration: json['concentration'] as bool?,
      castingTime: json['casting_time'] as String?,
      level: json['level'] as int?,
      school: json['school'] as String?,
      document: json['document'] != null
          ? Document.fromJson(json['document'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'key': key,
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
      'document': document?.toJson(),
    };
  }
}

/// Spell School from Open5e API v2
class SpellSchool {
  final String url;
  final String key;
  final String name;
  final String desc;

  SpellSchool({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory SpellSchool.fromJson(Map<String, dynamic> json) {
    return SpellSchool(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'key': key,
      'name': name,
      'desc': desc,
    };
  }
}
