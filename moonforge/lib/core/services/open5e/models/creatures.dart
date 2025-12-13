/// Creature-related models for Open5e API v2

import 'package:moonforge/core/services/open5e/models/common.dart';

/// Creature from Open5e API v2 (formerly Monster in v1)
class Creature {
  final String url;
  final String key;
  final String name;
  final Document? document;
  final String? desc;
  final String? size;
  final String? type;
  final String? category;
  final String? subcategory;
  final int? armorClass;
  final int? hitPoints;
  final String? hitDice;
  final int? speed;
  final int? abilityScoreStrength;
  final int? abilityScoreDexterity;
  final int? abilityScoreConstitution;
  final int? abilityScoreIntelligence;
  final int? abilityScoreWisdom;
  final int? abilityScoreCharisma;
  final double? challengeRatingDecimal;
  final String? challengeRatingText;
  final int? passivePerception;

  Creature({
    required this.url,
    required this.key,
    required this.name,
    this.document,
    this.desc,
    this.size,
    this.type,
    this.category,
    this.subcategory,
    this.armorClass,
    this.hitPoints,
    this.hitDice,
    this.speed,
    this.abilityScoreStrength,
    this.abilityScoreDexterity,
    this.abilityScoreConstitution,
    this.abilityScoreIntelligence,
    this.abilityScoreWisdom,
    this.abilityScoreCharisma,
    this.challengeRatingDecimal,
    this.challengeRatingText,
    this.passivePerception,
  });

  factory Creature.fromJson(Map<String, dynamic> json) {
    return Creature(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      document: json['document'] != null
          ? Document.fromJson(json['document'] as Map<String, dynamic>)
          : null,
      desc: json['desc'] as String?,
      size: json['size'] as String?,
      type: json['type'] as String?,
      category: json['category'] as String?,
      subcategory: json['subcategory'] as String?,
      armorClass: json['armor_class'] as int?,
      hitPoints: json['hit_points'] as int?,
      hitDice: json['hit_dice'] as String?,
      speed: json['speed'] as int?,
      abilityScoreStrength: json['ability_score_strength'] as int?,
      abilityScoreDexterity: json['ability_score_dexterity'] as int?,
      abilityScoreConstitution: json['ability_score_constitution'] as int?,
      abilityScoreIntelligence: json['ability_score_intelligence'] as int?,
      abilityScoreWisdom: json['ability_score_wisdom'] as int?,
      abilityScoreCharisma: json['ability_score_charisma'] as int?,
      challengeRatingDecimal: (json['challenge_rating_decimal'] as num?)?.toDouble(),
      challengeRatingText: json['challenge_rating_text'] as String?,
      passivePerception: json['passive_perception'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'key': key,
      'name': name,
      'document': document?.toJson(),
      'desc': desc,
      'size': size,
      'type': type,
      'category': category,
      'subcategory': subcategory,
      'armor_class': armorClass,
      'hit_points': hitPoints,
      'hit_dice': hitDice,
      'speed': speed,
      'ability_score_strength': abilityScoreStrength,
      'ability_score_dexterity': abilityScoreDexterity,
      'ability_score_constitution': abilityScoreConstitution,
      'ability_score_intelligence': abilityScoreIntelligence,
      'ability_score_wisdom': abilityScoreWisdom,
      'ability_score_charisma': abilityScoreCharisma,
      'challenge_rating_decimal': challengeRatingDecimal,
      'challenge_rating_text': challengeRatingText,
      'passive_perception': passivePerception,
    };
  }
}

/// Creature Type from Open5e API v2
class CreatureType {
  final String url;
  final String key;
  final String name;
  final String desc;

  CreatureType({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory CreatureType.fromJson(Map<String, dynamic> json) {
    return CreatureType(
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

/// Creature Set from Open5e API v2
class CreatureSet {
  final String url;
  final String key;
  final String name;
  final String desc;

  CreatureSet({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory CreatureSet.fromJson(Map<String, dynamic> json) {
    return CreatureSet(
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
