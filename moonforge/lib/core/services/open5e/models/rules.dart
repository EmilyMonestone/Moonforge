/// Rules and miscellaneous models for Open5e API v2

import 'package:moonforge/core/services/open5e/models/common.dart';

/// Rule from Open5e API v2
class Rule {
  final String url;
  final String key;
  final String name;
  final String desc;
  final Document? document;

  Rule({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    this.document,
  });

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
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

/// Rule Set from Open5e API v2
class RuleSet {
  final String url;
  final String key;
  final String name;
  final String desc;

  RuleSet({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory RuleSet.fromJson(Map<String, dynamic> json) {
    return RuleSet(
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

/// Image from Open5e API v2
class Open5eImage {
  final String url;
  final String key;
  final String name;
  final String? desc;
  final String? imageUrl;
  final Document? document;

  Open5eImage({
    required this.url,
    required this.key,
    required this.name,
    this.desc,
    this.imageUrl,
    this.document,
  });

  factory Open5eImage.fromJson(Map<String, dynamic> json) {
    return Open5eImage(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String?,
      imageUrl: json['image_url'] as String?,
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
      'image_url': imageUrl,
      'document': document?.toJson(),
    };
  }
}

/// Service from Open5e API v2
class Open5eService {
  final String url;
  final String key;
  final String name;
  final String desc;

  Open5eService({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
  });

  factory Open5eService.fromJson(Map<String, dynamic> json) {
    return Open5eService(
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
