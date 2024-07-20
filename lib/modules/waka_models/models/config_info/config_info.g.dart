// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigInfo _$ConfigInfoFromJson(Map<String, dynamic> json) => ConfigInfo(
      name: json['name'] as String,
      uid: json['uid'] as String,
      logoUrl: json['logoUrl'] as String,
      nsfw: json['nsfw'] as bool,
      language: json['language'] as String,
      version: (json['version'] as num).toInt(),
      filters:
          const GalleryFiltersJsonConverter().fromJson(json['filters'] as List),
      type: $enumDecode(_$ConfigInfoTypeEnumMap, json['type']),
      protectorConfig:
          _$JsonConverterFromJson<Map<String, dynamic>, ProtectorConfig>(
              json['protectorConfig'],
              const ProtectorConfigJsonConverter().fromJson),
      searchAvailable: json['searchAvailable'] as bool,
    );

Map<String, dynamic> _$ConfigInfoToJson(ConfigInfo instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
      'type': _$ConfigInfoTypeEnumMap[instance.type]!,
      'nsfw': instance.nsfw,
      'language': instance.language,
      'version': instance.version,
      'filters': const GalleryFiltersJsonConverter().toJson(instance.filters),
      'protectorConfig':
          _$JsonConverterToJson<Map<String, dynamic>, ProtectorConfig>(
              instance.protectorConfig,
              const ProtectorConfigJsonConverter().toJson),
      'searchAvailable': instance.searchAvailable,
    };

const _$ConfigInfoTypeEnumMap = {
  ConfigInfoType.MANGA: 0,
  ConfigInfoType.ANIME: 1,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
