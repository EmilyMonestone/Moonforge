/// Equipment-related models for Open5e API v2

import 'package:moonforge/core/services/open5e/models/common.dart';

/// Generic Item from Open5e API v2
class Item {
  final String url;
  final String key;
  final String name;
  final String desc;
  final Document? document;

  Item({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.document,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
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

/// Magic Item from Open5e API v2
class MagicItem {
  final String url;
  final String key;
  final String name;
  final String desc;
  final String? type;
  final String? rarity;
  final bool? requiresAttunement;
  final Document? document;

  MagicItem({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.type,
    this.rarity,
    this.requiresAttunement,
    this.document,
  });

  factory MagicItem.fromJson(Map<String, dynamic> json) {
    return MagicItem(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      type: json['type'] as String?,
      rarity: json['rarity'] as String?,
      requiresAttunement: json['requires_attunement'] as bool?,
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
      'type': type,
      'rarity': rarity,
      'requires_attunement': requiresAttunement,
      'document': document?.toJson(),
    };
  }
}

/// Weapon from Open5e API v2
class Weapon {
  final String url;
  final String key;
  final String name;
  final String desc;
  final String? category;
  final String? damage;
  final String? damageType;
  final String? weight;
  final String? properties;
  final Document? document;

  Weapon({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.category,
    this.damage,
    this.damageType,
    this.weight,
    this.properties,
    this.document,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) {
    return Weapon(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      category: json['category'] as String?,
      damage: json['damage'] as String?,
      damageType: json['damage_type'] as String?,
      weight: json['weight'] as String?,
      properties: json['properties'] as String?,
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
      'category': category,
      'damage': damage,
      'damage_type': damageType,
      'weight': weight,
      'properties': properties,
      'document': document?.toJson(),
    };
  }
}

/// Armor from Open5e API v2
class Armor {
  final String url;
  final String key;
  final String name;
  final String desc;
  final String? category;
  final String? armorClass;
  final String? strength;
  final bool? stealthDisadvantage;
  final String? weight;
  final Document? document;

  Armor({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.category,
    this.armorClass,
    this.strength,
    this.stealthDisadvantage,
    this.weight,
    this.document,
  });

  factory Armor.fromJson(Map<String, dynamic> json) {
    return Armor(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      category: json['category'] as String?,
      armorClass: json['armor_class'] as String?,
      strength: json['strength'] as String?,
      stealthDisadvantage: json['stealth_disadvantage'] as bool?,
      weight: json['weight'] as String?,
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
      'category': category,
      'armor_class': armorClass,
      'strength': strength,
      'stealth_disadvantage': stealthDisadvantage,
      'weight': weight,
      'document': document?.toJson(),
    };
  }
}

/// Item Set from Open5e API v2
class ItemSet {
  final String url;
  final String key;
  final String name;
  final String desc;

  ItemSet({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory ItemSet.fromJson(Map<String, dynamic> json) {
    return ItemSet(
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

/// Item Category from Open5e API v2
class ItemCategory {
  final String url;
  final String key;
  final String name;
  final String desc;

  ItemCategory({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory ItemCategory.fromJson(Map<String, dynamic> json) {
    return ItemCategory(
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

/// Item Rarity from Open5e API v2
class ItemRarity {
  final String url;
  final String key;
  final String name;
  final String desc;

  ItemRarity({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory ItemRarity.fromJson(Map<String, dynamic> json) {
    return ItemRarity(
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

/// Weapon Property from Open5e API v2
class WeaponProperty {
  final String url;
  final String key;
  final String name;
  final String desc;

  WeaponProperty({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory WeaponProperty.fromJson(Map<String, dynamic> json) {
    return WeaponProperty(
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
