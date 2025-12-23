/// Game mechanics models for Open5e API v2

import 'package:moonforge/core/services/open5e/models/common.dart';

/// Condition from Open5e API v2
class Condition {
  final String url;
  final String key;
  final String name;
  final String desc;
  final Document? document;

  Condition({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.document,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
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

/// Damage Type from Open5e API v2
class DamageType {
  final String url;
  final String key;
  final String name;
  final String desc;

  DamageType({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory DamageType.fromJson(Map<String, dynamic> json) {
    return DamageType(
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

/// Language from Open5e API v2
class Language {
  final String url;
  final String key;
  final String name;
  final String desc;

  Language({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
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

/// Alignment from Open5e API v2
class Alignment {
  final String url;
  final String key;
  final String name;
  final String desc;

  Alignment({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory Alignment.fromJson(Map<String, dynamic> json) {
    return Alignment(
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

/// Size from Open5e API v2
class Size {
  final String url;
  final String key;
  final String name;
  final String desc;

  Size({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
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

/// Environment from Open5e API v2
class Environment {
  final String url;
  final String key;
  final String name;
  final String desc;

  Environment({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory Environment.fromJson(Map<String, dynamic> json) {
    return Environment(
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
