/// Core data structures for Open5e API responses

/// Generic paginated response wrapper used by most Open5e list endpoints
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

/// Manifest entry - represents an available API resource
class ManifestEntry {
  final String title;
  final String description;
  final String slug;
  final String url;

  ManifestEntry({
    required this.title,
    required this.description,
    required this.slug,
    required this.url,
  });

  factory ManifestEntry.fromJson(Map<String, dynamic> json) {
    return ManifestEntry(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'slug': slug,
      'url': url,
    };
  }
}

/// Document - represents a rulebook or source
class Document {
  final String slug;
  final String title;
  final String desc;
  final String? license;
  final String? author;
  final String? organization;
  final String? version;
  final String? url;
  final String? copyright;

  Document({
    required this.slug,
    required this.title,
    required this.desc,
    this.license,
    this.author,
    this.organization,
    this.version,
    this.url,
    this.copyright,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      desc: json['desc'] as String? ?? '',
      license: json['license'] as String?,
      author: json['author'] as String?,
      organization: json['organization'] as String?,
      version: json['version'] as String?,
      url: json['url'] as String?,
      copyright: json['copyright'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'title': title,
      'desc': desc,
      'license': license,
      'author': author,
      'organization': organization,
      'version': version,
      'url': url,
      'copyright': copyright,
    };
  }
}
