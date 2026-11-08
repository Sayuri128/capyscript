import 'package:json_annotation/json_annotation.dart';

class SourceType {
  static const String website = 'website';
  static const String selfHosted = 'self-hosted';
  static const String official = 'official';
  static const String local = 'local';

  static const List<String> known = <String>[
    website,
    selfHosted,
    official,
    local,
  ];

  static String parse(Object? json) {
    if (json is! String) {
      return website;
    }
    final String value = json.trim().toLowerCase();
    if (known.contains(value)) {
      return value;
    }
    return website;
  }
}

class SourceTypeJsonConverter extends JsonConverter<String, Object?> {
  const SourceTypeJsonConverter();

  @override
  String fromJson(Object? json) => SourceType.parse(json);

  @override
  Object? toJson(String object) => object;
}
