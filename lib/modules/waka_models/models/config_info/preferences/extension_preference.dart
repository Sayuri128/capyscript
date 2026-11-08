import 'package:capyscript/modules/waka_models/models/config_info/lenient_json.dart';
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

  static ExtensionPreferenceOption? tryParse(Object? json) {
    final Map<String, Object?>? fields = LenientJson.stringKeyedMap(json);
    if (fields == null) {
      return null;
    }
    final String? value = LenientJson.scalarAsString(fields['value']);
    final String? label = LenientJson.scalarAsString(fields['label']);
    if (value == null || label == null) {
      return null;
    }
    return ExtensionPreferenceOption(value: value, label: label);
  }
}

@JsonSerializable(explicitToJson: true)
class ExtensionPreference {
  static const String mirrorKey = '__mirror';
  static const String pageSizeKey = '__pageSize';

  factory ExtensionPreference.fromJson(Map<String, dynamic> json) =>
      _$ExtensionPreferenceFromJson(json);

  Map<String, dynamic> toJson() => _$ExtensionPreferenceToJson(this);

  final String key;
  final ExtensionPreferenceType type;
  final String title;
  final String? summary;
  @JsonKey(name: 'default')
  final Object? defaultValue;
  @ExtensionPreferenceOptionsJsonConverter()
  final List<ExtensionPreferenceOption> options;
  @JsonKey(defaultValue: false)
  final bool secret;

  const ExtensionPreference({
    required this.key,
    required this.type,
    required this.title,
    this.summary,
    this.defaultValue,
    this.options = const <ExtensionPreferenceOption>[],
    this.secret = false,
  });

  static ExtensionPreference? tryParse(Object? json) {
    final Map<String, Object?>? fields = LenientJson.stringKeyedMap(json);
    if (fields == null) {
      return null;
    }
    final Object? key = fields['key'];
    final ExtensionPreferenceType? type =
        extensionPreferenceTypeNames[fields['type']];
    final Object? title = fields['title'];
    if (key is! String || type == null || title is! String) {
      return null;
    }
    final Object? summary = fields['summary'];
    return ExtensionPreference(
      key: key,
      type: type,
      title: title,
      summary: summary is String ? summary : null,
      defaultValue: fields['default'],
      options: const ExtensionPreferenceOptionsJsonConverter().fromJson(
        fields['options'],
      ),
      secret: type == ExtensionPreferenceType.text && fields['secret'] == true,
    );
  }

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

class ExtensionPreferenceOptionsJsonConverter
    extends JsonConverter<List<ExtensionPreferenceOption>, Object?> {
  const ExtensionPreferenceOptionsJsonConverter();

  @override
  List<ExtensionPreferenceOption> fromJson(Object? json) {
    if (json is! List) {
      return const <ExtensionPreferenceOption>[];
    }
    final List<ExtensionPreferenceOption> options =
        <ExtensionPreferenceOption>[];
    for (final Object? item in json) {
      final ExtensionPreferenceOption? option =
          ExtensionPreferenceOption.tryParse(item);
      if (option != null) {
        options.add(option);
      }
    }
    return options;
  }

  @override
  List<dynamic> toJson(List<ExtensionPreferenceOption> object) {
    return object.map((e) => e.toJson()).toList();
  }
}

class ExtensionPreferencesJsonConverter
    extends JsonConverter<List<ExtensionPreference>, Object?> {
  const ExtensionPreferencesJsonConverter();

  @override
  List<ExtensionPreference> fromJson(Object? json) {
    if (json is! List) {
      return const <ExtensionPreference>[];
    }
    final List<ExtensionPreference> preferences = <ExtensionPreference>[];
    for (final Object? item in json) {
      final ExtensionPreference? preference = ExtensionPreference.tryParse(item);
      if (preference != null) {
        preferences.add(preference);
      }
    }
    return preferences;
  }

  @override
  List<dynamic> toJson(List<ExtensionPreference> object) {
    return object.map((e) => e.toJson()).toList();
  }
}
