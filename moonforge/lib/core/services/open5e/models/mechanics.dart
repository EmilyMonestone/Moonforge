/// Game mechanics models for Open5e API

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
