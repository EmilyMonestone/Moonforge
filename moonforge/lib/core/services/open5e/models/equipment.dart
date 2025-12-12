/// Equipment-related models for Open5e API

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
