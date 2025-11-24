/// Simple in-memory cache for repository entities.
class RepositoryCache<T, ID> {
  final Duration ttl;
  final Map<ID, _CacheEntry<T>> _cache = <ID, _CacheEntry<T>>{};

  RepositoryCache({this.ttl = const Duration(minutes: 5)});

  T? get(ID id) {
    final entry = _cache[id];
    if (entry == null) {
      return null;
    }

    if (DateTime.now().difference(entry.timestamp) > ttl) {
      _cache.remove(id);
      return null;
    }

    return entry.value;
  }

  void set(ID id, T value) {
    _cache[id] = _CacheEntry<T>(value, DateTime.now());
  }

  void remove(ID id) {
    _cache.remove(id);
  }

  void clear() {
    _cache.clear();
  }
}

class _CacheEntry<T> {
  final T value;
  final DateTime timestamp;

  _CacheEntry(this.value, this.timestamp);
}
