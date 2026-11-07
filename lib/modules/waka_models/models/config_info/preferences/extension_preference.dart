import 'package:json_annotation/json_annotation.dart';

part 'extension_preference.g.dart';

enum ExtensionPreferenceType {
  @JsonValue('toggle')
  toggle,
  @JsonValue('select')
  select,
  @JsonValue('multiselect')
  multiselect,
  @JsonValue('text')
  text,
  @JsonValue('number')
  number,
}

const Map<String, ExtensionPreferenceType> extensionPreferenceTypeNames = {
  'toggle': ExtensionPreferenceType.toggle,
  'select': ExtensionPreferenceType.select,
  'multiselect': ExtensionPreferenceType.multiselect,
  'text': ExtensionPreferenceType.text,
  'number': ExtensionPreferenceType.number,
};

@JsonSerializable()
class ExtensionPreferenceOption {
  factory ExtensionPreferenceOption.fromJson(Map<String, dynamic> json) =>
      _$ExtensionPreferenceOptionFromJson(json);

  Map<String, dynamic> toJson() => _$ExtensionPreferenceOptionToJson(this);

  final String value;
  final String label;

  const ExtensionPreferenceOption({required this.value, required this.label});
}

@JsonSerializable(explicitToJson: true)
class ExtensionPreference {
  static const String mirrorKey = '__mirror';

  factory ExtensionPreference.fromJson(Map<String, dynamic> json) =>
      _$ExtensionPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ExtensionPreferenceToJson(this);

  final String key;
  final ExtensionPreferenceType type;
  final String title;
  final String? summary;
  @JsonKey(name: 'default')
  final Object? defaultValue;
  @JsonKey(defaultValue: <ExtensionPreferenceOption>[])
  final List<ExtensionPreferenceOption> options;

  const ExtensionPreference({
    required this.key,
    required this.type,
    required this.title,
    this.summary,
    this.defaultValue,
    this.options = const <ExtensionPreferenceOption>[],
  });

  Object? get effectiveDefault {
    final Object? value = defaultValue;
    switch (type) {
      case ExtensionPreferenceType.toggle:
        return value is bool ? value : false;
      case ExtensionPreferenceType.select:
        if (value is String) {
          return value;
        }
        return options.isEmpty ? null : options.first.value;
      case ExtensionPreferenceType.multiselect:
        if (value is List) {
          return value.map((e) => e.toString()).toList();
        }
        return <String>[];
      case ExtensionPreferenceType.text:
        return value is String ? value : '';
      case ExtensionPreferenceType.number:
        return value is num ? value : 0;
    }
  }
}

class ExtensionPreferencesJsonConverter
    extends JsonConverter<List<ExtensionPreference>, List<dynamic>?> {
  const ExtensionPreferencesJsonConverter();

  @override
  List<ExtensionPreference> fromJson(List<dynamic>? json) {
    if (json == null) {
      return const <ExtensionPreference>[];
    }
    return json
        .whereType<Map>()
        .where((e) =>
            e['key'] is String &&
            extensionPreferenceTypeNames.containsKey(e['type']))
        .map((e) => ExtensionPreference.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  List<dynamic> toJson(List<ExtensionPreference> object) {
    return object.map((e) => e.toJson()).toList();
  }
}
