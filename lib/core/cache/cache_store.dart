/// Offline-first cache abstraction (vendor-neutral).
abstract interface class CacheStore {
  Future<void> initialize();

  Future<void> writeString(String key, String value);

  Future<String?> readString(String key);

  Future<void> delete(String key);

  Future<void> clear();

  Future<void> close();
}

class InMemoryCacheStore implements CacheStore {
  final Map<String, String> _store = {};

  @override
  Future<void> initialize() async {}

  @override
  Future<void> writeString(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<String?> readString(String key) async => _store[key];

  @override
  Future<void> delete(String key) async => _store.remove(key);

  @override
  Future<void> clear() async => _store.clear();

  @override
  Future<void> close() async => _store.clear();
}
