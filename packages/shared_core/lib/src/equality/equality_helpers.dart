/// Helpers for consistent equality across collections.
abstract final class EqualityHelpers {
  static bool listEquals<T>(List<T>? a, List<T>? b) {
    return ListEquality<T>().equals(a, b);
  }

  static int listHash<T>(List<T>? list) {
    return ListEquality<T>().hash(list);
  }
}

class ListEquality<T> {
  const ListEquality();

  bool equals(List<T>? a, List<T>? b) {
    if (identical(a, b)) {
      return true;
    }
    if (a == null || b == null || a.length != b.length) {
      return false;
    }
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  int hash(List<T>? list) {
    if (list == null) {
      return 0;
    }
    return Object.hashAll(list);
  }
}
