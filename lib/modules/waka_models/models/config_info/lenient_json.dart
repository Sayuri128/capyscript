class LenientJson {
  static String? scalarAsString(Object? value) {
    if (value is String) {
      return value;
    }
    if (value is num || value is bool) {
      return value.toString();
    }
    return null;
  }

  static Map<String, Object?>? stringKeyedMap(Object? value) {
    if (value is! Map) {
      return null;
    }
    final Map<String, Object?> result = <String, Object?>{};
    value.forEach((Object? key, Object? entryValue) {
      if (key is String) {
        result[key] = entryValue;
      }
    });
    return result;
  }

  static List<Map<String, Object?>> mapEntries(Object? value) {
    if (value is! List) {
      return const <Map<String, Object?>>[];
    }
    final List<Map<String, Object?>> entries = <Map<String, Object?>>[];
    for (final Object? item in value) {
      final Map<String, Object?>? entry = stringKeyedMap(item);
      if (entry != null) {
        entries.add(entry);
      }
    }
    return entries;
  }
}
