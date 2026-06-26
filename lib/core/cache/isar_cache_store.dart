import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import '../errors/exceptions.dart';
import '../logging/app_logger.dart';
import 'cache_entry.dart';
import 'cache_store.dart';

/// Isar-backed offline cache (preferred over Hive for indexed queries and async I/O).
class IsarCacheStore implements CacheStore {
  IsarCacheStore(this._logger);

  final AppLogger _logger;
  Isar? _isar;

  @override
  Future<void> initialize() async {
    if (_isar != null) {
      return;
    }
    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [CacheEntrySchema],
        directory: dir.path,
        name: AppConstants.isarDatabaseName,
      );
      _logger.info('Isar cache initialized');
    } catch (e, st) {
      _logger.error('Failed to initialize Isar', error: e, stackTrace: st);
      throw CacheException('Isar initialization failed: $e');
    }
  }

  Isar get _db {
    final isar = _isar;
    if (isar == null) {
      throw const CacheException('CacheStore not initialized');
    }
    return isar;
  }

  @override
  Future<void> writeString(String key, String value) async {
    final entry = CacheEntry()
      ..key = key
      ..value = value
      ..updatedAt = DateTime.now().toUtc();

    await _db.writeTxn(() async {
      await _db.cacheEntrys.put(entry);
    });
  }

  @override
  Future<String?> readString(String key) async {
    final entry = await _db.cacheEntrys.filter().keyEqualTo(key).findFirst();
    return entry?.value;
  }

  @override
  Future<void> delete(String key) async {
    await _db.writeTxn(() async {
      final existing = await _db.cacheEntrys.filter().keyEqualTo(key).findFirst();
      if (existing != null) {
        await _db.cacheEntrys.delete(existing.id);
      }
    });
  }

  @override
  Future<void> clear() async {
    await _db.writeTxn(() async {
      await _db.cacheEntrys.clear();
    });
  }

  @override
  Future<void> close() async {
    await _isar?.close();
    _isar = null;
  }
}
