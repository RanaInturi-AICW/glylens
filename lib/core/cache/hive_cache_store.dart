import 'package:hive_flutter/hive_flutter.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../logging/app_logger.dart';
import 'cache_store.dart';

/// Hive-backed offline cache for foundation key-value persistence.
class HiveCacheStore implements CacheStore {
  HiveCacheStore(this._logger);

  final AppLogger _logger;
  Box<String>? _box;

  static const String _boxName = '${AppConstants.isarDatabaseName}_kv';

  @override
  Future<void> initialize() async {
    if (_box != null && _box!.isOpen) {
      return;
    }
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox<String>(_boxName);
      _logger.info('Hive cache initialized');
    } catch (e, st) {
      _logger.error('Hive initialization failed', error: e, stackTrace: st);
      throw CacheException('Hive initialization failed: $e');
    }
  }

  Box<String> get _db {
    final box = _box;
    if (box == null || !box.isOpen) {
      throw const CacheException('CacheStore not initialized');
    }
    return box;
  }

  @override
  Future<void> writeString(String key, String value) async {
    await _db.put(key, value);
  }

  @override
  Future<String?> readString(String key) async => _db.get(key);

  @override
  Future<void> delete(String key) async {
    await _db.delete(key);
  }

  @override
  Future<void> clear() async {
    await _db.clear();
  }

  @override
  Future<void> close() async {
    await _box?.close();
    _box = null;
  }
}
