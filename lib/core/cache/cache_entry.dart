import 'package:isar/isar.dart';

part 'cache_entry.g.dart';

@collection
class CacheEntry {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late String value;

  late DateTime updatedAt;
}
