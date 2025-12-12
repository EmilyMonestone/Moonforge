/// Character-related models for Open5e API v2

import 'package:moonforge/core/services/open5e/models/common.dart';

/// Background from Open5e API v2
class Background {
  final String url;
  final String key;
  final String name;
  final String desc;
  final Document? document;

  Background({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.document,
  });

  factory Background.fromJson(Map<String, dynamic> json) {
    return Background(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
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
      'document': document?.toJson(),
    };
  }
}

/// Feat from Open5e API v2
class Feat {
  final String url;
  final String key;
  final String name;
  final String desc;
  final String? prerequisite;
  final Document? document;

  Feat({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.prerequisite,
    this.document,
  });

  factory Feat.fromJson(Map<String, dynamic> json) {
    return Feat(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      prerequisite: json['prerequisite'] as String?,
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
      'prerequisite': prerequisite,
      'document': document?.toJson(),
    };
  }
}

/// Species (formerly Race) from Open5e API v2
class Species {
  final String url;
  final String key;
  final String name;
  final String desc;
  final Document? document;

  Species({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.document,
  });

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
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
      'document': document?.toJson(),
    };
  }
}

/// Character class from Open5e API v2
class CharacterClass {
  final String url;
  final String key;
  final String name;
  final String desc;
  final Document? document;

  CharacterClass({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.document,
  });

  factory CharacterClass.fromJson(Map<String, dynamic> json) {
    return CharacterClass(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
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
      'document': document?.toJson(),
    };
  }
}

/// Ability from Open5e API v2
class Ability {
  final String url;
  final String key;
  final String name;
  final String? fullName;
  final String desc;

  Ability({
    required this.url,
    required this.key,
    required this.name,
    this.fullName,
    required this.desc,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      fullName: json['full_name'] as String?,
      desc: json['desc'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'key': key,
      'name': name,
      'full_name': fullName,
      'desc': desc,
    };
  }
}

/// Skill from Open5e API v2
class Skill {
  final String url;
  final String key;
  final String name;
  final String desc;
  final String? ability;

  Skill({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.ability,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      ability: json['ability'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'key': key,
      'name': name,
      'desc': desc,
      'ability': ability,
    };
  }
}
