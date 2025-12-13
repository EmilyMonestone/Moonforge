/// Core data structures for Open5e API v2 responses

/// Generic paginated response wrapper used by Open5e v2 list endpoints
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

/// GameSystem represents a D&D rule system
class GameSystem {
  final String url;
  final String key;
  final String name;
  final String desc;
  final String contentPrefix;

  GameSystem({
    required this.url,
    required this.key,
    required this.name,
    required this.desc,
    required this.contentPrefix,
  });

  factory GameSystem.fromJson(Map<String, dynamic> json) {
    return GameSystem(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      contentPrefix: json['content_prefix'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'key': key,
      'name': name,
      'desc': desc,
      'content_prefix': contentPrefix,
    };
  }
}

/// Publisher represents a content publisher
class Publisher {
  final String url;
  final String key;
  final String name;

  Publisher({
    required this.url,
    required this.key,
    required this.name,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'key': key,
      'name': name,
    };
  }
}

/// Document - represents a rulebook or source with nested gamesystem and publisher
class Document {
  final String name;
  final String key;
  final String type;
  final String displayName;
  final Publisher? publisher;
  final GameSystem? gamesystem;
  final String? permalink;

  Document({
    required this.name,
    required this.key,
    required this.type,
    required this.displayName,
    this.publisher,
    this.gamesystem,
    this.permalink,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      name: json['name'] as String? ?? '',
      key: json['key'] as String? ?? '',
      type: json['type'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
      publisher: json['publisher'] != null
          ? Publisher.fromJson(json['publisher'] as Map<String, dynamic>)
          : null,
      gamesystem: json['gamesystem'] != null
          ? GameSystem.fromJson(json['gamesystem'] as Map<String, dynamic>)
          : null,
      permalink: json['permalink'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'key': key,
      'type': type,
      'display_name': displayName,
      'publisher': publisher?.toJson(),
      'gamesystem': gamesystem?.toJson(),
      'permalink': permalink,
    };
  }
}

/// License represents a content license
class License {
  final String url;
  final String key;
  final String name;
  final String? desc;

  License({
    required this.url,
    required this.key,
    required this.name,
    this.desc,
  });

  factory License.fromJson(Map<String, dynamic> json) {
    return License(
      url: json['url'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      desc: json['desc'] as String?,
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
