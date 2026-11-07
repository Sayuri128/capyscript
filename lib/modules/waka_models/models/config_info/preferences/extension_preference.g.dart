// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extension_preference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExtensionPreferenceOption _$ExtensionPreferenceOptionFromJson(
  Map<String, dynamic> json,
) => ExtensionPreferenceOption(
  value: json['value'] as String,
  label: json['label'] as String,
);

Map<String, dynamic> _$ExtensionPreferenceOptionToJson(
  ExtensionPreferenceOption instance,
) => <String, dynamic>{'value': instance.value, 'label': instance.label};

ExtensionPreference _$ExtensionPreferenceFromJson(Map<String, dynamic> json) =>
    ExtensionPreference(
      key: json['key'] as String,
      type: $enumDecode(_$ExtensionPreferenceTypeEnumMap, json['type']),
      title: json['title'] as String,
      summary: json['summary'] as String?,
      defaultValue: json['default'],
      options:
          (json['options'] as List<dynamic>?)
              ?.map(
                (e) => ExtensionPreferenceOption.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );

Map<String, dynamic> _$ExtensionPreferenceToJson(
  ExtensionPreference instance,
) => <String, dynamic>{
  'key': instance.key,
  'type': _$ExtensionPreferenceTypeEnumMap[instance.type]!,
  'title': instance.title,
  'summary': instance.summary,
  'default': instance.defaultValue,
  'options': instance.options.map((e) => e.toJson()).toList(),
};

const _$ExtensionPreferenceTypeEnumMap = {
  ExtensionPreferenceType.toggle: 'toggle',
  ExtensionPreferenceType.select: 'select',
  ExtensionPreferenceType.multiselect: 'multiselect',
  ExtensionPreferenceType.text: 'text',
  ExtensionPreferenceType.number: 'number',
};
