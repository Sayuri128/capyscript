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
  filters: const GalleryFiltersJsonConverter().fromJson(
    json['filters'] as List,
  ),
  type: const ConfigInfoTypeJsonConverter().fromJson(json['type']),
  protectorConfig:
      _$JsonConverterFromJson<Map<String, dynamic>, ProtectorConfig>(
        json['protectorConfig'],
        const ProtectorConfigJsonConverter().fromJson,
      ),
  downloadConfig: _$JsonConverterFromJson<Map<String, dynamic>, DownloadConfig>(
    json['downloadConfig'],
    const DownloadConfigJsonConverter().fromJson,
  ),
  searchAvailable: json['searchAvailable'] as bool,
  apiVersion: (json['apiVersion'] as num?)?.toInt() ?? 1,
  minAppVersion: json['minAppVersion'] as String?,
  preferences: json['preferences'] == null
      ? const <ExtensionPreference>[]
      : const ExtensionPreferencesJsonConverter().fromJson(json['preferences']),
  requestPolicy: const RequestPolicyJsonConverter().fromJson(
    json['requestPolicy'],
  ),
  feeds: json['feeds'] == null
      ? const <GalleryFeed>[]
      : const GalleryFeedsJsonConverter().fromJson(json['feeds']),
  pagination: const GalleryPaginationJsonConverter().fromJson(
    json['pagination'],
  ),
  contentKinds: json['contentKinds'] == null
      ? const <String>[]
      : const ContentKindsJsonConverter().fromJson(json['contentKinds']),
  pricing: json['pricing'] == null
      ? SourcePricing.free
      : const SourcePricingJsonConverter().fromJson(json['pricing']),
  multiInstance: json['multiInstance'] == null
      ? false
      : ConfigInfo.readMultiInstance(json['multiInstance']),
);

Map<String, dynamic> _$ConfigInfoToJson(
  ConfigInfo instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
  'logoUrl': instance.logoUrl,
  'type': const ConfigInfoTypeJsonConverter().toJson(instance.type),
  'nsfw': instance.nsfw,
  'language': instance.language,
  'version': instance.version,
  'filters': const GalleryFiltersJsonConverter().toJson(instance.filters),
  'protectorConfig':
      _$JsonConverterToJson<Map<String, dynamic>, ProtectorConfig>(
        instance.protectorConfig,
        const ProtectorConfigJsonConverter().toJson,
      ),
  'downloadConfig': _$JsonConverterToJson<Map<String, dynamic>, DownloadConfig>(
    instance.downloadConfig,
    const DownloadConfigJsonConverter().toJson,
  ),
  'searchAvailable': instance.searchAvailable,
  'apiVersion': instance.apiVersion,
  'minAppVersion': instance.minAppVersion,
  'preferences': const ExtensionPreferencesJsonConverter().toJson(
    instance.preferences,
  ),
  'requestPolicy': const RequestPolicyJsonConverter().toJson(
    instance.requestPolicy,
  ),
  'feeds': const GalleryFeedsJsonConverter().toJson(instance.feeds),
  'pagination': const GalleryPaginationJsonConverter().toJson(
    instance.pagination,
  ),
  'contentKinds': const ContentKindsJsonConverter().toJson(
    instance.contentKinds,
  ),
  'pricing': const SourcePricingJsonConverter().toJson(instance.pricing),
  'multiInstance': instance.multiInstance,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
